# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :aoc, AocWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wd7y1rQGF3f0XUVpi1VffhFxbVIR35P7h3Tzy5H/UjBC8ME+WWlRMTLeK79Q2ehE",
  render_errors: [view: AocWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Aoc.PubSub,
  live_view: [signing_salt: "E9+osj1Y"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
