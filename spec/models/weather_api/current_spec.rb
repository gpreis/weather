require 'rails_helper'

RSpec.describe WeatherApi::Current, type: :model do
  subject(:current) { described_class.new(**attributes) }

  let(:condition) do
    WeatherApi::Condition.new(
      text: 'Sunny',
      icon: 'sun.png',
      code: 1000
    )
  end

  let(:forecast) do
    double('forecast',
      maxtemp_c: 25.0,
      maxtemp_f: 77.0,
      mintemp_c: 15.0,
      mintemp_f: 59.0
    )
  end

  let(:attributes) do
    {
      temp_c: 22.0,
      temp_f: 71.6,
      condition: condition,
      forecast: forecast
    }
  end

  describe '#initialize' do
    context 'with all required attributes' do
      it 'sets temperature in celsius' do
        expect(subject.temp_c).to eq(22.0)
      end

      it 'sets temperature in fahrenheit' do
        expect(subject.temp_f).to eq(71.6)
      end

      it 'sets condition' do
        expect(subject.condition).to eq(condition)
      end

      it 'sets forecast' do
        expect(subject.forecast).to eq(forecast)
      end
    end

    context 'with optional forecast as nil' do
      let(:attributes) { super().except(:forecast) }

      it 'allows forecast to be nil' do
        expect(subject.forecast).to be_nil
      end
    end

    context 'with missing required attributes' do
      let(:attributes) { { temp_c: 22.0, temp_f: 71.6 } }

      it 'raises ArgumentError for missing condition' do
        expect { subject }.to raise_error(ArgumentError, /missing keyword: (:)?condition/)
      end
    end
  end

  describe '.from_hash' do
    subject(:current) { described_class.from_hash(hash) }

    let(:hash) do
      {
        temp_c: 18.5,
        temp_f: 65.3,
        condition: {
          text: 'Cloudy',
          icon: 'cloud.png',
          code: 1006
        },
        forecast: forecast
      }
    end

    it 'sets temperature in celsius from hash' do
      expect(subject.temp_c).to eq(18.5)
    end

    it 'sets temperature in fahrenheit from hash' do
      expect(subject.temp_f).to eq(65.3)
    end

    it 'creates condition object from nested hash' do
      expect(subject.condition).to be_a(WeatherApi::Condition)
    end

    it 'sets condition text from nested hash' do
      expect(subject.condition.text).to eq('Cloudy')
    end

    it 'sets forecast object' do
      expect(subject.forecast).to eq(forecast)
    end

    context 'when forecast is missing from hash' do
      let(:hash) { super().except(:forecast) }

      it 'handles missing forecast gracefully' do
        expect(subject.forecast).to be_nil
      end
    end

    context 'with condition data in nested hash' do
      it 'creates condition with correct text' do
        expect(subject.condition.text).to eq('Cloudy')
      end

      it 'creates condition with correct icon' do
        expect(subject.condition.icon).to eq('cloud.png')
      end

      it 'creates condition with correct code' do
        expect(subject.condition.code).to eq(1006)
      end
    end
  end

  describe 'condition delegation' do
    context 'when condition is present' do
      it 'delegates condition_text to condition' do
        expect(subject.condition_text).to eq('Sunny')
      end

      it 'delegates condition_icon to condition' do
        expect(subject.condition_icon).to eq('sun.png')
      end

      it 'delegates condition_code to condition' do
        expect(subject.condition_code).to eq(1000)
      end
    end

    context 'when condition is nil' do
      let(:attributes) { super().merge(condition: nil) }

      it 'returns nil for condition_text' do
        expect(subject.condition_text).to be_nil
      end

      it 'returns nil for condition_icon' do
        expect(subject.condition_icon).to be_nil
      end

      it 'returns nil for condition_code' do
        expect(subject.condition_code).to be_nil
      end
    end
  end

  describe 'forecast delegation' do
    context 'when forecast is present' do
      it 'delegates maxtemp_c to forecast' do
        expect(subject.maxtemp_c).to eq(25.0)
      end

      it 'delegates maxtemp_f to forecast' do
        expect(subject.maxtemp_f).to eq(77.0)
      end

      it 'delegates mintemp_c to forecast' do
        expect(subject.mintemp_c).to eq(15.0)
      end

      it 'delegates mintemp_f to forecast' do
        expect(subject.mintemp_f).to eq(59.0)
      end
    end

    context 'when forecast is nil' do
      let(:attributes) { super().except(:forecast) }

      it 'returns nil for maxtemp_c' do
        expect(subject.maxtemp_c).to be_nil
      end

      it 'returns nil for maxtemp_f' do
        expect(subject.maxtemp_f).to be_nil
      end

      it 'returns nil for mintemp_c' do
        expect(subject.mintemp_c).to be_nil
      end

      it 'returns nil for mintemp_f' do
        expect(subject.mintemp_f).to be_nil
      end
    end
  end
end
