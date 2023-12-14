defmodule AdVantage.Campaings.CampaignVariation do
  use Ecto.Schema
  import Ecto.Changeset

  alias AdVantage.Campaings.Campaign
  alias AdVantage.Campaings.Variation
  alias AdVantage.Campaings.Validation

  schema "campaign_variations" do
    field :filename, :string
    field :explanation, :string

    belongs_to :campaign, Campaign
    belongs_to :variation, Variation

    has_many :validations, Validation

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(campaign_variation, attrs) do
    campaign_variation
    |> cast(attrs, [:filename, :explanation, :campaign_id, :variation_id])
    |> validate_required([:filename, :campaign_id, :variation_id])
  end
end
