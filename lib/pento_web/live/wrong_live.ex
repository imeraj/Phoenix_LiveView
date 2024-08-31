defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, score: 0, message: "Make a guess", winning_score: :rand.uniform(10))}
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    %{score: score, winning_score: winning_score} = socket.assigns

    {message, score} =
      if String.to_integer(guess) == winning_score do
        {"You have won.", score + 1}
      else
        {"Your guess: #{guess}. Wrong. Guess again.", score - 1}
      end

    {:noreply, assign(socket, message: message, score: score)}
  end

  def render(assigns) do
    ~H"""
    <h1 class="mb-4 text-4xl font-extrabold">Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    </h2>
    <br />
    <h2>
      <%= for n <- 1..10 do %>
        <.link
          class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
          phx-click="guess"
          phx-value-number={n}
        >
          <%= n %>
        </.link>
      <% end %>
    </h2>
    """
  end
end
