defmodule Oc2.DoQueryFeatures do
  @moduledoc """
  Documentation for `Query features` contains helper functions for
  blah blah
  """

  require Logger

  @doc """
  return_features returns feature query results
     (or error)
  """
  def return_features(%Oc2.Command{action: "query",
                      target: "features",
                      target_specifier: ts
                      } = command) when is_list(ts) do
    get_features(command, ts)
  end
  def return_features(command) do
    Logger.debug("return_features #{inspect(command)}")
    Oc2.Command.return_error("invalid target specifier")
  end

  defp get_features(command, []) do
    ## empty feature list, return ok
    %Oc2.Command{command | response: %{status: 200}}
  end
  defp get_features(command, features)
          when is_list(features) do
    ## iterate thru list
    output = %{status: 200, results: %{}}
    case iterate_features(output,features) do
      {:ok, result} ->
        ## respond with answer
        %Oc2.Command{command | response: result}
      _ ->
        ## oops occurred on format
        Logger.debug "get_features error"
        error_msg = "invalid features"
        Oc2.Command.return_error(error_msg)
    end
  end

  defp iterate_features(output,[]) do
    ## done
    {:ok, output}
  end
  defp iterate_features(output,[head | tail]) do
    ## iterate thru feature list adding results
    old_results = output[:results]
    case head do
      "versions" ->
        Logger.debug "iterate_features - versions"
        ver = "0.5.2"
        new_results = Map.put(old_results, :versions, [ver])
        new_output = Map.replace!(output, :results, new_results)
        ## now iterate again
        iterate_features(new_output,tail)
      "profiles" ->
        Logger.debug "iterate_features - profiles"
        profileout = "Duncan needs to do profiles output"
        new_results = Map.put(old_results, :profiles, profileout)
        new_output = Map.replace!(output, :results, new_results)
        ## now iterate again
        iterate_features(new_output,tail)
      "pairs" ->
        Logger.debug "iterate_features - pairs"
        pairsout = %{
          query: [
            :features,
            :sbom,
            :"x-sfractal-blinky:hello_world"
            ],
          set: [
            :"x-sfractal-blinky:led",
            :"x-sfractal-blinky:buzzer",
            :"x-sfractal-blinky:valve",
            :"x-sfractal-blinky:spa_key"
            ],
           allow: [
            :ipv4_net,
            :ipv6_net
            ],
           cancel: [:command_id]
        }
        new_results = Map.put(old_results, :pairs, pairsout)
        new_output = Map.replace!(output, :results, new_results)
        ## now iterate again
        iterate_features(new_output,tail)
      "rate_limit" ->
        rate_limit = 100000
        new_results = Map.put(old_results, :rate_limit, rate_limit)
        new_output = Map.replace!(output, :results, new_results)
        ## now iterate again
        iterate_features(new_output,tail)
      _ ->
        Logger.debug "iterate_features - unknown feature"
        {:error, "unknown feature"}
    end
  end




end
