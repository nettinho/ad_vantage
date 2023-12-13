defmodule AdVantageWeb.CampaignChannelLiveTest do
  use AdVantageWeb.ConnCase

  import Phoenix.LiveViewTest
  import AdVantage.CampaingsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_campaign_channel(_) do
    campaign_channel = campaign_channel_fixture()
    %{campaign_channel: campaign_channel}
  end

  describe "Index" do
    setup [:create_campaign_channel]

    test "lists all campaigns_channels", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/campaigns_channels")

      assert html =~ "Listing Campaigns channels"
    end

    test "saves new campaign_channel", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/campaigns_channels")

      assert index_live |> element("a", "New Campaign channel") |> render_click() =~
               "New Campaign channel"

      assert_patch(index_live, ~p"/campaigns_channels/new")

      assert index_live
             |> form("#campaign_channel-form", campaign_channel: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#campaign_channel-form", campaign_channel: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/campaigns_channels")

      html = render(index_live)
      assert html =~ "Campaign channel created successfully"
    end

    test "updates campaign_channel in listing", %{conn: conn, campaign_channel: campaign_channel} do
      {:ok, index_live, _html} = live(conn, ~p"/campaigns_channels")

      assert index_live |> element("#campaigns_channels-#{campaign_channel.id} a", "Edit") |> render_click() =~
               "Edit Campaign channel"

      assert_patch(index_live, ~p"/campaigns_channels/#{campaign_channel}/edit")

      assert index_live
             |> form("#campaign_channel-form", campaign_channel: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#campaign_channel-form", campaign_channel: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/campaigns_channels")

      html = render(index_live)
      assert html =~ "Campaign channel updated successfully"
    end

    test "deletes campaign_channel in listing", %{conn: conn, campaign_channel: campaign_channel} do
      {:ok, index_live, _html} = live(conn, ~p"/campaigns_channels")

      assert index_live |> element("#campaigns_channels-#{campaign_channel.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#campaigns_channels-#{campaign_channel.id}")
    end
  end

  describe "Show" do
    setup [:create_campaign_channel]

    test "displays campaign_channel", %{conn: conn, campaign_channel: campaign_channel} do
      {:ok, _show_live, html} = live(conn, ~p"/campaigns_channels/#{campaign_channel}")

      assert html =~ "Show Campaign channel"
    end

    test "updates campaign_channel within modal", %{conn: conn, campaign_channel: campaign_channel} do
      {:ok, show_live, _html} = live(conn, ~p"/campaigns_channels/#{campaign_channel}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Campaign channel"

      assert_patch(show_live, ~p"/campaigns_channels/#{campaign_channel}/show/edit")

      assert show_live
             |> form("#campaign_channel-form", campaign_channel: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#campaign_channel-form", campaign_channel: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/campaigns_channels/#{campaign_channel}")

      html = render(show_live)
      assert html =~ "Campaign channel updated successfully"
    end
  end
end
