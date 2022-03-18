defmodule Viing.Packet.Pubcomp do
  @moduledoc false

  alias Viing.Packet

  @opcode 7

  @type t :: %__MODULE__{
          __META__: Packet.Meta.t(),
          packet_identifier: non_neg_integer()
        }
  defstruct __META__: %Packet.Meta{opcode: @opcode, flags: 0},
            packet_identifier: 0

  @spec decode(nonempty_binary()) ::
          {:error, :malformed_packet_error} | {:ok, Viing.Packet.Pubcomp.t()}
  def decode(<<@opcode::4, 0::4, 2::8, packet_identifier::16>>) do
    {:ok, %__MODULE__{packet_identifier: packet_identifier}}
  end

  def decode(_), do: {:error, Packet.malformed_error()}

  defimpl Viing.Encoding.Encodable do
    alias Viing.Packet

    @spec encode(Viing.Packet.Pubcomp.t()) :: <<_::24, _::_*8>>
    def encode(%Packet.Pubcomp{packet_identifier: packet_identifier} = t) do
      Packet.Meta.encode(t.__META__) <> <<2::8, packet_identifier::16>>
    end
  end
end
