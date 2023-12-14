defmodule AdVantage.Repo.Migrations.AddValidationResponse do
  use Ecto.Migration

  def change do
    alter table(:validations) do
      add :raw_results, :text
      add :results, :map
      add :valid_rate, :float
    end
  end
end
