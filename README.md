# Planswell.Extensions

Module to make improvements to the Elixir API without actually having to fork or deal with the Elixir Devs. This module should follow Elixir guidelines, and we should consider everything in these files as able to be patched into mainstream Elixir. This is a good place to adopt APIs from other languages or frameworks (Ramda, Clojure, Elm, Haskell, etc...)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `extensions` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:extensions, "~> 0.1.0"}]
    end
    ```

  2. Ensure `extensions` is started before your application:

    ```elixir
    def application do
      [applications: [:extensions]]
    end
    ```

