defmodule SupinfoPhoenixLearningWeb.BookController do
  use SupinfoPhoenixLearningWeb, :controller
  alias SupinfoPhoenixLearning.Repo
  alias SupinfoPhoenixLearning.SupinfoPhoenixLearningWeb.Books
  require Logger
  import Ecto.Query

  def index(conn, _par) do
    json conn, Repo.all(Books)
  end

  def edit(conn, %{"id" => id}) do
    Logger.debug "Edit ????"
    current_book = Repo.one(from b in Books, where: ilike(b.bookID, ^id))
    render conn, "edit.html", changeset: Books.changeset(%Books{}), old_book: current_book
  end

  def new(conn, _par) do
    render conn, "new.html", changeset: Books.changeset(%Books{})
  end

  def show(conn, %{"id" => id}) do
    json conn, Repo.one(from b in Books, where: ilike(b.bookID, ^id))
  end

  def create(conn, book) do
    ins_book = 
      if Map.has_key?(book, "book") do
        Books.parse book["book"]
      else
        Books.parse book
      end
    try do
      Repo.insert(ins_book)
      json conn, %{ok: "Well created book.", book: ins_book}
    rescue
      _ ->
        conn = conn.put_status 422
        json conn, %{ok: "Error while creating book.", book: ins_book}
    end
  end

  def update(conn, %{"id" => id, "book" => book}) do
    current_book = Repo.one(from b in Books, where: ilike(b.bookID, ^id))
    ins_book = 
      if Map.has_key?(book, "book") do
        book["book"]
      else
        book
      end
    res = Books.update(current_book, ins_book)
    unless elem(res, 0) == :ok do
      json conn, %{ok: "Error while updating book.", error: elem(res, 1), new_book: book}
    else
      json conn, %{ok: "Well updated book.", new_book: book}
    end
  end

  def delete(conn,  %{"id" => id}) do
    book = Repo.one(from b in Books, where: ilike(b.bookID, ^id))
    res = Repo.delete(book)
    unless elem(res, 0) == :ok do
      json conn, %{ok: "Error while deleting book.", error: elem(res, 1), book: book}
    else
      json conn, %{ok: "Well deleted book.", book: book}
    end
  end
end
