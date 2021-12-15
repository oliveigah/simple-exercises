defmodule AoC2021.Day12 do
  def get_input() do
    file_path = Path.absname("./lib/advent-of-code/2021/12/input.txt")
    FileReader.read_file(file_path)
  end

  defmodule Part1 do
    def run() do
      AoC2021.Day12.get_input()
      |> Enum.map(&String.split(&1, "-"))
      |> Enum.reduce(%{}, fn [a, b], acc ->
        current_paths_a = Map.get(acc, a, [])
        current_paths_b = Map.get(acc, b, [])

        acc
        |> Map.put(a, [b | current_paths_a])
        |> Map.put(b, [a | current_paths_b])
      end)
      |> find_paths("start", [])
    end

    def find_paths(_map, "end", _minor_visited), do: 1

    def find_paths(map, initial_pos, minor_visited) do
      possible_paths = Map.get(map, initial_pos) -- minor_visited

      new_visited =
        if is_minor(initial_pos), do: [initial_pos | minor_visited], else: minor_visited

      Enum.map(possible_paths, &find_paths(map, &1, new_visited))
      |> Enum.sum()
    end

    def is_minor(point), do: point !== String.upcase(point)
  end

  defmodule Part2 do
    def run() do
      AoC2021.Day12.get_input()
      |> Enum.map(&String.split(&1, "-"))
      |> Enum.reduce(%{}, fn [a, b], acc ->
        current_paths_a = Map.get(acc, a, [])
        current_paths_b = Map.get(acc, b, [])

        acc
        |> Map.put(a, [b | current_paths_a])
        |> Map.put(b, [a | current_paths_b])
      end)
      |> find_paths("start", [])
    end

    def find_paths(_map, "end", _minor_visited), do: 1

    def find_paths(_map, "start", [_ | _]), do: 0

    def find_paths(map, initial_pos, minor_visited) do
      possible_paths = Map.get(map, initial_pos)

      new_visited =
        if is_minor(initial_pos), do: [initial_pos | minor_visited], else: minor_visited

      already_visited_twice =
        new_visited
        |> Enum.frequencies()
        |> Enum.find(fn {_, freq} -> freq >= 2 end)

      possible_paths =
        if already_visited_twice !== nil,
          do: possible_paths -- new_visited,
          else: possible_paths

      Enum.map(possible_paths, &find_paths(map, &1, new_visited))
      |> Enum.sum()
    end

    def is_minor(point), do: point !== String.upcase(point)
  end
end
