defmodule Viing.Packet.Connack.VariableHeaderTest do
  use ExUnit.Case, async: true

  alias Viing.Packet.Connack.VariableHeader
  alias Viing.Encoding.Encodable

  describe "encode/1" do
    test "return correct encoding" do
      variable_header = %VariableHeader{
        session_present?: false,
        status: 0x00
      }

      assert <<0::7, 0::1, 0::8>> = Encodable.encode(variable_header)
    end
  end
end
