defmodule SupinfoPhoenixLearningWeb.Router do
  use SupinfoPhoenixLearningWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json", "html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", SupinfoPhoenixLearningWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/alive", PageController, :alive
  end

  scope "/hello", SupinfoPhoenixLearningWeb do
    pipe_through :browser

    get "/", HelloController, :index
    get "/polite/:nom/:sexe", HelloController, :polite_messenger
  end

  scope "/api", SupinfoPhoenixLearningWeb do
    pipe_through :api

    get "/healthy", ApiController, :healthy
    get "/", ApiController, :get_test
    post "/", ApiController, :post_test
    put "/", ApiController, :put_test
    delete "/", ApiController, :delete_test

    # Ressources path for books
    resources "/books", BookController
  end
end
