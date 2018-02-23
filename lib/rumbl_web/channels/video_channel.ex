
defmodule RumblWeb.VideoChannel do
  use RumblWeb, :channel

  def join("videos:" <> video_id, _payload, socket) do
    {:ok, socket}
  end

  def join("videos:" <> _video_id, _payload, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("ping", _payload, socket) do
    count = socket.assigns[:count] || 1 
    push socket, "ping", %{count: count}
    
    {:noreply, assign(socket, :count, count + 1)}
  end
end