defmodule Pento.Search do
  alias Pento.Search.EmbedSearch

  @doc false
  def search_by_sku(%EmbedSearch{} = search, attrs) do
    changeset = EmbedSearch.changeset(search, attrs)

    case changeset.valid? do
      true -> {:ok, %EmbedSearch{}}
      false -> {:error, %EmbedSearch{}}
    end
  end

  @doc false
  def change_embed_search(%EmbedSearch{} = search, attrs \\ %{}) do
    EmbedSearch.changeset(search, attrs)
  end
end
