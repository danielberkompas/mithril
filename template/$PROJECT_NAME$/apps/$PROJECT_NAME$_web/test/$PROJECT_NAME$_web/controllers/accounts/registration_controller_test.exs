defmodule <%= @project_name_camel_case %>Web.Accounts.RegistrationControllerTest do
  use <%= @project_name_camel_case %>Web.ConnCase

  import <%= @project_name_camel_case %>.AccountsFactory

  alias <%= @project_name_camel_case %>.Accounts

  describe ".new/2" do
    test "renders registration form", %{conn: conn} do
      response =
        conn
        |> get(Routes.registration_path(conn, :new))
        |> html_response(200)

      assert response =~ "form"
      assert response =~ "action=\"#{Routes.registration_path(conn, :create)}\""
      assert response =~ "input id=\"user_email\""
      assert response =~ "input id=\"user_password\""
      assert response =~ "input id=\"user_password_confirmation\""
    end
  end

  describe ".create/2" do
    test "creates a user and logs in if valid", %{conn: conn} do
      params = %{
        "user" => %{
          "email" => "test@email.com",
          "password" => "p@$$w0rd",
          "password_confirmation" => "p@$$w0rd"
        }
      }

      conn = post(conn, Routes.registration_path(conn, :create), params)

      assert conn.assigns.current_user
      assert get_flash(conn, :success)
      assert redirected_to(conn) =~ Routes.page_path(conn, :index)
    end

    test "validates form", %{conn: conn} do
      params = %{
        "user" => %{
          "email" => "",
          "password" => "p@$$w0rd",
          "password_confirmation" => "mismatch"
        }
      }

      response =
        conn
        |> post(Routes.registration_path(conn, :create), params)
        |> html_response(400)

      assert response =~ "can&#39;t be blank"
      assert response =~ "does not match confirmation"
    end
  end

  describe ".edit/2" do
    setup [:create_user, :create_token]

    test "requires user to be logged in", %{conn: conn} do
      assert_login_required fn ->
        get(conn, Routes.registration_path(conn, :edit))
      end
    end

    test "displays a form to edit the current user", %{conn: conn, user: user} do
      response =
        conn
        |> assign(:current_user, user)
        |> get(Routes.registration_path(conn, :edit))
        |> html_response(200)

      assert response =~ "form"
      assert response =~ "action=\"#{Routes.registration_path(conn, :update)}\""
      assert response =~ "input id=\"user_email\""
      assert response =~ "input id=\"user_password\""
      assert response =~ "input id=\"user_password_confirmation\""
      assert response =~ "value=\"#{user.email}\""
    end
  end

  describe ".update/2" do
    setup [:create_user, :create_token]

    test "requires user to be logged in", %{conn: conn} do
      assert_login_required fn ->
        put(conn, Routes.registration_path(conn, :update), %{})
      end
    end

    test "updates a user's fields", %{conn: conn, user: user} do
      params = %{
        "user" => %{
          "email" => "new@email.com",
          "password" => "new_password",
          "password_confirmation" => "new_password"
        }
      }

      conn = 
        conn
        |> assign(:current_user, user)
        |> put(Routes.registration_path(conn, :update), params)

      assert get_flash(conn, :success)
      assert html_response(conn, 200) =~ "form"
      assert {:ok, _token} = Accounts.tokenize({"new@email.com", "new_password"})
    end
  end

  defp assert_login_required(fun) do
    conn = fun.()
    assert get_flash(conn, :error) =~ "logged in"
    assert redirected_to(conn) == Routes.session_path(conn, :new)
  end
end