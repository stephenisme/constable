defmodule Constable.CommentTest do
  use Constable.ModelCase
  alias Constable.Comment
  import GoodTimes

  test "when a comment is inserted, it updates the announcement last_discussed_at" do
    announcement = create_announcement_last_discussed(a_week_ago)

    comment = insert_comment_on_announcement(announcement)

    assert comment.announcement.last_discussed_at == comment.inserted_at
  end

  defp create_announcement_last_discussed(time_ago) do
    create(:announcement, last_discussed_at: Ecto.DateTime.cast!(time_ago))
  end

  defp insert_comment_on_announcement(announcement) do
    comment_params = %{
      announcement_id: announcement.id,
      body: "Anything",
      user_id: create(:user).id
    }

    Comment.changeset(:create, comment_params)
    |> Repo.insert!
    |> Repo.preload(:announcement)
  end
end
