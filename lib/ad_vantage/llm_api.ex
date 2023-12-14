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

  def validate(validation, prompt) do
    GenServer.cast(__MODULE__, {:validate, validation, prompt})
  end

  @impl true
  def handle_cast({:validate, validation, prompt}, _) do
    Task.async(fn -> do_validate(validation, prompt) end)
    {:noreply, nil}
  end

  @impl true
  def handle_info(_, socket) do
    {:noreply, socket}
  end

  defp do_validate(%{status: status, campaign_variation: variation} = validation, prompt)
       when status in ["init", "error"] do
    Campaings.update_validation(validation, %{status: "validating", message: ""})

    case run_validation(variation, prompt) do
      {:ok, %{"data" => data}} ->
        IO.inspect(data, label: "RETURNED DATA")

        case Jason.decode(data) do
          {:ok, %{"validate" => valid_rate, "errors" => errors}} ->
            IO.inspect(errors, label: "OK")

            Campaings.update_validation(validation, %{
              status: "done",
              results: errors,
              raw_results: data,
              valid_rate: valid_rate
            })
            |> dbg

          _ ->
            Campaings.update_validation(validation, %{
              status: "done invalid",
              raw_results: data,
              message: "Resultado JSON invalido"
            })
        end

      {:error, error} ->
        Campaings.update_validation(validation, %{status: "error", message: error})
    end
  end

  defp do_validate(_, _) do
    nil
  end

  def run_validation(variation, prompt) do
    content =
      prompt
      |> Map.get(:content)
      |> Enum.map(fn
        %{type: "var"} ->
          %{
            "type" => "image_url",
            "image_url" => %{
              "url" => "#{@image_prefix}#{variation.filename}",
              "detail" => "high"
            }
          }

        %{type: "master"} ->
          %{
            "type" => "image_url",
            "image_url" => %{
              "url" => "#{@image_prefix}#{variation.campaign.filename}",
              "detail" => "high"
            }
          }

        %{text: text} ->
          %{"type" => "text", "text" => text}
      end)
      |> Jason.encode!()

    Req.post(@url,
      body: content,
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
