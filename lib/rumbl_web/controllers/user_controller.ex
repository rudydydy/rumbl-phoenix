defmodule RumblWeb.UserController do
  use RumblWeb, :controller
  # import RumblWeb.Auth, only: [login: 2]
  alias Rumbl.Account
  alias Rumbl.Account.User

  plug :authenticate_user when action in [:index, :show, :edit, :update, :delete]
  plug :authorize_request when action in [:edit, :update, :delete]

  def index(conn, _params) do
    users = Account.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Account.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Account.create_user(user_params) do
      {:ok, user} ->
        conn
        |> login(user) # Auto login on create
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    changeset = Account.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Account.get_user!(id)

    case Account.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    {:ok, _user} = Account.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
  
  defp authorize_request(conn = %{ params: %{ "id" => id }, assigns: %{ current_user: %{ id: user_id } }}, _opts) do
    if String.to_integer(id) == user_id do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized")
      |> redirect(to: user_path(conn, :new))
      |> halt()
    end
  end 
end
