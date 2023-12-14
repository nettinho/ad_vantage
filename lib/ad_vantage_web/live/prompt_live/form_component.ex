defmodule AdVantageWeb.PromptLive.FormComponent do
  use AdVantageWeb, :live_component

  alias AdVantage.Prompts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
      </.header>

      <.simple_form
        for={@form}
        id="prompt-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label={gettext("Nombre")} />
        <.input field={@form[:is_default]} type="checkbox" label={gettext("Usar por defecto")} />

        <label class="block text-sm font-semibold leading-6 text-zinc-800">
          <%= gettext("Contenido") %>
        </label>

        <div id="content" phx-hook="SortableInputsFor">
          <.inputs_for :let={f_nested} field={@form[:content]}>
            <div class="w-full flex space-x-2 mb-4">
              <div>
                <label class="cursor-pointer">
                  <input
                    type="checkbox"
                    name="prompt[content_delete][]"
                    class="hidden"
                    value={f_nested.index}
                  />
                  <.icon name="hero-x-mark" />
                </label>
              </div>
              <input type="hidden" name="prompt[content_order][]" value={f_nested.index} />
              <.input
                field={f_nested[:type]}
                type="select"
                options={[{"Texto", "text"}, {"Imagen master", "master"}, {"Imagen variación", "var"}]}
                label={gettext("Tipo")}
              />
              <div :if={f_nested[:type].value == "text"} class="grow">
                <.input field={f_nested[:text]} type="textarea" label={gettext("Texto")} />
              </div>
            </div>
          </.inputs_for>
        </div>

        <div>
          <label class="cursor-pointer p-2  border rounded-md">
            <input type="checkbox" name="prompt[content_order][]" class="hidden" />
            <.icon name="hero-plus-circle" /><%= gettext("Añadir elemento") %>
          </label>
        </div>

        <:actions>
          <.button phx-disable-with="Saving..."><%= gettext("Guardar prompt") %></.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{prompt: prompt} = assigns, socket) do
    changeset = Prompts.change_prompt(prompt)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"prompt" => prompt_params}, socket) do
    changeset =
      socket.assigns.prompt
      |> Prompts.change_prompt(prompt_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"prompt" => prompt_params}, socket) do
    save_prompt(socket, socket.assigns.action, prompt_params)
  end

  defp save_prompt(socket, :edit, prompt_params) do
    case Prompts.update_prompt(socket.assigns.prompt, prompt_params) do
      {:ok, prompt} ->
        notify_parent({:saved, prompt})

        {:noreply,
         socket
         |> put_flash(:info, "Prompt updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_prompt(socket, :new, prompt_params) do
    case Prompts.create_prompt(prompt_params) do
      {:ok, prompt} ->
        notify_parent({:saved, prompt})

        {:noreply,
         socket
         |> put_flash(:info, "Prompt created successfully")
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
