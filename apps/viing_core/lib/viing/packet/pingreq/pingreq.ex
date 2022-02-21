defmodule Viing.Packet.Pingreq do
  @moduledoc false

  alias Viing.Packet

  @opcode 12

  @type t :: %__MODULE__{
          __META__: Packet.Meta.t()
        }
  defstruct __META__: %Packet.Meta{opcode: @opcode, flags: 0}

  @spec decode(<<_::16>>) :: Viing.Packet.Pingreq.t()
  def decode(<<@opcode::4, 0::4, 0::8>>) do
    %__MODULE__{}
  end
end
