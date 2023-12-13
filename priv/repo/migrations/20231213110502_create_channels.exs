defmodule AdVantage.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add :name, :string
      add :offering, :string

      timestamps(type: :utc_datetime)
    end
  end
end
