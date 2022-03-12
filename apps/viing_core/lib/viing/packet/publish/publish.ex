defmodule Viing.Packet.Publish do
  @moduledoc false

  alias Viing.Packet

  @opcode 3

  @type t :: %__MODULE__{
          __META__: Packet.Meta.t(),
          dup: boolean(),
          qos: Viing.qos(),
          retain: boolean(),
          variable_header: Packet.Publish.VariableHeader.t(),
          payload: Packet.Publish.Payload.t()
        }
  defstruct __META__: %Packet.Meta{opcode: @opcode},
            dup: false,
            qos: 0,
            retain: false,
            variable_header: %Packet.Publish.VariableHeader{},
            payload: %Packet.Publish.Payload{}

  @spec decode(binary()) :: {:error, :malformed_packet_error} | {:ok, Viing.Packet.Publish.t()}
  def decode(<<@opcode::4, 0::1, 0::integer-size(2), retain::1, rest::binary>>) do
    decode_internal(0, 0, retain, rest)
  end

  def decode(<<@opcode::4, dup::1, qos::integer-size(2), retain::1, rest::binary>>)
      when dup > 0 and qos > 0 do
    decode_internal(dup, qos, retain, rest)
  end

  def decode(_), do: {:error, Packet.malformed_error()}

  defp decode_internal(dup, qos, retain, rest) do
    with {:ok, rest} <- Packet.drop_length(rest),
         {:ok, variable_header, rest} <- Packet.Publish.VariableHeader.decode(qos, rest),
         {:ok, payload} <- Packet.Publish.Payload.decode(rest) do
      {
        :ok,
        %__MODULE__{
          dup: dup == 1,
          qos: qos,
          retain: retain == 1,
          variable_header: variable_header,
          payload: payload
        }
      }
    else
      error -> error
    end
  end

  defimpl Viing.Encoding.Encodable do
    alias Viing.{Encoding, Packet}

    @spec encode(Viing.Packet.Publish.t()) :: <<_::16, _::_*8>>
    def encode(%Packet.Publish{} = t) do
      dup = if t.dup, do: 1, else: 0
      retain = if t.retain, do: 1, else: 0

      variable_header = Encoding.Encodable.encode(t.variable_header)
      payload = Encoding.Encodable.encode(t.payload)

      <<t.__META__.opcode::4, dup::1, t.qos::2, retain::1>> <>
        Packet.compute_remaining_length(variable_header <> payload) <>
        variable_header <>
        payload
    end
  end
end
