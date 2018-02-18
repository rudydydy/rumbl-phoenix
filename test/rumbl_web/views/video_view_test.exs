defmodule RumblWeb.VideoViewTest do
  use RumblWeb.ConnCase, async: true
  import Phoenix.View

  test "renders index.html", %{conn: conn} do
    videos = [
      %Rumbl.Movie.Video{id: 1, title: "dogs", category: %Rumbl.Genre.Category{id: 1, name: "Pets"}},
      %Rumbl.Movie.Video{id: 2, title: "cats", category: nil}
    ]

    content = render_to_string(RumblWeb.VideoView, "index.html", conn: conn, videos: videos)

    assert String.contains?(content, "Listing Videos")
    for video <- videos do
      assert String.contains?(content, video.title)
    end
  end

  test "renders new.html", %{conn: conn} do
    changeset = Rumbl.Movie.Video.changeset(%Rumbl.Movie.Video{})
    categories = [{"cats", 123}]

    content = render_to_string(RumblWeb.VideoView, "new.html", conn: conn, changeset: changeset, categories: categories)

    assert String.contains?(content, "New Video")
  end

end