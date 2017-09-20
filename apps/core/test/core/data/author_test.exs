defmodule Core.Data.AuthorTest do
  use Core.DataCase

  setup do
    :ok
  end

  alias Core.Data.Author

  test "get an author by id" do
    assert {:ok, author} = Author.upsert(%{"username" => "bob-dobbs"})
    assert {:ok, author} == Author.get(author.id)
  end

  test "create a new author with valid params" do
    assert [] = Author.all()
    assert {:ok, author} = Author.upsert(%{"username" => "bob-dobbs"})
    assert [author] == Author.all()
  end

  test "edit an existing author with valid params" do
    assert [] = Author.all()
    {:ok, author} = Author.upsert(%{"username" => "bob-dobbs"})
    refute author.image_src
    assert {:ok, updated} = Author.upsert(%{"id" => author.id, "image_src" => "test-image-src"})
    assert updated.id == author.id
    assert updated.username == author.username
    assert updated.image_src == "test-image-src"
    assert [updated] == Author.all()
  end

  test "delete an existing author" do
    {:ok, author} = Author.upsert(%{"username" => "bob-dobbs"})
    refute author.deleted
    refute author.deleted_at
    assert :ok = Author.delete(author.id)
    assert [] = Author.all()
  end

  test "get an author with bad id" do
    assert {:error, "Invalid :binary_id with value \"1\""} = Author.delete("1")
  end

  test "delete an author with bad id" do
    assert {:error, "Invalid :binary_id with value \"1\""} = Author.delete("1")
  end
end
