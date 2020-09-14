defmodule TwinklyMaha.Release do
  @moduledoc """
  Release tasks for the application

  We can call any of this code by calling the `eval` command e.g
  ```shell
  $ bin/twinkly_maha eval "TwinklyMaHa.Release.migrate"
  ```
  """
  @app :twinkly_maha

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
