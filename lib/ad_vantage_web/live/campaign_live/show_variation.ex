defmodule AdVantageWeb.CampaignLive.ShowVariation do
  use AdVantageWeb, :live_view

  alias AdVantage.Campaings
  alias AdVantage.Campaings.Validation
  alias AdVantage.LLMApi

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(AdVantage.PubSub, "validations")
    end

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id, "variation_id" => variation_id}, _, socket) do
    variation = Campaings.get_campaign_variation!(variation_id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:variation, variation)
     |> assign(:campaign, Campaings.get_campaign!(id))
     |> stream(:validations, variation.validations)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    validation = Campaings.get_validation!(id)
    {:ok, _} = Campaings.delete_validation(validation)

    {:noreply, stream_delete(socket, :validations, validation)}
  end

  def handle_event("run_validation", _, socket) do
    variation = socket.assigns.variation

    {:ok, validation} =
      Campaings.create_validation(%{campaign_variation_id: variation.id})

    LLMApi.validate(validation)
    {:noreply, socket}
  end

  def handle_event("rerun_validation", %{"id" => validation_id}, socket) do
    validation = Campaings.get_validation!(validation_id)

    LLMApi.validate(validation)
    {:noreply, socket}
  end

  @impl true
  def handle_event(_, _, socket) do
    {:noreply, socket}
  end

  defp page_title(:show_variation), do: gettext("Detalle variación")
  defp page_title(:edit_variation), do: gettext("Editar variación")

  @impl true
  def handle_info(
        {_, %Validation{campaign_variation_id: var_id} = validation},
        %{assigns: %{variation: %{id: var_id}}} = socket
      ) do
    {:noreply, stream_insert(socket, :validations, validation)}
  end
end
