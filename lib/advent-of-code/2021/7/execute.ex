defmodule AoC2021.Day7 do
  def get_input() do
    file_path = Path.absname("./lib/advent-of-code/2021/7/input.txt")

    FileReader.read_file(file_path)
    |> Enum.map(&String.split(&1, ",", trim: true))
    |> List.first()
    |> Enum.map(&String.to_integer/1)
  end

  defmodule Part1 do
    def run() do
      input = AoC2021.Day7.get_input()

      max = Enum.max(input)
      freqs = Enum.frequencies(input)

      Enum.reduce(0..max, :infinity, fn pos, min_acc ->
        iteration_sum =
          Enum.reduce(freqs, 0, fn {compare_pos, freq}, acc ->
            acc + freq * abs(compare_pos - pos)
          end)

        if iteration_sum < min_acc, do: iteration_sum, else: min_acc
      end)
    end
  end

  defmodule Part2 do
    def run() do
      input = AoC2021.Day7.get_input()

      max = Enum.max(input)
      freqs = Enum.frequencies(input)

      Enum.reduce(0..max, :infinity, fn pos, min_acc ->
        iteration_sum =
          Enum.reduce(freqs, 0, fn {compare_pos, freq}, acc ->
            distance = abs(compare_pos - pos)
            cost = round(distance * ((1 + distance) / 2))
            acc + freq * cost
          end)

        if iteration_sum < min_acc, do: iteration_sum, else: min_acc
      end)
    end
  end
end
