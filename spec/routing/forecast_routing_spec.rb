require 'rails_helper'

RSpec.describe 'Forecast Routing', type: :routing do
  describe 'routes' do
    it 'routes / to forecast#index' do
      expect(get: '/').to route_to(controller: 'forecast', action: 'index')
    end

    it 'routes /forecast to forecast#index' do
      expect(get: '/forecast').to route_to(controller: 'forecast', action: 'index')
    end

    it 'routes /forecast/search to forecast#search' do
      expect(get: '/forecast/search').to route_to(controller: 'forecast', action: 'search')
    end

    it 'rejects unsupported HTTP methods' do
      expect(post: '/forecast').not_to be_routable
      expect(put: '/forecast').not_to be_routable
      expect(delete: '/forecast').not_to be_routable
    end
  end

  describe 'path helpers' do
    it 'generates correct paths' do
      expect(forecast_index_path).to eq('/forecast')
      expect(search_forecast_index_path).to eq('/forecast/search')
    end
  end
end