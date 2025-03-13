defmodule Pento.Repo.Migrations.ConvertSkuIntToString do
  use Ecto.Migration

  def change do
    alter table(:products) do
      modify :sku, :string
    end
  end
end
