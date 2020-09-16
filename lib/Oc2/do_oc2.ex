defmodule Oc2.DoOc2 do
  @moduledoc """
  `Oc2.DoOc2` contains routines to execute the OpenC2 command,
  calling helper routines for the different OpenC2  commands
  (e.g. do_query for the OpenC2 'query' command )
  """

  require Logger

  @doc """
  do_cmd executes the action
  matching on action/target
  """
  def do_cmd(%Oc2.Command{error?: true} = command) do
    ## upstream error, pass it on
    command
  end

  def do_cmd(%Oc2.Command{action: "set"} = command) do
    Oc2.DoSet.do_cmd(command)
  end

  def do_cmd(%Oc2.Command{action: "query"} = command) do
    Oc2.DoQuery.do_cmd(command)
  end

  def do_cmd(command) do
    # reached wo matching so error
    e1 = "no match on action/target pair: "
    e2 = inspect(command.action)
    e3 = inspect(command.target)
    error_msg = e1 <> e2 <> "" <> e3
    Oc2.Command.return_error(error_msg)
  end
end
