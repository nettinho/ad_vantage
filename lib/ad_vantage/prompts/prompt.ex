defmodule AdVantage.Prompts.Prompt do
  use Ecto.Schema
  import Ecto.Changeset

  schema "prompts" do
    field :name, :string
    field :is_default, :boolean, default: false

    embeds_many :content, PromptContent, on_replace: :delete do
      field :type, :string, default: "text"
      field :text, :string
    end

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(prompt, attrs) do
    prompt
    |> cast(attrs, [:name, :is_default])
    |> validate_required([:name, :is_default])
    |> cast_embed(:content,
      with: &content_changeset/2,
      sort_param: :content_order,
      drop_param: :content_delete
    )
  end

  def content_changeset(content, attrs) do
    content
    |> cast(attrs, [:text, :type])
  end
end
