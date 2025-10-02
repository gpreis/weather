require 'rails_helper'

RSpec.describe WeatherApi::Condition, type: :model do
  describe '#initialize' do
    subject do
      described_class.new(
        text: 'Sunny',
        icon: 'sun.png',
        code: 1000
      )
    end

    context 'with valid attributes' do
      it { expect(subject.text).to eq('Sunny') }
      it { expect(subject.icon).to eq('sun.png') }
      it { expect(subject.code).to eq(1000) }
    end

    context 'with missing required parameters' do
      it 'raises ArgumentError when code is missing' do
        expect {
          described_class.new(text: 'Sunny', icon: 'sun.png')
        }.to raise_error(ArgumentError, /missing keyword: (:)?code/)
      end
    end
  end

  describe '.from_hash' do
    let(:valid_hash) do
      {
        text: 'Partly cloudy',
        icon: 'partly_cloudy.png',
        code: 1003
      }
    end

    subject { described_class.from_hash(valid_hash) }

    context 'with valid hash' do
      it { expect(subject.text).to eq('Partly cloudy') }
      it { expect(subject.icon).to eq('partly_cloudy.png') }
      it { expect(subject.code).to eq(1003) }
    end

    context 'with nil values' do
      let(:hash_with_nils) { { text: nil, icon: nil, code: nil } }
      subject { described_class.from_hash(hash_with_nils) }

      it { expect(subject.text).to be_nil }
      it { expect(subject.icon).to be_nil }
      it { expect(subject.code).to be_nil }
    end

    context 'with missing keys' do
      let(:incomplete_hash) { { text: 'Sunny' } }
      subject { described_class.from_hash(incomplete_hash) }

      it { expect(subject.text).to eq('Sunny') }
      it { expect(subject.icon).to be_nil }
      it { expect(subject.code).to be_nil }
    end
  end
end
