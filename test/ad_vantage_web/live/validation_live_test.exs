defmodule AdVantageWeb.ValidationLiveTest do
  use AdVantageWeb.ConnCase

  import Phoenix.LiveViewTest
  import AdVantage.CampaingsFixtures

  @create_attrs %{approved: true, explanation: "some explanation"}
  @update_attrs %{approved: false, explanation: "some updated explanation"}
  @invalid_attrs %{approved: false, explanation: nil}

  defp create_validation(_) do
    validation = validation_fixture()
    %{validation: validation}
  end

  describe "Index" do
    setup [:create_validation]

    test "lists all validations", %{conn: conn, validation: validation} do
      {:ok, _index_live, html} = live(conn, ~p"/validations")

      assert html =~ "Listing Validations"
      assert html =~ validation.explanation
    end

    test "saves new validation", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/validations")

      assert index_live |> element("a", "New Validation") |> render_click() =~
               "New Validation"

      assert_patch(index_live, ~p"/validations/new")

      assert index_live
             |> form("#validation-form", validation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#validation-form", validation: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/validations")

      html = render(index_live)
      assert html =~ "Validation created successfully"
      assert html =~ "some explanation"
    end

    test "updates validation in listing", %{conn: conn, validation: validation} do
      {:ok, index_live, _html} = live(conn, ~p"/validations")

      assert index_live |> element("#validations-#{validation.id} a", "Edit") |> render_click() =~
               "Edit Validation"

      assert_patch(index_live, ~p"/validations/#{validation}/edit")

      assert index_live
             |> form("#validation-form", validation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#validation-form", validation: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/validations")

      html = render(index_live)
      assert html =~ "Validation updated successfully"
      assert html =~ "some updated explanation"
    end

    test "deletes validation in listing", %{conn: conn, validation: validation} do
      {:ok, index_live, _html} = live(conn, ~p"/validations")

      assert index_live |> element("#validations-#{validation.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#validations-#{validation.id}")
    end
  end

  describe "Show" do
    setup [:create_validation]

    test "displays validation", %{conn: conn, validation: validation} do
      {:ok, _show_live, html} = live(conn, ~p"/validations/#{validation}")

      assert html =~ "Show Validation"
      assert html =~ validation.explanation
    end

    test "updates validation within modal", %{conn: conn, validation: validation} do
      {:ok, show_live, _html} = live(conn, ~p"/validations/#{validation}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Validation"

      assert_patch(show_live, ~p"/validations/#{validation}/show/edit")

      assert show_live
             |> form("#validation-form", validation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#validation-form", validation: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/validations/#{validation}")

      html = render(show_live)
      assert html =~ "Validation updated successfully"
      assert html =~ "some updated explanation"
    end
  end
end
