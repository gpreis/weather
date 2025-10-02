require 'rails_helper'

RSpec.describe WeatherApi::Location, type: :model do
  describe '#initialize' do
    subject do
      described_class.new(
        name: 'New York',
        region: 'New York',
        country: 'United States of America',
        tz_id: 'America/New_York',
        localtime: '2023-10-01 14:30'
      )
    end

    context 'with valid attributes' do
      it { expect(subject.name).to eq('New York') }
      it { expect(subject.region).to eq('New York') }
      it { expect(subject.country).to eq('United States of America') }
      it { expect(subject.tz_id).to eq('America/New_York') }
      it { expect(subject.localtime).to eq('2023-10-01 14:30') }
    end

    context 'with missing required parameters' do
      it 'raises ArgumentError' do
        expect {
          described_class.new(name: 'New York', region: 'New York')
        }.to raise_error(ArgumentError, /missing keyword/)
      end
    end
  end

  describe '.from_hash' do
    let(:valid_hash) do
      {
        name: 'London',
        region: 'City of London, Greater London',
        country: 'United Kingdom',
        tz_id: 'Europe/London',
        localtime: '2023-10-01 19:30'
      }
    end

    subject { described_class.from_hash(valid_hash) }

    context 'with valid hash' do
      it { expect(subject.name).to eq('London') }
      it { expect(subject.region).to eq('City of London, Greater London') }
      it { expect(subject.country).to eq('United Kingdom') }
      it { expect(subject.tz_id).to eq('Europe/London') }
      it { expect(subject.localtime).to eq('2023-10-01 19:30') }
    end

    context 'with nil values' do
      let(:hash_with_nils) do
        {
          name: nil,
          region: nil,
          country: nil,
          tz_id: nil,
          localtime: nil
        }
      end
      subject { described_class.from_hash(hash_with_nils) }

      it { expect(subject.name).to be_nil }
      it { expect(subject.region).to be_nil }
      it { expect(subject.country).to be_nil }
      it { expect(subject.tz_id).to be_nil }
      it { expect(subject.localtime).to be_nil }
    end
  end

  describe '#full_name' do
    context 'with all values present' do
      subject do
        described_class.new(
          name: 'New York',
          region: 'New York',
          country: 'United States of America',
          tz_id: 'America/New_York',
          localtime: '2023-10-01 14:30'
        )
      end

      it { expect(subject.full_name).to eq('New York, New York, United States of America') }
    end

    context 'with blank region' do
      subject do
        described_class.new(
          name: 'Paris',
          region: '',
          country: 'France',
          tz_id: 'Europe/Paris',
          localtime: '2023-10-01 20:30'
        )
      end

      it { expect(subject.full_name).to eq('Paris, France') }
    end

    context 'with nil region' do
      subject do
        described_class.new(
          name: 'Tokyo',
          region: nil,
          country: 'Japan',
          tz_id: 'Asia/Tokyo',
          localtime: '2023-10-02 03:30'
        )
      end

      it { expect(subject.full_name).to eq('Tokyo, Japan') }
    end

    context 'with all blank values' do
      subject do
        described_class.new(
          name: '',
          region: nil,
          country: '',
          tz_id: 'UTC',
          localtime: '2023-10-01 12:00'
        )
      end

      it { expect(subject.full_name).to eq('') }
    end
  end
end
