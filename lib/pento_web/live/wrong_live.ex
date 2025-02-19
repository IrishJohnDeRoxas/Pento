defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, session, socket) do
    {
      :ok,
      assign(
        socket,
        score: 0,
        correct_number: Enum.random(1..10),
        message: "Make a guess:",
        session_id: session["live_socket_id"]
      )
    }
  end

  def render(assigns) do
    ~H"""
    <h1 class="mb-4 text-4xl font-extrabold">Your score: {@score}</h1>
    <h2>
      {@message}
    </h2>
    <br />
    <h2>
      <%= for n <- 1..10 do %>
        <.link
          class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
          phx-click="guess"
          phx-value-number={n}
        >
          {n}
        </.link>
      <% end %>
    </h2>
    <br />
    <pre>
      {@session_id}
    </pre>
    """
  end

  def handle_event("guess", %{"number" => guess_str}, socket) do
    guess = String.to_integer(guess_str)
    correct_number = socket.assigns.correct_number

    {
      :noreply,
      socket
      |> is_guess_correct?(guess, correct_number)
    }
  end

  defp is_guess_correct?(socket, guess, correct_number) do
    cond do
      guess == correct_number ->
        message = "Your guess: #{guess}. Correct!"
        score = socket.assigns.score + 1
        correct_number = Enum.random(1..10)

        socket
        |> assign(:score, score)
        |> assign(:message, message)
        |> assign(:correct_number, correct_number)

      guess != correct_number ->
        message = "Your guess: #{guess}. Wrong. Guess again."
        score = max(0, socket.assigns.score - 1)

        socket
        |> assign(:score, score)
        |> assign(:message, message)
    end
  end
end
