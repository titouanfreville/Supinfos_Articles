# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :supinfo_phoenix_learning,
  ecto_repos: [SupinfoPhoenixLearning.Repo]

# Configures the endpoint
config :supinfo_phoenix_learning, SupinfoPhoenixLearningWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+ucabnei8Pl1O2ozjK1Z+viAy7x5M2to9kwKb6UyOPjUyTGpFJBzgZTFm+RVCD/9",
  render_errors: [view: SupinfoPhoenixLearningWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SupinfoPhoenixLearning.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "database.exs"
import_config "#{Mix.env}.exs"
