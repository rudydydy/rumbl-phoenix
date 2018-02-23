defmodule Rumbl.Comment.Annotation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Comment.Annotation
  alias Rumbl.Account.User
  alias Rumbl.Movie.Video
  
  schema "annotations" do
    field :at, :integer
    field :body, :string
    
    belongs_to :user, User
    belongs_to :video, Video

    timestamps()
  end

  @required_fields ~w(body at video_id)a

  @doc false
  def changeset(%Annotation{} = annotation, attrs) do
    annotation
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
