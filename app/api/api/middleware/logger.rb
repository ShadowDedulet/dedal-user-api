# frozen_string_literal: true

require 'grape'

module API
  module Middleware
    class Logger < Grape::Middleware::Base
      LOG_EVENT_MIN_QUERY_EXECUTION_TIME = Integer((ENV['LOG_EVENT_MIN_QUERY_EXECUTION_TIME'] || 10_000.to_s), 10)
      private_constant :LOG_EVENT_MIN_QUERY_EXECUTION_TIME

      def before
        @start_time = Time.zone.now
      end

      # rubocop:disable Metrics/MethodLength, Lint/RescueException
      def call!(env)
        @env = env
        before

        begin
          @app_response = @app.call(@env)
        rescue Exception => e
          add_log_event(e)
        else
          add_log_event
        ensure
          begin
            @after_response = after
          rescue StandardError => e
            warn("caught error of type #{e.class} in after callback inside #{self.class.name} : #{e.message}")
            raise(e)
          end
        end

        @after_response || @app_response
      end
      # rubocop:enable Metrics/MethodLength, Lint/RescueException

      private

      # rubocop:disable Metrics/AbcSize
      def add_log_event(exception = nil)
        exception ||= env[:original_exception]
        return unless log_event?(exception)

        log_event = LogEvent.new(request_id:           request.__id__,
                                 http_method:          request.request_method,
                                 params:               request.params.to_s,
                                 created_at:           Time.zone.now,
                                 application:          Rails.application.engine_name,
                                 controller:           endpoint.options[:for].to_s,
                                 action:               endpoint.options[:route_options][:description],
                                 status:               response_status,
                                 message:              exception_message(exception),
                                 query_execution_time:,
                                 hostname:             ENV.fetch('HOSTNAME'),
                                 service_name:         ENV.fetch('SERVICE_NAME'))

        log_event.to_log_service!
      end
      # rubocop:enable Metrics/AbcSize

      def log_event?(exception)
        return true if exception.present?

        !(request.request_method == 'GET' &&
          query_execution_time   < LOG_EVENT_MIN_QUERY_EXECUTION_TIME &&
          response_status        < 400)
      end

      def endpoint
        @endpoint ||= env[Grape::Env::API_ENDPOINT]
      end

      def request
        @request ||= ::Rack::Request.new(@env)
      end

      def response_status
        @app_response.present? ? response.status : 500
      end

      def query_execution_time
        @query_execution_time ||= ((Time.zone.now - @start_time) * 1000)
      end

      def exception_message(exception)
        return if exception.blank?

        exception.backtrace.unshift(exception.message).join("\n")
      end
    end
  end
end
