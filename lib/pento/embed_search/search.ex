defmodule Pento.Search.EmbedSearch do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key false

  embedded_schema do
    field :sku, :integer
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:sku])
    |> validate_required([:sku])
    |> validate_min_number_length(:sku, 7)
  end

  def validate_min_number_length(changeset, field, min_length) do
    case get_field(changeset, field) do
      nil ->
        # Or handle nil values differently
        changeset

      value when is_integer(value) ->
        value_string = Integer.to_string(value)

        if String.length(value_string) >= min_length do
          changeset
        else
          add_error(changeset, field, "must be at least #{min_length} digits long")
        end

      _ ->
        add_error(changeset, field, "must be a number")
    end
  end
end
