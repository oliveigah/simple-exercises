defmodule FileReader do
  def read_file(path) do
    File.stream!(path)
    |> Enum.map(&String.replace(&1, "\n", ""))
  end
end
