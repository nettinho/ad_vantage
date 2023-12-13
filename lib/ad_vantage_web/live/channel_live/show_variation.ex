defmodule AdVantageWeb.ChannelLive.ShowVariation do
  use AdVantageWeb, :live_view

  alias AdVantage.Campaings

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id, "variation_id" => variation_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:variation, Campaings.get_variation!(variation_id))
     |> assign(:channel, Campaings.get_channel!(id))}
  end

  defp page_title(:show_variation), do: gettext("Detalle variación")
  defp page_title(:edit_variation), do: gettext("Editar variación")
end
