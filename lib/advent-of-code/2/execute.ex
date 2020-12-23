defmodule AoC.Challenge2 do
  def run_part_1 do
    get_input()
    |> Stream.map(&parse_input_line/1)
    |> Stream.map(&verify_input_1/1)
    |> Enum.count(fn is_valid -> is_valid end)
  end

  def run_part_2 do
    get_input()
    |> Stream.map(&parse_input_line/1)
    |> Stream.map(&verify_input_2/1)
    |> Enum.count(fn is_valid -> is_valid end)
  end

  defp verify_input_1({min, max, rule_letter, password}) do
    parsed_rule_letter = List.first(String.to_charlist(rule_letter))
    rule_letter_qty =
      password
      |> String.to_charlist()
      |> Enum.count(fn letter -> letter == parsed_rule_letter end)

    rule_letter_qty <= max and rule_letter_qty >= min
  end

  defp verify_input_2({first, second, rule_letter, password}) do
    parsed_rule_letter = List.first(String.to_charlist(rule_letter))
    parsed_password = String.to_charlist(password)
    first_letter = Enum.at(parsed_password, first-1)
    second_letter = Enum.at(parsed_password, second-1)

    match_first = first_letter == parsed_rule_letter
    match_second = second_letter == parsed_rule_letter

    match_first != match_second
  end

  defp parse_input_line(line) do
    [rule_text, password] = String.split(line, ":")
    {min, max, rule_letter} = parse_rule(rule_text)
    {String.to_integer(min), String.to_integer(max), rule_letter, String.trim(password)}
  end

  defp parse_rule(rule_text) do
    [min_max_text, rule_letter] = String.split(rule_text, " ")
    [min, max] = String.split(min_max_text, "-")
    {min, max, rule_letter}
  end

  defp get_input do
    file_path = Path.absname("./lib/advent-of-code/2/input.txt")
    FileReader.read_file(file_path)
  end
end
