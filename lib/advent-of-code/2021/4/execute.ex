defmodule AoC2021.Day4 do
  def get_input() do
    file_path = Path.absname("./lib/advent-of-code/2021/4/input.txt")

    [values_drawn | boards] =
      FileReader.read_file(file_path)
      |> Enum.chunk_by(fn ele -> ele !== "" end)
      |> Enum.filter(fn ele -> ele !== [""] end)

    [parsed_values_drawn] =
      values_drawn
      |> Enum.map(&String.split(&1, ","))

    parsed_boards =
      boards
      |> Enum.map(&Enum.map(&1, fn line -> String.split(line, " ", trim: true) end))

    {parsed_values_drawn, parsed_boards}
  end

  defmodule Part1 do
    def run() do
      {drawn_values, boards} = AoC2021.Day4.get_input()

      boards =
        Enum.map(boards, fn board ->
          %{
            rows: board,
            columns: Enum.map(Enum.zip(board), &Tuple.to_list/1)
          }
        end)

      get_first_winning_board_score(drawn_values, boards)
    end

    defp get_first_winning_board_score([curr_value | remaining_values], boards) do
      new_boards = remove_value_from_boards(curr_value, boards)

      case check_winning_board(new_boards) do
        nil ->
          get_first_winning_board_score(remaining_values, new_boards)

        winning_board ->
          calculate_score(winning_board, curr_value)
      end
    end

    defp remove_value_from_boards(value, boards) do
      Enum.map(boards, fn %{columns: cols, rows: rows} ->
        new_cols = Enum.map(cols, fn col -> col -- [value] end)
        new_rows = Enum.map(rows, fn row -> row -- [value] end)
        %{columns: new_cols, rows: new_rows}
      end)
    end

    defp check_winning_board(boards) do
      Enum.find(boards, fn %{columns: cols, rows: rows} ->
        finish_col = Enum.find(cols, false, fn col -> col === [] end)
        finish_rows = Enum.find(rows, false, fn row -> row === [] end)
        finish_rows || finish_col
      end)
    end

    defp calculate_score(board, last_value_drawn) do
      remaining_sum =
        board
        |> Map.get(:rows)
        |> Enum.flat_map(fn e -> e end)
        |> Enum.map(&String.to_integer/1)
        |> Enum.sum()

      remaining_sum * String.to_integer(last_value_drawn)
    end
  end

  defmodule Part2 do
    def run() do
      {drawn_values, boards} = AoC2021.Day4.get_input()

      boards =
        Enum.map(boards, fn board ->
          %{
            rows: board,
            columns: Enum.map(Enum.zip(board), &Tuple.to_list/1)
          }
        end)

      [result | _] = get_last_winning_board_score(drawn_values, boards, nil)
      result
    end

    defp get_last_winning_board_score([], _boards, last_winning_scores), do: last_winning_scores

    defp get_last_winning_board_score(
           [curr_value | remaining_values],
           boards,
           last_winning_scores
         ) do
      new_boards = remove_value_from_boards(curr_value, boards)

      case check_winning_board(new_boards) do
        [] ->
          get_last_winning_board_score(remaining_values, new_boards, last_winning_scores)

        winning_boards ->
          new_boards = new_boards -- winning_boards
          new_last_winning_scores = calculate_score(winning_boards, curr_value)
          get_last_winning_board_score(remaining_values, new_boards, new_last_winning_scores)
      end
    end

    defp remove_value_from_boards(value, boards) do
      Enum.map(boards, fn %{columns: cols, rows: rows} ->
        new_cols = Enum.map(cols, fn col -> col -- [value] end)
        new_rows = Enum.map(rows, fn row -> row -- [value] end)
        %{columns: new_cols, rows: new_rows}
      end)
    end

    defp check_winning_board(boards) do
      Enum.filter(boards, fn %{columns: cols, rows: rows} ->
        finish_col = Enum.find(cols, false, fn col -> col === [] end)
        finish_rows = Enum.find(rows, false, fn row -> row === [] end)
        finish_rows || finish_col
      end)
    end

    defp calculate_score(winning_boards, last_value_drawn) do
      Enum.map(winning_boards, fn board ->
        remaining_sum =
          board
          |> Map.get(:rows)
          |> Enum.flat_map(fn e -> e end)
          |> Enum.map(&String.to_integer/1)
          |> Enum.sum()

        remaining_sum * String.to_integer(last_value_drawn)
      end)
    end
  end
end
