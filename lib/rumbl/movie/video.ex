defmodule Rumbl.Movie.Video do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Movie.Video
  alias Rumbl.Account.User
  alias Rumbl.Genre.Category

  schema "videos" do
    field :description, :string
    field :title, :string
    field :url, :string

    belongs_to :user, User
    belongs_to :category, Category

    timestamps()
  end

  @required_fields ~w(url title description)
  @optional_fields ~w(category_id)

  @doc false
  def changeset(%Video{} = video, attrs) do
    video
    |> cast(attrs, @required_fields, @optional_fields)
    |> assoc_constraint(:category)
  end
end
