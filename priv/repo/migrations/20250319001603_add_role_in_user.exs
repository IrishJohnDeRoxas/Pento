defmodule Pento.Repo.Migrations.AddRoleInUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :role, :string
    end
  end
end
