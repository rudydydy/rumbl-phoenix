defmodule Rumbl.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Comeonin.Argon2, only: [hashpwsalt: 1]
  alias Rumbl.Account.User
  alias Rumbl.Movie.Video

  schema "users" do
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :username, :string

    has_many :videos, Video

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :username])
    |> validate_required([:name, :username])
    |> validate_length(:username, min: 1, max: 20)
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, ~w(password), [])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash
  end

  # defp put_pass_hash(changeset) do
  #   case changeset do
  #     %Ecto.Changeset{valid?: true, changes: %{ password: pass }} ->
  #       put_change(changeset, :password_hash, hashpwsalt(pass))
  #     _ ->
  #       changeset
  #   end
  # end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{ password: password }} = changeset) do
    put_change(changeset, :password_hash, hashpwsalt(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
