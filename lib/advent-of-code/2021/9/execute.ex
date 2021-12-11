defmodule AoC2021.Day9 do
  def get_input() do
    file_path = Path.absname("./lib/advent-of-code/2021/9/input.txt")
    FileReader.read_file(file_path)
  end

  defmodule Part1 do
    @spec run :: any
    def run() do
      matrix =
        AoC2021.Day9.get_input()
        |> Enum.map(fn line ->
          String.split(line, "", trim: true)
          |> Enum.map(&String.to_integer/1)
          |> List.to_tuple()
        end)
        |> List.to_tuple()

      max_line = tuple_size(matrix) - 1
      max_col = tuple_size(elem(matrix, 0)) - 1

      Enum.reduce(0..max_line, [], fn line, acc_line ->
        Enum.reduce(0..max_col, [], fn col, acc_col ->
          if is_low_point?(line, col, matrix) do
            [get_matrix_element(matrix, line, col) | acc_col]
          else
            acc_col
          end
        end) ++ acc_line
      end)
      |> Enum.map(&(&1 + 1))
      |> Enum.sum()
    end

    def is_low_point?(line, col, matrix) do
      center = get_matrix_element(matrix, line, col)

      valid_points =
        [
          get_matrix_element(matrix, line, col + 1),
          get_matrix_element(matrix, line - 1, col),
          get_matrix_element(matrix, line, col - 1),
          get_matrix_element(matrix, line + 1, col)
        ]
        |> Enum.filter(fn e -> e !== nil end)

      lower_point = Enum.find(valid_points, fn e -> e <= center end)

      lower_point === nil
    end

    def get_matrix_element(matrix, line, col)
        when line < 0 or col < 0 or line >= tuple_size(matrix) or
               col >= tuple_size(elem(matrix, 0)),
        do: nil

    def get_matrix_element(matrix, line, col), do: matrix |> elem(line) |> elem(col)
  end

  defmodule Part2 do
    def run() do
      matrix =
        AoC2021.Day9.get_input()
        |> Enum.map(fn line ->
          String.split(line, "", trim: true)
          |> Enum.map(&String.to_integer/1)
          |> List.to_tuple()
        end)
        |> List.to_tuple()

      max_line = tuple_size(matrix) - 1
      max_col = tuple_size(elem(matrix, 0)) - 1

      Enum.reduce(0..max_line, [], fn line, acc_line ->
        Enum.reduce(0..max_col, [], fn col, acc_col ->
          if is_low_point?(line, col, matrix) do
            [{line, col} | acc_col]
          else
            acc_col
          end
        end) ++ acc_line
      end)
      |> Enum.map(&get_basin(&1, matrix))
      |> Enum.map(&length/1)
      |> Enum.sort(:desc)
      |> Enum.slice(0..2)
      |> Enum.reduce(1, fn e, acc -> e * acc end)
    end

    def is_low_point?(line, col, matrix) do
      center = get_matrix_element(matrix, line, col)

      valid_points =
        [
          get_matrix_element(matrix, line, col + 1),
          get_matrix_element(matrix, line - 1, col),
          get_matrix_element(matrix, line, col - 1),
          get_matrix_element(matrix, line + 1, col)
        ]
        |> Enum.filter(fn e -> e !== nil end)

      lower_point = Enum.find(valid_points, fn e -> e <= center end)

      lower_point === nil
    end

    def get_basin({line, col}, matrix) do
      center = get_matrix_element(matrix, line, col)

      valid_points =
        [
          {get_matrix_element(matrix, line, col + 1), {line, col + 1}},
          {get_matrix_element(matrix, line - 1, col), {line - 1, col}},
          {get_matrix_element(matrix, line, col - 1), {line, col - 1}},
          {get_matrix_element(matrix, line + 1, col), {line + 1, col}}
        ]
        |> Enum.filter(fn {val, _} -> val !== nil end)
        |> Enum.filter(fn {val, _} -> val > center && val < 9 end)
        |> Enum.map(fn {_, coordinates} -> coordinates end)
        |> Enum.map(&get_basin(&1, matrix))
        |> Enum.flat_map(fn e -> e end)

      Enum.uniq([{line, col} | valid_points])
    end

    def get_matrix_element(matrix, line, col)
        when line < 0 or col < 0 or line >= tuple_size(matrix) or
               col >= tuple_size(elem(matrix, 0)),
        do: nil

    def get_matrix_element(matrix, line, col), do: matrix |> elem(line) |> elem(col)
  end
end
