defprotocol Viing.Encoding.Decodable do
  @moduledoc false

  @spec decode(binary() | list()) :: any
  def decode(data)
end

defimpl Viing.Encoding.Decodable, for: BitString do
  alias Viing.Packet

  def decode(<<1::4, _::4, _::binary>> = data), do: Packet.Connect.decode(data)
  def decode(<<3::4, _::4, _::binary>> = data), do: {:publish, data}
  def decode(<<4::4, _::4, _::binary>> = data), do: {:buback, data}
  def decode(<<5::4, _::4, _::binary>> = data), do: {:pubrec, data}
  def decode(<<6::4, _::4, _::binary>> = data), do: {:pubrel, data}
  def decode(<<7::4, _::4, _::binary>> = data), do: {:pubcomp, data}
  def decode(<<8::4, _::4, _::binary>> = data), do: {:subscribe, data}
  def decode(<<10::4, _::4, _::binary>> = data), do: {:unsubscribe, data}
  def decode(<<12::4, _::4, _::binary>> = data), do: {:pingreq, data}
  def decode(<<14::4, _::4, _::binary>> = data), do: {:disconnect, data}
  def decode(<<15::4, _::4, _::binary>> = data), do: {:auth, data}
  def decode(_), do: {:error, Packet.malformed_error()}
end

defimpl Viing.Encoding.Decodable, for: List do
  def decode(data) do
    data
    |> IO.iodata_to_binary()
    |> Viing.Encoding.Decodable.decode()
  end
end
