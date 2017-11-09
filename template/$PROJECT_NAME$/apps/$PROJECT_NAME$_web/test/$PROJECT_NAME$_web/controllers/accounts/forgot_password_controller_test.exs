defmodule <%= @project_name_camel_case %>Web.Accounts.ForgotPasswordControllerTest do
  use <%= @project_name_camel_case %>Web.ConnCase

  alias <%= @project_name_camel_case %>.Accounts

  describe ".new/2" do
    test "renders a form to reset password", %{conn: conn} do
      response = 
        conn
        |> get(Routes.forgot_password_path(conn, :new))
        |> html_response(200)
      
      assert response =~ "form"
      assert response =~ "input id=\"user_email\""
    end
  end

  describe ".create/2" do
    setup [:create_user]

    test "sends password reset instructions via email if email exists", %{conn: conn} do
      params = %{"user" => %{"email" => "test@example.com"}}
      conn = post(conn, Routes.forgot_password_path(conn, :create), params)

      assert_received {:email, email}
      assert email.to == [{"", "test@example.com"}]
      assert email.text_body =~ Routes.reset_password_url(conn, :new)
      assert email.html_body =~ Routes.reset_password_url(conn, :new)
      assert get_flash(conn, :success)
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end

  defp create_user(_) do
    {:ok, user} =
      Accounts.create_user(%{
        email: "test@example.com",
        password: "password",
        password_confirmation: "password"
      })

    {:ok, [user: user]}
  end
end