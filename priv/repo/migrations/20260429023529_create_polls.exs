defmodule StreamActivities.Repo.Migrations.CreatePolls do
  use Ecto.Migration

  def change do
    create table(:polls) do
      add :stream_id, :integer, null: false
      add :question,  :string, size: 255, null: false
      add :is_anonymous, :boolean, default: true, null: false
      add :max_number_selections, :integer, default: 1, null: false
      add :status, :string, default: "open", null: false
      add :created_at, :utc_datetime, null: false
      add :closed_at, :utc_datetime

      timestamps()
    end
  end
end