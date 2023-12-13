defmodule AdVantageWeb.ChannelLive.FormComponent do
  use AdVantageWeb, :live_component

  alias AdVantage.Campaings

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= gettext("Nuevo canal") %>
      </.header>

      <.simple_form
        for={@form}
        id="channel-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label={gettext("Nombre")} />
        <.input field={@form[:offering]} type="textarea" label={gettext("Oferta")} />
        <:actions>
          <.button phx-disable-with="Saving..."><%= gettext("Guardar") %></.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{channel: channel} = assigns, socket) do
    changeset = Campaings.change_channel(channel)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"channel" => channel_params}, socket) do
    changeset =
      socket.assigns.channel
      |> Campaings.change_channel(channel_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"channel" => channel_params}, socket) do
    save_channel(socket, socket.assigns.action, channel_params)
  end

  defp save_channel(socket, :edit, channel_params) do
    case Campaings.update_channel(socket.assigns.channel, channel_params) do
      {:ok, channel} ->
        notify_parent({:saved, channel})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Canal actualizado"))
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_channel(socket, :new, channel_params) do
    case Campaings.create_channel(channel_params) do
      {:ok, channel} ->
        notify_parent({:saved, channel})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Canal creado"))
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
