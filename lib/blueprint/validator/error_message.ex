defmodule Blueprint.Validator.ErrorMessage do
    @moduledoc false

    defmacro __using__(_) do
        quote do
            @message_fields []
            @before_compile unquote(__MODULE__)
            import unquote(__MODULE__)
        end
    end

    defmacro __before_compile__(_) do
        quote do
            def __validator__(:message_fields), do: @message_fields
        end
    end

    @doc """
    Extract the error message renderer and pass params to it. Looking for `:error_renderer` in validator options,
    then `:error_renderer` in `:blueprint` application config, if not found use `Blueprint.ErrorRenderers.EEx` as default.

    ## Examples

        iex> Blueprint.Validator.ErrorMessage.message(nil, "default")
        "default"

        iex> Blueprint.Validator.ErrorMessage.message([message: "override"], "default")
        "override"

        iex> Blueprint.Validator.ErrorMessage.message([message: "Context #<%= value %>"], "default", value: 2)
        "Context #2"

        iex> Blueprint.Validator.ErrorMessage.message([message: "Context #<%= value %>", error_renderer: Blueprint.ErrorRenderers.Parameterized], "default", value: 2)
        [message: "Context #<%= value %>", context: [value: 2]]
    """
    def message(options, default, context \\ []) do
        renderer = extract_error_renderer(options)
        renderer.message(options, default, context)
    end

    defp extract_error_renderer(options) do
        cond do
            Keyword.keyword?(options) && Keyword.has_key?(options, :error_renderer) ->
                options[:error_renderer]

            renderer = Application.get_env(:blueprint, :error_renderer) ->
                renderer

            true ->
                Blueprint.ErrorRenderers.EEx
        end
    end
end
