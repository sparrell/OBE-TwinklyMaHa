defmodule TwinklyMahaWeb.TwinklyLive do
  @moduledoc "Live view for the LED"

  use TwinklyMahaWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, led_on?: false)}
  end

  def render(assigns) do
    ~L"""
    <div class="row">
      <div class="columns">
        <%= for n <- 1..8 do %>
          <%= for m <- 1..8 do %>
            <div class="led-box">
            <div class="led led-<%= if @led_on?, do: "on", else: "off" %>" data-ledcolor="purple" phx-hook="LedColor"></div>
            </div>
          <% end %>
            <br/ >
        <% end %>
        <div>
          <a class="button" phx-click="toggle-led">Turn LED <%= if @led_on?, do: "OFF", else: "ON" %> </a>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("toggle-led", _, socket) do
    {:noreply, toggle_led(socket)}
  end

  defp toggle_led(socket) do
    assign(socket, :led_on?, !socket.assigns.led_on?)
  end
end
