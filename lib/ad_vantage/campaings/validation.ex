defmodule AdVantage.Campaings.Validation do
  use Ecto.Schema
  import Ecto.Changeset

  alias AdVantage.Campaings.CampaignVariation

  schema "validations" do
    field :approved, :boolean, default: false
    field :explanation, :string
    field :status, :string, default: "init"
    field :message, :string

    field :raw_results, :string
    field :results, {:array, :map}
    field :valid_rate, :float

    belongs_to :campaign_variation, CampaignVariation

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(validation, attrs) do
    validation
    |> cast(attrs, [
      :approved,
      :explanation,
      :campaign_variation_id,
      :status,
      :message,
      :raw_results,
      :results,
      :valid_rate
    ])
    |> validate_required([:campaign_variation_id])
  end
end
