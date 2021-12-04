defmodule AoC2021.Day3 do
  defp get_input() do
    file_path = Path.absname("./lib/advent-of-code/2021/3/input.txt")

    FileReader.read_file(file_path)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  defp binary_list_to_number(list) do
    list
    |> Enum.reduce(fn bit, acc -> acc <> bit end)
    |> Integer.parse(2)
    |> elem(0)
  end

  def run_1() do
    columns = Enum.zip(get_input())

    calc_gamma_rate(columns) * calc_epsilon_rate(columns)
  end

  defp count_zeros_and_ones(col) do
    Enum.reduce(col, {0, 0}, fn bit, {zeros, ones} ->
      if bit === "0", do: {zeros + 1, ones}, else: {zeros, ones + 1}
    end)
  end

  defp calc_gamma_rate(columns) do
    columns
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(fn col ->
      {zeros, ones} = count_zeros_and_ones(col)
      if zeros > ones, do: "0", else: "1"
    end)
    |> binary_list_to_number()
  end

  defp calc_epsilon_rate(columns) do
    columns
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(fn col ->
      {zeros, ones} = count_zeros_and_ones(col)
      if zeros < ones, do: "0", else: "1"
    end)
    |> binary_list_to_number()
  end

  ## PART 2
  def run_2() do
    rows = Enum.map(get_input(), &List.to_tuple/1)

    calculate_o2(rows, 0) * calculate_co2(rows, 0)
  end

  defp count_zeros_and_ones(rows, col_position) do
    Enum.reduce(rows, {0, 0}, fn row, {zeros, ones} ->
      if elem(row, col_position) === "0" do
        {zeros + 1, ones}
      else
        {zeros, ones + 1}
      end
    end)
  end

  defp calculate_o2([result | []], _position) do
    result
    |> Tuple.to_list()
    |> binary_list_to_number()
  end

  defp calculate_o2([_ | tail] = rows, position) when length(tail) > 0 do
    {zeros, ones} = count_zeros_and_ones(rows, position)
    desired_bit = get_o2_desired_bit(zeros, ones)
    new_rows = Enum.filter(rows, fn row -> elem(row, position) === desired_bit end)
    calculate_o2(new_rows, position + 1)
  end

  defp get_o2_desired_bit(zeros, ones) when zeros > ones, do: "0"
  defp get_o2_desired_bit(zeros, ones) when ones >= zeros, do: "1"

  defp calculate_co2([result | []], _position) do
    result
    |> Tuple.to_list()
    |> binary_list_to_number()
  end

  defp calculate_co2([_ | tail] = rows, position) when length(tail) > 0 do
    {zeros, ones} = count_zeros_and_ones(rows, position)
    desired_bit = get_co2_desired_bit(zeros, ones)
    new_rows = Enum.filter(rows, fn row -> elem(row, position) === desired_bit end)
    calculate_co2(new_rows, position + 1)
  end

  defp get_co2_desired_bit(zeros, ones) when zeros <= ones, do: "0"
  defp get_co2_desired_bit(zeros, ones) when ones < zeros, do: "1"
end
