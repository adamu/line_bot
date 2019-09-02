import Config

case Mix.env() do
  :dev ->
    config :line_bot,
      client_id: 123,
      client_secret: "secret"

  :test ->
    config :line_bot,
      client_id: 123,
      client_secret: "secret",
      api_client: MockAPIClient,
      token_server: MockTokenServer

  _ ->
    []
end
