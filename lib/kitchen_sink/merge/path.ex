defmodule KitchenSink.Merge.Path do
  @doc """
  Merge keys from origin object into destination object. only values from the defined path get merged.
  The merge_key can be anything, it will be wrapped in a list to be used with the Access module
  """
  def path(destination_object, origin_object, merge_path) do
    merge_path = List.wrap(merge_path)
    merge_new_field = fn (_id, obj_to_update, update_obj) ->
      updated_field = get_in(update_obj, merge_path)
      put_in(obj_to_update, merge_path, updated_field)
    end

    Map.merge(destination_object, origin_object, merge_new_field)
  end
end
