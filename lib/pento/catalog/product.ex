defmodule Pento.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pento.Catalog.Product

  schema "products" do
    field :name, :string
    field :description, :string
    field :unit_price, :float
    field :sku, :string
    field :image_upload, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku, :image_upload])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> unique_constraint(:sku)
    |> validate_length(:sku, min: 7)
    |> validate_number(:unit_price, greater_than: 0.0)
  end

  @doc false
  def unit_price_changeset(%Product{} = product, attrs) do
    product
    |> cast(attrs, [:unit_price])
    |> validate_required([:unit_price])
    |> validate_number(:unit_price,
      less_than: product.unit_price
    )
  end
end
