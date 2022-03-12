defmodule Viing.Packet do
  @moduledoc false

  @spec drop_length(binary()) :: {:error, :malformed_packet_error} | {:ok, binary()}
  def drop_length(packet) do
    case packet do
      <<0::1, _::7, rest::binary>> -> {:ok, rest}
      <<1::1, _::7, 0::1, _::7, rest::binary>> -> {:ok, rest}
      <<1::1, _::7, 1::1, _::7, 0::1, _::7, rest::binary>> -> {:ok, rest}
      <<1::1, _::7, 1::1, _::7, 1::1, _::7, 0::1, _::7, rest::binary>> -> {:ok, rest}
      _ -> {:error, malformed_error()}
    end
  end

  @spec malformed_error :: :malformed_packet_error
  def malformed_error(), do: :malformed_packet_error

  @spec unsupported_protocol_version_error :: :unsupported_protocol_version_error
  def unsupported_protocol_version_error(), do: :unsupported_protocol_version_error

  @spec flag(pos_integer() | 0 | nil | false) :: 0 | 1
  def flag(f) when f in [0, nil, false], do: 0
  def flag(_), do: 1

  @spec compute_remaining_length(binary()) :: nonempty_binary()
  def compute_remaining_length(data) when is_binary(data) do
    data
    |> IO.iodata_length()
    |> compute_remaining_length_internal()
  end

  @highbit 0b10000000

  defp compute_remaining_length_internal(n) when n < @highbit do
    <<0::1, n::7>>
  end

  defp compute_remaining_length_internal(n) do
    <<1::1, rem(n, @highbit)::7>> <> compute_remaining_length_internal(div(n, @highbit))
  end
end
