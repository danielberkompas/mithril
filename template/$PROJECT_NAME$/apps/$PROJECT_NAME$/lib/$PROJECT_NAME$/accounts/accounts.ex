defmodule <%= @project_name_camel_case %>.Accounts do
  @moduledoc """
  Provides user registration, auth tokens, and account recovery.
  """

  use Authority.Template,
    behaviours: [
      Authority.Authentication,
      Authority.Recovery,
      Authority.Registration,
      Authority.Tokenization
    ],
    config: [
      repo: <%= @project_name_camel_case %>.Repo,
      user_schema: <%= @project_name_camel_case %>.Accounts.User,
      token_schema: <%= @project_name_camel_case %>.Accounts.Token,
      recovery_callback: {<%= @project_name_camel_case %>.Notifications, :forgot_password}
    ]
end