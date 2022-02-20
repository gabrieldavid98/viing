defmodule Viing.Packet.Connect.PayloadTest do
  use ExUnit.Case, async: true

  alias Viing.Packet.Connect.{Payload, VariableHeader}

  describe "decode/2" do
    test "return {:ok, %Viing.Packet.Connect.Payload{}} if the packet is valid" do
      packet =
        <<0x00, 0x11, 0x45, 0x6C, 0x69, 0x78, 0x69, 0x72, 0x2E, 0x48, 0x65, 0x6C, 0x6C, 0x6F,
          0x57, 0x6F, 0x72, 0x6C, 0x64, 0x00, 0x07, 0x67, 0x61, 0x62, 0x72, 0x69, 0x65, 0x6C,
          0x00, 0x07, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x61>>

      variable_header = %VariableHeader{
        user_name?: true,
        password?: true
      }

      assert {:ok,
              %Viing.Packet.Connect.Payload{
                client_id: "Elixir.HelloWorld",
                password: "123456a",
                user_name: "gabriel"
              }} = Payload.decode(variable_header, packet)
    end
  end
end
