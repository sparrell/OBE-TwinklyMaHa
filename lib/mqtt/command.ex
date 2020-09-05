defmodule Command do
  @moduledoc """
  Documentation for `Command` contains helper functions for decoding
  and responding to OpenC2 cmds:
  - new - initialize struct and validate command
  - do_cmd - execute the command
  - return_result - respond to OC2 producer
  """

  @enforce_keys [:error?]
  defstruct [
        :error?,
        :error_msg,
        :cmd,
        :action,
        :target,
        :target_specifier,
        :actuator,
        :actuator_specifier,
        :cmd_id,
        :args,
        :response
        ]



  require Logger

  @doc """
  new intializes the command struct
  """
  def new(msg) do
    msg
    |> Jason.decode           # convert json text into elixir map
    |> CheckOc2.new           # initialize struct
    |> CheckOc2.check_cmd     # validate oc2
  end

  @doc """
  do_cmd executes the action
  matching on action/target
  """
  def do_cmd((%Command{error?: true} = command)) do
    ## something went wrong upstream, pass along
    command
  end
  def do_cmd(command) do
    command
    |> DoOc2.do_cmd
  end

  @doc """
  return result
  """
  def return_result((%Command{error?: true} = command)) do
    ## something went wrong upstream, so return "oops"
    e1 = "Error: "
    e2 = inspect(command.error_msg)
    error_msg = e1 <> " " <> e2
    Logger.debug(error_msg)
    Tortoise.publish("sFractal/response", "oops")
    {:error, error_msg}
  end
  def return_result((%Command{response: nil} = command)) do
    ## no response
    {:ok, command}
  end
  def return_result(command) do
    Logger.debug("return: ok #{inspect(command.response)}")
    response = Jason.encode(command.response)
    Logger.debug("json: #{inspect(response)}")
    Tortoise.publish("sFractal/response", response)
    {:ok, command}
  end

  @doc """
  error helper
  """
  def return_error(error_msg) do
    Logger.debug(error_msg)
    %Command{error?: true, error_msg: error_msg}
  end

end
