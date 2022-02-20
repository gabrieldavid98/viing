defmodule Viing.Packet.Connack do
  @moduledoc false

  alias Viing.Packet.Meta
  alias Viing.Packet.Connack.VariableHeader

  @opcode 2

  @type t :: %__MODULE__{
          __META__: Meta.t(),
          remaining_length: 0x02,
          variable_header: VariableHeader.t()
        }
  defstruct __META__: %Meta{opcode: @opcode, flags: 0},
            remaining_length: 0x02,
            variable_header: %VariableHeader{}

  defimpl Viing.Encoding.Encodable do
    alias Viing.Packet.Connack
    alias Viing.Encoding.Encodable

    @spec encode(Viing.Packet.Connack.t()) :: nonempty_binary
    def encode(%Connack{remaining_length: remaining_length, variable_header: variable_header} = t) do
      <<Meta.encode(t.__META__) <>
          <<remaining_length>> <> Encodable.encode(variable_header)>>
    end
  end
end
