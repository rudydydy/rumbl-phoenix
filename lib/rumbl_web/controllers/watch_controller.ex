defmodule RumblWeb.WatchController do
  use RumblWeb, :controller

  alias Rumbl.Movie

  def show(conn, %{"id" => id}) do
    video = Movie.get_video_by_slug(id)
    render conn, "show.html", video: video
  end
end