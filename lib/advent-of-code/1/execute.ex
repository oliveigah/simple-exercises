defmodule AoC.Challenge1 do
  def run do
    get_input()
    |> Enum.map(&String.to_integer/1)
    |> check_valid_responses([])
    |> Enum.filter(fn {_, _, is_valid} -> is_valid end)
    |> Enum.map(fn {n1, n2, _} -> n1 * n2 end)
    |> List.first()
    |> IO.inspect()
  end

  defp check_valid_responses([_h | []], acc_list) do
    acc_list
  end

  defp check_valid_responses([current_input | remaining_inputs], acc_list) do
    current_results =
      Enum.map(remaining_inputs, fn remaining_input ->
        {current_input, remaining_input, current_input + remaining_input == 2020}
      end)

    check_valid_responses(remaining_inputs, current_results ++ acc_list)
  end

  defp get_input do
    file_path = Path.absname("./lib/advent-of-code/1/input.txt")
    FileReader.read_file(file_path)
  end
end
