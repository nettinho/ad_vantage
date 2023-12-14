defmodule AdVantageWeb.CampaignLive.Show do
  use AdVantageWeb, :live_view

  alias AdVantage.Campaings
  alias AdVantage.Campaings.CampaignVariation

  @impl true
  def mount(_params, _session, socket) do
    channels = Campaings.list_channels()

    {:ok, assign(socket, :channels, channels)}
  end

  @impl true
  def handle_params(params, _, socket) do
    id = Map.get(params, "id")
    variation_id = Map.get(params, "variation_id")
    channel_id = Map.get(params, "channel_id")

    campaign = Campaings.get_campaign!(id)

    socket =
      socket.assigns.channels
      |> Enum.map(&{&1.id, channel_variations(campaign, &1.id)})
      |> Enum.reduce(socket, fn {channel_id, variations}, socket ->
        stream(socket, variations_stream(channel_id), variations)
      end)

    {:noreply,
     socket
     |> apply_action(socket.assigns.live_action, variation_id)
     |> assign(:campaign, campaign)
     |> assign(:channel_id, channel_id)}
  end

  @impl true
  def handle_info(
        {AdVantageWeb.CampaignLive.VariationFormComponent, {:saved, variation, channel_id}},
        socket
      ) do
    {:noreply, stream_insert(socket, variations_stream(channel_id), variation)}
  end

  def handle_info({AdVantageWeb.CampaignLive.FormComponent, _}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    id
    |> Campaings.get_campaign_variation!()
    |> Campaings.delete_campaign_variation()

    {:noreply, socket}
  end

  defp apply_action(socket, :edit_variation, variation_id) do
    socket
    |> assign(:page_title, gettext("Editar variación"))
    |> assign(:variation, Campaings.get_campaign_variation!(variation_id))
  end

  defp apply_action(socket, :new_variation, _) do
    socket
    |> assign(:page_title, gettext("Nueva variación"))
    |> assign(:variation, %CampaignVariation{})
  end

  defp apply_action(socket, :show, _) do
    assign(socket, :page_title, gettext("Ver campaña"))
  end

  defp apply_action(socket, :edit, _) do
    assign(socket, :page_title, gettext("Editar campaña"))
  end

  def channel_variations(campaign, channel_id) do
    campaign
    |> Map.get(:variations)
    |> Enum.filter(&(&1.variation.channel_id == channel_id))
  end

  def variations_stream(channel_id), do: String.to_atom("variations_channel_#{channel_id}")
end
