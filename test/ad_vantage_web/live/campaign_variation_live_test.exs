defmodule AdVantageWeb.CampaignVariationLiveTest do
  use AdVantageWeb.ConnCase

  import Phoenix.LiveViewTest
  import AdVantage.CampaingsFixtures

  @create_attrs %{filename: "some filename", explanation: "some explanation"}
  @update_attrs %{filename: "some updated filename", explanation: "some updated explanation"}
  @invalid_attrs %{filename: nil, explanation: nil}

  defp create_campaign_variation(_) do
    campaign_variation = campaign_variation_fixture()
    %{campaign_variation: campaign_variation}
  end

  describe "Index" do
    setup [:create_campaign_variation]

    test "lists all campaign_variations", %{conn: conn, campaign_variation: campaign_variation} do
      {:ok, _index_live, html} = live(conn, ~p"/campaign_variations")

      assert html =~ "Listing Campaign variations"
      assert html =~ campaign_variation.filename
    end

    test "saves new campaign_variation", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/campaign_variations")

      assert index_live |> element("a", "New Campaign variation") |> render_click() =~
               "New Campaign variation"

      assert_patch(index_live, ~p"/campaign_variations/new")

      assert index_live
             |> form("#campaign_variation-form", campaign_variation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#campaign_variation-form", campaign_variation: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/campaign_variations")

      html = render(index_live)
      assert html =~ "Campaign variation created successfully"
      assert html =~ "some filename"
    end

    test "updates campaign_variation in listing", %{conn: conn, campaign_variation: campaign_variation} do
      {:ok, index_live, _html} = live(conn, ~p"/campaign_variations")

      assert index_live |> element("#campaign_variations-#{campaign_variation.id} a", "Edit") |> render_click() =~
               "Edit Campaign variation"

      assert_patch(index_live, ~p"/campaign_variations/#{campaign_variation}/edit")

      assert index_live
             |> form("#campaign_variation-form", campaign_variation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#campaign_variation-form", campaign_variation: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/campaign_variations")

      html = render(index_live)
      assert html =~ "Campaign variation updated successfully"
      assert html =~ "some updated filename"
    end

    test "deletes campaign_variation in listing", %{conn: conn, campaign_variation: campaign_variation} do
      {:ok, index_live, _html} = live(conn, ~p"/campaign_variations")

      assert index_live |> element("#campaign_variations-#{campaign_variation.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#campaign_variations-#{campaign_variation.id}")
    end
  end

  describe "Show" do
    setup [:create_campaign_variation]

    test "displays campaign_variation", %{conn: conn, campaign_variation: campaign_variation} do
      {:ok, _show_live, html} = live(conn, ~p"/campaign_variations/#{campaign_variation}")

      assert html =~ "Show Campaign variation"
      assert html =~ campaign_variation.filename
    end

    test "updates campaign_variation within modal", %{conn: conn, campaign_variation: campaign_variation} do
      {:ok, show_live, _html} = live(conn, ~p"/campaign_variations/#{campaign_variation}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Campaign variation"

      assert_patch(show_live, ~p"/campaign_variations/#{campaign_variation}/show/edit")

      assert show_live
             |> form("#campaign_variation-form", campaign_variation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#campaign_variation-form", campaign_variation: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/campaign_variations/#{campaign_variation}")

      html = render(show_live)
      assert html =~ "Campaign variation updated successfully"
      assert html =~ "some updated filename"
    end
  end
end
