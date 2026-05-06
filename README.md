# StreamActivities

This repository contains the Stream Activities microservice for the Blume application,
which is a streaming service for teachers and students; this repo's responsibility is to handle 
stream chat, interactions, polls, and other activities like quizzes, etc.

The microservice is built with the Phoenix framework using Elixir and PostgreSQL for the database.

To start the microservice server:

* Make sure you have Elixir and Erlang installed
* Run `mix setup` to install and setup dependencies
* Run `mix ecto.create` to create the database
* Run `mix ecto.migrate` to run all migrations of the database
* Set the required environment variables in `.env` file (JWT_SECRET)
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now the server is listening on port 4000 of localhost.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix
