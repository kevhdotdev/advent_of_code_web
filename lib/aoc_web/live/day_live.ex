defmodule AocWeb.DayLive do
  use AocWeb, :live_view

  def handle_params(%{"year" => year, "day" => day}, _uri, socket) do
    module = :"Elixir.Aoc.Y#{year}.#{day(day)}"
    input = Aoc.Input.as_string(year, day)

    %Task{ref: ref_one} = Task.async(fn -> apply(module, :part_one, [input]) || "No Input" end)
    %Task{ref: ref_two} = Task.async(fn -> apply(module, :part_two, [input]) || "No Input" end)

    {:noreply,
     assign(socket,
       year: year,
       day: day,
       part_one_ref: ref_one,
       part_two_ref: ref_two,
       part_one: nil,
       part_two: nil
     )}
  end

  def handle_info({ref, result}, socket = %{assigns: %{part_one_ref: ref}}),
    do: {:noreply, assign(socket, part_one: result)}

  def handle_info({ref, result}, socket = %{assigns: %{part_two_ref: ref}}),
    do: {:noreply, assign(socket, part_two: result)}

  def handle_info({:DOWN, ref, :process, _, _}, socket), do: {:noreply, socket}

  defp day(%{assigns: %{day: day}}), do: day(day)

  defp day(day) do
    "Day" <> String.pad_leading("#{day}", 2, "0")
  end

  def render(assigns) do
    ~L"""
    <h1><%= @year %>/<%= @day %></h1>
    <section>
      <h2>Part One</h2>
      <%= @part_one || img_tag("/images/spinner.gif") %>
      </section>
    <section>
      <h2>Part Two</h2>
      <%= @part_two || img_tag("/images/spinner.gif") %>
    </section>
    """
  end
end
