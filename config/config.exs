# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ad_vantage,
  ecto_repos: [AdVantage.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :ad_vantage, AdVantageWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [html: AdVantageWeb.ErrorHTML, json: AdVantageWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: AdVantage.PubSub,
  live_view: [signing_salt: "4JhwlGa2"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :ad_vantage, AdVantage.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :azurex, Azurex.Blob.Config,
  # api_url: "https://sample.blob.core.windows.net", # Optional
  # default_container: "defaultcontainer", # Optional
  storage_account_name: "indplatformpamlsaiaem",
  storage_account_key:
    "x3tN0UPD46HHb9URjbpRvUDEgXimSCyFzzBZYG77s7dHijeDIoiJJYnA66cp0a3BCM94+MFDKn8V+AStblJQQQ=="

config :ad_vantage, storage_container: "advantage"

# storage_account_connection_string: "Storage=Account;Connection=String" # Required if storage account `name` and `key` not set

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
