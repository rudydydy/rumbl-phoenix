defmodule Rumbl.Movie.Video do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Movie
  alias Rumbl.Movie.Video
  alias Rumbl.Account.User
  alias Rumbl.Genre.Category
  alias Rumbl.Comment.Annotation
  
  schema "videos" do
    field :description, :string
    field :title, :string
    field :url, :string
    field :slug, :string

    has_many :annotations, Annotation

    belongs_to :user, User
    belongs_to :category, Category

    timestamps()
  end

  @required_fields ~w(url title description)a
  @optional_fields ~w(category_id)a

  defimpl Phoenix.Param, for: Video do
    def to_param(%{slug: slug}), do: slug
  end

  @doc false
  def changeset(%Video{} = video, attrs \\ %{}) do
    video
    |> cast(attrs, (@required_fields ++ @optional_fields))
    |> validate_required(@required_fields)
    |> slugify_title()
    |> assoc_constraint(:category)
    |> unique_constraint(:slug)
  end

  defp slugify_title(changeset) do
    if title = get_change(changeset, :title) do
      slug_title = slugify(title) 
                   |> ensure_slug_is_uniq(title)

      put_change(changeset, :slug, slug_title)
    else
      changeset
    end
  end

  defp ensure_slug_is_uniq(slug, title, iteration \\ 1) do
    if Movie.get_video_by_slug(slug) do
      slug = slugify("#{title}-#{iteration}")
      ensure_slug_is_uniq(slug, title, iteration + 1)
    else
      slug
    end
  end

  defp slugify(str) do
    str
    |> String.downcase
    |> String.replace(~r/[^\w-]+/u, "-")
  end
end
