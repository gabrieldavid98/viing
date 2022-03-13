defmodule Viing.Packet.PubackTest do
  use ExUnit.Case, async: true

  alias Viing.Packet
  alias Viing.Encoding

  describe "decode/1" do
    test "decodes puback packet when binary packet is valid" do
      packet = <<0x40, 0x02, 0x00, 0x77>>

      assert {:ok,
              %Viing.Packet.Puback{
                __META__: %Viing.Packet.Meta{flags: 0, opcode: 4},
                packet_identifier: 119
              }} = Packet.Puback.decode(packet)
    end

    test "fails when packet is malformed" do
      assert {:error, :malformed_packet_error} = Packet.Puback.decode(<<10, 20, 30>>)
    end
  end

  describe "encode/1 from Encodable protocol" do
    test "encodes puback packet" do
      puback = %Viing.Packet.Puback{
        __META__: %Viing.Packet.Meta{flags: 0, opcode: 4},
        packet_identifier: 119
      }

      assert <<0x40, 0x02, 0x00, 0x77>> = Encoding.Encodable.encode(puback)
    end
  end
end
