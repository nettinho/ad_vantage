defmodule AdVantage.Repo.Migrations.ModifyValidationMessageToText do
  use Ecto.Migration

  def change do
    alter table(:validations) do
      modify :message, :text
      modify :explanation, :text
    end
  end
end
