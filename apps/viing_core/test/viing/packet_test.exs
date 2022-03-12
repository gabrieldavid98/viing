defmodule Viing.PacketTest do
  use ExUnit.Case, async: true

  alias Viing.Packet

  describe "drop_length/1" do
    test "drops 1 byte length" do
      packet = <<0x40, 0x10>>

      assert {:ok, <<0x10>>} = Packet.drop_length(packet)
    end

    test "drops 2 bytes length" do
      packet = <<0xC1, 0x02, 0x10>>

      assert {:ok, <<0x10>>} = Packet.drop_length(packet)
    end

    test "drops 3 bytes length" do
      packet = <<0xE8, 0x84, 0x01, 0x10>>

      assert {:ok, <<0x10>>} = Packet.drop_length(packet)
    end

    test "drops 4 bytes length" do
      packet = <<0x80, 0xE1, 0xEB, 0x17, 0x10>>

      assert {:ok, <<0x10>>} = Packet.drop_length(packet)
    end

    test "fails when 5 bytes length" do
      packet = <<0x80, 0xE1, 0xEB, 0xEB, 0x17, 0x10>>

      assert {:error, :malformed_packet_error} = Packet.drop_length(packet)
    end
  end

  describe "flag/1" do
    test "returns 0 when 0 or nil or false passed as parameter" do
      assert 0 = Packet.flag(0)
      assert 0 = Packet.flag(nil)
      assert 0 = Packet.flag(false)
    end

    test "returns 1 when 1 or a positive integer passed as parameter" do
      assert 1 = Packet.flag(1)
      assert 1 = Packet.flag(77)
    end
  end

  describe "compute_remaining_length/1" do
    test "computes remainig length from a given binary data" do
      data = Enum.reduce(1..321, <<>>, fn n, acc -> acc <> <<n>> end)
      assert <<0xC1, 0x02>> = Packet.compute_remaining_length(data)
    end
  end
end
