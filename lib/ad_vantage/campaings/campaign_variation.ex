defmodule AdVantage.Campaings.CampaignVariation do
  use Ecto.Schema
  import Ecto.Changeset

  alias AdVantage.Campaings.Campaign
  alias AdVantage.Campaings.Variation

  schema "campaign_variations" do
    field :filename, :string
    field :explanation, :string

    belongs_to :campaign, Campaign
    belongs_to :variation, Variation

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(campaign_variation, attrs) do
    campaign_variation
    |> cast(attrs, [:filename, :explanation, :campaign_id, :variation_id])
    |> validate_required([:filename, :explanation, :campaign_id, :variation_id])
  end
end
