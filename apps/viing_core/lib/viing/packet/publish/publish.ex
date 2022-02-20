defmodule Viing.Packet.Publish do
  @moduledoc false

  alias Viing.Packet.Meta

  @opcode 3

  @type t :: %__MODULE__{
          __META__: Meta.t(),
          dup: boolean(),
          qos: Viing.qos(),
          retain: boolean()
        }
  defstruct __META__: %Meta{opcode: @opcode},
            dup: false,
            qos: 0,
            retain: false
end
