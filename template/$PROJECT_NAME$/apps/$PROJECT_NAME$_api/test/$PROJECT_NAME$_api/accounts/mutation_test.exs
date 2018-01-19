defmodule <%= @project_name_camel_case %>API.Accounts.MutationTest do
  use <%= @project_name_camel_case %>API.DataCase

  import <%= @project_name_camel_case %>.AccountsFactory,
    only: [
      create_user: 1,
      create_token: 1
    ]

  describe "create_user" do
    setup [:create_user]

    test "creates a user if parameters are valid" do
      {:ok, %{data: %{"create_user" => %{"user" => user, "errors" => nil}}}} =
        run(
          mutation(:create_user),
          variables: %{
            "input" => %{
              "email" => "new@example.com",
              "password" => "password",
              "password_confirmation" => "password"
            }
          }
        )

      assert user["email"] == "new@example.com"
      assert user["inserted_at"]
      assert user["updated_at"]
    end

    test "validates parameters", %{user: user} do
      {:ok, %{data: %{"create_user" => %{"user" => nil, "errors" => errors}}}} =
        run(
          mutation(:create_user),
          variables: %{
            "input" => %{
              "email" => user.email,
              "password" => "password",
              "password_confirmation" => "password"
            }
          }
        )

      assert errors == [
        %{"field" => "email", "errors" => [%{"type" => "unique", "message" => "has already been taken"}]}
      ]
    end
  end

  describe "login" do
    setup [:create_user]

    test "returns authorization token if credentials are valid", %{user: user} do
      {:ok, %{data: %{"login" => %{"token" => token}}}} =
        run(
          mutation(:login),
          variables: %{
            "input" => %{
              "email" => user.email,
              "password" => "password"
            }
          }
        )

      assert token
    end

    test "returns error if credentials are invalid" do
      {:ok, %{data: %{"login" => nil}, errors: [error]}} =
        run(
          mutation(:login),
          variables: %{
            "input" => %{
              "email" => "nonexistent@email.com",
              "password" => "invalid"
            }
          }
        )

      assert error[:message] =~ "invalid_email"
    end
  end

  describe "update_current_user" do
    setup [:create_user, :create_token]

    test "requires login" do
      assert_invalid_token(
        run(
          mutation(:update_current_user),
          variables: %{
            "input" => %{
              "email" => "new@email.com"
            }
          }
        )
      )
    end

    test "updates user if logged in and valid params", %{token: token} do
      {:ok, %{data: %{"update_current_user" => %{"user" => user, "errors" => nil}}}} =
        run(
          mutation(:update_current_user),
          variables: %{
            "input" => %{
              "email" => "new@email.com",
              "password" => "new_password",
              "password_confirmation" => "new_password"
            }
          },
          context: %{
            token: token
          }
        )

      assert user["email"] == "new@email.com"

      {:ok, %{data: %{"login" => %{"token" => token}}}} =
        run(
          mutation(:login),
          variables: %{
            "input" => %{
              "email" => "new@email.com",
              "password" => "new_password"
            }
          }
        )

      assert token
    end

    test "validates parameters", %{token: token} do
      {:ok, %{data: %{"update_current_user" => %{"user" => nil, "errors" => errors}}}} =
        run(
          mutation(:update_current_user),
          variables: %{
            "input" => %{
              "email" => "",
              "password" => "new_password",
              "password_confirmation" => "mismatch"
            }
          },
          context: %{
            token: token
          }
        )

      expected = [
        %{"field" => "email", "errors" => [%{"type" => "required", "message" => "can't be blank"}]},
        %{"field" => "password_confirmation", "errors" => [%{"type" => "confirmation", "message" => "does not match confirmation"}]}
      ]

      assert errors == expected
    end
  end
end