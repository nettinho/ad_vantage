defmodule AdVantageWeb.CampaignLive.VariationFormComponent do
  use AdVantageWeb, :live_component

  alias AdVantage.Campaings

  @container Application.compile_env(:ad_vantage, :storage_container)

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
      </.header>

      <.simple_form
        for={@form}
        id="campaign_variation-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:variation_id]}
          type="select"
          options={@variation_options}
          label={gettext("Tipo de variación")}
        />
        <.input field={@form[:explanation]} type="textarea" label={gettext("Explicación")} />

        <label for={@uploads.file.ref}><%= gettext("Fichero Master") %></label>
        <.live_file_input upload={@uploads.file} />

        <article :for={entry <- @uploads.file.entries} class="upload-entry">
          <figure>
            <.live_img_preview entry={entry} />
            <figcaption><%= entry.client_name %></figcaption>
          </figure>

          <%!-- entry.progress will update automatically for in-flight entries --%>
          <progress value={entry.progress} max="100"><%= entry.progress %>%</progress>

          <%!-- a regular click event whose handler will invoke Phoenix.LiveView.cancel_upload/3 --%>
          <button
            type="button"
            phx-click="cancel-upload"
            phx-value-ref={entry.ref}
            aria-label="cancel"
          >
            &times;
          </button>

          <%!-- Phoenix.Component.upload_errors/2 returns a list of error atoms --%>
          <p :for={err <- upload_errors(@uploads.file, entry)} class="alert alert-danger">
            <%= error_to_string(err) %>
          </p>
        </article>
        <:actions>
          <.button phx-disable-with="Saving..."><%= gettext("Guardar") %></.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{campaign_variation: campaign_variation, channel_id: channel_id} = assigns, socket) do
    changeset = Campaings.change_campaign_variation(campaign_variation)
    channel = Campaings.get_channel!(channel_id)

    variation_options =
      channel
      |> Map.get(:variations)
      |> Enum.map(&{&1.name, &1.id})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:channel, channel)
     |> assign(:variation_options, variation_options)
     |> assign_form(changeset)
     |> allow_upload(:file,
       accept: ~w(.jpg .jpeg),
       max_entries: 1
     )}
  end

  @impl true
  def handle_event("validate", %{"campaign_variation" => campaign_variation_params}, socket) do
    changeset =
      socket.assigns.campaign_variation
      |> Campaings.change_campaign_variation(campaign_variation_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"campaign_variation" => campaign_variation_params}, socket) do
    [filename] =
      consume_uploaded_entries(socket, :file, fn %{path: path}, %{client_type: content_type} ->
        blob = File.read!(path)

        name =
          blob
          |> then(&:crypto.hash(:md5, &1))
          |> Base.encode32()

        Azurex.Blob.put_blob(name, blob, content_type, @container)
        {:ok, name}
      end)

    campaign_variation_params =
      campaign_variation_params
      |> Map.put("filename", filename)
      |> Map.put("campaign_id", socket.assigns.campaign_id)

    save_campaign_variation(socket, socket.assigns.action, campaign_variation_params)
  end

  defp save_campaign_variation(socket, :edit_variation, campaign_variation_params) do
    case Campaings.update_campaign_variation(
           socket.assigns.campaign_variation,
           campaign_variation_params
         ) do
      {:ok, campaign_variation} ->
        notify_parent({:saved, campaign_variation, socket.assigns.channel_id})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Variación actualizada"))
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_campaign_variation(socket, :new_variation, campaign_variation_params) do
    case Campaings.create_campaign_variation(campaign_variation_params) do
      {:ok, campaign_variation} ->
        notify_parent({:saved, campaign_variation, socket.assigns.channel_id})

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

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
