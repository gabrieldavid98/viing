defmodule Viing.Packet.Publish.VariableHeaderTest do
  use ExUnit.Case, async: true

  alias Viing.Packet
  alias Viing.Encoding

  describe "decode/2" do
    test "fails when packet is malformed" do
      assert {:error, :malformed_packet_error} =
               Packet.Publish.VariableHeader.decode(0, <<10, 20, 30>>)
    end

    test "decodes variable header when qos is 0 and packet_identifier is not present in the packet" do
      packet =
        <<0x00, 0x03, 0x61, 0x2F, 0x62, 0x48, 0x6F, 0x6C, 0x61, 0x20, 0x71, 0x75, 0xC3, 0xA9,
          0x20, 0x74, 0x61, 0x6C, 0x3F>>

      assert {
               :ok,
               %Viing.Packet.Publish.VariableHeader{packet_identifier: nil, topic_name: "a/b"},
               "Hola qué tal?"
             } = Packet.Publish.VariableHeader.decode(0, packet)
    end

    test "decodes variable header when qos is 1 and packet is valid" do
      packet =
        <<0x00, 0x03, 0x61, 0x2F, 0x62, 0x00, 0x01, 0x48, 0x6F, 0x6C, 0x61, 0x20, 0x71, 0x75,
          0xC3, 0xA9, 0x20, 0x74, 0x61, 0x6C, 0x3F>>

      assert {
               :ok,
               %Viing.Packet.Publish.VariableHeader{packet_identifier: 1, topic_name: "a/b"},
               "Hola qué tal?"
             } = Packet.Publish.VariableHeader.decode(1, packet)
    end
  end

  describe "encode/1 from Encodable protocol" do
    test "encodes variable header when no packet identifier present" do
      variable_header = %Packet.Publish.VariableHeader{
        packet_identifier: nil,
        topic_name: "module1/switch/on"
      }

      assert <<0x00, 0x11, 0x6D, 0x6F, 0x64, 0x75, 0x6C, 0x65, 0x31, 0x2F, 0x73, 0x77, 0x69, 0x74,
               0x63, 0x68, 0x2F, 0x6F, 0x6E>> = Encoding.Encodable.encode(variable_header)
    end

    test "encodes variable header when packet identifier is present" do
      variable_header = %Packet.Publish.VariableHeader{
        packet_identifier: 77,
        topic_name: "module1/switch/on"
      }

      assert <<0x00, 0x11, 0x6D, 0x6F, 0x64, 0x75, 0x6C, 0x65, 0x31, 0x2F, 0x73, 0x77, 0x69, 0x74,
               0x63, 0x68, 0x2F, 0x6F, 0x6E, 0x00,
               0x4D>> = Encoding.Encodable.encode(variable_header)
    end
  end
end
