defmodule Blueprint.Types.Datetime do
    use Timex

    @moduledoc """
    ## example

        iex> {:ok, _value} = Blueprint.Types.Datetime.cast("01-01-1900", [])

        iex> {:ok, _value} = Blueprint.Types.Datetime.cast("1900-01-01", [])

        iex> {:ok, _value} = Blueprint.Types.Datetime.cast("2016-02-29T22:25:00-06:00", [])

        iex> {:error, _reason} = Blueprint.Types.Datetime.cast("1900-91-91", [])
    """

    @iso_format ~r/^\d{4}-\d{2}-\d{2}T\d{1,2}:\d{1,2}:\d{1,2}-\d{1,2}:\d{1,2}$/

    def cast(value, _opts) when is_number(value) do
        {:ok, Timex.from_unix(value)}
    end

    def cast(value, _opts) when is_binary(value) do
        dvalue = String.trim(value)
        cond do
            String.match?(dvalue, ~r/^\d{4}-\d{2}-\d{2}$/) ->
                Timex.parse(dvalue, "{YYYY}-{0M}-{D}")

            String.match?(dvalue, ~r/^\d{2}-\d{2}-\d{4}$/) ->
                Timex.parse(dvalue, "{D}-{0M}-{YYYY}")

            String.match?(dvalue, @iso_format) ->
                Timex.parse(dvalue, "{ISO:Extended}")

            true ->
                {:error, ["invalid datetime"]}
        end
    end

    def cast(%Date{}=value, _opts) do
        {:ok, value}
    end

    def cast(%DateTime{}=value, _opts) do
        {:ok, value}
    end

    def cast(_value, _opts) do
        {:error, ["invalid datetime"]}
    end

end


