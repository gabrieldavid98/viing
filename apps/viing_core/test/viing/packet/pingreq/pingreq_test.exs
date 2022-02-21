defmodule Viing.Packet.PingreqTest do
  use ExUnit.Case, async: true

  alias Viing.Packet

  describe "decode/1" do
    test "return %Viing.Packet.Pingreq{} if the packet is valid" do
      packet = <<0xC0, 0x00>>

      assert %Viing.Packet.Pingreq{
               __META__: %Viing.Packet.Meta{flags: 0, opcode: 12}
             } = Packet.Pingreq.decode(packet)
    end
  end
end
