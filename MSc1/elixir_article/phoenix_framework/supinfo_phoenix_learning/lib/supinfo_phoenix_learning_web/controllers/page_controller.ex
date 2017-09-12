defmodule SupinfoPhoenixLearningWeb.PageController do
  use SupinfoPhoenixLearningWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
