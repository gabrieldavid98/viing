defmodule Viing.Packet.Publish.VariableHeader do
  @moduledoc false

  alias Viing.Packet

  @type t :: %__MODULE__{
          topic_name: binary() | nil,
          packet_identifier: non_neg_integer() | nil
        }
  defstruct topic_name: nil,
            packet_identifier: 0

  @spec decode(non_neg_integer(), <<_::16, _::_*8>>) ::
          {:error, :malformed_packet_error}
          | {:ok, Viing.Packet.Publish.VariableHeader.t(), binary}
  def decode(0, <<length::big-integer-size(16), rest::binary>>) do
    with <<topic_name::binary-size(length), payload::binary>> <- rest do
      variable_header = %__MODULE__{
        topic_name: topic_name,
        packet_identifier: nil
      }

      {:ok, variable_header, payload}
    else
      _ -> {:error, Packet.malformed_error()}
    end
  end

  def decode(qos, <<length::big-integer-size(16), rest::binary>>) when qos > 0 do
    with <<topic_name::binary-size(length), packet_identifier::big-integer-size(16),
           payload::binary>> <- rest do
      variable_header = %__MODULE__{
        topic_name: topic_name,
        packet_identifier: packet_identifier
      }

      {:ok, variable_header, payload}
    else
      _ -> {:error, Packet.malformed_error()}
    end
  end

  defimpl Viing.Encoding.Encodable do
    alias Viing.Packet

    @spec encode(Viing.Packet.Publish.VariableHeader.t()) :: <<_::16, _::_*8>>
    def encode(%Packet.Publish.VariableHeader{
          topic_name: topic_name,
          packet_identifier: nil
        }) do
      <<byte_size(topic_name)::16, topic_name::binary>>
    end

    def encode(%Packet.Publish.VariableHeader{
          topic_name: topic_name,
          packet_identifier: packet_identifier
        }) do
      <<byte_size(topic_name)::16, topic_name::binary, packet_identifier::16>>
    end
  end
end
