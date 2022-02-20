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

  def flag(f) when f in [0, nil, false], do: 0
  def flag(_), do: 1
end
