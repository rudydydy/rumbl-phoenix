defmodule Rumbl.Repo.Migrations.UniqIndexVideoSlug do
  use Ecto.Migration

  def change do
    create unique_index(:videos, [:slug])
  end
end
