require "rails_helper"

RSpec.describe WeatherApi::Client, type: :service do
  describe ".pool" do
    it "creates a connection pool" do
      expect(described_class.pool).to be_a(ConnectionPool)
    end

    it "reuses the same pool instance" do
      pool1 = described_class.pool
      pool2 = described_class.pool

      expect(pool1).to be(pool2)
    end
  end

  describe ".with_connection" do
    it "yields a Faraday connection from the pool" do
      described_class.with_connection do |client|
        expect(client).to be_a(Faraday::Connection)
        expect(client.url_prefix.to_s).to eq("http://api.weatherapi.com/v1")
      end
    end

    it "properly manages connection pool resources" do
      expect(described_class.pool.size).to eq(10) # Default pool size
    end
  end
end