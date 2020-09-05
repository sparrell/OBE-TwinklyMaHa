defmodule DoSet do
  @moduledoc """
  Documentation for `Set` contains helper functions for
  blah blah
  """

  require Logger

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
    ToDo.rainbow()
  end
  defp set_color("violet", command) do
    ToDo.violet()
  end
  defp set_color("indigo", command) do
    ToDo.indigo()
  end
  defp set_color("blue", command) do
    ToDo.blue()
  end
  defp set_color("green", command) do
    ToDo.green()
  end
  defp set_color("yellow", command) do
    ToDo.yellow()
  end
  defp set_color("orange", command) do
    ToDo.orange()
  end
  defp set_color("red", command) do
    ToDo.red()
  end
  defp set_color(color, command) do
    ## if haven't matched color yet, then bad color
    Command.return_error("bad color")
  end


end
