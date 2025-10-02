require "rails_helper"

RSpec.describe WeatherForecastService, type: :service do
  subject(:service) { described_class.new }

  let(:geolocation) { double("geolocation", coordinates: [37.7749, -122.4194], postal_code: "94102") }
  let(:http_client) { instance_double(Faraday::Connection) }
  let(:successful_response) { double("response", success?: true, body: '{"location":{"name":"San Francisco"}}') }

  before do
    allow(service).to receive(:http_client).and_return(http_client)
    allow(WeatherApi::ForecastResponse).to receive(:from_response).and_return("forecast_response")
    allow(Rails.cache).to receive(:read).and_return(nil)
    allow(Rails.cache).to receive(:write)
  end

  describe "#call" do
    context "with successful API response" do
      before do
        allow(http_client).to receive(:post).and_return(successful_response)
      end

      it "returns forecast response and caches result" do
        result = service.call(geolocation)

        expect(result).to eq("forecast_response")
        expect(Rails.cache).to have_received(:write)
          .with("forecast_94102", successful_response, expires_in: 30.minutes)
      end
    end

    context "with cached response" do
      before do
        allow(Rails.cache).to receive(:read).with("forecast_94102").and_return(successful_response)
        allow(http_client).to receive(:post)
      end

      it "returns cached result without API call" do
        result = service.call(geolocation)

        expect(result).to eq("forecast_response")
        expect(http_client).not_to have_received(:post)
      end
    end

    context "with failed API response" do
      before do
        allow(http_client).to receive(:post).and_return(double("response", success?: false))
      end

      it "returns nil" do
        result = service.call(geolocation)

        expect(result).to be_nil
      end
    end

    context "with network error" do
      before do
        allow(http_client).to receive(:post).and_raise(Faraday::ConnectionFailed)
        allow(Rails.logger).to receive(:error)
      end

      it "returns nil and logs error" do
        result = service.call(geolocation)

        expect(result).to be_nil
        expect(Rails.logger).to have_received(:error)
      end
    end
  end
end