# Kitchen Sink

Module to make improvements to the Elixir Standard API. This module should follow Elixir guidelines, and we should consider everything in these files as able to be patched into mainstream Elixir. This is a good place to adopt APIs from other languages or frameworks (Ramda, Clojure, Elm, Haskell, etc...)

## Installation

This package [is available in Hex](https://hexdocs.pm/kitchen_sink/KitchenSink.html) and can be installed this way:

  1. Add `kitchen_sink` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:kitchen_sink, "~> 1.2.0"}]
    end
    ```

  2. Ensure `kitchen_sink` is started before your application:

    ```elixir
    def application do
      [applications: [:kitchen_sink]]
    end
    ```
