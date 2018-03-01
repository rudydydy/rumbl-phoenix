# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Rumbl.Repo.insert!(%Rumbl.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Rumbl.Genre

for category <- ~w(Action Drama Romance Comedy Sci-fi) do
  Genre.get_category_by_name(category) || Genre.create_category(%{ name: category })
end

Rumbl.Repo.insert!(%Rumbl.Account.User{name: "Wolfram", username: "wolfram"})