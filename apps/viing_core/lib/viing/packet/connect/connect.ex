defmodule Viing.Packet.Connect do
  @moduledoc false

  alias Viing.Packet

  @opcode 1

  @type t :: %__MODULE__{
          __META__: Packet.Meta.t(),
          variable_header: Packet.Connect.VariableHeader.t(),
          payload: Packet.Connect.Payload.t() | nil
        }
  defstruct __META__: %Packet.Meta{opcode: @opcode},
            variable_header: %Packet.Connect.VariableHeader{},
            payload: nil

  @spec decode(nonempty_binary()) ::
          {:error, :malformed_packet_error | :unsupported_protocol_version_error}
          | {:ok, Viing.Packet.Connect.t()}
  def decode(<<@opcode::4, 0::4, payload::binary>>) do
    with {:ok, rest} <- Packet.drop_length(payload),
         {:ok, variable_header, rest} <- Packet.Connect.VariableHeader.decode(rest),
         {:ok, payload} <- Packet.Connect.Payload.decode(variable_header, rest) do
      {
        :ok,
        %__MODULE__{
          variable_header: variable_header,
          payload: payload
        }
      }
    else
      error -> error
    end
  end
end
