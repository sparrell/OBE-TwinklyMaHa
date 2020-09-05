defmodule Oc2Mqtt.Handler do
  @moduledoc false

  require Logger

  defstruct [:name]
  alias __MODULE__, as: State

  @behaviour Tortoise.Handler

  @impl true
  def init(opts) do
    name = Keyword.get(opts, :name)
    {:ok, %State{name: name}}
  end

  @impl true
  def connection(:up, state) do
    Logger.debug("Connection has been established")
    {:ok, state}
  end

  def connection(:down, state) do
    Logger.warn("Connection has been dropped")
    {:ok, state}
  end

  @impl true
  def subscription(:up, topic, state) do
    Logger.debug("Subscribed to #{topic}")
    {:ok, state}
  end

  def subscription({:warn, [requested: req, accepted: qos]}, topic, state) do
    Logger.warn("Subscribed to #{topic}; requested #{req} but got accepted with QoS #{qos}")
    {:ok, state}
  end

  def subscription({:error, reason}, topic, state) do
    Logger.error("Error subscribing to #{topic}; #{inspect(reason)}")
    {:ok, state}
  end

  def subscription(:down, topic, state) do
    Logger.debug("Unsubscribed from #{topic}")
    {:ok, state}
  end

  @impl true
  def handle_message(["sfractal","command"], msg, state) do
    Logger.debug("id: #{state.name}")
    Logger.debug("topic: sfractal/command")
    Logger.debug("msg: #{inspect(msg)}")

    {status, result} =
      msg
      |> Command.new            #initialize struct
      |> Command.do_cmd         #execute
      |> Command.return_result  #reply
    Logger.debug("handle_msg: status #{inspect(status)}")
    Logger.debug("handle_msg: command #{inspect(result)}")
    Logger.debug("state: #{inspect(state)}")
    {:ok, state}
  end
  def handle_message(topic, msg, state) do
    Logger.info("topic != sfractal/command")
    Logger.info("#{state.name}, #{Enum.join(topic, "/")} #{inspect(msg)}")
    {:ok, state}
  end

  @impl true
  def terminate(reason, _state) do
    Logger.warn("Client has been terminated with reason: #{inspect(reason)}")
    :ok
  end

end
