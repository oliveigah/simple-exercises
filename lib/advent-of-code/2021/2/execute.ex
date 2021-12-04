defmodule AoC2021.Day2 do
  def run_1() do
    get_input()
    |> do_1({0, 0})
  end

  defp do_1([{"forward", val} | tail], {h, dep}), do: do_1(tail, {h + val, dep})
  defp do_1([{"up", val} | tail], {h, dep}), do: do_1(tail, {h, dep - val})
  defp do_1([{"down", val} | tail], {h, dep}), do: do_1(tail, {h, dep + val})
  defp do_1([], {h, dep}), do: h * dep

  def run_2() do
    get_input()
    |> do_2({0, 0, 0})
  end

  defp do_2([{"forward", val} | tail], {h, dep, a}), do: do_2(tail, {h + val, dep + val * a, a})
  defp do_2([{"up", val} | tail], {h, dep, a}), do: do_2(tail, {h, dep, a - val})
  defp do_2([{"down", val} | tail], {h, dep, a}), do: do_2(tail, {h, dep, a + val})
  defp do_2([], {h, dep, _a}), do: h * dep

  defp get_input() do
    file_path = Path.absname("./lib/advent-of-code/2021/2/input.txt")

    FileReader.read_file(file_path)
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [direction, value] -> [direction, String.to_integer(value)] end)
    |> Enum.map(&List.to_tuple/1)
  end
end
