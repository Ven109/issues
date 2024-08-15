defmodule Issues.TableFormatterTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  alias Issues.TableFormatter, as: TF

  @simple_test_data [
    %{"number" => 1, "created_at" => "2021-01-01", "title" => "First"},
    %{"number" => 2, "created_at" => "2021-01-02", "title" => "Secon"},
    %{"number" => 3, "created_at" => "2021-01-03", "title" => "Third"}
  ]

  @headers ["number", "created_at", "title"]

  def split_with_three_columns do
    TF.split_into_columns(@simple_test_data, @headers)
  end

  test "split_into_columns" do
    columns = split_with_three_columns()
    assert length(columns) == length(@headers)
    assert List.first(columns) == ["1", "2", "3"]
    assert List.last(columns) == ["First", "Secon", "Third"]
  end

  test "columns_width" do
    widths = TF.calculate_column_widths(split_with_three_columns())
    assert widths == [1, 10, 5]
  end

  test "correct format string returned" do
    assert TF.format_for([9, 10, 12]) == "~-9s | ~-10s | ~-12s~n"
  end

  test "Outputs is correct" do
    result =
      capture_io(fn ->
        TF.format(@simple_test_data, @headers)
      end)

    assert result == """
           n | created_at | title
           --+------------+-------
           1 | 2021-01-01 | First
           2 | 2021-01-02 | Secon
           3 | 2021-01-03 | Third
           """
  end
end
