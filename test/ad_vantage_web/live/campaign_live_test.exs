defmodule AdVantageWeb.CampaignLiveTest do
  use AdVantageWeb.ConnCase

  import Phoenix.LiveViewTest
  import AdVantage.CampaingsFixtures

  @create_attrs %{name: "some name", filename: "some filename", description: "some description"}
  @update_attrs %{name: "some updated name", filename: "some updated filename", description: "some updated description"}
  @invalid_attrs %{name: nil, filename: nil, description: nil}

  defp create_campaign(_) do
    campaign = campaign_fixture()
    %{campaign: campaign}
  end

  describe "Index" do
    setup [:create_campaign]

    test "lists all campaigns", %{conn: conn, campaign: campaign} do
      {:ok, _index_live, html} = live(conn, ~p"/campaigns")

      assert html =~ "Listing Campaigns"
      assert html =~ campaign.name
    end

    test "saves new campaign", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/campaigns")

      assert index_live |> element("a", "New Campaign") |> render_click() =~
               "New Campaign"

      assert_patch(index_live, ~p"/campaigns/new")

      assert index_live
             |> form("#campaign-form", campaign: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#campaign-form", campaign: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/campaigns")

      html = render(index_live)
      assert html =~ "Campaign created successfully"
      assert html =~ "some name"
    end

    test "updates campaign in listing", %{conn: conn, campaign: campaign} do
      {:ok, index_live, _html} = live(conn, ~p"/campaigns")

      assert index_live |> element("#campaigns-#{campaign.id} a", "Edit") |> render_click() =~
               "Edit Campaign"

      assert_patch(index_live, ~p"/campaigns/#{campaign}/edit")

      assert index_live
             |> form("#campaign-form", campaign: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#campaign-form", campaign: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/campaigns")

      html = render(index_live)
      assert html =~ "Campaign updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes campaign in listing", %{conn: conn, campaign: campaign} do
      {:ok, index_live, _html} = live(conn, ~p"/campaigns")

      assert index_live |> element("#campaigns-#{campaign.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#campaigns-#{campaign.id}")
    end
  end

  describe "Show" do
    setup [:create_campaign]

    test "displays campaign", %{conn: conn, campaign: campaign} do
      {:ok, _show_live, html} = live(conn, ~p"/campaigns/#{campaign}")

      assert html =~ "Show Campaign"
      assert html =~ campaign.name
    end

    test "updates campaign within modal", %{conn: conn, campaign: campaign} do
      {:ok, show_live, _html} = live(conn, ~p"/campaigns/#{campaign}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Campaign"

      assert_patch(show_live, ~p"/campaigns/#{campaign}/show/edit")

      assert show_live
             |> form("#campaign-form", campaign: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#campaign-form", campaign: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/campaigns/#{campaign}")

      html = render(show_live)
      assert html =~ "Campaign updated successfully"
      assert html =~ "some updated name"
    end
  end
end
