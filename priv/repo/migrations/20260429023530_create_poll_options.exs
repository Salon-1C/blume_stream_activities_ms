defmodule StreamActivities.Repo.Migrations.CreatePollOptions do
  use Ecto.Migration

  def change do
    create table(:poll_options) do
      add :poll_id, references(:polls, on_delete: :delete_all), null: false
      add :description, :string, size: 255, null: false
      add :final_vote_count, :integer
      add :final_percentage, :decimal, precision: 5, scale: 2
    end
  end
end
