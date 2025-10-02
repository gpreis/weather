# Weather Forecast App

A modern Ruby on Rails application that provides 5-day weather forecasts with intelligent caching and geolocation services. Built with Rails 8, Redis caching, and Tailwind CSS.

## Features

- **Address-based Weather Search**: Enter any address to get weather forecasts
- **Intelligent Geocoding**: Automatic postal code detection and coordinate conversion
- **5-Day Weather Forecasts**: Detailed weather information including temperature and conditions
- **Redis Caching**: High-performance caching with visual cache hit indicators
- **Responsive Design**: Beautiful, mobile-friendly interface built with Tailwind CSS
- **Cache Status Indicators**: Visual feedback showing when data is served from cache vs fresh API calls

### Cache Hit Indicators

The application displays cache status with color-coded indicators:
- **🔵 Blue "CACHE HIT" tag**: Data was retrieved from Redis cache (faster response)
- **🔴 Red "CACHE HIT" tag**: Data was fetched fresh from the weather API (slower response)

This helps users understand response times and demonstrates the caching system in action.

## Technical Stack

- **Backend**: Ruby 3.4.6, Rails 8.0.3
- **Caching**: Redis 5.4 with Hiredis driver for performance
- **Frontend**: Tailwind CSS 4.3 with modern responsive design
- **HTTP Client**: Faraday 2.14 for external API communication
- **Geocoding**: Geocoder gem for address-to-coordinates and address-to-zipcode conversion
- **Testing**: RSpec 8.0.2 with comprehensive test coverage
- **Code Quality**: RuboCop with Rails Omakase styling

## Quick Start

### Prerequisites

- Ruby 3.4.6+
- Rails 8.0.3+
- Redis server
- Bundler gem

### Installation

1. **Clone the repository**
   ```bash
   git clone git@github.com:gpreis/weather.git
   cd weather
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Environment Configuration**

   Create a `.env` file or set environment variables:
   ```bash
   # Weather API Configuration
   OPENWEATHER_API_KEY=your_weather_api_key_here

   # Redis Configuration
   REDIS_URL=redis://localhost:6379/0
   ```

   > ⚠️ **Security Note**: The default API key is hardcoded for demonstration purposes only. In production, always use proper environment variables and secret management.

4. **Start Redis Server**

   Choose one of the following options:

   **Option A: Docker Compose (Recommended)**
   ```bash
   docker-compose up redis
   ```

   **Option B: Local Installation**
   ```bash
   # macOS with Homebrew
   brew install redis && brew services start redis

   # Ubuntu/Debian
   sudo apt-get install redis-server && sudo systemctl start redis-server

   # Windows (using WSL or direct installation)
   # Follow Redis documentation for Windows setup
   ```

5. **Start the Application**
   ```bash
   # Development server
   bundle exec rails server

   # With custom port
   bundle exec rails server -p 3001
   ```

6. **Visit the Application**

   Open your browser and navigate to: `http://localhost:3000`

## Testing

The application includes comprehensive test coverage following Better Specs guidelines:

```bash
# Run all tests
bundle exec rspec

# Run with documentation format
bundle exec rspec --format documentation

# Run specific test types
bundle exec rspec spec/models/     # Model tests
bundle exec rspec spec/requests/   # Request/integration tests
bundle exec rspec spec/routing/    # Routing tests
```

### Test Coverage

- **Model Tests**: 130+ examples covering all WeatherApi models
- **Request Tests**: 30+ examples testing controller endpoints
- **Integration Tests**: 20+ examples testing end-to-end workflows
- **Routing Tests**: Complete route coverage with path helpers

## Configuration

### Redis Caching

The application uses Redis with the Hiredis driver for optimal performance:

- **Cache Duration**: 30 minutes for weather data
- **Cache Keys**: `forecast_{postal_code}` format
- **Connection Pool**: Configured for high concurrency
- **Fallback**: Graceful degradation if Redis is unavailable

### Weather API Integration

- **Provider**: WeatherAPI.com
- **Endpoints**: Current weather and 5-day forecast
- **Rate Limiting**: Cached responses reduce API calls
- **Error Handling**: Graceful fallbacks for API failures

### Geocoding Service

- **Provider**: Multiple geocoding services via Geocoder gem
- **Input**: Street addresses, city names, landmarks
- **Output**: Coordinates and postal codes for weather API calls
- **Caching**: Geocoding results cached to reduce external calls

## Deployment

### Development Environment

```bash
# Start all services
bin/dev

# Or individually
bundle exec rails server
docker-compose up redis (or start local Redis server)
```

### Production Deployment

The application has not been configured for production deployment yet, even if has some basic configuration for Kamal.

## Project Structure

```
app/
├── controllers/         # Request handling
│   └── forecast_controller.rb
├── models/             # Data models
│   └── weather_api/    # Weather API response models
├── services/           # Business logic
│   ├── geolocation_service.rb
│   └── weather_forecast_service.rb
├── views/              # Templates
│   └── forecast/       # Weather forecast views
└── assets/             # Stylesheets and JavaScript

config/
├── initializers/
│   └── redis.rb        # Redis configuration
├── routes.rb           # Application routes
└── deploy.yml          # Kamal deployment config

spec/                   # Test suite
├── models/             # Model tests
├── requests/           # Request tests
├── routing/            # Routing tests
└── integration/        # Integration tests
```

## Development

### Code Quality

```bash
# Run RuboCop for style checking
bundle exec rubocop

# Auto-fix style issues
bundle exec rubocop -a

# Security audit
bundle exec brakeman
```

### Code Standards

- Follow Better Specs guidelines for testing
- Use RuboCop Rails Omakase configuration
- Write descriptive commit messages
- Include tests for new features (using better specs specification)
- Update documentation as needed
