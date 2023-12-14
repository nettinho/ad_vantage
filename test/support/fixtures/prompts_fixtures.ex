defmodule AdVantage.PromptsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AdVantage.Prompts` context.
  """

  @doc """
  Generate a prompt.
  """
  def prompt_fixture(attrs \\ %{}) do
    {:ok, prompt} =
      attrs
      |> Enum.into(%{
        content: %{},
        is_default: true,
        name: "some name"
      })
      |> AdVantage.Prompts.create_prompt()

    prompt
  end
end
