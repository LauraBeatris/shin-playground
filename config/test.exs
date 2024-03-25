import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :shin_playground, ShinPlaygroundWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "RgyWKR2zze3/smyLdWI8TmxJhBNUotBS9ORT7XJT+w0e8AY1oU78hDhA0KC7ZYTL",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
