defmodule StreamActivitiesWeb.StreamChannel do
  use Phoenix.Channel
  alias StreamActivities.Chat

  @impl true
  def join("stream:" <> stream_id, _params, socket) do
    messages = Chat.get_stream_messages(stream_id)

    {:ok, %{messages: messages}, assign(socket, :stream_id, stream_id)}
  end

  @impl true
  def handle_in("new_message", %{"message" => content}, socket) do
    broadcast!(socket, "new_message", %{
      sender_id: socket.assigns.user_id,
      username: socket.assigns.username,
      stream_id: socket.assigns.stream_id,
      message: content,
      sent_at: DateTime.utc_now()
    })
    {:reply, :ok, socket}
  end
end
