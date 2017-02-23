defmodule TestStruct do
  use KitchenSink.StructEnum
  use KitchenSink.StructAccess

  defstruct [:name, :age]
end

defmodule TestStructNested do
  use KitchenSink.StructEnum
  use KitchenSink.StructAccess

  defstruct [:field1, :field2]
end
