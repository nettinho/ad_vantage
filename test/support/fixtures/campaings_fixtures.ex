defmodule AdVantage.CampaingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AdVantage.Campaings` context.
  """

  @doc """
  Generate a campaign.
  """
  def campaign_fixture(attrs \\ %{}) do
    {:ok, campaign} =
      attrs
      |> Enum.into(%{
        description: "some description",
        filename: "some filename",
        name: "some name"
      })
      |> AdVantage.Campaings.create_campaign()

    campaign
  end

  @doc """
  Generate a channel.
  """
  def channel_fixture(attrs \\ %{}) do
    {:ok, channel} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> AdVantage.Campaings.create_channel()

    channel
  end

  @doc """
  Generate a variation.
  """
  def variation_fixture(attrs \\ %{}) do
    {:ok, variation} =
      attrs
      |> Enum.into(%{
        description: "some description",
        has_logo: true,
        height: 42,
        margin: 42,
        name: "some name",
        orientation: "some orientation",
        target: "some target",
        tone: "some tone",
        width: 42
      })
      |> AdVantage.Campaings.create_variation()

    variation
  end

  @doc """
  Generate a campaign_channel.
  """
  def campaign_channel_fixture(attrs \\ %{}) do
    {:ok, campaign_channel} =
      attrs
      |> Enum.into(%{})
      |> AdVantage.Campaings.create_campaign_channel()

    campaign_channel
  end

  @doc """
  Generate a campaign_variation.
  """
  def campaign_variation_fixture(attrs \\ %{}) do
    {:ok, campaign_variation} =
      attrs
      |> Enum.into(%{
        explanation: "some explanation",
        filename: "some filename"
      })
      |> AdVantage.Campaings.create_campaign_variation()

    campaign_variation
  end

  @doc """
  Generate a validation.
  """
  def validation_fixture(attrs \\ %{}) do
    {:ok, validation} =
      attrs
      |> Enum.into(%{
        approved: true,
        explanation: "some explanation"
      })
      |> AdVantage.Campaings.create_validation()

    validation
  end
end
