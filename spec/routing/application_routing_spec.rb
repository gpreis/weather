require 'rails_helper'

RSpec.describe 'Application Routing', type: :routing do
  describe 'forecast routes' do
    it 'routes root to forecast#index' do
      expect(get: '/').to route_to(controller: 'forecast', action: 'index')
    end
  end

  describe 'path helpers' do
    it 'generates correct paths' do
      expect(root_path).to eq('/')
    end
  end
end
