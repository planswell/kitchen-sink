defmodule TestStruct do
  use KitchenSink.StructEnum
  use KitchenSink.StructAccess

  defstruct [:name, :age]
end
