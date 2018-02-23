
defmodule RumblWeb.VideoChannel do
  use RumblWeb, :channel

  def join("videos:" <> video_id, _payload, socket) do
    {:ok, socket}
  end

  def join("videos:" <> _video_id, _payload, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_annotation", %{"body" => body, "at" => at}, socket) do
    broadcast! socket, "new_annotation", %{
      user: %{username: "anon"},
      body: body,
      at: at
    }
    {:reply, :ok, socket}
  end
end