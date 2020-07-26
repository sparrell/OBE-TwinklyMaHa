# TwinklyMaHa
Twinkly is the
digital twin of blinky (ie in cloud instead of on Raspberry Pi, LiveView graphics instead of LEDs).

Blinky looks like:
[![blinky](./docs/blinky.jpeg)](https://www.youtube.com/watch?v=RcnRFfFtKQY)

Twinkly looks like:
![twinklygif](https://user-images.githubusercontent.com/584211/88267055-ed08ca80-ccd8-11ea-89ab-6760e772eb10.gif)

## Setup guide
First ensure you have the following set up in your computer
- elixir 1.10.4
- nodejs > 12 LTS
- Postgresql > 11

You can use [the phoenix installation guide](https://hexdocs.pm/phoenix/installation.html#content) to ensure you
have everything set up as expected

To start the server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Convenience make tasks
This project includes a couple of convenience `make` tasks. To get the full list
of the tasks run the command `make targets` to see a list of current tasks. For example

```shell
Targets
---------------------------------------------------------------
compile                compile the project
format                 Run formatting tools on the code
lint-compile           check for warnings in functions used in the project
lint-credo             Use credo to ensure formatting styles
lint-format            Check if the project is well formated using elixir formatter
lint                   Check if the project follows set conventions such as formatting
test                   Run the test suite
```
