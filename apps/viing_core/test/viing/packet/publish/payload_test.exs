defmodule Viing.Packet.Publish.PayloadTest do
  use ExUnit.Case, async: true

  alias Viing.Packet
  alias Viing.Encoding

  describe "decode/1" do
    test "decodes the payload when packet is valid" do
      packet =
        <<0x48, 0x6F, 0x6C, 0x61, 0x20, 0x71, 0x75, 0xC3, 0xA9, 0x20, 0x74, 0x61, 0x6C, 0x3F>>

      assert {
               :ok,
               %Viing.Packet.Publish.Payload{app_message: "Hola qué tal?"}
             } = Packet.Publish.Payload.decode(packet)
    end
  end

  describe "encode/1 from Encodable protocol" do
    test "encodes payload packet" do
      payload = %Packet.Publish.Payload{app_message: "Hola qué tal?"}

      assert <<"Hola qué tal?">> = Encoding.Encodable.encode(payload)
    end
  end
end
