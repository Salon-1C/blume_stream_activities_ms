defmodule StreamActivitiesWeb.UserSocket do
  use Phoenix.Socket

  channel "stream:*", StreamActivitiesWeb.StreamChannel

  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    case verify_jwt(token) do
      {:ok, user_id} ->
        {:ok, assign(socket, :user_id, user_id)}
      {:error, _reason} ->
        :error
    end
  end

  # if no token is provided at all, reject the connection
  def connect(_params, _socket, _connect_info) do
    :error
  end

  @impl true
  def id(socket), do: "user_socket:#{socket.assigns.user_id}"

  defp verify_jwt(token) do
    # placeholder until you integrate Joken
    # for now just extract the user_id so you can test
    case token do
      nil -> {:error, :missing_token}
      _   -> {:ok, token}  # temporarily treat the token as the user_id
    end
  end
end
