defmodule AdVantage.Repo.Migrations.AddStatusToValidations do
  use Ecto.Migration

  def change do
    alter table(:validations) do
      add :status, :string
      add :message, :string
    end
  end
end
