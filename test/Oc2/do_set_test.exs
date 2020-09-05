defmodule DoSetTest do
  use ExUnit.Case
  doctest DoSet

  test "check_cmd_upsteam" do
    command = %Command{error?: true, error_msg: "error_msg"}
        |> DoSet.do_cmd
    assert command.error? == true
    assert command.error_msg == "error_msg"
  end

  test "wrong action" do
    command = %Command{error?: false, action: "query" }
        |> DoSet.do_cmd
    assert command.error? == true
    assert command.error_msg == "wrong action in command"
  end

  test "wrong led color" do
    command = %Command{error?: false,
                      action: "set",
                      target: "x-sfractal-blinky:led",
                      target_specifier: "badcolor"
                     }
        |> DoSet.do_cmd
    assert command.error? == true
    assert command.error_msg == "bad color"
  end



end
