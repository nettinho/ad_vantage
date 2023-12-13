defmodule AdVantage.Repo.Migrations.CreateVariations do
  use Ecto.Migration

  def change do
    create table(:variations) do
      add :name, :string
      add :description, :string
      add :orientation, :string
      add :width, :integer
      add :height, :integer
      add :margin, :integer
      add :has_logo, :boolean, default: false, null: false
      add :tone, :string
      add :target, :string
      add :channel_id, references(:channels, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:variations, [:channel_id])
  end
end
