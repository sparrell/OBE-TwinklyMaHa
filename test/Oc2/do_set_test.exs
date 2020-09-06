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
    assert command.error_msg == "invalid color"
  end

  test "rainbow" do
    command = %Command{error?: false,
                      action: "set",
                      target: "x-sfractal-blinky:led",
                      target_specifier: "rainbow"
                     }
        |> DoSet.do_cmd
    assert command.error_msg == nil
    assert command.error? == false
    assert command.response.status == 200
  end

  test "red" do
    command = %Command{error?: false,
                      action: "set",
                      target: "x-sfractal-blinky:led",
                      target_specifier: "Red"
                     }
        |> DoSet.do_cmd
    assert command.error_msg == nil
    assert command.error? == false
    assert command.response.status == 200
  end

  test "led off" do
    command = %Command{error?: false,
                      action: "set",
                      target: "x-sfractal-blinky:led",
                      target_specifier: "off"
                     }
        |> DoSet.do_cmd
    assert command.error_msg == nil
    assert command.error? == false
    assert command.response.status == 200
  end

end
