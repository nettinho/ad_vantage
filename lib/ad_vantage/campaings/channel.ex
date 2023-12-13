defmodule AdVantage.Campaings.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  alias AdVantage.Campaings.Variation

  schema "channels" do
    field :name, :string
    field :offering, :string

    has_many :variations, Variation

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:name, :offering])
    |> validate_required([:name])
  end
end
