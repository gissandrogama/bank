defmodule BankTest do
  use ExUnit.Case
  doctest Bank

  test "start/0" do
    assert Bank.start() == :ok
  end
end
