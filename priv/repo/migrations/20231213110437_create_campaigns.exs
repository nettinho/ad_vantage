defmodule AdVantage.Repo.Migrations.CreateCampaigns do
  use Ecto.Migration

  def change do
    create table(:campaigns) do
      add :name, :string
      add :description, :text
      add :filename, :string

      timestamps(type: :utc_datetime)
    end
  end
end
