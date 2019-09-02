import Config

config :line_bot,
  client_id: System.get_env("LINE_CLIENT_ID"),
  client_secret: System.get_env("LINE_CLIENT_SECRET")

# Use to skip request signature validation local testing.
# config :line_bot, skip_validation: true

config :line_bot_sample, port: System.get_env("PORT")
