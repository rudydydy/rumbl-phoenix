defmodule Rumbl.Comment do
  @moduledoc """
  The Comment context.
  """

  import Ecto.Query, warn: false
  import Ecto
  alias Rumbl.Repo

  alias Rumbl.Comment.Annotation
  alias Rumbl.Movie.Video
  alias Rumbl.Account
  alias Rumbl.Account.User

  @doc """
  Returns the list of annotations.

  ## Examples

      iex> list_annotations()
      [%Annotation{}, ...]

  """
  def list_annotations do
    Repo.all(Annotation)
  end

  def list_annotations(%Video{} = video, last_seen_id) do
    query = from(
      a in assoc(video, :annotations),
      where: a.id > ^last_seen_id,
      order_by: [asc: a.at, asc: a.id],
      limit: 200,
      preload: [:user]
    )
    
    Repo.all(query)
  end

  @doc """
  Gets a single annotation.

  Raises `Ecto.NoResultsError` if the Annotation does not exist.

  ## Examples

      iex> get_annotation!(123)
      %Annotation{}

      iex> get_annotation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_annotation!(id), do: Repo.get!(Annotation, id)

  def get_annotation_user(annotation), do: Repo.preload(annotation, :user)

  @doc """
  Creates a annotation.

  ## Examples

      iex> create_annotation(%{field: value})
      {:ok, %Annotation{}}

      iex> create_annotation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_annotation(%User{} = user, attrs \\ %{}) do
    user
    |> build_assoc(:annotations)
    |> Annotation.changeset(attrs)
    |> Repo.insert
  end

  def create_worlfram_feedback("wolfram", attrs \\ %{}) do
    Account.get_user_by_username("wolfram")
    |> build_assoc(:annotations)
    |> Rumbl.Annotation.changeset(attrs)
    |> Repo.insert
  end

  @doc """
  Updates a annotation.

  ## Examples

      iex> update_annotation(annotation, %{field: new_value})
      {:ok, %Annotation{}}

      iex> update_annotation(annotation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_annotation(%Annotation{} = annotation, attrs) do
    annotation
    |> Annotation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Annotation.

  ## Examples

      iex> delete_annotation(annotation)
      {:ok, %Annotation{}}

      iex> delete_annotation(annotation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_annotation(%Annotation{} = annotation) do
    Repo.delete(annotation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking annotation changes.

  ## Examples

      iex> change_annotation(annotation)
      %Ecto.Changeset{source: %Annotation{}}

  """
  def change_annotation(%Annotation{} = annotation) do
    Annotation.changeset(annotation, %{})
  end
end
