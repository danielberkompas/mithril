defmodule <%= @project_name_camel_case %>.Callback do
  @moduledoc """
  Allows you to easily define callback interfaces, as described in
  [the callback pattern](https://infinitered.github.io/mithril/#/how-to?id=callback-pattern).

  ## Example

      defmodule <%= @project_name_camel_case %>.MyDomain.Callback do
        use <%= @project_name_camel_case %>.Callback

        @callback some_event_happened(integer) :: :ok | no_return
      end
  """

  @doc false
  defmacro __using__(opts) do
    quote do
      @modules unquote(opts[:modules] || [])

      @doc """
      Executes a callback function on all subscribing modules in individual `Task`s.

      ## Example

          execute(:callback_function_name, [args])
      """
      @spec execute(atom, list) :: :ok
      def execute(function, args) do
        Enum.each(modules(), fn module ->
          Task.async(fn ->
            apply(module, function, args)
          end)
        end)
      end

      @doc """
      Returns a list of all subscribing modules.
      """
      @spec modules :: [module]
      def modules do
        :<%= @project_name %>
        |> Application.get_env(__MODULE__, [])
        |> Keyword.get(:modules, [])
        |> Enum.concat(@modules)
      end
    end
  end
end