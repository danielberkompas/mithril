defmodule <%= @project_name_camel_case %>API.Accounts.QueryTest do
  use <%= @project_name_camel_case %>API.DataCase

  import <%= @project_name_camel_case %>.AccountsFactory,
    only: [
      create_user: 1,
      create_token: 1
    ]

  describe "current_user" do
    setup [:create_user, :create_token]

    test "returns current user if logged in", %{user: user, token: token} do
      {:ok, %{data: data}} = run(query(:current_user), context: %{current_user: user, token: token})
      assert data["current_user"]["email"] == user.email
    end

    test "returns error if not logged in" do
      assert_invalid_token(run(query(:current_user)))
    end
  end
end