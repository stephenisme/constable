defmodule Constable.Factories do
  use ExMachina.Ecto, repo: Constable.Repo

  factory :email_reply_message do
    %{
      text: "My email reply",
      from_email: sequence(:email, &"test#{&1}@thoughtbot.com"),
      email: "constable-fakekey@thoughtbot.com"
    }
  end

  factory :email_reply_event do
    %{
      event: "inbound",
      msg: build(:email_reply_message)
    }
  end

  factory :email_reply_webhook do
    %{
      mandrill_events: [build(:email_reply_event)]
    }
  end

  factory :interest do
    %Constable.Interest{
      name: sequence(:interest_name, &"interest-#{&1}")
    }
  end

  factory :user do
    %Constable.User{
      username: "myusername",
      name: "Gumbo",
      email: sequence(:email, &"test#{&1}@thoughtbot.com"),
      daily_digest: true,
      auto_subscribe: false
    }
  end

  factory :announcement do
    %Constable.Announcement{
      title: sequence(:email, &"Post Title#{&1}"),
      body: "Post Body",
      user: assoc(:user)
    }
  end

  factory :announcement_params do
    %{
      title: "Title",
      body: "Body",
      user_id: nil
    }
  end

  factory :announcement_interest do
    %Constable.AnnouncementInterest{
      announcement: assoc(:announcement),
      interest: assoc(:interest)
    }
  end

  factory :comment do
    %Constable.Comment{
      body: "Post Body",
      user: assoc(:user),
      announcement: assoc(:announcement)
    }
  end

  factory :subscription do
    %Constable.Subscription{
      user: assoc(:user),
      announcement: assoc(:announcement)
    }
  end

  factory :user_interest do
    %Constable.UserInterest{
      user: assoc(:user),
      interest: assoc(:interest)
    }
  end

  def tag_with_interest(announcement, interest) do
    create(:announcement_interest, announcement: announcement, interest:
    interest).announcement
  end

  def with_comment(announcement) do
    create(:comment, announcement: announcement).announcement
  end

  def with_interest(user, interest \\ create(:interest)) do
    create(:user_interest, user: user, interest: interest).user
  end

  def with_subscription(user, announcement \\ create(:announcement)) do
    create(:subscription, user: user, announcement: announcement).user
  end

  def with_subscriber(announcement, user) do
    create(:subscription, announcement: announcement, user: user)
    |> Map.fetch!(:announcement)
  end
end
