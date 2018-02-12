defmodule <%= @project_name_camel_case %>Web.Accounts.SessionControllerTest do
  use <%= @project_name_camel_case %>Web.ConnCase

  alias <%= @project_name_camel_case %>.Accounts

  describe ".new/2" do
    test "renders a login form", %{conn: conn} do
      response =
        conn
        |> get(Routes.session_path(conn, :new))
        |> html_response(200)

      assert response =~ "form"
      assert response =~ "input id=\"user_email\""
      assert response =~ "input id=\"user_password\""
    end
  end

  describe ".create/2" do
    setup [:create_user]

    test "creates a new user session, if credentials are valid", %{conn: conn} do
      params = %{
        "user" => %{
          "email" => "test@example.com",
          "password" => "p@$$w0rd"
        }
      }

      conn = post(conn, Routes.session_path(conn, :create), params)
      assert conn.assigns[:current_user]
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "displays error if credentials are invalid", %{conn: conn} do
      params = %{
        "user" => %{
          "email" => "nonexistent@email.com",
          "password" => "p@$$w0rd"
        }
      }

      conn = post(conn, Routes.session_path(conn, :create), params)
      assert get_flash(conn, :error)
      refute conn.assigns[:current_user]
      assert html_response(conn, 400) =~ "form"
    end
  end

  describe ".delete/2" do
    test "clears the user session", %{conn: conn} do
      conn =
        conn
        |> assign(:token, "my-token")
        |> get(Routes.session_path(conn, :delete))
      
      refute conn.assigns[:current_user]
      assert get_flash(conn, :success)
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end

  defp create_user(_) do
    {:ok, user} =
      Accounts.create_user(%{
        email: "test@example.com",
        password: "p@$$w0rd",
        password_confirmation: "p@$$w0rd"
      })

    {:ok, [user: user]}
  end
end