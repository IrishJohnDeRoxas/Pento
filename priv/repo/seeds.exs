# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pento.Repo.insert!(%Pento.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Pento.Catalog

products = [
  %{
    name: "Chess",
    description: "The classic strategy game",
    sku: "5_678_910",
    unit_price: 10.00
  },
  %{
    name: "Tic-Tac-Toe",
    description: "The game of Xs and Os",
    sku: "11_121_314",
    unit_price: 3.00
  },
  %{
    name: "Table Tennis",
    description: "Bat the ball back and forth. Don't miss!",
    sku: "15_222_324",
    unit_price: 12.00
  }
]

Enum.each(products, fn product ->
  Catalog.create_product(product)
end)

import Ecto.Query
alias Pento.Accounts.User
alias Pento.Catalog.Product
alias Pento.{Repo, Accounts, Survey}

for i <- 1..6 do
  Accounts.register_user(%{
    email: "user#{i}@example.com",
    password: "userpassword#{i}"
  })
  |> IO.inspect()
end

user_ids = Repo.all(from u in User, select: u.id)
product_ids = Repo.all(from p in Product, select: p.id)
genders = ["female", "male", "other", "prefer not to say"]

education_level = [
  :"high school",
  :"bachelor's degree",
  :"graduate degree",
  :other,
  :"prefer not to say"
]

years = 1920..2025
stars = 1..5

for uid <- user_ids do
  Survey.create_demographic(%{
    user_id: uid,
    gender: Enum.random(genders),
    education_level: Enum.random(education_level),
    year_of_birth: Enum.random(years)
  })
end

for uid <- user_ids, pid <- product_ids do
  Survey.create_rating(%{
    user_id: uid,
    product_id: pid,
    stars: Enum.random(stars)
  })
end

admin = %{
  role: :admin,
  email: "email@email.com",
  password: "password"
}

Accounts.register_user(admin)
