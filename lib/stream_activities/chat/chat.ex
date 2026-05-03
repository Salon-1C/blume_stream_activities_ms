defmodule StreamActivities.Chat do
  @moduledoc """
  Handles everything chat
  """

  import Ecto.Query
  alias StreamActivities.Repo
  alias StreamActivities.Chat.ChatMessage

  def create_message(attrs) do
    %ChatMessage{}
    |> ChatMessage.changeset(attrs)
    |> Repo.insert()
  end

  def get_stream_messages(stream_id) do
    from(m in ChatMessage,
      where: m.stream_id == ^stream_id,
      order_by: [asc: m.sent_at]
    )
    |> Repo.all()
  end
end
