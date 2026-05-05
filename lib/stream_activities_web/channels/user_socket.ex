defmodule StreamActivitiesWeb.UserSocket do
  use Phoenix.Socket

  channel "stream:*", StreamActivitiesWeb.StreamChannel

  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    case verify_jwt(token) do
      {:ok, user_id, username} ->
        {:ok, socket
         |> assign(:user_id, user_id) |> assign(:username, username)}
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
    secret = Application.fetch_env!(:stream_activities, :jwt_secret)
    signer = Joken.Signer.create("HS256", secret)

    case Joken.verify(token, signer) do
      {:ok, claims} ->
        IO.inspect(claims, label: "CLAIMS")
        user_id = claims["userId"]
        username = claims["username"]
        {:ok, user_id, username}
      {:error, reason} ->
        IO.inspect(reason, label: "JWT ERROR")  # add this
        {:error, reason}
    end
  end
end
