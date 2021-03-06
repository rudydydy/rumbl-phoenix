defmodule Rumbl.Movie do
  @moduledoc """
  The Movie context.
  """

  import Ecto.Query, warn: false
  import Ecto
  alias Rumbl.Repo

  alias Rumbl.Movie.Video
  alias Rumbl.Account.User

  @doc """
  Returns the list of videos.

  ## Examples

      iex> list_videos()
      [%Video{}, ...]

  """
  def list_videos(%User{} = user) do
    user
    |> assoc(:videos)
    |> Repo.all
    |> Repo.preload(:category)
  end

  @doc """
  Gets a single video.

  Raises `Ecto.NoResultsError` if the Video does not exist.

  ## Examples

      iex> get_video!(123)
      %Video{}

      iex> get_video!(456)
      ** (Ecto.NoResultsError)

  """
  def get_video!(%User{} = user, id) do
    user
    |> assoc(:videos)
    |> Repo.get_by!(slug: id)
  end

  def get_video!(id) do
    Repo.get!(Video, id)
  end

  @doc """
  Gets a single video by slug attribute.

  ## Examples

      iex> get_video_by_slug("apple")
      %Video{}

      iex> get_video_by_slug("apple")
      nil

  """
  def get_video_by_slug(slug) do
    Repo.get_by(Video, slug: slug)
  end

  @doc """
  Creates a video.

  ## Examples

      iex> create_video(%{field: value})
      {:ok, %Video{}}

      iex> create_video(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_video(%User{} = user, attrs \\ %{}) do
    user
    |> build_assoc(:videos)
    |> Video.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a video.

  ## Examples

      iex> update_video(video, %{field: new_value})
      {:ok, %Video{}}

      iex> update_video(video, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_video(%Video{} = video, attrs) do
    video
    |> Video.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Video.

  ## Examples

      iex> delete_video(video)
      {:ok, %Video{}}

      iex> delete_video(video)
      {:error, %Ecto.Changeset{}}

  """
  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking video changes.

  ## Examples

      iex> change_video(video)
      %Ecto.Changeset{source: %Video{}}

  """
  def change_video(%User{} = user) do
    user
    |> build_assoc(:videos)
    |> Video.changeset(%{})
  end

  def change_video(%Video{} = video) do
    Video.changeset(video, %{})
  end
end
