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

## Deployment to GCP
The deployment is done using docker images with the help of make tasks. We can create a docker image, push it to container registry on gcp and then launch
an instance using this docker image

The docker image is automatically tagged with the application version from your mix file

### Deployment from local machine
**Before you begin:**
- Make sure you have write access to the docker registry
- You will need the necessary permissions to create an instance
- Docker should be installed in your computer and running
- GCloud should be well set up, authenticated and initialised to use docker
- access to production secrets in the `prod.secrets.exs` file (look at `config/prod.sample.exs` to see an example)


#### creating an image for use in your laptop
If you want to create a docker image for use in your laptop then you can use the command
```shell
make docker-image
```

#### Creating an image and pushing to GCP
You can optionally create an image on your laptop and push it up to GCP container registry using the following command
```shell
make push-image-gcp
```
This will create the image and tag it with the current application version then push the created image to GCP

#### creating an image and lauching an instance on GCP
You can also run a server on GCP using the docker image by running the following command
```shell
make push-and-serve-gcp instance-name=<give-the-instance-a-unique-name>
```

If you had created an image before and would like to create a running server using the image run:
```shell
make deploy-existing instance-name=<give-the-instance-a-unique-name>
```

The instance name you provide above should be unique and should not be existing on GCP already otherwise you will get an error

### Accessing twinklymaha
The above procedures create an instance of twinklymaha
on GCP with the name you gave it.
Using console.cloud.google.compute,
go to your virtual machine instances,
and look up the external ip (a.b.c.d5) of the instance you just created.
Note the phoenix webserver is running on port 4000
and the home page is twinkly.
Go to http://a.b.c.d:4000/twinkly
Note it is http not https
