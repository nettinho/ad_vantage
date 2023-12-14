defmodule AdVantage.Repo.Migrations.CreatePrompts do
  use Ecto.Migration

  def change do
    create table(:prompts) do
      add :name, :string
      add :is_default, :boolean, default: false, null: false
      add :content, :map

      timestamps(type: :utc_datetime)
    end
  end
end
