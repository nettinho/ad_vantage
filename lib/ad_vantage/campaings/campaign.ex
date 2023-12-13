defmodule AdVantage.Campaings.Campaign do
  use Ecto.Schema
  import Ecto.Changeset

  alias AdVantage.Campaings.CampaignVariation

  schema "campaigns" do
    field :name, :string
    field :filename, :string
    field :description, :string

    has_many :variations, CampaignVariation

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(campaign, attrs) do
    campaign
    |> cast(attrs, [:name, :description, :filename])
    |> validate_required([:name, :filename])
  end
end
