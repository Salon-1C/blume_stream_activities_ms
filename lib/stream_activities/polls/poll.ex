defmodule StreamActivities.Polls.Poll do
  @moduledoc false

  import Ecto.Query
  alias StreamActivities.Repo
  alias StreamActivities.Polls.Polls

  def create_poll(attrs) do
    result = %Polls{}
             |> Polls.changeset(attrs)
             |> Repo.insert()
    result
  end
end

