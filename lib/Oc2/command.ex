defmodule Oc2.Command do
  @moduledoc """
  Documentation for `Oc2.Command` contains helper functions for decoding
  and responding to OpenC2 cmds:
  - new - initialize struct and validate command
  - do_cmd - execute the command (using helpers in peer modules)
  - return_error - helper routine for when errors are encountered

  Oc2.Command is called from transport modules (eg mqtt, http, ...)
  and is common across transports.
  Oc2.Command results are returned to transport modules to return reply messages
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
    # convert json text into elixir map
    |> Jason.decode()
    # initialize struct
    |> Oc2.CheckOc2.new()
    # validate oc2
    |> Oc2.CheckOc2.check_cmd()
  end

  @doc """
  do_cmd executes the action
  matching on action/target
  """
  def do_cmd(%Oc2.Command{error?: true} = command) do
    ## something went wrong upstream, pass along
    command
  end

  def do_cmd(command) do
    command
    |> Oc2.DoOc2.do_cmd()
  end

  @doc """
  error helper
  """
  def return_error(error_msg) do
    Logger.debug(error_msg)
    %Oc2.Command{error?: true, error_msg: error_msg}
  end
end
