defmodule AdVantage.Campaings.Validation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "validations" do
    field :approved, :boolean, default: false
    field :explanation, :string
    field :campaign_variation_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(validation, attrs) do
    validation
    |> cast(attrs, [:approved, :explanation])
    |> validate_required([:approved, :explanation])
  end
end
