defmodule KitchenSink.Mixfile do
  use Mix.Project

  @moduledoc false

  @version "1.3.8"
  @repo_url "https://github.com/planswell/kitchen-sink"

  def project do
    [
      app: :kitchen_sink,
      version: @version,
      elixir: "~> 1.4",
      build_path: "_build",
      deps_path: "deps",
      lockfile: "mix.lock",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      # Hex
      package: hex_package(),
      description: "Mixins for Elixir namespaces and Misc utility functions",
      # Docs
      name: "KitchenSink",
      docs: [
        source_ref: "v#{@version}",
        main: "KitchenSink",
        source_url: @repo_url,
        extras: ["README.md", "CHANGELOG.md"],
      ],
      elixirc_paths: elixirc_paths(Mix.env),
      dialyzer: [ignore_warnings: "dialyzer.ignore-warnings", plt_add_deps: :transitive],
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  def application do
    [
      applications: [:logger]
    ]
  end

  defp hex_package do
    [
      maintainers: ["Olafur Arason", "Paul Iannazzo"],
      licenses: ["MIT"],
      links: %{"GitHub" => @repo_url}
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.0", only: [:dev, :test]},
      {:dialyxir, "~> 0.5.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.16", only: :dev}
    ]
  end
end
