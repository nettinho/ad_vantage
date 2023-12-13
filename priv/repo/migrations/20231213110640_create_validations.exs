defmodule AdVantage.Repo.Migrations.CreateValidations do
  use Ecto.Migration

  def change do
    create table(:validations) do
      add :approved, :boolean, default: false, null: false
      add :explanation, :string
      add :campaign_variation_id, references(:campaign_variations, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:validations, [:campaign_variation_id])
  end
end
