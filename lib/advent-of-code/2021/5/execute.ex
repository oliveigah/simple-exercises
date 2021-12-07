defmodule AoC2021.Day5 do
  def get_input() do
    Path.absname("./lib/advent-of-code/2021/5/input.txt")
    |> FileReader.read_file()
    |> Enum.map(&String.split(&1, "->", trim: true))
    |> Enum.map(fn line ->
      line
      |> Enum.map(&String.trim/1)
      |> Enum.flat_map(&String.split(&1, ","))
    end)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.map(fn {x1, y1, x2, y2} ->
      f = &String.to_integer/1
      {f.(x1), f.(y1), f.(x2), f.(y2)}
    end)
  end

  defmodule Part1 do
    def run() do
      input = AoC2021.Day5.get_input()

      input
      |> get_max_coordinates()
      |> create_grid()
      |> populate_grid(input)
      |> Tuple.to_list()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.flat_map(fn e -> e end)
      |> Enum.count(fn e -> e >= 2 end)
    end

    defp get_max_coordinates(input) do
      input
      |> Enum.reduce({0, 0}, fn {x1, y1, x2, y2}, {max_x, max_y} ->
        max_x = Enum.max([x1, x2, max_x])
        max_y = Enum.max([y1, y2, max_y])
        {max_x, max_y}
      end)
    end

    defp create_grid({max_x, max_y}) do
      Enum.reduce(0..max_x, {}, fn _, acc_r ->
        col =
          Enum.reduce(0..max_y, {}, fn _, acc_c ->
            Tuple.append(acc_c, 0)
          end)

        Tuple.append(acc_r, col)
      end)
    end

    defp populate_grid(grid, []), do: grid

    defp populate_grid(grid, [{x1, y1, x2, y2} | tail]) do
      get_all_points(x1, y1, x2, y2)
      |> Enum.reduce(grid, fn {x, y}, new_grid -> increment_grid(new_grid, x, y) end)
      |> populate_grid(tail)
    end

    def get_all_points(x, y1, x, y2), do: Enum.map(y1..y2, fn y -> {x, y} end)
    def get_all_points(x1, y, x2, y), do: Enum.map(x1..x2, fn x -> {x, y} end)
    def get_all_points(_, _, _, _), do: []

    def increment_grid(grid, x, y) do
      current_val =
        grid
        |> elem(x)
        |> elem(y)

      new_column = grid |> elem(x) |> put_elem(y, current_val + 1)
      grid |> put_elem(x, new_column)
    end
  end

  defmodule Part2 do
    def run() do
      input = AoC2021.Day5.get_input()

      input
      |> get_max_coordinates()
      |> create_grid()
      |> populate_grid(input)
      |> Tuple.to_list()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.flat_map(fn e -> e end)
      |> Enum.count(fn e -> e >= 2 end)
    end

    defp get_max_coordinates(input) do
      input
      |> Enum.reduce({0, 0}, fn {x1, y1, x2, y2}, {max_x, max_y} ->
        max_x = Enum.max([x1, x2, max_x])
        max_y = Enum.max([y1, y2, max_y])
        {max_x, max_y}
      end)
    end

    defp create_grid({max_x, max_y}) do
      Enum.reduce(0..max_x, {}, fn _, acc_r ->
        col =
          Enum.reduce(0..max_y, {}, fn _, acc_c ->
            Tuple.append(acc_c, 0)
          end)

        Tuple.append(acc_r, col)
      end)
    end

    defp populate_grid(grid, []), do: grid

    defp populate_grid(grid, [{x1, y1, x2, y2} | tail]) do
      get_all_points(x1, y1, x2, y2)
      |> Enum.reduce(grid, fn {x, y}, new_grid -> increment_grid(new_grid, x, y) end)
      |> populate_grid(tail)
    end

    def get_all_points(x1, y1, x2, y2), do: do_get_all_points(x1, y1, x2, y2, [])

    def do_get_all_points(x, y, x, y, points_list), do: [{x, y} | points_list]

    def do_get_all_points(x1, y1, x2, y2, points_list) do
      new_points_list = [{x1, y1} | points_list]
      new_x = direction(x1, x2).(x1)
      new_y = direction(y1, y2).(y1)
      do_get_all_points(new_x, new_y, x2, y2, new_points_list)
    end

    def direction(p1, p2) when p1 < p2, do: fn p -> p + 1 end
    def direction(p1, p2) when p1 > p2, do: fn p -> p - 1 end
    def direction(p1, p2) when p2 == p1, do: fn p -> p end

    def increment_grid(grid, x, y) do
      current_val =
        grid
        |> elem(x)
        |> elem(y)

      new_column = grid |> elem(x) |> put_elem(y, current_val + 1)
      grid |> put_elem(x, new_column)
    end
  end
end
