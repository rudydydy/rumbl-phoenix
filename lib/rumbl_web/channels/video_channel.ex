
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
      {:ok, annotation} ->
        broadcast_annotation(socket, annotation)
        Task.start_link(fn -> compute_additional_info(annotation, socket) end)
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  defp broadcast_annotation(socket, annotation) do
    annotation = Comment.get_annotation_user(annotation)
    rendered_ann = Phoenix.View.render(AnnotationView, "annotation.json", %{
      annotation: annotation
    })
    broadcast! socket, "new_annotation", rendered_ann
  end

  defp compute_additional_info(ann, socket) do
    for result <- Rumbl.InfoSys.compute(ann.body, limit: 1, timeout: 10_000) do
      attrs = %{url: result.url, body: result.text, at: ann.at, video_id: ann.video_id}
      case Comment.create_worlfram_feedback(result.backend, attrs) do
        {:ok, info_ann} -> broadcast_annotation(socket, info_ann)
        {:error, _changeset} -> :ignore
      end
    end
  end
end