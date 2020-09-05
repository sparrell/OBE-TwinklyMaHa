defmodule DoQueryTest do
  use ExUnit.Case
  doctest DoQuery

  test "check_cmd_upsteam" do
    command = %Command{error?: true, error_msg: "error_msg"}
        |> DoQuery.do_cmd
    assert command.error? == true
    assert command.error_msg == "error_msg"
  end

  test "wrong action" do
    command = %Command{error?: false, action: "set" }
        |> DoQuery.do_cmd
    assert command.error? == true
    assert command.error_msg == "wrong action in command"
  end

  test "hello world" do
    command = %Command{error?: false,
                       action: "query",
                       target: "x-sfractal-blinky:hello_world",
                       target_specifier: "Hello"
                       }
        |> DoQuery.do_cmd
    assert command.error? == false
    assert command.response == "Hello World"
  end

  test "bad hello world" do
    command = %Command{error?: false,
                       action: "query",
                       target: "x-sfractal-blinky:hello_world",
                       target_specifier: "hello"
                       }
        |> DoQuery.do_cmd
    assert command.error? == true
    assert command.error_msg == "Hello World incorrect specifier"
  end

  test "invalid action/target" do
    command = %Command{error?: false,
                       action: "query",
                       target: "hello_world",
                       target_specifier: "hello"
                       }
        |> DoQuery.do_cmd
    assert command.error? == true
    assert command.error_msg == "invalid action/target or target/specifier pair"
  end

  test "good_sbom" do
    command = %Command{error?: false,
                       action: "query",
                       target: "sbom",
                       target_specifier: %{type: ["cyclonedx", "spdx","swid"]}
                       }
        |> DoQuery.do_cmd
    assert command.error? == false
    assert command.response.status == 200
    assert command.response.results.sbom.depth == "one-hop"
    assert command.response.results.sbom.manifest.mime_type == "application/cyclonedx+xml"
    assert command.response.results.sbom.type == "CycloneDX"
  end

  test "sbom_swid" do
    command = %Command{error?: false,
                       action: "query",
                       target: "sbom",
                       target_specifier: %{type: ["swid"]}
                       }
        |> DoQuery.do_cmd
    assert command.error? == true
    assert command.error_msg == "invalid target specifier"
  end

  test "sbom_not_list" do
    command = %Command{error?: false,
                       action: "query",
                       target: "sbom",
                       target_specifier: %{type: "cyclonedx"}
                       }
        |> DoQuery.do_cmd
    assert command.error? == true
    assert command.error_msg == "invalid target specifier"
  end

  test "sbom_not_type" do
    command = %Command{error?: false,
                       action: "query",
                       target: "sbom",
                       target_specifier: %{nottype: "cyclonedx"}
                       }
        |> DoQuery.do_cmd
    assert command.error? == true
    assert command.error_msg == "invalid target specifier"
  end

  test "sbom_not_map" do
    command = %Command{error?: false,
                       action: "query",
                       target: "sbom",
                       target_specifier: "cyclonedx"
                       }
        |> DoQuery.do_cmd
    assert command.error? == true
    assert command.error_msg == "invalid target specifier"
  end

  test "feature not list" do
    command = %Command{error?: false,
                       action: "query",
                       target: "features",
                       target_specifier: "version"
                       }
        |> DoQuery.do_cmd
    assert command.error? == true
    assert command.error_msg == "invalid target specifier"
  end

  test "invalid feature" do
    command = %Command{error?: false,
                       action: "query",
                       target: "features",
                       target_specifier: ["nonfeature"]
                       }
        |> DoQuery.do_cmd
    assert command.error? == true
    assert command.error_msg == "invalid features"
  end

  test "empty feature" do
    command = %Command{error?: false,
                       action: "query",
                       target: "features",
                       target_specifier: []
                       }
        |> DoQuery.do_cmd
    assert command.error? == false
    assert command.response.status == 200
  end

  test "versions" do
    command = %Command{error?: false,
                       action: "query",
                       target: "features",
                       target_specifier: ["versions"]
                       }
        |> DoQuery.do_cmd
    assert command.error? == false
    assert command.response.status == 200
    assert command.response.results.versions == ["0.5.2"]
  end

  test "pairs" do
    command = %Command{error?: false,
                       action: "query",
                       target: "features",
                       target_specifier: ["pairs"]
                       }
        |> DoQuery.do_cmd
    assert command.error? == false
    assert command.response.status == 200
    assert Enum.member?(command.response.results.pairs.query, :features)
    assert Enum.member?(command.response.results.pairs.query, :sbom)
    assert Enum.member?(command.response.results.pairs.query, :"x-sfractal-blinky:hello_world")
    assert Enum.member?(command.response.results.pairs.set, :"x-sfractal-blinky:led")
  end

  test "rate_limit" do
    command = %Command{error?: false,
                       action: "query",
                       target: "features",
                       target_specifier: ["rate_limit"]
                       }
        |> DoQuery.do_cmd
    assert command.error? == false
    assert command.response.status == 200
    assert command.response.results.rate_limit == 100000
  end

  test "profiles" do
    command = %Command{error?: false,
                       action: "query",
                       target: "features",
                       target_specifier: ["profiles"]
                       }
        |> DoQuery.do_cmd
    assert command.error? == false
    assert command.response.status == 200
    assert command.response.results.profiles == "Duncan needs to do profiles output"
  end

  test "multifeature" do
    command = %Command{error?: false,
                       action: "query",
                       target: "features",
                       target_specifier: ["rate_limit", "profiles", "pairs"]
                       }
        |> DoQuery.do_cmd
    assert command.error? == false
    assert command.response.status == 200
    assert command.response.results.rate_limit == 100000
    assert command.response.results.profiles
    assert Enum.member?(command.response.results.pairs.query, :sbom)

  end



end
