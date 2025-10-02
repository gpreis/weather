require "rails_helper"

RSpec.describe GeolocationService, type: :service do
  let(:address_query) { "San Francisco, CA" }
  let(:geocoder_result) { double("geocoder_result", coordinates: [ 37.7749, -122.4194 ]) }

  describe "#call" do
    before do
      allow(Geocoder).to receive(:search).and_return([ geocoder_result ])
    end

    context "with valid address" do
      it "returns geocoder result" do
        result = described_class.call(address_query)

        expect(result).to eq(geocoder_result)
      end
    end

    context "with blank address" do
      it "returns nil" do
        result = described_class.call("")

        expect(result).to be_nil
      end
    end

    context "with no results found" do
      before do
        allow(Geocoder).to receive(:search).and_return([])
      end

      it "returns nil" do
        result = described_class.call(address_query)

        expect(result).to be_nil
      end
    end
  end
end
