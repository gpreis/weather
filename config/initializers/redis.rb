# # Configure Redis connection with Hiredis for better performance
# Rails.application.configure do
#   config.to_prepare do
#     redis_url = ENV.fetch("REDIS_URL", "redis://localhost:6379/0")

#     # Configure Redis to use Hiredis for better performance
#     Redis.current = Redis.new(
#       url: redis_url,
#       driver: :hiredis,
#       # Connection pool settings
#       reconnect_attempts: 3,
#       # Timeout settings
#       connect_timeout: 5,
#       read_timeout: 1,
#       write_timeout: 1
#     )
#   end
# end
