defmodule AdVantageWeb.ValidationLive.FormComponent do
  use AdVantageWeb, :live_component

  alias AdVantage.Campaings

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage validation records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="validation-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:approved]} type="checkbox" label="Approved" />
        <.input field={@form[:explanation]} type="text" label="Explanation" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Validation</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{validation: validation} = assigns, socket) do
    changeset = Campaings.change_validation(validation)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"validation" => validation_params}, socket) do
    changeset =
      socket.assigns.validation
      |> Campaings.change_validation(validation_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"validation" => validation_params}, socket) do
    save_validation(socket, socket.assigns.action, validation_params)
  end

  defp save_validation(socket, :edit, validation_params) do
    case Campaings.update_validation(socket.assigns.validation, validation_params) do
      {:ok, validation} ->
        notify_parent({:saved, validation})

        {:noreply,
         socket
         |> put_flash(:info, "Validation updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_validation(socket, :new, validation_params) do
    case Campaings.create_validation(validation_params) do
      {:ok, validation} ->
        notify_parent({:saved, validation})

        {:noreply,
         socket
         |> put_flash(:info, "Validation created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
