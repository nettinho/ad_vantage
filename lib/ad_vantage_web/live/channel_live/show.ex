defmodule AdVantageWeb.ChannelLive.Show do
  use AdVantageWeb, :live_view

  alias AdVantage.Campaings
  alias AdVantage.Campaings.Variation

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    id = Map.get(params, "id")
    variation_id = Map.get(params, "variation_id")

    channel = Campaings.get_channel!(id)

    {:noreply,
     socket
     |> apply_action(socket.assigns.live_action, variation_id)
     |> assign(:channel, channel)
     |> stream(:variations, channel.variations)}
  end

  @impl true
  def handle_info({AdVantageWeb.ChannelLive.VariationFormComponent, {:saved, variation}}, socket) do
    {:noreply, stream_insert(socket, :variations, variation)}
  end

  def handle_info({AdVantageWeb.ChannelLive.FormComponent, _}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    variation = Campaings.get_variation!(id)
    {:ok, _} = Campaings.delete_variation(variation)

    {:noreply, stream_delete(socket, :variations, variation)}
  end

  defp apply_action(socket, :edit_variation, variation_id) do
    socket
    |> assign(:page_title, gettext("Editar variación"))
    |> assign(:variation, Campaings.get_variation!(variation_id))
  end

  defp apply_action(socket, :new_variation, _) do
    socket
    |> assign(:page_title, gettext("Nueva variación"))
    |> assign(:variation, %Variation{})
  end

  defp apply_action(socket, :show, _) do
    assign(socket, :page_title, gettext("Ver canal"))
  end

  defp apply_action(socket, :edit, _) do
    assign(socket, :page_title, gettext("Editar canal"))
  end
end
