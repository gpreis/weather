# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

## Redis Cache Configuration

This application uses Redis with Hiredis for caching to improve performance.

### Local Development

For local development, you can either:

1. **Use Docker Compose** (recommended):
   ```bash
   docker-compose up redis
   ```

2. **Install Redis locally**:
   ```bash
   # macOS with Homebrew
   brew install redis
   brew services start redis

   # Ubuntu/Debian
   sudo apt-get install redis-server
   sudo systemctl start redis-server
   ```

The application will connect to Redis at `redis://localhost:6379/0` by default.

### Environment Variables

- `REDIS_URL`: Redis connection URL (default: `redis://localhost:6379/0`)

### Production Deployment

Redis is configured as an accessory service in the Kamal deployment configuration and will be automatically deployed alongside the application.

* Deployment instructions

* ...
