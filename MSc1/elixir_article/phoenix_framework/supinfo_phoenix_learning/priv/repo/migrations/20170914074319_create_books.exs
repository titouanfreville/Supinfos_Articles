defmodule SupinfoPhoenixLearning.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :author, :string
      add :bookID, :string
      add :editor, :string
      add :publicationDate, :utc_datetime
      add :title, :string

      timestamps()
    end

  end
end
