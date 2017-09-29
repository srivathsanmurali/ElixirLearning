
defmodule Discuss.TopicController do
  use Discuss.Web, :controller
  alias Discuss.Topic

  plug Discuss.Plugs.RequireAuth
    when action in [:new, :create, :edit, :update, :delete]

  plug :check_topic_owner when action in [:update, :edit, :delete]

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def show(conn, %{"id" => topic_id}) do
    case Repo.get(Topic, topic_id) do
      nil ->
        conn
        |> put_flash(:error, "Topic not found")
        |> redirect(to: topic_path(conn, :index))
      topic ->
        render conn, "show.html", topic: topic
    end
  end

  @doc """
    handles new topic get request.

    => Shows the new topic form
  """
  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    changeset =
      conn.assigns.user
      |> build_assoc(:topics)
      |> Topic.changeset(topic)
    
    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: topic_path(conn, :index))
      
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    case Repo.get(Topic, topic_id) do
      nil ->
        conn
        |> put_flash(:error, "Topic not found")
        |> redirect(to: topic_path(conn, :index))
      topic ->
        changeset = Topic.changeset(topic, %{})
        render conn, "edit.html", changeset: changeset, topic: topic
    end
  end

  def update(conn, %{"topic" => topic, "id" => topic_id}) do
    old_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)
    
    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Edited")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, topic: old_topic
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    case Repo.get(Topic, topic_id) do
      nil ->
        conn
        |> put_flash(:error, "Topic not found")
        |> redirect(to: topic_path(conn, :index))
      topic ->
        Repo.delete!(topic)
        conn
        |> put_flash(:info, "Topic Deleted")
        |> redirect(to: topic_path(conn, :index))
    end
  end

  def check_topic_owner(%{params: %{"id" => topic_id}} = conn, _params) do
    if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You can't edit that")
      |> redirect(to: topic_path(conn, :index))
      |> halt()
     
    end
  end
end
