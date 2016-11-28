defmodule KitchenSink.Mixfile do
  use Mix.Project

  @moduledoc false

  @version "0.0.16"
  @repo_url "https://github.com/planswell/kitchen-sink"

  def project do
    [
      app: :kitchen_sink,
      version: @version,
      elixir: "~> 1.3",
      build_path: "_build",
      deps_path: "deps",
      lockfile: "mix.lock",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
      # Hex
      package: hex_package,
      description: "Mixins for Elixir namespaces and Misc utility functions",
      # Docs
      name: "KitchenSink",
      docs: [source_ref: "v#{@version}", main: "KitchenSink", source_url: @repo_url,  extras: ["README.md"]],

      dialyzer: [plt_add_deps: :transitive],
    ]
  end

  def application do
    [
      applications: [:logger]
    ]
  end

  defp hex_package do
    [
      maintainers: ["Paul Iannazzo"],
      licenses: ["MIT"],
      links: %{"GitHub" => @repo_url}
    ]
  end

  defp deps do
    [
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:dialyxir, "~> 0.3.5", only: [:dev]},
      {:ex_doc, "~> 0.12", only: :dev}
    ]
  end
end
