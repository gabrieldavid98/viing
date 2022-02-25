defmodule Viing.Packet.Connack do
  @moduledoc false

  alias Viing.Packet

  @opcode 2

  @type t :: %__MODULE__{
          __META__: Packet.Meta.t(),
          remaining_length: 0x02,
          variable_header: Packet.Connack.VariableHeader.t()
        }
  defstruct __META__: %Packet.Meta{opcode: @opcode, flags: 0},
            remaining_length: 0x02,
            variable_header: %Packet.Connack.VariableHeader{}

  defimpl Viing.Encoding.Encodable do
    alias Viing.Encoding.Encodable

    @spec encode(Viing.Packet.Connack.t()) :: nonempty_binary
    def encode(
          %Packet.Connack{
            remaining_length: remaining_length,
            variable_header: variable_header
          } = t
        ) do
      <<Packet.Meta.encode(t.__META__) <>
          <<remaining_length>> <> Encodable.encode(variable_header)>>
    end
  end
end
