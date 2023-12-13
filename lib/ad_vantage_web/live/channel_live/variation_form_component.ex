defmodule AdVantageWeb.ChannelLive.VariationFormComponent do
  use AdVantageWeb, :live_component

  alias AdVantage.Campaings

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage variation records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="variation-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label={gettext("Nombre")} />
        <.input field={@form[:description]} type="text" label={gettext("Descripción")} />
        <.input field={@form[:tone]} type="text" label={gettext("Tono")} />
        <.input field={@form[:target]} type="text" label={gettext("Grupo objetivo")} />
        <.input field={@form[:orientation]} type="text" label={gettext("Orientacíon")} />
        <.input field={@form[:width]} type="number" label={gettext("Ancho (px)")} />
        <.input field={@form[:height]} type="number" label={gettext("Altura (px)")} />
        <.input field={@form[:margin]} type="number" label={gettext("Margen (px)")} />
        <.input field={@form[:has_logo]} type="checkbox" label={gettext("Logo?")} />
        <:actions>
          <.button phx-disable-with="Saving...">Save Variation</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{variation: variation} = assigns, socket) do
    changeset = Campaings.change_variation(variation)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"variation" => variation_params}, socket) do
    changeset =
      socket.assigns.variation
      |> Campaings.change_variation(variation_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"variation" => variation_params}, socket) do
    save_variation(socket, socket.assigns.action, variation_params)
  end

  defp save_variation(socket, :edit_variation, variation_params) do
    case Campaings.update_variation(socket.assigns.variation, variation_params) do
      {:ok, variation} ->
        notify_parent({:saved, variation})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Variación actualizada"))
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_variation(socket, :new_variation, variation_params) do
    variation_params = Map.put(variation_params, "channel_id", socket.assigns.channel_id)

    case Campaings.create_variation(variation_params) do
      {:ok, variation} ->
        notify_parent({:saved, variation})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Variación creada"))
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
