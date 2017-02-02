defmodule KitchenSink.Merge do
  @moduledoc ""

  alias __MODULE__.Path

  defdelegate path(destination_object, origin_object, merge_path), to: Path
end
