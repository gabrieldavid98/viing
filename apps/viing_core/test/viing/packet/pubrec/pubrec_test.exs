defmodule Viing.Packet.PubrecTest do
  use ExUnit.Case, async: true

  alias Viing.Packet
  alias Viing.Encoding

  describe "decode/1" do
    test "decodes pubrec packet when binary packet is valid" do
      packet = <<0x50, 0x02, 0x00, 0x77>>

      assert {:ok,
              %Viing.Packet.Pubrec{
                __META__: %Viing.Packet.Meta{flags: 0, opcode: 5},
                packet_identifier: 119
              }} = Packet.Pubrec.decode(packet)
    end

    test "fails when packet is malformed" do
      assert {:error, :malformed_packet_error} = Packet.Pubrec.decode(<<10, 20, 30>>)
    end
  end

  describe "encode/1 from Encodable protocol" do
    test "encodes pubrec packet" do
      puback = %Viing.Packet.Pubrec{
        __META__: %Viing.Packet.Meta{flags: 0, opcode: 5},
        packet_identifier: 119
      }

      assert <<0x50, 0x02, 0x00, 0x77>> = Encoding.Encodable.encode(puback)
    end
  end
end