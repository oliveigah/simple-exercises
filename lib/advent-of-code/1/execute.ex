defmodule AoC.Challenge1 do
  def run do
    get_input()
    |> Enum.map(&String.to_integer/1)
    |> check_valid_responses
    |> Enum.filter(fn {_, _, is_valid} -> is_valid end)
    |> Enum.map(fn {n1, n2, _} -> n1 * n2 end)
  end

  defp check_valid_responses(input) do
    for i <- input, j <- input do
      {i, j, i + j == 2020}
    end
  end

  defp get_input do
    file_path = Path.absname("./lib/advent-of-code/1/input.txt")
    FileReader.read_file(file_path)
  end
end
