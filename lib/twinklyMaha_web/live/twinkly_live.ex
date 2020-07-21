defmodule TwinklyMahaWeb.TwinklyLive do
  @moduledoc "Live view for the LED"

  use TwinklyMahaWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, led_on?: false, current_color: "green")}
  end

  def render(assigns) do
    ~L"""
    <div class="row">
      <div class="columns">
        <%= for _row <- 1..8 do %>
          <%= for _column <- 1..8 do %>
            <div class="led-box">
            <div class="led led-<%= if @led_on?, do: "on", else: "off" %>" data-ledcolor="<%= @current_color %>" phx-hook="LedColor"></div>
            </div>
          <% end %>
            <br/ >
        <% end %>
        <%= if @led_on?, do: select_color(assigns) %>
        <div>
          <a class="button" phx-click="toggle-led">Turn LED <%= if @led_on?, do: "OFF", else: "ON" %> </a>
        </div>
      </div>
    </div>
    """
  end

  defp select_color(assigns) do
    ~L"""
      <select id="select-colors" name="colors">
      <%= for color <- ["green", "red", "purple"] do %>
          <option value="<%= color %>"
                  phx-click="change-color"
                  phx-value-color=<%= color %>
                  <%= if @current_color == color, do: "selected" %>
                > <%= color %>
          </option>
        <% end %>
    </select>
    """
  end

  @impl true
  def handle_event("toggle-led", _, socket) do
    socket = toggle_led(socket)
    {:noreply, socket |> current_color("green", socket.assigns.led_on?)}
  end

  @impl true
  def handle_event("change-color", %{"color" => color}, socket) do
    {:noreply, current_color(socket, color, socket.assigns.led_on?)}
  end

  defp current_color(socket, _color, false = led_on?) do
    assign(socket, :current_color, "rgba(0, 0, 0, 0.2)")
  end

  defp current_color(socket, color, true = led_on?) do
    assign(socket, :current_color, color)
  end

  defp toggle_led(socket) do
    assign(socket, :led_on?, !socket.assigns.led_on?)
  end
end
