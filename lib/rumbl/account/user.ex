defmodule Rumbl.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Account.User


  schema "users" do
    field :name, :string
    field :password, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :username, :password])
    |> validate_required([:name, :username, :password])
  end
end
