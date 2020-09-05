defmodule DoSet do
  @moduledoc """
  Documentation for `Set` contains helper functions for
  blah blah
  """

  require Logger

  @colors ["violet", "indigo", "blue", "green", "yellow", "orange", "red"]

  @topic "leds"


  @doc """
  do_cmd executes the action
  matching on action/target
  end
  """
  def do_cmd(%Command{error?: true} = command) do
    ## something went wrong upstream, pass along
    command
  end
  def do_cmd(%Command{action: action}) when action != "set" do
    ## should always be action=set
    Command.return_error("wrong action in command")
  end
  def do_cmd(%Command{target_specifier: color,
                      target: "x-sfractal-blinky:led"
                      } = command) do
    set_color(color, command)
  end
  def do_cmd(command) do
    ## should not have gotten here
    Logger.debug("do_cmd #{inspect(command)}")
    Command.return_error("invalid action/target or target/specifier pair")
  end

  defp set_color("rainbow", command) do
    Phoenix.PubSub.broadcast(TwinklyMaha.PubSub, @topic, "rainbow")
    %Command{command | response: %{status: 200}}
  end
  defp set_color("off", command) do
    Phoenix.PubSub.broadcast(TwinklyMaha.PubSub, @topic, "off")
    %Command{command | response: %{status: 200}}
  end
  defp set_color(color, command) do
    if color in @colors do
      Phoenix.PubSub.broadcast(TwinklyMaha.PubSub, @topic, color)
      %Command{command | response: %{status: 200}}
    else
      Command.return_error("invalid color")
    end
  end

end
