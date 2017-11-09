<% MixTemplates.ignore_file_unless(assigns[:accounts] != nil) %>
defmodule <%= @project_name_camel_case %>API.Types.Accounts do
  @moduledoc """
  Type, query, and mutations for `<%= @project_name_camel_case %>.Accounts`.

  ## Usage

      import_types <%= @project_name_camel_case %>API.Types.Accounts

      query do
        import_fields :account_queries
      end

      mutation do
        import_fields :account_mutations
      end
  """

  use Absinthe.Schema.Notation

  alias <%= @project_name_camel_case %>API.Resolvers

  import_types Absinthe.Type.Custom
  import_types <%= @project_name_camel_case %>API.Types.Custom

  ##
  # Types
  ##

  @desc "A user account"
  object :user do
    field :email, non_null(:string)
    field :inserted_at, non_null(:datetime)
    field :updated_at, non_null(:datetime)
  end

  @desc "Result from creating or updating a user account"
  object :user_result do
    field :errors, list_of(:input_error)
    field :user, :user
  end

  @desc "A user session, with user information and an `Authorization` token."
  object :user_session do
    field :token, non_null(:string)
    field :user, non_null(:user)
  end

  @desc "Required parameters for creating a user"
  input_object :create_user_input do
    field :email, non_null(:string)
    field :password, non_null(:string)
    field :password_confirmation, non_null(:string)
  end

  @desc "Required parameters for updating a user"
  input_object :update_user_input do
    field :email, non_null(:string)
    field :password, :string
    field :password_confirmation, :string
  end

  @desc "Required parameters to log in and get an authentication token"
  input_object :login_user_input do
    field :email, non_null(:string)
    field :password, non_null(:string)
  end

  ##
  # Queries
  ##

  object :account_queries do
    @desc """
    Returns information about the current authenticated user.
    
    Requires `Authorization` token.
    """
    field :current_user, :user do
      resolve &Resolvers.Accounts.current_user/2
    end
  end

  ##
  # Mutations
  ##

  object :account_mutations do
    @desc "Registers a new user"
    field :create_user, :user_result do
      arg :input, non_null(:create_user_input)
      resolve &Resolvers.Accounts.create_user/2
    end

    @desc "Updates the current user. Requires `Authorization` token"
    field :update_current_user, :user_result do
      arg :input, non_null(:update_user_input)
      resolve &Resolvers.Accounts.update_current_user/2
    end

    @desc """
    Get an authentication token in exchange for an email and password.

    You should then store the token and pass it in subsequent requests as
    an Authorization header.

        Authorization: Bearer WlH7faHJCUuegh6rBE8rVgR1c1KVXWsH72LD6Wm1rDo=
    """
    field :login, :user_session do
      arg :input, non_null(:login_user_input)
      resolve &Resolvers.Accounts.login_user/2
    end
  end
end