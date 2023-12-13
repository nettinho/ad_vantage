defmodule AdVantageWeb.ValidationLive.Index do
  use AdVantageWeb, :live_view

  alias AdVantage.Campaings
  alias AdVantage.Campaings.Validation

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :validations, Campaings.list_validations())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Validation")
    |> assign(:validation, Campaings.get_validation!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Validation")
    |> assign(:validation, %Validation{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Validations")
    |> assign(:validation, nil)
  end

  @impl true
  def handle_info({AdVantageWeb.ValidationLive.FormComponent, {:saved, validation}}, socket) do
    {:noreply, stream_insert(socket, :validations, validation)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    validation = Campaings.get_validation!(id)
    {:ok, _} = Campaings.delete_validation(validation)

    {:noreply, stream_delete(socket, :validations, validation)}
  end
end
