# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::Middleware::Logger do
  let(:app)             { proc { [200, {}, ['response body']] } }
  let(:log_event)       { instance_spy(LogEvent)                }

  before do
    allow(LogEvent).to receive(:new).and_return(log_event)
  end

  after do
    Timecop.return
  end

  context 'when GET request' do
    subject(:logger) { described_class.new(app) }

    let(:env) { build(:expected_env) }

    it 'is not logging if query execution time less than 10 sec' do
      logger.call!(env)
      expect(log_event).not_to have_received(:to_log_service!)
    end

    it 'is logging if query execution time more than 10 sec' do
      Timecop.scale(1_000_000)
      logger.call!(env)
      expect(log_event).to have_received(:to_log_service!)
    end
  end

  context 'when bad request' do
    subject(:logger) { described_class.new(invalid_app) }

    let(:invalid_app) { proc { [401, {}, ''] } }
    let(:env)         { build(:expected_env)   }

    it 'is logging' do
      logger.call!(env)
      expect(log_event).to have_received(:to_log_service!)
    end
  end

  context 'when POST request' do
    subject(:logger) { described_class.new(app) }

    let(:request_method) { 'POST'                      }
    let(:env)            { build(:expected_env, :post) }

    it 'is logging' do
      logger.call!(env)
      expect(log_event).to have_received(:to_log_service!)
    end
  end

  context 'when raising exceptions' do
    let(:env) { build(:expected_env) }
    let(:exception) do
      StandardError.new('test')
    end
    let(:warn_msg) do
      "caught error of type #{exception.class} in after callback inside #{described_class.name} : #{exception.message}"
    end

    context 'with app' do
      subject(:logger) { described_class.new(proc { raise exception }) }

      it 'is_logging' do
        logger.call!(env)
        expect(log_event).to have_received(:to_log_service!)
      end
    end

    context 'with callback' do
      subject(:logger) do
        described_class.new(proc { raise exception },
                            warn:  warn_msg,
                            after: exception,
                            raise: true)
      end

      it 'is_logging' do
        logger.call!(env)
        expect(log_event).to have_received(:to_log_service!)
      end
    end
  end
end
