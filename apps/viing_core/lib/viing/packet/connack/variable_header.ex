defmodule Viing.Packet.Connack.VariableHeader do
  @moduledoc false

  import Viing.Packet, only: [flag: 1]

  @type t :: %__MODULE__{
          session_present?: boolean(),
          status: 0x00 | 0x01 | 0x02 | 0x03 | 0x04 | 0x05
        }
  defstruct session_present?: false,
            status: 0x00

  defimpl Viing.Encoding.Encodable do
    alias Viing.Packet.Connack.VariableHeader

    @spec encode(Viing.Packet.Connack.VariableHeader.t()) :: <<_::16>>
    def encode(%VariableHeader{session_present?: session_present?, status: status}) do
      <<0::7, flag(session_present?)::1, status::8>>
    end
  end
end
