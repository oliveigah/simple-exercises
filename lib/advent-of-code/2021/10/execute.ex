defmodule AoC2021.Day10 do
  def get_input() do
    file_path = Path.absname("./lib/advent-of-code/2021/10/input.txt")
    FileReader.read_file(file_path)
  end

  defmodule Part1 do
    def run() do
      AoC2021.Day10.get_input()
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.map(&validate_syntax(&1, []))
      |> Enum.filter(fn {status, _val} -> status === :error end)
      |> Enum.map(fn {_, val} -> val end)
      |> Enum.map(fn
        ")" -> 3
        "]" -> 57
        "}" -> 1197
        ">" -> 25137
      end)
      |> Enum.frequencies()
      |> Enum.map(fn {val, freq} -> val * freq end)
      |> Enum.sum()
    end

    def validate_syntax([")" | t_line], ["(" | t_stack]), do: validate_syntax(t_line, t_stack)
    def validate_syntax(["]" | t_line], ["[" | t_stack]), do: validate_syntax(t_line, t_stack)
    def validate_syntax(["}" | t_line], ["{" | t_stack]), do: validate_syntax(t_line, t_stack)
    def validate_syntax([">" | t_line], ["<" | t_stack]), do: validate_syntax(t_line, t_stack)

    def validate_syntax(["(" | t_line], stack), do: validate_syntax(t_line, ["(" | stack])
    def validate_syntax(["[" | t_line], stack), do: validate_syntax(t_line, ["[" | stack])
    def validate_syntax(["{" | t_line], stack), do: validate_syntax(t_line, ["{" | stack])
    def validate_syntax(["<" | t_line], stack), do: validate_syntax(t_line, ["<" | stack])

    def validate_syntax([], []), do: {:ok, :complete}
    def validate_syntax([], [_ | _]), do: {:ok, :incomplete}

    def validate_syntax([val | _t_line], _stack), do: {:error, val}
  end

  defmodule Part2 do
    def run() do
      sorted_list =
        AoC2021.Day10.get_input()
        |> Enum.map(&String.split(&1, "", trim: true))
        |> Enum.map(&validate_syntax(&1, []))
        |> Enum.filter(fn {status, _stack} -> status === :incomplete end)
        |> Enum.map(fn {_, stack} -> stack end)
        |> Enum.map(fn stack ->
          Enum.reduce(stack, 0, fn
            ")", acc -> acc * 5 + 1
            "]", acc -> acc * 5 + 2
            "}", acc -> acc * 5 + 3
            ">", acc -> acc * 5 + 4
          end)
        end)
        |> Enum.sort()

      Enum.at(sorted_list, floor(length(sorted_list) / 2))
    end

    def validate_syntax([val | t_line], [val | t_stack]), do: validate_syntax(t_line, t_stack)

    def validate_syntax(["(" | t_line], stack), do: validate_syntax(t_line, [")" | stack])
    def validate_syntax(["[" | t_line], stack), do: validate_syntax(t_line, ["]" | stack])
    def validate_syntax(["{" | t_line], stack), do: validate_syntax(t_line, ["}" | stack])
    def validate_syntax(["<" | t_line], stack), do: validate_syntax(t_line, [">" | stack])

    def validate_syntax([], []), do: {:ok, :complete}
    def validate_syntax([], stack), do: {:incomplete, stack}

    def validate_syntax([val | _t_line], _stack), do: {:error, val}
  end
end
