defmodule Viing do
  @typedoc """
  An identifier used to identify the client on the server.
  Most servers accept a maximum of 23 UTF-8 encode bytes for a client
  id, and only the characters:
    - "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  Tortoise accept atoms as client ids but they it will be converted to
  a string before going on the wire. Be careful with atoms such as
  `Example` because they are expanded to the atom `:"Elixir.Example"`,
  it is really easy to hit the maximum byte limit. Solving this is
  easy, just add a `:` before the client id such as `:Example`.
  """
  @type client_id() :: atom() | String.t()

  @typedoc """
  A 16-bit number identifying a message in a message exchange.
  Some MQTT packages are part of a message exchange and need an
  identifier so the server and client can distinct between multiple
  in-flight messages.
  Tortoise will assign package identifier to packages that need them,
  so outside of tests (where it is beneficial to assert on the
  identifier of a package) it should be set by tortoise itself; so
  just leave it as `nil`.
  """
  @type package_identifier() :: 0x0001..0xFFFF | nil

  @typedoc """
  What Quality of Service (QoS) mode should be used.
  Quality of Service is one of 0, 1, and 2 denoting the following:
  - `0` no quality of service. The message is a fire and forget.
  - `1` at least once delivery. The receiver will respond with an
    acknowledge message, so the sender will be certain that the
    message has reached the destination. It is possible that a message
    will be delivered twice though, as the package identifier for a
    publish will be relinquished when the message has been
    acknowledged, so a package with the same identifier will be
    treated as a new message though it might be a re-transmission.
  - `2` exactly once delivery. The receiver will only receive the
    message once. This happens by having a more elaborate message
    exchange than the QoS=1 variant.
  There are a difference in the semantics of assigning a QoS to a
  publish and a subscription. When assigned to a publish the message
  will get delivered to the server with the requested QoS; that is if
  it accept that level of QoS for the given topic.
  When used in the context of a subscription it should be read as *the
  maximum QoS*. When messages are published to the subscribed topic
  the message will get on-warded with the same topic as it was
  delivered with, or downgraded to the maximum QoS of the subscription
  for the given subscribing client. That is, if the client subscribe
  with a maximum QoS=2 and a message is published to said topic with a
  QoS=1, the message will get downgraded to QoS=1 when on-warded to
  the client.
  """
  @type qos() :: 0..2

  @typedoc """
  A topic for a message.
  According to the MQTT 3.1.1 specification a valid topic must be at
  least one character long. They are case sensitive and can include
  space characters.
  MQTT topics consist of topic levels which are delimited with forward
  slashes `/`. A topic with a leading or trailing forward slash is
  allowed but they create distinct topics from the ones without;
  `/sports/tennis/results` are different from
  `sports/tennis/results`. While a topic level normally require at
  least one character the topic `/` (a single forward slash) is valid.
  The server will drop the connection if it receive an invalid topic.
  """
  @type topic() :: String.t()

  @typedoc """
  A topic filter for a subscription.
  The topic filter is different from a `topic` because it is allowed
  to contain wildcard characters:
  - `+` is a single level wildcard which is allowed to stand on any
    position in the topic filter. For instance: `sport/+/results` will
    match `sport/tennis/results`, `sport/soccer/results`, etc.
  - `#` is a multi-level wildcard and is only allowed to be on the
    last position of the topic filter. For instance: `sport/#` will
    match `sport/tennis/results`, `sport/tennis/announcements`, etc.
  The server will reject any invalid topic filter and close the
  connection.
  """
  @type topic_filter() :: String.t()
end
