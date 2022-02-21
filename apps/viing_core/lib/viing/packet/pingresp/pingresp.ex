defmodule Viing.Packet.Pingresp do
  @moduledoc false

  alias Viing.Packet

  @opcode 13

  @type t :: %__MODULE__{
          __META__: Packet.Meta.t()
        }
  defstruct __META__: %Packet.Meta{opcode: @opcode, flags: 0}

  defimpl Viing.Encoding.Encodable do
    @spec encode(Viing.Packet.Pingresp.t()) :: nonempty_binary()
    def encode(%Packet.Pingresp{} = ping_resp) do
      <<(Packet.Meta.encode(ping_resp.__META__) <> <<0::8>>)>>
    end
  end
end
