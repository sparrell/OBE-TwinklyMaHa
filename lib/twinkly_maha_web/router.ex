defmodule TwinklyMahaWeb.Router do
  use TwinklyMahaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TwinklyMahaWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TwinklyMahaWeb do
    pipe_through :browser

    live "/", PageLive, :index
    live "/phoenix", PageLive, :index
    live "/twinkly", TwinklyLive, :twinkly
  end

  # Other scopes may use custom stacks.
  # scope "/api", TwinklyMahaWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: TwinklyMahaWeb.Telemetry
    end
  end
end
