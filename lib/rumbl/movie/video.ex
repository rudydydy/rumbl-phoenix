defmodule Rumbl.Movie.Video do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Movie.Video
  alias Rumbl.Account.User

  schema "videos" do
    field :description, :string
    field :title, :string
    field :url, :string
    
    belongs_to :user, User

    timestamps()
  end

  @required_fields ~w(url title description)
  @optional_fields ~w()

  @doc false
  def changeset(%Video{} = video, attrs) do
    video
    |> cast(attrs, @required_fields, @optional_fields)
    |> validate_required([:url, :title, :description])
  end
end
