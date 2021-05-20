defmodule Tahmeel.Repo.Migrations.CreateScheduleJobs do
  use Ecto.Migration

  def up do
    create table(:schedule_jobs) do
      add :state, :string, null: false
      add :worker, :string, null: false
      add :inserted_at, :utc_datetime_usec,
        null: false,
        default: fragment("timezone('UTC', now())")
      add :errors, {:array, :map}, null: false, default: []
    end

    execute """
      CREATE OR REPLACE FUNCTION schedule_jobs_notify() RETURNS trigger AS $$
      DECLARE
        channel text;
        notice json;
      BEGIN
        IF (TG_OP = 'INSERT') THEN
          channel = 'schedule_job_insert';
          notice = json_build_object('state', NEW.state);
        ELSE
          channel = 'schedule_job_update';
          notice = json_build_object('old_state', OLD.state, 'new_state', NEW.state);
        END IF;

        PERFORM pg_notify(channel, notice::text);
        RETURN NULL;
      END;
      $$ LANGUAGE plpgsql;
    """

    execute """
      CREATE TRIGGER schedule_notify
      AFTER INSERT OR UPDATE OF state ON schedule_jobs
      FOR EACH ROW EXECUTE PROCEDURE schedule_jobs_notify();
    """
  end

  def down do
    execute "DROP TRIGGER IF EXISTS schedule_notify ON schedule_jobs"
    execute "DROP FUNCTION IF EXISTS schedule_jobs_notify()"
    drop_if_exists table(:schedule_jobs)
  end
end
