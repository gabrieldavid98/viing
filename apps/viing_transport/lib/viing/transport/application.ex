defmodule Viing.Transport.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    port = String.to_integer(System.get_env("MQTT_TCP_PORT") || "1883")

    children = [
      {Task.Supervisor, name: Viing.Transport.TaskSupervisor},
      Supervisor.child_spec(
        {Task, fn -> Viing.Transport.Tcp.accept(port) end},
        restart: :permanent
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Viing.Transport.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
