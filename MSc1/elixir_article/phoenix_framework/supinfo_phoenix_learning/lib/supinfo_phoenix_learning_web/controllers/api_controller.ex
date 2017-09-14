defmodule SupinfoPhoenixLearningWeb.ApiController do
  use SupinfoPhoenixLearningWeb, :controller

  def healthy(conn, _par) do
    json conn, "healthy"
  end

  def get_test(conn, _par) do
   json conn, "Get Ok"
  end 

  def post_test(conn, obj) do
    json conn, %{ok: "Post well recievied", object: obj}
  end

  def put_test(conn, obj) do
    json conn, %{ok: "Put well recievied", object: obj}
  end

  def delete_test(conn, obj) do
    json conn, %{ok: "Delete well recievied", object: obj}
  end
end
