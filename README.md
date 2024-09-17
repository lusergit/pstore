# Pstore

Manage a petstore of cats and dogs! 

## Pre
- the [elixir language](https://elixir-lang.org/)
- the [phoenix framework](https://www.phoenixframework.org/)
- and a database, currently tested with
  [PostgreSQL](https://www.postgresql.org/)

## Run the server

Configure the database connection in
[confing/dev.exs](./config/dev.exs), currently the configuration is
the following

```elixir
config :pstore, Pstore.Repo,
  username: "pstore",
  password: "pstorepswd",
  hostname: "localhost",
  database: "pstore_dev",
  # ...
```

Then you can run the server with

```sh
mix phx.server
```

## Routes
Once the server is started several http endpoints are available,
namely
```
  GET     /pets                                  Get the list of all pets in the store
  GET     /pets/:id                              Show the details of the pet with id :id
  POST    /pets                                  Create a new pet
  PUT     /pets/:id                              Update a pet's details
  DELETE  /pets/:id                              Delete the pet with id :id
  
  ...
```
The full routes list and their controller are available with

	mix phx.routes
