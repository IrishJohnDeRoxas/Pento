defmodule Pento.Catalog do
  @moduledoc """
  The Catalog context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Pento.Repo
  alias Pento.Catalog.Product
  alias Pento.Survey.Rating

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product)
  end

  def list_products_with_user_rating(user) do
    Product.Query.with_user_ratings(user)
    |> Repo.all()
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id)

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Multi.new()
    |> Multi.run(:rating_ids, fn _repo, _changes ->
      rating_ids =
        Rating.Query.rating_ids_for_product(product)
        |> Repo.all()

      {:ok, rating_ids}
    end)
    |> Multi.delete_all(:ratings, fn %{rating_ids: rating_ids} ->
      Rating.Query.ratings_by_ids(rating_ids)
    end)
    |> Multi.delete(:product, product)
    |> Repo.transaction()
  end

  @doc """
  Marks down a product unit price.

  ## Examples

      iex> markdown_product(product, %{unit_price: lower_value})
      {:ok, %Product{}}

      iex> markdown_product(product, %{unit_price: greater_than_value})
      {:error, %Ecto.Changeset{}}

  """
  def markdown_product(%Product{} = product, attrs) do
    product
    |> Product.unit_price_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product unit price changes.

  ## Examples

      iex> change_product_unit_price(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product_unit_price(%Product{} = product, attrs \\ %{}) do
    Product.unit_price_changeset(product, attrs)
  end

  def products_with_average_ratings do
    Product.Query.with_average_ratings()
    |> Repo.all()
  end

  def products_with_average_ratings(%{
        age_group_filter: age_group_filter,
        gender_filter: gender_filter
      }) do
    Product.Query.with_average_ratings()
    |> Product.Query.join_users()
    |> Product.Query.join_demographics()
    |> Product.Query.filter_by_age_group(age_group_filter)
    |> Product.Query.filter_by_gender(gender_filter)
    |> Repo.all()
  end

  def products_with_zero_ratings do
    Product.Query.with_zero_ratings()
    |> Repo.all()
  end
end
