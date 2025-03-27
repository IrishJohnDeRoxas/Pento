defmodule Pento.Survey.Rating.Query do
  import Ecto.Query
  alias Pento.Survey.Rating

  def base do
    Rating
  end

  def preload_user(user) do
    base()
    |> for_user(user)
  end

  defp for_user(query, user) do
    query
    |> where([r], r.user_id == ^user.id)
  end

  def preload_product(product) do
    base()
    |> for_product(product)
  end

  defp for_product(query, product) do
    query
    |> where([r], r.product_id == ^product.id)
  end

  def rating_ids_for_product(product) do
    preload_product(product)
    |> select([r], r.id)
  end

  def ratings_by_ids(rating_ids) do
    base()
    |> where([r], r.id in ^rating_ids)
  end
end
