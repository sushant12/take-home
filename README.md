- Clone the repo
- `cd` into the repo
- run `asdf install`
- run `mix do deps.get, deps.compile`
- change the database configuration in "dev.exs" and run `mix ecto.setup`

# About

Implementation of periodic job with cron expression using OTP.

To define periodic jobs:

config.exs

```elixir
config :your_app,
  periodic_jobs: [
    {"@daily", YourWorker},
    {"* * * * *", YourWorker2}
  ]
```

your_worker.ex

```elixir
defmodule YourWorker do
  def run do
    # run your code
  end
end
```

Your worker module will need to define a `run` function.
