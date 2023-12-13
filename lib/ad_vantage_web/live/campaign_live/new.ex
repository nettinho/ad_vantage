defmodule AdVantageWeb.CampaignLive.New do
  use AdVantageWeb, :live_view

  alias AdVantage.Campaings
  alias AdVantage.Campaings.Campaign

  @container Application.compile_env(:ad_vantage, :storage_container)

  @impl true
  def mount(_params, _session, socket) do
    changeset = Campaings.change_campaign(%Campaign{})

    {:ok,
     socket
     |> stream(:campaigns, Campaings.list_campaigns())
     |> assign_form(changeset)
     |> allow_upload(:master,
       accept: ~w(.jpg .jpeg),
       max_entries: 1
     )}
  end

  @impl true
  def handle_event("validate", %{"campaign" => campaign_params}, socket) do
    changeset =
      %Campaign{}
      |> Campaings.change_campaign(campaign_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"campaign" => campaign_params}, socket) do
    [filename] =
      consume_uploaded_entries(socket, :master, fn %{path: path}, %{client_type: content_type} ->
        blob = File.read!(path)

        name =
          blob
          |> then(&:crypto.hash(:md5, &1))
          |> Base.encode32()

        Azurex.Blob.put_blob(name, blob, content_type, @container)
        {:ok, name}
      end)

    campaign_params = Map.put(campaign_params, "filename", filename)

    case Campaings.create_campaign(campaign_params) do
      {:ok, campaign} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("Campaña creada"))
         |> redirect(to: ~p"/campaigns/#{campaign}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
