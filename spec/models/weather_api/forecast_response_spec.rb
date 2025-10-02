require 'rails_helper'

RSpec.describe WeatherApi::ForecastResponse, type: :model do
  subject(:forecast_response) { described_class.new(**attributes) }

  let(:location) do
    WeatherApi::Location.new(
      name: 'New York',
      region: 'New York',
      country: 'United States of America',
      tz_id: 'America/New_York',
      localtime: '2023-10-01 14:30'
    )
  end

  let(:current) do
    WeatherApi::Current.new(
      temp_c: 22.0,
      temp_f: 71.6,
      condition: WeatherApi::Condition.new(
        text: 'Sunny',
        icon: 'sun.png',
        code: 1000
      )
    )
  end

  let(:forecast_days) do
    [
      WeatherApi::ForecastDay.new(
        date: '2023-10-01',
        maxtemp_c: 25.0,
        maxtemp_f: 77.0,
        mintemp_c: 15.0,
        mintemp_f: 59.0,
        condition: WeatherApi::Condition.new(
          text: 'Sunny',
          icon: 'sun.png',
          code: 1000
        )
      ),
      WeatherApi::ForecastDay.new(
        date: '2023-10-02',
        maxtemp_c: 20.0,
        maxtemp_f: 68.0,
        mintemp_c: 10.0,
        mintemp_f: 50.0,
        condition: WeatherApi::Condition.new(
          text: 'Cloudy',
          icon: 'cloud.png',
          code: 1006
        )
      )
    ]
  end

  describe '#initialize' do
    context 'with all attributes provided' do
      let(:attributes) do
        {
          location: location,
          current: current,
          forecast_days: forecast_days,
          cache_hit: true
        }
      end

      it 'sets location' do
        expect(subject.location).to eq(location)
      end

      it 'sets current weather' do
        expect(subject.current).to eq(current)
      end

      it 'sets forecast days' do
        expect(subject.forecast_days).to eq(forecast_days)
      end

      it 'sets cache hit status' do
        expect(subject.cache_hit).to be true
      end
    end

    context 'with no attributes provided' do
      let(:attributes) { {} }

      it 'uses empty hash for location default' do
        expect(subject.location).to eq({})
      end

      it 'uses empty hash for current default' do
        expect(subject.current).to eq({})
      end

      it 'uses empty array for forecast days default' do
        expect(subject.forecast_days).to eq([])
      end

      it 'uses false for cache hit default' do
        expect(subject.cache_hit).to be false
      end
    end

    context 'with partial attributes provided' do
      let(:attributes) { { location: location, cache_hit: true } }

      it 'sets provided location' do
        expect(subject.location).to eq(location)
      end

      it 'uses default for current' do
        expect(subject.current).to eq({})
      end

      it 'uses default for forecast days' do
        expect(subject.forecast_days).to eq([])
      end

      it 'sets provided cache hit status' do
        expect(subject.cache_hit).to be true
      end
    end
  end

  describe '.from_response' do
    subject(:forecast_response) { described_class.from_response(api_response, cache_hit: cache_hit) }

    let(:api_response) { double('response', body: response_body.to_json) }
    let(:cache_hit) { false }

    let(:response_body) do
      {
        location: {
          name: 'London',
          region: 'City of London, Greater London',
          country: 'United Kingdom',
          tz_id: 'Europe/London',
          localtime: '2023-10-01 19:30'
        },
        current: {
          temp_c: 18.5,
          temp_f: 65.3,
          condition: {
            text: 'Cloudy',
            icon: 'cloud.png',
            code: 1006
          }
        },
        forecast: {
          forecastday: [
            {
              date: '2023-10-01',
              day: {
                maxtemp_c: 20.0,
                maxtemp_f: 68.0,
                mintemp_c: 12.0,
                mintemp_f: 53.6,
                condition: {
                  text: 'Cloudy',
                  icon: 'cloud.png',
                  code: 1006
                }
              }
            },
            {
              date: '2023-10-02',
              day: {
                maxtemp_c: 22.0,
                maxtemp_f: 71.6,
                mintemp_c: 14.0,
                mintemp_f: 57.2,
                condition: {
                  text: 'Partly cloudy',
                  icon: 'partly_cloudy.png',
                  code: 1003
                }
              }
            }
          ]
        }
      }
    end

    it 'creates forecast response object' do
      expect(subject).to be_a(described_class)
    end

    it 'sets cache hit status from parameter' do
      expect(subject.cache_hit).to be false
    end

    describe 'location creation' do
      it 'creates location object from response data' do
        expect(subject.location).to be_a(WeatherApi::Location)
      end

      it 'sets location name from response' do
        expect(subject.location.name).to eq('London')
      end

      it 'sets location country from response' do
        expect(subject.location.country).to eq('United Kingdom')
      end
    end

    describe 'current weather creation' do
      it 'creates current weather object from response data' do
        expect(subject.current).to be_a(WeatherApi::Current)
      end

      it 'sets current temperature from response' do
        expect(subject.current.temp_c).to eq(18.5)
      end

      it 'sets current condition text from response' do
        expect(subject.current.condition_text).to eq('Cloudy')
      end

      it 'includes forecast data in current weather' do
        expect(subject.current.forecast).to be_a(WeatherApi::ForecastDay)
      end

      it 'sets current max temperature from first forecast day' do
        expect(subject.current.maxtemp_c).to eq(20.0)
      end

      it 'sets current min temperature from first forecast day' do
        expect(subject.current.mintemp_c).to eq(12.0)
      end
    end

    describe 'forecast days creation' do
      it 'excludes first day from forecast days array' do
        expect(subject.forecast_days.size).to eq(1)
      end

      it 'creates forecast day objects' do
        expect(subject.forecast_days.first).to be_a(WeatherApi::ForecastDay)
      end

      it 'sets forecast day date correctly' do
        expect(subject.forecast_days.first.date).to eq('2023-10-02')
      end

      it 'sets forecast day condition correctly' do
        expect(subject.forecast_days.first.condition_text).to eq('Partly cloudy')
      end
    end

    context 'when cache is hit' do
      let(:cache_hit) { true }

      it 'sets cache hit to true' do
        expect(subject.cache_hit).to be true
      end
    end

    context 'when cache is not hit' do
      let(:cache_hit) { false }

      it 'sets cache hit to false' do
        expect(subject.cache_hit).to be false
      end
    end

    context 'when forecast data is missing' do
      let(:response_body) { super().except(:forecast) }

      it 'returns empty forecast days array' do
        expect(subject.forecast_days).to be_empty
      end

      it 'sets current forecast to nil' do
        expect(subject.current.forecast).to be_nil
      end
    end

    context 'when forecast days array is empty' do
      let(:response_body) { super().merge(forecast: { forecastday: [] }) }

      it 'returns empty forecast days array' do
        expect(subject.forecast_days).to be_empty
      end

      it 'sets current forecast to nil' do
        expect(subject.current.forecast).to be_nil
      end
    end
  end
end