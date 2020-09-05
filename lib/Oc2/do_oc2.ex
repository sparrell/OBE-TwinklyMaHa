defmodule DoOc2 do
  @moduledoc """
  Documentation for `DoOc2` contains ...
  """

  require Logger

    @doc """
  do_cmd executes the action
  matching on action/target
  """
  def do_cmd(%Command{error?: true} = command) do
    ## upstream error, pass it on
    command
  end
  def do_cmd(%Command{action: "set"} = command) do
    DoSet.do_cmd(command)
  end
  def do_cmd(%Command{action: "query"} = command) do
    DoQuery.do_cmd(command)
  end

  def do_cmd(command) do
    # reached wo matching so error
    e1 = "no match on action/target pair: "
    e2 = inspect(command.action)
    e3 = inspect(command.target)
    error_msg = e1 <> e2 <> "" <> e3
    Command.return_error(error_msg)
  end

end
