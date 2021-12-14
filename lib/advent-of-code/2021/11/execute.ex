defmodule AoC2021.Day11 do
  def get_input() do
    file_path = Path.absname("./lib/advent-of-code/2021/11/input.txt")
    FileReader.read_file(file_path)
  end

  defmodule Part1 do
    def run() do
      lines = AoC2021.Day11.get_input()

      grid =
        for {row_values, row_index} <- Enum.with_index(lines),
            {value, col_index} <- Enum.with_index(String.split(row_values, "", trim: true)),
            into: %{} do
          {{row_index, col_index}, String.to_integer(value)}
        end

      simulate_steps(grid, 0, 100)
    end

    def simulate_steps(_grid, flashes_counter, 0), do: flashes_counter

    def simulate_steps(grid, flashes_counter, steps) do
      flashes =
        Enum.filter(grid, fn {_, v} -> v == 9 end)
        |> Enum.map(fn {k, _} -> k end)

      {new_grid, new_counter} = flash_shockwave(grid, flashes, flashes_counter + length(flashes))

      new_grid = Enum.reduce(new_grid, new_grid, fn {k, v}, acc -> Map.put(acc, k, v + 1) end)

      new_grid =
        Enum.reduce(new_grid, new_grid, fn {k, v}, acc ->
          if v > 9, do: Map.put(acc, k, 0), else: Map.put(acc, k, v)
        end)

      simulate_steps(new_grid, new_counter, steps - 1)
    end

    def flash_shockwave(grid, [], flash_counter), do: {grid, flash_counter}

    def flash_shockwave(grid, [{row, col} | tail], flash_counter) do
      neighbors =
        [
          {row, col + 1},
          {row, col - 1},
          {row - 1, col + 1},
          {row - 1, col},
          {row - 1, col - 1},
          {row + 1, col + 1},
          {row + 1, col},
          {row + 1, col - 1}
        ]
        |> Enum.map(fn coordinates ->
          case Map.get(grid, coordinates) do
            nil -> {coordinates, nil}
            val -> {coordinates, val + 1}
          end
        end)
        |> Enum.filter(fn {_, val} -> val != nil end)

      new_grid =
        Enum.reduce(neighbors, grid, fn {coordinates, new_val}, acc ->
          Map.put(acc, coordinates, new_val)
        end)

      new_flashed =
        Enum.filter(neighbors, fn {_, val} -> val === 9 end)
        |> Enum.map(fn {coordinates, _} -> coordinates end)

      flash_shockwave(new_grid, tail ++ new_flashed, flash_counter + length(new_flashed))
    end
  end

  defmodule Part2 do
    def run() do
      lines = AoC2021.Day11.get_input()

      grid =
        for {row_values, row_index} <- Enum.with_index(lines),
            {value, col_index} <- Enum.with_index(String.split(row_values, "", trim: true)),
            into: %{} do
          {{row_index, col_index}, String.to_integer(value)}
        end

      simulate_steps(grid)
    end

    def simulate_steps(grid, counter \\ 0, steps \\ 0)

    def simulate_steps(grid, counter, steps) when map_size(grid) === counter, do: steps

    def simulate_steps(grid, _counter, steps) do
      flashes =
        Enum.filter(grid, fn {_, v} -> v == 9 end)
        |> Enum.map(fn {k, _} -> k end)

      {new_grid, new_counter} = flash_shockwave(grid, flashes, length(flashes))

      new_grid = Enum.reduce(new_grid, new_grid, fn {k, v}, acc -> Map.put(acc, k, v + 1) end)

      new_grid =
        Enum.reduce(new_grid, new_grid, fn {k, v}, acc ->
          if v > 9, do: Map.put(acc, k, 0), else: Map.put(acc, k, v)
        end)

      simulate_steps(new_grid, new_counter, steps + 1)
    end

    def flash_shockwave(grid, [], flash_counter), do: {grid, flash_counter}

    def flash_shockwave(grid, [{row, col} | tail], flash_counter) do
      neighbors =
        [
          {row, col + 1},
          {row, col - 1},
          {row - 1, col + 1},
          {row - 1, col},
          {row - 1, col - 1},
          {row + 1, col + 1},
          {row + 1, col},
          {row + 1, col - 1}
        ]
        |> Enum.map(fn coordinates ->
          case Map.get(grid, coordinates) do
            nil -> {coordinates, nil}
            val -> {coordinates, val + 1}
          end
        end)
        |> Enum.filter(fn {_, val} -> val != nil end)

      new_grid =
        Enum.reduce(neighbors, grid, fn {coordinates, new_val}, acc ->
          Map.put(acc, coordinates, new_val)
        end)

      new_flashed =
        Enum.filter(neighbors, fn {_, val} -> val === 9 end)
        |> Enum.map(fn {coordinates, _} -> coordinates end)

      flash_shockwave(new_grid, tail ++ new_flashed, flash_counter + length(new_flashed))
    end
  end
end
