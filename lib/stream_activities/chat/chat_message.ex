defmodule StreamActivities.Chat.ChatMessage do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "chat_messages" do
    field :sender_id, :string
    field :username, :string
    field :stream_id, :string
    field :message, :string

    timestamps()
    end

    def changeset(chat_message, attrs) do
      chat_message
      |> cast(attrs, [:sender_id, :stream_id, :message, :username])
      |> validate_required([:sender_id, :stream_id, :message, :username])
    end
end
