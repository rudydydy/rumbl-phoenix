ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Rumbl.Repo, :manual)

defmodule Rumbl.TestHelpers do
  alias Rumbl.Repo

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(%{
      name: "Some User",
      username: "user#{Base.encode16(:crypto.strong_rand_bytes(8))}",
      password: "supersecret"
    }, attrs)

    %Rumbl.Account.User{}
    |> Rumbl.Account.User.registration_changeset(changes)
    |> Repo.insert!
  end

  def insert_video(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:videos, attrs)
    |> Repo.insert!
  end
end