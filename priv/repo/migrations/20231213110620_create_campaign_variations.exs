defmodule AdVantage.Repo.Migrations.CreateCampaignVariations do
  use Ecto.Migration

  def change do
    create table(:campaign_variations) do
      add :filename, :string
      add :explanation, :string
      add :campaign_id, references(:campaigns, on_delete: :nothing)
      add :variation_id, references(:variations, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:campaign_variations, [:campaign_id])
    create index(:campaign_variations, [:variation_id])
  end
end
