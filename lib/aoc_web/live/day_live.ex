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

  defp run(part) do
  end

  def render(assigns) do
    ~L"""
    <h1 class="text-4xl font-bold">Year <%= @year %> :: Day <%= @day %></h1>
    <div>
      <a href="https://adventofcode.com/<%= @year %>/day/<%= @day %>" target="_BLANK" class="text-blue-700 hover:underline">aoc</a>
      <span class="text-gray-500">|</span>
      <%= link "code",
            to: "https://github.com/kevinhughesdotdev/adent_of_code_web/blob/main/lib/aoc/Y#{@year}/Day#{Aoc.Input.padded_number(@day)}.ex",
            class: "text-blue-700 hover:underline",
            target: "_BLANK"
      %>
    </div>
    <div class="flex">
      <section class="w-1/2">
        <h2 class="text-2xl font-medium mt-5">Part One</h2>
        <%= if @part_one do %>
          <div class="text-lg"><%= @part_one %></div>
          <div class="text-sm text-gray-600">Ran in <%= Number.Delimit.number_to_delimited(@part_one_time, precision: 0) %>ms</div>
        <% else %>
          <div class="animate-bounce">Running...</div>
        <% end %>
      </section>
      <section class="w-1/2">
        <h2 class="text-2xl font-medium mt-5">Part Two</h2>
        <%= if @part_two do %>
          <div class="text-lg"><%= @part_two %></div>
          <div class="text-sm text-gray-600">Ran in <%= Number.Delimit.number_to_delimited(@part_two_time, precision: 0) %>ms</div>
        <% else %>
        <div class="animate-bounce">Running...</div>
        <% end %>
      </section>
    </div>
    """
  end
end
