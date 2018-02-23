
defmodule RumblWeb.VideoChannel do
  use RumblWeb, :channel

  alias Rumbl.Account
  alias Rumbl.Movie
  alias Rumbl.Comment
  alias RumblWeb.UserView
  alias RumblWeb.AnnotationView
  
  def join("videos:" <> video_id, payload, socket) do
    last_seen_id = payload["last_seen_id"] || 0
    video_id = String.to_integer(video_id)
    video = Movie.get_video!(video_id)
    annotations = Comment.list_annotations(video, last_seen_id)
    
    resp = %{annotations: Phoenix.View.render_many(annotations, AnnotationView, "annotation.json")}

    {:ok, resp, assign(socket, :video_id, video_id)}
  end

  def handle_in(event, payload, socket = %{ assigns: %{ user_id: user_id }}) do
    user = user_id && Account.get_user!(user_id)
    handle_in(event, payload, user, socket)
  end

  def handle_in("new_annotation", %{"body" => body, "at" => at}, user, socket = %{ assigns: %{ video_id: video_id }}) do
    case Comment.create_annotation(user, %{body: body, at: at, video_id: video_id}) do
      {:ok, comment} ->
        broadcast! socket, "new_annotation", %{
          id: comment.id,
          user: UserView.render("user.json", %{user: user}),
          body: comment.body,
          at: comment.at
        }
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end