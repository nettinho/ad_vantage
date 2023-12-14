defmodule AdVantageWeb.ValidationLive.Show do
  use AdVantageWeb, :live_view

  alias AdVantage.Campaings

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    %{
      campaign_variation: %{
        id: campaign_variation_id,
        campaign: campaign,
        variation: variation
      }
    } = validation = Campaings.get_validation!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:validation, validation)
     |> assign(:campaign, campaign)
     |> assign(:variation, variation)
     |> assign(:campaign_variation_id, campaign_variation_id)}
  end

  defp page_title(:show), do: gettext("Detalle validación")
  defp page_title(:edit), do: gettext("Edit validación")

  def parse_errors(errors) do
    Enum.flat_map(errors, &Enum.map(&1, fn x -> x end))
  end
end
