defmodule SupinfoPhoenixLearningWeb.HelloController do
  use SupinfoPhoenixLearningWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def polite_messenger(conn, %{"nom" => messenger, "sexe" => gender}) do
    render conn, "polite.html", messenger: messenger, gender: gender
  end
end
