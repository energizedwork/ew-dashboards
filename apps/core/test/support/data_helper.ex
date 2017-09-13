defmodule Core.DataHelper do
  alias Core.Schemas.{
    Author,
    Dashboard,
    DataSource,
    Widget
  }

  def generate_author do
    %Author{}
    |> Author.changeset(%{username: "bob-dobbs"})
    |> Core.Repo.insert!()
  end

  def generate_widget(author) do
    %Widget{}
    |> Widget.changeset(%{name: "Widget 1", author_id: author.id})
    |> Core.Repo.insert!()
  end

  def generate_dashboard(author) do
    %Dashboard{}
    |> Dashboard.changeset(%{name: "Dashboard 1", slug: "dashboar-1", author_id: author.id})
    |> Core.Repo.insert!()
  end

  def generate_data_source do
    %DataSource{}
    |> DataSource.changeset(%{name: "Data Source 1"})
    |> Core.Repo.insert!()
  end

end
