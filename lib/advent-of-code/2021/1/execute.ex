defmodule AoC2021.Day1 do
  def run_1() do
    get_input()
    |> Enum.map(&String.to_integer/1)
    |> do_run_1(0)
  end

  defp do_run_1([a, b | tail], acc) when a < b, do: do_run_1([b | tail], acc + 1)
  defp do_run_1([_ | tail], acc), do: do_run_1(tail, acc)
  defp do_run_1([], acc), do: acc

  def run_2() do
    get_input()
    |> Enum.map(&String.to_integer/1)
    |> do_run_2(0)
  end

  defp do_run_2([a, b, c, d | tail], acc) when a < d, do: do_run_2([b, c, d | tail], acc + 1)
  defp do_run_2([_ | tail], acc), do: do_run_2(tail, acc)
  defp do_run_2([], acc), do: acc

  defp get_input() do
    file_path = Path.absname("./lib/advent-of-code/2021/1/input.txt")
    FileReader.read_file(file_path)
  end
end
