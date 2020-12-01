defmodule AocWeb.DayLive do
  use AocWeb, :live_view

  def handle_params(%{"year" => year, "day" => day}, _uri, socket) do
    module = :"Elixir.Aoc.Y#{year}.#{day(day)}"
    input = Aoc.Input.as_string(year, day)

    start_time = DateTime.utc_now()

    %Task{ref: ref_two} = Task.async(fn -> apply(module, :part_two, [input]) || "No Input" end)
    %Task{ref: ref_one} = Task.async(fn -> apply(module, :part_one, [input]) || "No Input" end)

    {:noreply,
     assign(socket,
       year: year,
       day: day,
       start_time: start_time,
       part_one_ref: ref_one,
       part_two_ref: ref_two,
       part_one: nil,
       part_two: nil
     )}
  end

  def handle_params(_, _, socket),
    do: handle_params(%{"year" => "2020", "day" => "1"}, nil, socket)

  def handle_info(
        {ref, result},
        socket = %{assigns: %{start_time: start_time, part_one_ref: ref}}
      ),
      do:
        {:noreply,
         assign(socket,
           part_one: result,
           part_one_time: DateTime.utc_now() |> DateTime.diff(start_time, :milliseconds)
         )}

  def handle_info(
        {ref, result},
        socket = %{assigns: %{start_time: start_time, part_two_ref: ref}}
      ),
      do:
        {:noreply,
         assign(socket,
           part_two: result,
           part_two_time: DateTime.utc_now() |> DateTime.diff(start_time, :milliseconds)
         )}

  def handle_info({:DOWN, ref, :process, _, _}, socket), do: {:noreply, socket}

  defp day(%{assigns: %{day: day}}), do: day(day)

  defp day(day) do
    "Day" <> String.pad_leading("#{day}", 2, "0")
  end

  def render(assigns) do
    ~L"""
    <section>
      <h2 class="text-lg font-medium">Part One</h2>
      <%= if @part_one do %>
        <div class="text-6xl font-cursive font-bold text-yellow-300"><%= @part_one %></div>
        <div class="text-sm text-gray-600">Ran in <%= Number.Delimit.number_to_delimited(@part_one_time, precision: 0) %>ms</div>
      <% else %>
        <div class="animate-bounce">Running...</div>
      <% end %>
    </section>
    <section>
      <h2 class="text-lg font-medium">Part Two</h2>
      <%= if @part_two do %>
        <div class="text-6xl font-cursive font-bold text-yellow-300"><%= @part_two %></div>
        <div class="text-sm text-gray-600">Ran in <%= Number.Delimit.number_to_delimited(@part_two_time, precision: 0) %>ms</div>
      <% else %>
      <div class="animate-bounce">Running...</div>
      <% end %>
    </section>
    """
  end
end
