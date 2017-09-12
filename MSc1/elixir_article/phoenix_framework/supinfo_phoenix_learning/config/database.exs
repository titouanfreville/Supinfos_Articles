use Mix.Config

config :supinfo_phoenix_learning, SupinfoPhoenixLearning.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "supinfo_phoenix_learning",
  username: "supinfo",
  password: "supinfou",
  hostname: "0.0.0.0"