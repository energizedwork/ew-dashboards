defmodule Core.Data.AuthorTest do
  use Core.DataCase

  setup do
    :ok
  end

  alias Core.Data.Author

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
    assert {:ok, deleted} = Author.delete(author.id)
    assert deleted.deleted
    assert deleted.deleted_at
    assert [deleted] == Author.all()
  end

end
