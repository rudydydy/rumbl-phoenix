defmodule Rumbl.Genre.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Genre.Category
  alias Rumbl.Movie.Video

  schema "categories" do
    field :name, :string
    field :video_count, :integer, virtual: true, default: 0
    has_many :videos, Video, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
