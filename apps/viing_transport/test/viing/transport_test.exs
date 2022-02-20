defmodule Viing.TransportTest do
  use ExUnit.Case
  doctest Viing.Transport

  test "greets the world" do
    assert Viing.Transport.hello() == :world
  end
end
