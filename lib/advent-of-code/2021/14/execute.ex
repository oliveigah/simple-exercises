defmodule AoC2021.Day14 do
  def get_input() do
    file_path = Path.absname("./lib/advent-of-code/2021/14/input.txt")
    FileReader.read_file(file_path)
  end

  defmodule Part1 do
    def run do
      {[template], rules} =
        AoC2021.Day14.get_input()
        |> Enum.filter(&(&1 != ""))
        |> Enum.split(1)

      template =
        template
        |> String.to_charlist()

      rules =
        rules
        |> Enum.map(fn rule ->
          String.split(rule, " -> ", trim: true)
          |> Enum.map(&String.to_charlist/1)
        end)
        |> Enum.map(&List.to_tuple/1)
        |> Map.new()

      {least, most} =
        do_step(template, rules, 10)
        |> Enum.frequencies()
        |> Enum.map(fn {_, freq} -> freq end)
        |> Enum.min_max_by(fn freq -> freq end)

      most - least
    end

    def do_step(input, _rules, 0), do: input

    def do_step(input, rules, step) do
      pairs = Enum.chunk_every(input, 2, 1, :discard)

      inserts =
        Enum.map(pairs, &Map.get(rules, &1))
        |> Enum.with_index()
        |> Enum.map(fn {val, index} -> {index, val} end)
        |> Map.new()

      input
      |> Enum.with_index()
      |> Enum.reduce([], fn {val, index}, acc ->
        case Map.get(inserts, index - 1) do
          nil ->
            acc ++ [val]

          insert_value ->
            acc ++ [insert_value, val]
        end
      end)
      |> List.to_charlist()
      |> do_step(rules, step - 1)
    end
  end

  defmodule Part2 do
    def run do
      {[template], rules} =
        AoC2021.Day14.get_input()
        |> Enum.filter(&(&1 != ""))
        |> Enum.split(1)

      template =
        template
        |> String.split("", trim: true)

      rules =
        rules
        |> Enum.map(fn rule ->
          [combination, insert] = String.split(rule, " -> ", trim: true)
          [first, second] = String.split(combination, "", trim: true)

          {[first, second], [[first, insert], [insert, second]]}
        end)
        |> Map.new()

      pairs_counter =
        template
        |> Enum.chunk_every(2, 1)
        |> Enum.frequencies()

      {{_, min}, {_, max}} =
        do_step(pairs_counter, rules, 40)
        |> Enum.reduce(%{}, fn
          {[first, _], count}, acc -> Map.put(acc, first, Map.get(acc, first, 0) + count)
          {[last], count}, acc -> Map.put(acc, last, Map.get(acc, last, 0) + count)
        end)
        |> Enum.min_max_by(fn {_, count} -> count end)

      max - min
    end

    def do_step(pairs_counter, _rules, 0), do: pairs_counter

    def do_step(pairs_counter, rules, step) do
      pairs_counter
      |> Enum.reduce(%{}, fn {pair, qty}, acc ->
        case Map.get(rules, pair) do
          [first_new_pair, second_new_pair] ->
            acc
            |> Map.put(first_new_pair, Map.get(acc, first_new_pair, 0) + qty)
            |> Map.put(second_new_pair, Map.get(acc, second_new_pair, 0) + qty)

          _ ->
            Map.put(acc, pair, qty)
        end
      end)
      |> do_step(rules, step - 1)
    end
  end
end
