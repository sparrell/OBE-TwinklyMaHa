defmodule DoQuery do
  @moduledoc """
  Documentation for `Query` contains helper functions for
  blah blah
  """

  require Logger

  @doc """
  do_cmd executes the action
  matching on action/target
  """
  def do_cmd(%Command{error?: true} = command) do
    ## something went wrong upstream, pass along
    command
  end
  def do_cmd(%Command{action: action}) when action != "query" do
    ## should always be action=query
    Command.return_error("wrong action in command")
  end
  def do_cmd(%Command{action: "query",
                      target: "x-sfractal-blinky:hello_world",
                      target_specifier: "Hello"
                      } = command) do
    # executing hello world returns "Hello World"
    %Command{command | response: "Hello World"}
  end
  def do_cmd(%Command{action: "query",
                      target: "x-sfractal-blinky:hello_world",
                      } = command) do
    # did not match on correct target_specifier so error
    e1 = "Hello World incorrect specifier"
    e2 = inspect(command.target_specifier)
    error_msg = e1 <> " " <> e2
    Logger.debug(e1)
    Command.return_error(e1)
  end
  def do_cmd(%Command{action: "query",
                      target: "sbom"
                      } = command) do
    DoQuerySbom.return_sbom(command)
  end
  def do_cmd(%Command{action: "query",
                      target: "features"
                      } = command) do
    DoQueryFeatures.return_features(command)
  end
  def do_cmd(command) do
    ## no match of what to do, so error
    error_msg = "invalid action/target or target/specifier pair"
    Logger.debug("do_cmd #{inspect(command)}")
    Command.return_error(error_msg)
  end

end
