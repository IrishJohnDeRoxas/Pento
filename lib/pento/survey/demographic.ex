defmodule Pento.Survey.Demographic do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pento.Accounts.User

  @education_levels [
    :"high school",
    :"bachelor's degree",
    :"graduate degree",
    :other,
    :"prefer not to say"
  ]

  schema "demographics" do
    field :gender, :string
    field :year_of_birth, :integer
    field :education_level, Ecto.Enum, values: @education_levels
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(demographic, attrs) do
    demographic
    |> cast(attrs, [:gender, :education_level, :year_of_birth, :user_id])
    |> validate_required([:gender, :education_level, :year_of_birth, :user_id])
    |> validate_inclusion(
      :gender,
      ["male", "female", "other", "prefer not to say"]
    )
    |> validate_inclusion(:year_of_birth, 1920..2025)
    |> validate_inclusion(:education_level, @education_levels)
    |> unique_constraint(:user_id)
  end

  def education_levels_options do
    Enum.map(@education_levels, fn education_level ->
      string_education_level = education_level |> Atom.to_string() |> String.capitalize()

      {string_education_level, education_level}
    end)
  end
end
