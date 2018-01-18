defmodule <%= @project_name_camel_case %>Web.Accounts.ResetPasswordControllerTest do
  use <%= @project_name_camel_case %>Web.ConnCase

  import <%= @project_name_camel_case %>.AccountsFactory, only: [
    create_user: 1,
    create_reset_password_token: 1,
    expire_token!: 1
  ]

  alias <%= @project_name_camel_case %>.Accounts

  describe ".new/2" do
    setup [:create_user, :create_reset_password_token]

    test "renders reset password form, if the token is valid", %{conn: conn, token: token} do
      response =
        conn
        |> get(Routes.reset_password_path(conn, :new, token: token))
        |> html_response(200)

      assert response =~ "form"
      assert response =~ "action=\"#{Routes.reset_password_path(conn, :create, token: token)}\""
      assert response =~ "input id=\"user_password\""
      assert response =~ "input id=\"user_password_confirmation\""
    end

    test "redirects with error if token doesn't exist", %{conn: conn} do
      conn = get(conn, Routes.reset_password_path(conn, :new, token: "nonexistent"))
      assert_invalid_token(conn)
    end

    test "redirects with error if token has expired", %{conn: conn, token: token} do
      expire_token!(token)
      conn = get(conn, Routes.reset_password_path(conn, :new, token: "nonexistent"))
      assert_invalid_token(conn)
    end
  end

  @password_params %{
    "password" => "new_password",
    "password_confirmation" => "new_password"
  }

  describe ".create/2" do
    setup [:create_user, :create_reset_password_token]

    test "resets password if token is valid", %{conn: conn, user: user, token: token} do
      params = %{"token" => token, "user" => @password_params}
      conn = post(conn, Routes.reset_password_path(conn, :create), params)

      assert get_flash(conn, :success)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
      assert {:ok, _token} = Accounts.tokenize({user.email, "new_password"})
    end

    test "redirects with error if token does not exist", %{conn: conn} do
      params = %{"token" => "nonexistent", "user" => @password_params}
      conn = post(conn, Routes.reset_password_path(conn, :create), params)
      assert_invalid_token(conn)
    end

    test "redirects with error if token has expired", %{conn: conn, token: token} do
      expire_token!(token)
      params = %{"token" => token, "user" => @password_params}
      conn = post(conn, Routes.reset_password_path(conn, :create), params)
      assert_invalid_token(conn)
    end

    test "validates password confirmation", %{conn: conn, token: token} do
      params = %{
        "token" => token,
        "user" => %{
          "password" => "password",
          "password_confirmation" => "mismatch"
        }
      }

      response =
        conn
        |> post(Routes.reset_password_path(conn, :create), params)
        |> html_response(400)

      assert response =~ "does not match confirmation"
    end

    test "validates password min length", %{conn: conn, token: token} do
      params = %{
        "token" => token,
        "user" => %{
          "password" => "pass",
          "password_confirmation" => "pass"
        }
      }

      response =
        conn
        |> post(Routes.reset_password_path(conn, :create), params)
        |> html_response(400)

      assert response =~ "should be at least 8 character(s)"
    end
  end

  defp assert_invalid_token(conn) do
    assert get_flash(conn, :error)
    assert redirected_to(conn) == Routes.page_path(conn, :index)
  end
end