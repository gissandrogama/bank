defmodule Transactions do
  defstruct date: Date.utc_today(), type: nil, value: 0, of: nil, to: nil

  @transactions "transactions.txt"

  def record(type, of, value, date, to) do
    transactions =
      get_transactions() ++ [%__MODULE__{type: type, of: of, value: value, date: date, to: to}]

    File.write(@transactions, :erlang.term_to_binary(transactions))
  end

  def get_all, do: get_transactions()

  def get_transactions do
    {:ok, binary} = File.read(@transactions)

    binary |> :erlang.binary_to_term()
  end
end
