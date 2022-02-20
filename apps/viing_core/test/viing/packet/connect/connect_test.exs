defmodule Viing.Packet.ConnectTest do
  use ExUnit.Case, async: true

  alias Viing.Packet.Connect

  describe "decode/1" do
    test "return %Viing.Packet.Connect{} if the packet is valid" do
      packet =
        <<0x10, 0x30, 0x00, 0x04, 0x4D, 0x51, 0x54, 0x54, 0x04, 0xC2, 0x00, 0x3C, 0x00, 0x11,
          0x45, 0x6C, 0x69, 0x78, 0x69, 0x72, 0x2E, 0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x57, 0x6F,
          0x72, 0x6C, 0x64, 0x00, 0x07, 0x67, 0x61, 0x62, 0x72, 0x69, 0x65, 0x6C, 0x00, 0x07,
          0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x61>>

      assert {:ok,
              %Viing.Packet.Connect{
                __META__: %Viing.Packet.Meta{flags: 0, opcode: 1},
                payload: %Viing.Packet.Connect.Payload{
                  client_id: "Elixir.HelloWorld",
                  password: "123456a",
                  user_name: "gabriel"
                },
                variable_header: %Viing.Packet.Connect.VariableHeader{
                  clean_session?: true,
                  keep_alive: 60,
                  password?: true,
                  protocol: "MQTT",
                  protocol_version: 4,
                  user_name?: true,
                  will?: false,
                  will_qos?: 0,
                  will_retain?: false
                }
              }} = Connect.decode(packet)
    end
  end
end
