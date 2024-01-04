# frozen_string_literal: true

class LogEvent
  attr_reader :attributes

  def initialize(attributes = {})
    @attributes = attributes
  end

  def to_log_service!
    Rails.logger.tagged('service_bus') do |logger|
      logger.info(to: :log_service, code: 'log_operation/save_log', data: {})
    end
  end
end
