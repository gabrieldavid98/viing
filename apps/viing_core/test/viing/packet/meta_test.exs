defmodule Viing.Packet.MetaTest do
  use ExUnit.Case, async: true

  alias Viing.Packet.Meta

  describe "encode/1" do
    test "return <<1::4, 0::4>>" do
      meta = %Meta{
        opcode: 1,
        flags: 0
      }

      assert <<1::4, 0::4>> = Meta.encode(meta)
    end
  end
end
