defmodule Viing.Packet.Publish.Payload do
  @moduledoc false

  alias Viing.Packet

  @type t :: %__MODULE__{
          app_message: binary()
        }
  defstruct app_message: ""

  @spec decode(binary()) ::
          {:error, :malformed_packet_error} | {:ok, Viing.Packet.Publish.Payload.t()}
  def decode(<<app_message::binary>>) do
    {:ok, %__MODULE__{app_message: app_message}}
  end

  def decode(_), do: {:error, Packet.malformed_error()}

  defimpl Viing.Encoding.Encodable do
    alias Viing.Packet

    @spec encode(Viing.Packet.Publish.Payload.t()) :: binary()
    def encode(%Packet.Publish.Payload{app_message: app_message}) do
      <<app_message::binary>>
    end
  end
end
