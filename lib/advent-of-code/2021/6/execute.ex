defmodule AoC2021.Day6 do
  def get_input() do
    file_path = Path.absname("./lib/advent-of-code/2021/6/input.txt")

    FileReader.read_file(file_path)
    |> Enum.map(&String.split(&1, ",", trim: true))
    |> List.first()
    |> Enum.map(&String.to_integer/1)
  end

  defmodule Part1 do
    def run() do
      AoC2021.Day6.get_input()
      |> calc_population(80)
    end

    defp calc_population(population, 0), do: length(population)

    defp calc_population(population, days) do
      to_add = List.duplicate(8, Enum.count(population, fn fish -> fish === 0 end))
      new_population = Enum.map(population, &increment_fish/1)
      calc_population(new_population ++ to_add, days - 1)
    end

    defp increment_fish(fish) when fish > 0, do: fish - 1
    defp increment_fish(fish) when fish == 0, do: 6
  end

  defmodule Part2 do
    def run() do
      input =
        AoC2021.Day6.get_input()
        |> Enum.frequencies()

      Enum.reduce(0..8, [], fn key, acc -> acc ++ [Map.get(input, key, 0)] end)
      |> simulate(256)
      |> Enum.sum()
    end

    defp simulate(result, 0), do: result

    defp simulate([ready | tail], days) do
      (tail ++ [ready])
      |> List.update_at(6, &(&1 + ready))
      |> simulate(days - 1)
    end
  end
end
