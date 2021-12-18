defmodule AoC2021.Day13 do
  def get_input() do
    file_path = Path.absname("./lib/advent-of-code/2021/13/input.txt")
    FileReader.read_file(file_path)
  end

  defmodule Part1 do
    def run() do
      {dots, instructions} =
        AoC2021.Day13.get_input()
        |> Enum.filter(&(&1 !== ""))
        |> Enum.reduce({[], []}, fn line, {dots, instructions} ->
          if String.starts_with?(line, "fold along") do
            {dots, instructions ++ [line]}
          else
            {dots ++ [line], instructions}
          end
        end)

      dots =
        Enum.map(dots, fn line ->
          String.split(line, ",")
          |> Enum.map(&String.to_integer/1)
          |> List.to_tuple()
        end)

      instructions =
        Enum.map(instructions, fn line ->
          [orientation, val] =
            String.split(line, "fold along ", trim: true)
            |> List.first()
            |> String.split("=")

          {orientation, String.to_integer(val)}
        end)

      [List.first(instructions)]
      |> Enum.reduce(dots, fn
        {"y", pos}, acc ->
          Enum.map(acc, fn
            {_, ^pos} -> nil
            {x, y} when y < pos -> {x, y}
            {x, y} when y > pos -> {x, pos - (y - pos)}
          end)
          |> Enum.filter(&(&1 !== nil))

        {"x", pos}, acc ->
          Enum.map(acc, fn
            {^pos, _} -> nil
            {x, y} when x < pos -> {x, y}
            {x, y} when x > pos -> {pos - (x - pos), y}
          end)
          |> Enum.filter(&(&1 !== nil))
      end)
      |> MapSet.new()
      |> MapSet.size()
    end
  end

  defmodule Part2 do
    def run() do
      {dots, instructions} =
        AoC2021.Day13.get_input()
        |> Enum.filter(&(&1 !== ""))
        |> Enum.reduce({[], []}, fn line, {dots, instructions} ->
          if String.starts_with?(line, "fold along") do
            {dots, instructions ++ [line]}
          else
            {dots ++ [line], instructions}
          end
        end)

      dots =
        Enum.map(dots, fn line ->
          String.split(line, ",")
          |> Enum.map(&String.to_integer/1)
          |> List.to_tuple()
        end)

      instructions =
        Enum.map(instructions, fn line ->
          [orientation, val] =
            String.split(line, "fold along ", trim: true)
            |> List.first()
            |> String.split("=")

          {orientation, String.to_integer(val)}
        end)

      dots =
        instructions
        |> Enum.reduce(dots, fn
          {"y", pos}, acc ->
            Enum.map(acc, fn
              {_, ^pos} -> nil
              {x, y} when y < pos -> {x, y}
              {x, y} when y > pos -> {x, pos - (y - pos)}
            end)
            |> Enum.filter(&(&1 !== nil))

          {"x", pos}, acc ->
            Enum.map(acc, fn
              {^pos, _} -> nil
              {x, y} when x < pos -> {x, y}
              {x, y} when x > pos -> {pos - (x - pos), y}
            end)
            |> Enum.filter(&(&1 !== nil))
        end)
        |> MapSet.new()

      [xs, ys] = Enum.map(dots, &Tuple.to_list/1) |> Enum.zip()

      max_x = Tuple.to_list(xs) |> Enum.max()
      max_y = Tuple.to_list(ys) |> Enum.max()

      for y <- 0..max_y do
        for x <- 0..max_x do
          if MapSet.member?(dots, {x, y}) do
            IO.write(" # ")
          else
            IO.write("   ")
          end
        end

        IO.puts(" ")
      end
    end
  end
end
