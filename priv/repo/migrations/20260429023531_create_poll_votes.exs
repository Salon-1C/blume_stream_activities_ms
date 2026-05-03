defmodule StreamActivities.Repo.Migrations.CreatePollVotes do
  use Ecto.Migration

  def change do
    create table(:poll_votes) do
      add :poll_id, references(:polls, on_delete: :delete_all), null: false
      add :poll_option_id, references(:poll_options, on_delete: :delete_all), null: false
      add :user_id, :integer, null: false
      add :voted_at, :utc_datetime
    end

    create unique_index(:poll_votes, [:poll_option_id, :user_id])
  end
end
