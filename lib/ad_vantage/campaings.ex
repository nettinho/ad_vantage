defmodule AdVantage.Campaings do
  @moduledoc """
  The Campaings context.
  """

  import Ecto.Query, warn: false
  alias AdVantage.Repo

  alias AdVantage.Campaings.Campaign

  @doc """
  Returns the list of campaigns.

  ## Examples

      iex> list_campaigns()
      [%Campaign{}, ...]

  """
  def list_campaigns do
    Repo.all(Campaign)
  end

  @doc """
  Gets a single campaign.

  Raises `Ecto.NoResultsError` if the Campaign does not exist.

  ## Examples

      iex> get_campaign!(123)
      %Campaign{}

      iex> get_campaign!(456)
      ** (Ecto.NoResultsError)

  """
  def get_campaign!(id),
    do:
      Campaign
      |> Repo.get!(id)
      |> Repo.preload(variations: [:variation])

  @doc """
  Creates a campaign.

  ## Examples

      iex> create_campaign(%{field: value})
      {:ok, %Campaign{}}

      iex> create_campaign(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_campaign(attrs \\ %{}) do
    %Campaign{}
    |> Campaign.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a campaign.

  ## Examples

      iex> update_campaign(campaign, %{field: new_value})
      {:ok, %Campaign{}}

      iex> update_campaign(campaign, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_campaign(%Campaign{} = campaign, attrs) do
    campaign
    |> Campaign.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a campaign.

  ## Examples

      iex> delete_campaign(campaign)
      {:ok, %Campaign{}}

      iex> delete_campaign(campaign)
      {:error, %Ecto.Changeset{}}

  """
  def delete_campaign(%Campaign{} = campaign) do
    Repo.delete(campaign)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking campaign changes.

  ## Examples

      iex> change_campaign(campaign)
      %Ecto.Changeset{data: %Campaign{}}

  """
  def change_campaign(%Campaign{} = campaign, attrs \\ %{}) do
    Campaign.changeset(campaign, attrs)
  end

  alias AdVantage.Campaings.Channel

  @doc """
  Returns the list of channels.

  ## Examples

      iex> list_channels()
      [%Channel{}, ...]

  """
  def list_channels do
    Repo.all(Channel)
  end

  @doc """
  Gets a single channel.

  Raises `Ecto.NoResultsError` if the Channel does not exist.

  ## Examples

      iex> get_channel!(123)
      %Channel{}

      iex> get_channel!(456)
      ** (Ecto.NoResultsError)

  """
  def get_channel!(id),
    do:
      Channel
      |> Repo.get!(id)
      |> Repo.preload(:variations)

  @doc """
  Creates a channel.

  ## Examples

      iex> create_channel(%{field: value})
      {:ok, %Channel{}}

      iex> create_channel(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_channel(attrs \\ %{}) do
    %Channel{}
    |> Channel.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a channel.

  ## Examples

      iex> update_channel(channel, %{field: new_value})
      {:ok, %Channel{}}

      iex> update_channel(channel, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_channel(%Channel{} = channel, attrs) do
    channel
    |> Channel.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a channel.

  ## Examples

      iex> delete_channel(channel)
      {:ok, %Channel{}}

      iex> delete_channel(channel)
      {:error, %Ecto.Changeset{}}

  """
  def delete_channel(%Channel{} = channel) do
    Repo.delete(channel)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking channel changes.

  ## Examples

      iex> change_channel(channel)
      %Ecto.Changeset{data: %Channel{}}

  """
  def change_channel(%Channel{} = channel, attrs \\ %{}) do
    Channel.changeset(channel, attrs)
  end

  alias AdVantage.Campaings.Variation

  @doc """
  Returns the list of variations.

  ## Examples

      iex> list_variations()
      [%Variation{}, ...]

  """
  def list_variations do
    Repo.all(Variation)
  end

  @doc """
  Gets a single variation.

  Raises `Ecto.NoResultsError` if the Variation does not exist.

  ## Examples

      iex> get_variation!(123)
      %Variation{}

      iex> get_variation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_variation!(id), do: Repo.get!(Variation, id)

  @doc """
  Creates a variation.

  ## Examples

      iex> create_variation(%{field: value})
      {:ok, %Variation{}}

      iex> create_variation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_variation(attrs \\ %{}) do
    %Variation{}
    |> Variation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a variation.

  ## Examples

      iex> update_variation(variation, %{field: new_value})
      {:ok, %Variation{}}

      iex> update_variation(variation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_variation(%Variation{} = variation, attrs) do
    variation
    |> Variation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a variation.

  ## Examples

      iex> delete_variation(variation)
      {:ok, %Variation{}}

      iex> delete_variation(variation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_variation(%Variation{} = variation) do
    Repo.delete(variation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking variation changes.

  ## Examples

      iex> change_variation(variation)
      %Ecto.Changeset{data: %Variation{}}

  """
  def change_variation(%Variation{} = variation, attrs \\ %{}) do
    Variation.changeset(variation, attrs)
  end

  alias AdVantage.Campaings.CampaignVariation

  @doc """
  Returns the list of campaign_variations.

  ## Examples

      iex> list_campaign_variations()
      [%CampaignVariation{}, ...]

  """
  def list_campaign_variations do
    Repo.all(CampaignVariation)
  end

  @doc """
  Gets a single campaign_variation.

  Raises `Ecto.NoResultsError` if the Campaign variation does not exist.

  ## Examples

      iex> get_campaign_variation!(123)
      %CampaignVariation{}

      iex> get_campaign_variation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_campaign_variation!(id),
    do:
      CampaignVariation
      |> Repo.get!(id)
      |> Repo.preload(:variation)

  @doc """
  Creates a campaign_variation.

  ## Examples

      iex> create_campaign_variation(%{field: value})
      {:ok, %CampaignVariation{}}

      iex> create_campaign_variation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_campaign_variation(attrs \\ %{}) do
    %CampaignVariation{}
    |> CampaignVariation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a campaign_variation.

  ## Examples

      iex> update_campaign_variation(campaign_variation, %{field: new_value})
      {:ok, %CampaignVariation{}}

      iex> update_campaign_variation(campaign_variation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_campaign_variation(%CampaignVariation{} = campaign_variation, attrs) do
    campaign_variation
    |> CampaignVariation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a campaign_variation.

  ## Examples

      iex> delete_campaign_variation(campaign_variation)
      {:ok, %CampaignVariation{}}

      iex> delete_campaign_variation(campaign_variation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_campaign_variation(%CampaignVariation{} = campaign_variation) do
    Repo.delete(campaign_variation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking campaign_variation changes.

  ## Examples

      iex> change_campaign_variation(campaign_variation)
      %Ecto.Changeset{data: %CampaignVariation{}}

  """
  def change_campaign_variation(%CampaignVariation{} = campaign_variation, attrs \\ %{}) do
    CampaignVariation.changeset(campaign_variation, attrs)
  end

  alias AdVantage.Campaings.Validation

  @doc """
  Returns the list of validations.

  ## Examples

      iex> list_validations()
      [%Validation{}, ...]

  """
  def list_validations do
    Repo.all(Validation)
  end

  @doc """
  Gets a single validation.

  Raises `Ecto.NoResultsError` if the Validation does not exist.

  ## Examples

      iex> get_validation!(123)
      %Validation{}

      iex> get_validation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_validation!(id), do: Repo.get!(Validation, id)

  @doc """
  Creates a validation.

  ## Examples

      iex> create_validation(%{field: value})
      {:ok, %Validation{}}

      iex> create_validation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_validation(attrs \\ %{}) do
    %Validation{}
    |> Validation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a validation.

  ## Examples

      iex> update_validation(validation, %{field: new_value})
      {:ok, %Validation{}}

      iex> update_validation(validation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_validation(%Validation{} = validation, attrs) do
    validation
    |> Validation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a validation.

  ## Examples

      iex> delete_validation(validation)
      {:ok, %Validation{}}

      iex> delete_validation(validation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_validation(%Validation{} = validation) do
    Repo.delete(validation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking validation changes.

  ## Examples

      iex> change_validation(validation)
      %Ecto.Changeset{data: %Validation{}}

  """
  def change_validation(%Validation{} = validation, attrs \\ %{}) do
    Validation.changeset(validation, attrs)
  end
end
