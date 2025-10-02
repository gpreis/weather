require 'rails_helper'

RSpec.describe WeatherApi::ForecastDay, type: :model do
  subject(:forecast_day) { described_class.new(**attributes) }

  let(:condition) do
    WeatherApi::Condition.new(
      text: 'Partly cloudy',
      icon: 'partly_cloudy.png',
      code: 1003
    )
  end

  let(:attributes) do
    {
      date: '2023-10-01',
      maxtemp_c: 25.0,
      maxtemp_f: 77.0,
      mintemp_c: 15.0,
      mintemp_f: 59.0,
      condition: condition
    }
  end

  describe '#initialize' do
    context 'with all required attributes' do
      it 'sets date' do
        expect(subject.date).to eq('2023-10-01')
      end

      it 'sets maximum temperature in celsius' do
        expect(subject.maxtemp_c).to eq(25.0)
      end

      it 'sets maximum temperature in fahrenheit' do
        expect(subject.maxtemp_f).to eq(77.0)
      end

      it 'sets minimum temperature in celsius' do
        expect(subject.mintemp_c).to eq(15.0)
      end

      it 'sets minimum temperature in fahrenheit' do
        expect(subject.mintemp_f).to eq(59.0)
      end

      it 'sets condition' do
        expect(subject.condition).to eq(condition)
      end
    end

    context 'with missing required parameters' do
      let(:attributes) do
        {
          date: '2023-10-01',
          maxtemp_c: 25.0,
          maxtemp_f: 77.0,
          mintemp_c: 15.0
        }
      end

      it 'raises ArgumentError for missing keywords' do
        expect { subject }.to raise_error(ArgumentError, /missing keyword/)
      end
    end
  end

  describe '.from_hash' do
    subject(:forecast_day) { described_class.from_hash(hash) }

    let(:hash) do
      {
        date: '2023-10-02',
        day: {
          maxtemp_c: 23.5,
          maxtemp_f: 74.3,
          mintemp_c: 12.0,
          mintemp_f: 53.6,
          condition: {
            text: 'Light rain',
            icon: 'rain.png',
            code: 1063
          }
        }
      }
    end

    it 'sets date from hash' do
      expect(subject.date).to eq('2023-10-02')
    end

    it 'sets maximum temperature in celsius from nested day hash' do
      expect(subject.maxtemp_c).to eq(23.5)
    end

    it 'sets maximum temperature in fahrenheit from nested day hash' do
      expect(subject.maxtemp_f).to eq(74.3)
    end

    it 'sets minimum temperature in celsius from nested day hash' do
      expect(subject.mintemp_c).to eq(12.0)
    end

    it 'sets minimum temperature in fahrenheit from nested day hash' do
      expect(subject.mintemp_f).to eq(53.6)
    end

    it 'creates condition object from nested hash' do
      expect(subject.condition).to be_a(WeatherApi::Condition)
    end

    it 'sets condition text from nested hash' do
      expect(subject.condition.text).to eq('Light rain')
    end

    context 'when day data is missing' do
      let(:hash) { { date: '2023-10-02' } }

      it 'sets date from hash' do
        expect(subject.date).to eq('2023-10-02')
      end

      it 'sets maximum temperature celsius to nil' do
        expect(subject.maxtemp_c).to be_nil
      end

      it 'sets maximum temperature fahrenheit to nil' do
        expect(subject.maxtemp_f).to be_nil
      end

      it 'sets minimum temperature celsius to nil' do
        expect(subject.mintemp_c).to be_nil
      end

      it 'sets minimum temperature fahrenheit to nil' do
        expect(subject.mintemp_f).to be_nil
      end
    end

    context 'with condition data in nested hash' do
      it 'creates condition with correct text' do
        expect(subject.condition.text).to eq('Light rain')
      end

      it 'creates condition with correct icon' do
        expect(subject.condition.icon).to eq('rain.png')
      end

      it 'creates condition with correct code' do
        expect(subject.condition.code).to eq(1063)
      end
    end
  end

  describe '.many_from_hash' do
    subject(:forecast_days) { described_class.many_from_hash(forecast_days_hash) }

    let(:forecast_days_hash) do
      [
        {
          date: '2023-10-01',
          day: {
            maxtemp_c: 25.0,
            maxtemp_f: 77.0,
            mintemp_c: 15.0,
            mintemp_f: 59.0,
            condition: {
              text: 'Sunny',
              icon: 'sun.png',
              code: 1000
            }
          }
        },
        {
          date: '2023-10-02',
          day: {
            maxtemp_c: 20.0,
            maxtemp_f: 68.0,
            mintemp_c: 10.0,
            mintemp_f: 50.0,
            condition: {
              text: 'Cloudy',
              icon: 'cloud.png',
              code: 1006
            }
          }
        }
      ]
    end

    it 'creates correct number of forecast days' do
      expect(subject.size).to eq(2)
    end

    it 'creates forecast day objects' do
      subject.each do |day|
        expect(day).to be_a(described_class)
      end
    end

    it 'sets first day date correctly' do
      expect(subject.first.date).to eq('2023-10-01')
    end

    it 'sets first day condition correctly' do
      expect(subject.first.condition.text).to eq('Sunny')
    end

    it 'sets second day date correctly' do
      expect(subject.last.date).to eq('2023-10-02')
    end

    it 'sets second day condition correctly' do
      expect(subject.last.condition.text).to eq('Cloudy')
    end

    context 'with empty array' do
      let(:forecast_days_hash) { [] }

      it 'returns empty array' do
        expect(subject).to be_empty
      end
    end
  end

  describe 'condition delegation' do
    context 'when condition is present' do
      it 'delegates condition_text to condition' do
        expect(subject.condition_text).to eq('Partly cloudy')
      end

      it 'delegates condition_icon to condition' do
        expect(subject.condition_icon).to eq('partly_cloudy.png')
      end

      it 'delegates condition_code to condition' do
        expect(subject.condition_code).to eq(1003)
      end
    end

    context 'when condition is nil' do
      let(:attributes) { super().merge(condition: nil) }

      it 'raises NoMethodError for condition_text' do
        expect { subject.condition_text }.to raise_error(NoMethodError)
      end
    end
  end
end
