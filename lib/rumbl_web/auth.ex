defmodule RumblWeb.Auth do
  import Plug.Conn
  import Comeonin.Argon2, only: [checkpw: 2, dummy_checkpw: 0]
  import Phoenix.Controller
  alias Rumbl.Account
  alias RumblWeb.Router.Helpers

  def init(_opts) do
    # Keyword.fetch!(opts, :repo)
  end

  def call(conn, _repo) do
    user_id = get_session(conn, :user_id)
    user = user_id && Account.get_user!(user_id)
    assign(conn, :current_user, user)
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true) # protect from attacker
  end

  def login_by_username_and_pass(conn, username, given_pass, _opts) do
    # repo = Keyword.fetch!(opts, :repo)
    user = Account.get_user_by_username(username)
    cond do
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        # When a user isn’t found, we use comeonin’s dummy_checkpw()
        # function to simulate a password check with
        # variable timing. This hardens our authentication layer against timing attacks,
        # which is crucial to keeping our application secure.
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Helpers.page_path(conn, :index))
      |> halt()
    end
  end
end