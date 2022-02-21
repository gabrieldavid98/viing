defmodule Viing.Packet.ConnackTest do
  use ExUnit.Case, async: true

  alias Viing.Packet.Connack
  alias Viing.Encoding.Encodable

  describe "encode/1" do
    test "return encoded packet" do
      variable_header = %Connack.VariableHeader{
        session_present?: false,
        status: 0x00
      }

      connack = %Connack{variable_header: variable_header}

      assert <<2::4, 0::4, 0x02, 0::7, 0::1, 0::8>> = Encodable.encode(connack)
    end
  end
end
