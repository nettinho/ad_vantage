defmodule AdVantage.LLMApi do
  use GenServer

  alias AdVantage.Campaings

  @url Application.compile_env!(:ad_vantage, AdVantage.LLMApi)[:url]
  @image_prefix Application.compile_env!(:ad_vantage, :image_prefix)

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok, nil}
  end

  def validate(validation) do
    GenServer.cast(__MODULE__, {:validate, validation})
  end

  @impl true
  def handle_cast({:validate, validation}, _) do
    Task.async(fn -> do_validate(validation) end)
    {:noreply, nil}
  end

  @impl true
  def handle_info(_, socket) do
    {:noreply, socket}
  end

  defp do_validate(%{status: status, campaign_variation: variation} = validation)
       when status in ["init", "error"] do
    Campaings.update_validation(validation, %{status: "validating", message: ""})

    case run_validation(variation) do
      {:ok, %{"data" => data}} ->
        Campaings.update_validation(validation, %{status: "done", message: data})

      {:error, error} ->
        Campaings.update_validation(validation, %{status: "error", message: error})
    end
  end

  defp do_validate(_) do
    nil
  end

  def run_validation(variation) do
    body =
      %{
        url_master: "#{@image_prefix}#{variation.campaign.filename}",
        url_variation: "#{@image_prefix}#{variation.filename}"
      }
      |> Jason.encode!()

    Req.post(@url,
      body: body,
      receive_timeout: 600_000
    )
    |> case do
      {:ok, %Req.Response{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %Req.Response{body: body}} ->
        {:error, body}

      error ->
        IO.inspect(error, label: "API CALL ERROR")
        {:error, :error_calling_api}
    end
  end
end
