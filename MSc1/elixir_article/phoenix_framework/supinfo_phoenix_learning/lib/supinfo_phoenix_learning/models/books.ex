defmodule SupinfoPhoenixLearning.SupinfoPhoenixLearningWeb.Books do
  use Ecto.Schema
  import Ecto.Changeset
  alias SupinfoPhoenixLearning.SupinfoPhoenixLearningWeb.Books
  alias SupinfoPhoenixLearning.Repo
  require Logger

  @derive {Poison.Encoder, only: [:author, :bookId, :title, :editor, :publicationDate]}


  schema "books" do
    field :author, :string
    field :bookID, :string
    field :editor, :string
    field :publicationDate, :utc_datetime
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(%Books{} = books, attrs \\ %{}) do
    books
    |> cast(attrs, [:bookID, :title, :author, :editor, :publicationDate])
    |> validate_required([:bookID, :title, :author])
    |> unique_constraint(:bookID)
  end

  def changeset_update(%Books{} = books, attrs \\ %{}) do
    books
    |> cast(attrs, [:title, :author, :editor, :publicationDate])
  end

  defp get_pub_date(%{"publication-date" => date}) do
    date
  end

  defp get_pub_date(%{"publicationDate" => date}) do
    date
  end

  defp get_id(%{"book-id" => id}), do: id 

  defp get_id(%{"bookID" => id}), do: id  

  def parse(book) do
    date = get_pub_date(book)
    pub_date = Ecto.DateTime.cast date
    pub_date =
      unless elem(pub_date, 0) == :ok do
        nil 
      else
        elem(pub_date, 1)
      end

    %Books{
      bookID: get_id(book),
      title: book["title"],
      author: book["author"],
      editor: book["editor"],
      publicationDate: pub_date
    }
  end

  def update(old, new) do
    old
    |> changeset_update(new)
    |> Repo.update()
  end
end
