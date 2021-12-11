defmodule AoC2021.Day8 do
  def get_input() do
    file_path = Path.absname("./lib/advent-of-code/2021/8/input.txt")

    FileReader.read_file(file_path)
  end

  defmodule Part1 do
    def run() do
      AoC2021.Day8.get_input()
      |> Enum.map(&String.split(&1, " | "))
      |> Enum.map(fn [_, output] -> String.split(output) end)
      |> Enum.map(fn output -> Enum.frequencies_by(output, &String.length/1) end)
      |> Enum.map(
        &Enum.reduce(&1, 0, fn {segments_count, freq}, acc ->
          count_identifiable = Enum.find([2, 4, 3, 7], fn e -> segments_count === e end)
          if count_identifiable, do: freq + acc, else: acc
        end)
      )
      |> Enum.sum()
    end
  end

  defmodule Part2 do
    def run() do
      AoC2021.Day8.get_input()
      |> Enum.map(&String.split(&1, " | "))
      |> Enum.map(fn [signals, output] -> calc(signals, output) end)
      |> Enum.sum()
    end

    defp calc(signals, output) do
      display_map = get_display_map(String.split(signals))

      output
      |> String.split()
      |> Enum.map(fn digit ->
        digit
        |> String.split("", trim: true)
        |> Enum.sort()
        |> List.to_string()
      end)
      |> Enum.map(fn digit -> Map.get(display_map, digit) end)
      |> List.to_string()
      |> String.to_integer()
    end

    defp get_signal_by_length(signals, length) do
      res =
        signals
        |> Enum.filter(&(String.length(&1) === length))
        |> Enum.map(fn string ->
          String.split(string, "", trim: true) |> Enum.sort()
        end)

      if length(res) === 1, do: List.first(res), else: res
    end

    def get_display_map(signals) do
      signal_1 = get_signal_by_length(signals, 2)
      signal_4 = get_signal_by_length(signals, 4)
      signal_7 = get_signal_by_length(signals, 3)
      signal_8 = get_signal_by_length(signals, 7)

      [base_a] = signal_7 -- signal_1

      base_e_d = signal_8 -- (signal_4 ++ [base_a])

      base_b_c = signal_7 -- [base_a]

      base_f_g = signal_4 -- base_b_c

      signal_9 =
        Enum.find(get_signal_by_length(signals, 6), fn signal ->
          [] !== base_e_d -- signal
        end)

      [base_e] = base_e_d -- signal_9
      [base_d] = base_e_d -- [base_e]

      signal_6 =
        Enum.find(get_signal_by_length(signals, 6), fn signal ->
          [] !== base_b_c -- signal
        end)

      [base_b] = base_b_c -- signal_6
      [base_c] = base_b_c -- [base_b]

      signal_0 =
        Enum.find(get_signal_by_length(signals, 6), fn signal ->
          [] !== base_f_g -- signal
        end)

      [base_g] = base_f_g -- signal_0
      [base_f] = base_f_g -- [base_g]

      parsed_segments = %{
        "a" => base_a,
        "b" => base_b,
        "c" => base_c,
        "d" => base_d,
        "e" => base_e,
        "f" => base_f,
        "g" => base_g
      }

      base_map = %{
        "abcdef" => "0",
        "bc" => "1",
        "abdeg" => "2",
        "abcdg" => "3",
        "bcfg" => "4",
        "acdfg" => "5",
        "acdefg" => "6",
        "abc" => "7",
        "abcdefg" => "8",
        "abcdfg" => "9"
      }

      Enum.map(base_map, fn {base_signal, val} ->
        new_signal =
          String.split(base_signal, "", trim: true)
          |> Enum.map(&Map.get(parsed_segments, &1))
          |> Enum.sort()
          |> List.to_string()

        {new_signal, val}
      end)
      |> Map.new()
    end
  end
end
