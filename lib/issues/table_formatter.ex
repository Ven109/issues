defmodule Issues.TableFormatter do
  def format(issues, headers) do
    with data_by_columns = split_into_columns(issues, headers),
         column_widths = calculate_column_widths(data_by_columns),
         format = format_for(column_widths) do
      puts_one_line_in_columns(headers, format)
      IO.write(seperator(column_widths))
      puts_in_columns(data_by_columns, format)
    end
  end

  def format_for(column_widths) do
    Enum.map_join(column_widths, " | ", &"~-#{&1}s") <> "~n"
  end

  def calculate_column_widths(data_by_columns) do
    Enum.map(data_by_columns, fn column -> Enum.map(column, &String.length/1) |> Enum.max() end)
  end

  def split_into_columns(issues, headers) do
    for header <- headers do
      for issue <- issues do
        printable(issue[header])
      end
    end
  end

  def printable(value) when is_binary(value), do: value
  def printable(value), do: to_string(value)

  def puts_in_columns(data_by_columns, format) do
    data_by_columns
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.each(&puts_one_line_in_columns(&1, format))
  end

  def puts_one_line_in_columns(fields, format) do
    :io.format(format, fields)
  end

  def seperator(column_widths) do
    Enum.map_join(column_widths, "-+-", &List.duplicate("-", &1)) <> "-\n"
  end
end
