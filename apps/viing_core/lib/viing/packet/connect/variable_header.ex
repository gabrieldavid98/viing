defmodule Viing.Packet.Connect.VariableHeader do
  @moduledoc false

  alias Viing.Packet

  @type t :: %__MODULE__{
          protocol: binary(),
          protocol_version: non_neg_integer(),
          user_name?: boolean(),
          password?: boolean(),
          will_retain?: boolean(),
          will_qos?: 0x00 | 0x01 | 0x02,
          will?: boolean(),
          clean_session?: boolean(),
          keep_alive: non_neg_integer()
        }
  defstruct protocol: "MQTT",
            protocol_version: 0x04,
            user_name?: false,
            password?: false,
            will_retain?: false,
            will_qos?: 0,
            will?: false,
            clean_session?: false,
            keep_alive: 0

  @spec decode(any) ::
          {:error, :malformed_packet_error | :unsupported_protocol_version_error}
          | {:ok, Viing.Packet.Connect.VariableHeader.t(), binary}
  def decode(<<
        4::big-integer-size(16),
        "MQTT",
        4::8,
        user_name?::1,
        password?::1,
        will_retain?::1,
        will_qos?::2,
        will?::1,
        clean_session?::1,
        0::1,
        keep_alive::big-integer-size(16),
        packet::binary
      >>) do
    variable_header = %__MODULE__{
      user_name?: user_name? == 1,
      password?: password? == 1,
      will_retain?: will_retain? == 1,
      will_qos?: will_qos?,
      will?: will? == 1,
      clean_session?: clean_session? == 1,
      keep_alive: keep_alive
    }

    {:ok, variable_header, packet}
  end

  def decode(<<4::big-integer-size(16), "MQTT", _::8, _::binary>>) do
    {:error, Packet.unsupported_protocol_version_error()}
  end

  def decode(_), do: {:error, Packet.malformed_error()}
end
