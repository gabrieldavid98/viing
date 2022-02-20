defmodule Viing.Packet.Connect do
  @moduledoc false

  alias Viing.Packet
  alias Viing.Packet.Meta
  alias Viing.Packet.Connect.VariableHeader
  alias Viing.Packet.Connect.Payload

  @opcode 1

  @type t :: %__MODULE__{
          __META__: Meta.t(),
          variable_header: VariableHeader.t(),
          payload: Payload.t() | nil
        }
  defstruct __META__: %Meta{opcode: @opcode},
            variable_header: %VariableHeader{},
            payload: nil

  @spec decode(nonempty_binary()) ::
          {:error, :malformed_packet_error | :unsupported_protocol_version_error}
          | {:ok, Viing.Packet.Connect.t()}
  def decode(<<@opcode::4, 0::4, payload::binary>>) do
    with {:ok, rest} <- Packet.drop_length(payload),
         {:ok, variable_header, rest} <- VariableHeader.decode(rest),
         {:ok, payload} <- Payload.decode(variable_header, rest) do
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
