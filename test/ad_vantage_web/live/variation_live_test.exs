defmodule AdVantageWeb.VariationLiveTest do
  use AdVantageWeb.ConnCase

  import Phoenix.LiveViewTest
  import AdVantage.CampaingsFixtures

  @create_attrs %{
    name: "some name",
    description: "some description",
    width: 42,
    target: "some target",
    orientation: "some orientation",
    height: 42,
    margin: 42,
    has_logo: true,
    tone: "some tone"
  }
  @update_attrs %{
    name: "some updated name",
    description: "some updated description",
    width: 43,
    target: "some updated target",
    orientation: "some updated orientation",
    height: 43,
    margin: 43,
    has_logo: false,
    tone: "some updated tone"
  }
  @invalid_attrs %{
    name: nil,
    description: nil,
    width: nil,
    target: nil,
    orientation: nil,
    height: nil,
    margin: nil,
    has_logo: false,
    tone: nil
  }

  defp create_variation(_) do
    variation = variation_fixture()
    %{variation: variation}
  end

  describe "Index" do
    setup [:create_variation]

    test "lists all variations", %{conn: conn, variation: variation} do
      {:ok, _index_live, html} = live(conn, ~p"/variations")

      assert html =~ "Listing Variations"
      assert html =~ variation.name
    end

    test "saves new variation", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/variations")

      assert index_live |> element("a", "New Variation") |> render_click() =~
               "New Variation"

      assert_patch(index_live, ~p"/variations/new")

      assert index_live
             |> form("#variation-form", variation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#variation-form", variation: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/variations")

      html = render(index_live)
      assert html =~ "Variation created successfully"
      assert html =~ "some name"
    end

    test "updates variation in listing", %{conn: conn, variation: variation} do
      {:ok, index_live, _html} = live(conn, ~p"/variations")

      assert index_live |> element("#variations-#{variation.id} a", "Edit") |> render_click() =~
               "Edit Variation"

      assert_patch(index_live, ~p"/variations/#{variation}/edit")

      assert index_live
             |> form("#variation-form", variation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#variation-form", variation: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/variations")

      html = render(index_live)
      assert html =~ "Variation updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes variation in listing", %{conn: conn, variation: variation} do
      {:ok, index_live, _html} = live(conn, ~p"/variations")

      assert index_live |> element("#variations-#{variation.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#variations-#{variation.id}")
    end
  end

  describe "Show" do
    setup [:create_variation]

    test "displays variation", %{conn: conn, variation: variation} do
      {:ok, _show_live, html} = live(conn, ~p"/variations/#{variation}")

      assert html =~ "Show Variation"
      assert html =~ variation.name
    end

    test "updates variation within modal", %{conn: conn, variation: variation} do
      {:ok, show_live, _html} = live(conn, ~p"/variations/#{variation}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Variation"

      assert_patch(show_live, ~p"/variations/#{variation}/show/edit")

      assert show_live
             |> form("#variation-form", variation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#variation-form", variation: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/variations/#{variation}")

      html = render(show_live)
      assert html =~ "Variation updated successfully"
      assert html =~ "some updated name"
    end
  end
end
