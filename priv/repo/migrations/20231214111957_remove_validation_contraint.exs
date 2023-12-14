defmodule AdVantage.Repo.Migrations.RemoveValidationContraint do
  use Ecto.Migration

  def change do
    execute("DELETE FROM validations")

    alter table(:validations) do
      remove :campaign_variation_id, references(:campaign_variations, on_delete: :nothing)
    end

    alter table(:validations) do
      add :campaign_variation_id, references(:campaign_variations, on_delete: :delete_all)
    end
  end
end
