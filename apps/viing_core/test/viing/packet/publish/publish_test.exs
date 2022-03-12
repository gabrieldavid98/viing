defmodule Viing.Packet.PublishTest do
  use ExUnit.Case, async: true

  alias Viing.Packet
  alias Viing.Encoding

  describe "decode/1" do
    test "fails when packet is malformed" do
      assert {:error, :malformed_packet_error} = Packet.Publish.decode(<<10, 20, 30>>)
    end

    test "decodes publish packet when dup and qos are 0 and packet is valid" do
      packet =
        <<0x31, 0x15, 0x00, 0x03, 0x61, 0x2F, 0x62, 0x48, 0x6F, 0x6C, 0x61, 0x20, 0x71, 0x75,
          0xC3, 0xA9, 0x20, 0x74, 0x61, 0x6C, 0x3F>>

      assert {:ok,
              %Viing.Packet.Publish{
                __META__: %Viing.Packet.Meta{flags: 0, opcode: 3},
                dup: false,
                payload: %Viing.Packet.Publish.Payload{app_message: "Hola qué tal?"},
                qos: 0,
                retain: true,
                variable_header: %Viing.Packet.Publish.VariableHeader{
                  packet_identifier: nil,
                  topic_name: "a/b"
                }
              }} = Packet.Publish.decode(packet)
    end

    test "decodes publish packet when binary packet is valid" do
      packet =
        <<0x3D, 0x15, 0x00, 0x03, 0x61, 0x2F, 0x62, 0x00, 0x01, 0x48, 0x6F, 0x6C, 0x61, 0x20,
          0x71, 0x75, 0xC3, 0xA9, 0x20, 0x74, 0x61, 0x6C, 0x3F>>

      assert {:ok,
              %Viing.Packet.Publish{
                __META__: %Viing.Packet.Meta{flags: 0, opcode: 3},
                dup: true,
                payload: %Viing.Packet.Publish.Payload{app_message: "Hola qué tal?"},
                qos: 2,
                retain: true,
                variable_header: %Viing.Packet.Publish.VariableHeader{
                  packet_identifier: 1,
                  topic_name: "a/b"
                }
              }} = Packet.Publish.decode(packet)
    end
  end

  describe "encode/1 from Encodable protocol" do
    test "encodes publish packet" do
      publish = %Packet.Publish{
        __META__: %Packet.Meta{flags: 0, opcode: 3},
        dup: true,
        payload: %Packet.Publish.Payload{app_message: "Hola qué tal?"},
        qos: 2,
        retain: true,
        variable_header: %Packet.Publish.VariableHeader{
          packet_identifier: 1,
          topic_name: "a/b"
        }
      }

      assert <<0x3D, 0x15, 0x00, 0x03, 0x61, 0x2F, 0x62, 0x00, 0x01, 0x48, 0x6F, 0x6C, 0x61, 0x20,
               0x71, 0x75, 0xC3, 0xA9, 0x20, 0x74, 0x61, 0x6C,
               0x3F>> = Encoding.Encodable.encode(publish)
    end
  end
end
