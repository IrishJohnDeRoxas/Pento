defmodule Pento.Repo.Migrations.AddEducationLevelInDemographic do
  use Ecto.Migration

  def change do
    alter table(:demographics) do
      add :education_level, :string
    end
  end
end
