require 'rails_helper'

RSpec.describe 'WeatherApi Integration', type: :integration do
  subject(:forecast_response) do
    WeatherApi::ForecastResponse.from_response(mock_api_response, cache_hit: cache_hit)
  end

  let(:mock_api_response) do
    double('response', body: {
      location: {
        name: 'San Francisco',
        region: 'California',
        country: 'United States of America',
        tz_id: 'America/Los_Angeles',
        localtime: '2023-10-01 12:00'
      },
      current: {
        temp_c: 22.0,
        temp_f: 71.6,
        condition: {
          text: 'Sunny',
          icon: '//cdn.weatherapi.com/weather/64x64/day/113.png',
          code: 1000
        }
      },
      forecast: {
        forecastday: [
          {
            date: '2023-10-01',
            day: {
              maxtemp_c: 25.0,
              maxtemp_f: 77.0,
              mintemp_c: 18.0,
              mintemp_f: 64.4,
              condition: {
                text: 'Sunny',
                icon: '//cdn.weatherapi.com/weather/64x64/day/113.png',
                code: 1000
              }
            }
          },
          {
            date: '2023-10-02',
            day: {
              maxtemp_c: 23.0,
              maxtemp_f: 73.4,
              mintemp_c: 16.0,
              mintemp_f: 60.8,
              condition: {
                text: 'Partly cloudy',
                icon: '//cdn.weatherapi.com/weather/64x64/day/116.png',
                code: 1003
              }
            }
          },
          {
            date: '2023-10-03',
            day: {
              maxtemp_c: 20.0,
              maxtemp_f: 68.0,
              mintemp_c: 14.0,
              mintemp_f: 57.2,
              condition: {
                text: 'Cloudy',
                icon: '//cdn.weatherapi.com/weather/64x64/day/119.png',
                code: 1006
              }
            }
          }
        ]
      }
    }.to_json)
  end

  describe 'when cache is not hit' do
    let(:cache_hit) { false }

    describe 'location data' do
      it 'creates correct full name from location components' do
        expect(subject.location.full_name).to eq('San Francisco, California, United States of America')
      end

      it 'preserves timezone information' do
        expect(subject.location.tz_id).to eq('America/Los_Angeles')
      end
    end

    describe 'current weather data' do
      it 'provides temperature in celsius' do
        expect(subject.current.temp_c).to eq(22.0)
      end

      it 'provides condition text' do
        expect(subject.current.condition_text).to eq('Sunny')
      end

      it 'provides condition code' do
        expect(subject.current.condition_code).to eq(1000)
      end

      it 'includes maximum temperature from today forecast' do
        expect(subject.current.maxtemp_c).to eq(25.0)
      end

      it 'includes minimum temperature from today forecast' do
        expect(subject.current.mintemp_c).to eq(18.0)
      end
    end

    describe 'forecast days' do
      it 'excludes current day from forecast days' do
        expect(subject.forecast_days.size).to eq(2)
      end

      describe 'tomorrow forecast' do
        let(:tomorrow) { subject.forecast_days[0] }

        it 'has correct date' do
          expect(tomorrow.date).to eq('2023-10-02')
        end

        it 'has correct condition text' do
          expect(tomorrow.condition_text).to eq('Partly cloudy')
        end

        it 'has correct maximum temperature' do
          expect(tomorrow.maxtemp_c).to eq(23.0)
        end
      end

      describe 'day after tomorrow forecast' do
        let(:day_after) { subject.forecast_days[1] }

        it 'has correct date' do
          expect(day_after.date).to eq('2023-10-03')
        end

        it 'has correct condition text' do
          expect(day_after.condition_text).to eq('Cloudy')
        end

        it 'has correct maximum temperature' do
          expect(day_after.maxtemp_c).to eq(20.0)
        end
      end
    end

    it 'indicates cache was not hit' do
      expect(subject.cache_hit).to be false
    end
  end

  describe 'when cache is hit' do
    let(:cache_hit) { true }

    it 'indicates cache was hit' do
      expect(subject.cache_hit).to be true
    end

    it 'still processes location data correctly' do
      expect(subject.location.name).to eq('San Francisco')
    end
  end

  describe 'object composition' do
    let(:cache_hit) { false }

    it 'creates location object of correct type' do
      expect(subject.location).to be_a(WeatherApi::Location)
    end

    it 'creates current weather object of correct type' do
      expect(subject.current).to be_a(WeatherApi::Current)
    end

    it 'creates condition object for current weather' do
      expect(subject.current.condition).to be_a(WeatherApi::Condition)
    end

    it 'creates forecast day object for current weather' do
      expect(subject.current.forecast).to be_a(WeatherApi::ForecastDay)
    end

    it 'creates forecast day objects for each forecast day' do
      subject.forecast_days.each do |day|
        expect(day).to be_a(WeatherApi::ForecastDay)
      end
    end

    it 'creates condition objects for each forecast day' do
      subject.forecast_days.each do |day|
        expect(day.condition).to be_a(WeatherApi::Condition)
      end
    end
  end

  describe 'delegation behavior' do
    let(:cache_hit) { false }

    it 'delegates current condition text correctly' do
      expect(subject.current.condition_text).to eq('Sunny')
    end

    it 'delegates forecast condition text correctly' do
      expect(subject.forecast_days.first.condition_text).to eq('Partly cloudy')
    end
  end
end
