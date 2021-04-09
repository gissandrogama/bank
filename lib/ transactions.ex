defmodule Transactions do
  @moduledoc """
  Esse modulo possui função que gravação as transações de contas, buscam transações por dia, mês e ano.
  E também calculam o total dessas transações por dia, mês e ano.
  """
  defstruct date: Date.utc_today(), type: nil, value: 0, of: nil, to: nil

  @transactions "transactions.txt"

  @doc """
  Essa função grava as transações de contas.

  ## Parametro da função

  - type: tipo de transação efetuado na conta
  - of: conta de origem
  - value: valor da transação
  - date: data que da transação
  - to: conta para onde vai caso de transferência

  ## Informações adicionais

  - Se a tranzação for do tipo "transaction" as informações de `of` e `to`, são obrigatórias.
  - Se for do tipo "withdraw" só `of` é passado e `to` recebe nil

  ## Exemplo

      iex> account = Account.register(%User{name: "Gissandro", email: "gissandro@email.com"})
      iex> Transactions.record("withdraw", account, 50, Date.utc_today(), nil)
      :ok
  """
  def record(type, of, value, date, to) do
    transactions =
      get_transactions() ++ [%__MODULE__{type: type, of: of, value: value, date: date, to: to}]

    File.write(@transactions, :erlang.term_to_binary(transactions))
  end

  @doc """
  Função ler o arquivo `"transactions.txt"` e exibe os dados salvos nele.

  ## Parametro da função

  ## Informações adicionais

  - caso não exista nenhum dado salvo é retornado uma lista vazia.

  ## Exemplo

      iex> Account.register(%User{name: "Henry", email: "henry@email.com"})
      iex> Account.withdraw("henry@email.com", 50)
      iex> Transactions.get_all()
      [
         %Transactions{date: ~D[2021-04-09], of: %Account{balance: 950, user: %User{email: "henry@email.com", name: "Henry"}}, to: nil, type: "withdraw", value: 50}
      ]

  """
  def get_all, do: get_transactions()

  def for_year(year), do: Enum.filter(get_all(), &(&1.date.year == year))

  def for_month(month, year),
    do: Enum.filter(get_all(), &(&1.date.year == year && &1.date.month == month))

  def for_day(date), do: Enum.filter(get_all(), &(&1.date == date))

  def calculate_all, do: get_all() |> calculate()

  def calculate_month(month, year), do: for_month(month, year) |> calculate()

  def calculate_year(year), do: for_year(year) |> calculate()

  def calculate_day(date), do: for_day(date) |> calculate()

  defp calculate(transactions) do
    {transactions, Enum.reduce(transactions, 0, fn t, acc -> acc + t.value end)}
  end

  def get_transactions do
    {:ok, binary} = File.read(@transactions)

    binary |> :erlang.binary_to_term()
  end
end
