defmodule Viing.Packet.PingrespTest do
  use ExUnit.Case, async: true

  alias Viing.Packet
  alias Viing.Encoding.Encodable

  describe "encode/1" do
    test "return encoded packet" do
      ping_resp = %Packet.Pingresp{}

      assert <<0xD0, 0x00>> = Encodable.encode(ping_resp)
    end
  end
end
