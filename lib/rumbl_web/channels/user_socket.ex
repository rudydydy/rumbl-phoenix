defmodule RumblWeb.UserSocket do
  use Phoenix.Socket

  # 2 week
  @max_age 2 * 7 * 24 * 60 * 60

  ## Channels
  channel "videos:*", RumblWeb.VideoChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "user socket", token, max_age: @max_age) do
      {:ok, user_id} ->
        {:ok, assign(socket, :user_id, user_id)}
      {:error, _reaason} ->
        :error
    end
  end

  def connect(_params, _socket), do: :error

  def id(%{ assigns: %{ user_id: user_id }}), do: "users_socket:#{user_id}"
end
