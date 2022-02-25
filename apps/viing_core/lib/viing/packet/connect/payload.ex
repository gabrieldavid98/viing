defmodule Viing.Packet.Connect.Payload do
  @moduledoc false

  alias Viing.Packet

  @type t :: %__MODULE__{
          client_id: binary(),
          user_name: binary() | nil,
          password: binary() | nil
        }
  @enforce_keys [:client_id]
  defstruct client_id: "",
            user_name: nil,
            password: nil

  @spec decode(Viing.Packet.Connect.VariableHeader.t(), binary()) ::
          {:error, :malformed_packet_error} | {:ok, Viing.Packet.Connect.Payload.t()}
  def decode(%Packet.Connect.VariableHeader{} = variable_header, packet) do
    with <<length::big-integer-size(16), rest::binary>> <- packet,
         <<client_id::binary-size(length), rest::binary>> <- rest do
      decode_internal(variable_header, %__MODULE__{client_id: client_id}, rest)
    else
      _ -> {:error, Packet.malformed_error()}
    end
  end

  defp decode_internal(
         %Packet.Connect.VariableHeader{user_name?: true} = variable_header,
         %__MODULE__{} = payload,
         packet
       ) do
    with <<length::big-integer-size(16), rest::binary>> <- packet,
         <<user_name::binary-size(length), rest::binary>> <- rest do
      decode_internal(
        %{variable_header | user_name?: false},
        %{payload | user_name: user_name},
        rest
      )
    else
      _ -> {:error, Packet.malformed_error()}
    end
  end

  defp decode_internal(
         %Packet.Connect.VariableHeader{password?: true} = variable_header,
         %__MODULE__{} = payload,
         packet
       ) do
    with <<length::big-integer-size(16), rest::binary>> <- packet,
         <<password::binary-size(length), rest::binary>> <- rest do
      decode_internal(
        %{variable_header | password?: false},
        %{payload | password: password},
        rest
      )
    else
      _ -> {:error, Packet.malformed_error()}
    end
  end

  defp decode_internal(
         %Packet.Connect.VariableHeader{} = _variable_header,
         %__MODULE__{} = payload,
         <<>>
       ) do
    {:ok, payload}
  end

  defp decode_internal(
         %Packet.Connect.VariableHeader{} = _variable_header,
         %__MODULE__{} = _payload,
         packet
       )
       when byte_size(packet) > 0 do
    {:error, Packet.malformed_error()}
  end
end
