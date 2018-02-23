defmodule Rumbl.CommentTest do
  use Rumbl.DataCase

  alias Rumbl.Comment

  describe "annotations" do
    alias Rumbl.Comment.Annotation

    @valid_attrs %{at: 42, body: "some body"}
    @update_attrs %{at: 43, body: "some updated body"}
    @invalid_attrs %{at: nil, body: nil}

    def annotation_fixture(attrs \\ %{}) do
      {:ok, annotation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Comment.create_annotation()

      annotation
    end

    test "list_annotations/0 returns all annotations" do
      annotation = annotation_fixture()
      assert Comment.list_annotations() == [annotation]
    end

    test "get_annotation!/1 returns the annotation with given id" do
      annotation = annotation_fixture()
      assert Comment.get_annotation!(annotation.id) == annotation
    end

    test "create_annotation/1 with valid data creates a annotation" do
      assert {:ok, %Annotation{} = annotation} = Comment.create_annotation(@valid_attrs)
      assert annotation.at == 42
      assert annotation.body == "some body"
    end

    test "create_annotation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Comment.create_annotation(@invalid_attrs)
    end

    test "update_annotation/2 with valid data updates the annotation" do
      annotation = annotation_fixture()
      assert {:ok, annotation} = Comment.update_annotation(annotation, @update_attrs)
      assert %Annotation{} = annotation
      assert annotation.at == 43
      assert annotation.body == "some updated body"
    end

    test "update_annotation/2 with invalid data returns error changeset" do
      annotation = annotation_fixture()
      assert {:error, %Ecto.Changeset{}} = Comment.update_annotation(annotation, @invalid_attrs)
      assert annotation == Comment.get_annotation!(annotation.id)
    end

    test "delete_annotation/1 deletes the annotation" do
      annotation = annotation_fixture()
      assert {:ok, %Annotation{}} = Comment.delete_annotation(annotation)
      assert_raise Ecto.NoResultsError, fn -> Comment.get_annotation!(annotation.id) end
    end

    test "change_annotation/1 returns a annotation changeset" do
      annotation = annotation_fixture()
      assert %Ecto.Changeset{} = Comment.change_annotation(annotation)
    end
  end
end
