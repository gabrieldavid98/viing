defprotocol Viing.Encoding.Encodable do
  @moduledoc false

  @spec encode(t) :: iodata()
  def encode(packet)
end
