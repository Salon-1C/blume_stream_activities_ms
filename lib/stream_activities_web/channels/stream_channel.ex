defmodule StreamActivitiesWeb.StreamChannel do
  use Phoenix.Channel
  alias StreamActivities.Chat

  @impl true
  def join("stream:" <> stream_id, _params, socket) do
    messages = Chat.get_stream_messages(stream_id)
               |> Enum.map(fn m -> %{
                                     id: m.id,
                                     sender_id: m.sender_id,
                                     username: m.username,
                                     message: m.message,
                                     sent_at: m.inserted_at
                                   } end)
    IO.inspect(messages, label: "MESSAGES")
    {:ok, %{messages: messages}, assign(socket, :stream_id, stream_id)}
  end

  @impl true
  def handle_in("new_message", %{"message" => content}, socket) do
    attrs = %{
      sender_id: socket.assigns.user_id,
      username: socket.assigns.username,
      stream_id: socket.assigns.stream_id,
      message: content,
      sent_at: DateTime.utc_now()
    }

    case Chat.create_message(attrs) do
      {:ok, message} ->
        broadcast!(socket, "new_message", %{
          sender_id: message.sender_id,
          username: message.username,
          stream_id: message.stream_id,
          message: message.message,
          sent_at: message.inserted_at
        })
        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset.errors}}, socket}
    end
  end
end
