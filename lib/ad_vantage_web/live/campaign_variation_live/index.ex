defmodule AdVantageWeb.CampaignVariationLive.Index do
  use AdVantageWeb, :live_view

  alias AdVantage.Campaings
  alias AdVantage.Campaings.CampaignVariation

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :campaign_variations, Campaings.list_campaign_variations())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Campaign variation")
    |> assign(:campaign_variation, Campaings.get_campaign_variation!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Campaign variation")
    |> assign(:campaign_variation, %CampaignVariation{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Campaign variations")
    |> assign(:campaign_variation, nil)
  end

  @impl true
  def handle_info({AdVantageWeb.CampaignVariationLive.FormComponent, {:saved, campaign_variation}}, socket) do
    {:noreply, stream_insert(socket, :campaign_variations, campaign_variation)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    campaign_variation = Campaings.get_campaign_variation!(id)
    {:ok, _} = Campaings.delete_campaign_variation(campaign_variation)

    {:noreply, stream_delete(socket, :campaign_variations, campaign_variation)}
  end
end
