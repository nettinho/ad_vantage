defmodule AdVantage.Campaings.Variation do
  use Ecto.Schema
  import Ecto.Changeset

  alias AdVantage.Campaings.Channel

  schema "variations" do
    field :name, :string
    field :description, :string
    field :width, :integer
    field :target, :string
    field :orientation, :string
    field :height, :integer
    field :margin, :integer
    field :has_logo, :boolean, default: false
    field :tone, :string

    belongs_to :channel, Channel

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(variation, attrs) do
    variation
    |> cast(attrs, [
      :name,
      :description,
      :orientation,
      :width,
      :height,
      :margin,
      :has_logo,
      :tone,
      :target,
      :channel_id
    ])
    |> validate_required([
      :name,
      :channel_id
    ])
  end
end
