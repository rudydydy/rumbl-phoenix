defmodule Rumbl.GenreTest do
  use Rumbl.DataCase

  alias Rumbl.Genre

  describe "categories" do
    alias Rumbl.Genre.Category

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Genre.create_category()

      category
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Enum.map(Genre.list_categories(), &(&1.id)) == Enum.map([category], &(&1.id))
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Genre.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = Genre.create_category(@valid_attrs)
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Genre.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, category} = Genre.update_category(category, @update_attrs)
      assert %Category{} = category
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Genre.update_category(category, @invalid_attrs)
      assert category == Genre.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Genre.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Genre.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Genre.change_category(category)
    end
  end
end
