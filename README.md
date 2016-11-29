# Kitchen Sink

Module to make improvements to the Elixir Standard API. This module should follow Elixir guidelines, and we should consider everything in these files as able to be patched into mainstream Elixir. This is a good place to adopt APIs from other languages or frameworks (Ramda, Clojure, Elm, Haskell, etc...)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `kitchen_sink` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:kitchen_sink, "~> 0.0.17"}]
    end
    ```

  2. Ensure `kitchen_sink` is started before your application:

    ```elixir
    def application do
      [applications: [:kitchen_sink]]
    end
    ```

