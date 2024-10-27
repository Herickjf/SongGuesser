defmodule SongappWeb.RoomtestLiveTest do
  use SongappWeb.ConnCase

  import Phoenix.LiveViewTest
  import Songapp.LiveroomsFixtures

  @create_attrs %{code: "some code"}
  @update_attrs %{code: "some updated code"}
  @invalid_attrs %{code: nil}

  defp create_roomtest(_) do
    roomtest = roomtest_fixture()
    %{roomtest: roomtest}
  end

  describe "Index" do
    setup [:create_roomtest]

    test "lists all room", %{conn: conn, roomtest: roomtest} do
      {:ok, _index_live, html} = live(conn, ~p"/room")

      assert html =~ "Listing Room"
      assert html =~ roomtest.code
    end

    test "saves new roomtest", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/room")

      assert index_live |> element("a", "New Roomtest") |> render_click() =~
               "New Roomtest"

      assert_patch(index_live, ~p"/room/new")

      assert index_live
             |> form("#roomtest-form", roomtest: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#roomtest-form", roomtest: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/room")

      html = render(index_live)
      assert html =~ "Roomtest created successfully"
      assert html =~ "some code"
    end

    test "updates roomtest in listing", %{conn: conn, roomtest: roomtest} do
      {:ok, index_live, _html} = live(conn, ~p"/room")

      assert index_live |> element("#room-#{roomtest.id} a", "Edit") |> render_click() =~
               "Edit Roomtest"

      assert_patch(index_live, ~p"/room/#{roomtest}/edit")

      assert index_live
             |> form("#roomtest-form", roomtest: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#roomtest-form", roomtest: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/room")

      html = render(index_live)
      assert html =~ "Roomtest updated successfully"
      assert html =~ "some updated code"
    end

    test "deletes roomtest in listing", %{conn: conn, roomtest: roomtest} do
      {:ok, index_live, _html} = live(conn, ~p"/room")

      assert index_live |> element("#room-#{roomtest.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#room-#{roomtest.id}")
    end
  end

  describe "Show" do
    setup [:create_roomtest]

    test "displays roomtest", %{conn: conn, roomtest: roomtest} do
      {:ok, _show_live, html} = live(conn, ~p"/room/#{roomtest}")

      assert html =~ "Show Roomtest"
      assert html =~ roomtest.code
    end

    test "updates roomtest within modal", %{conn: conn, roomtest: roomtest} do
      {:ok, show_live, _html} = live(conn, ~p"/room/#{roomtest}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Roomtest"

      assert_patch(show_live, ~p"/room/#{roomtest}/show/edit")

      assert show_live
             |> form("#roomtest-form", roomtest: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#roomtest-form", roomtest: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/room/#{roomtest}")

      html = render(show_live)
      assert html =~ "Roomtest updated successfully"
      assert html =~ "some updated code"
    end
  end
end
