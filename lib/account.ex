defmodule Account do
  @moduledoc """
  Esse modulo possui função que vincula usuários a contas, efetua transferencia de valores
  e possibilita o saque de valores.

  As funções são: `register/1`, `tansfer/4` e `withdraw/2`
  """
  defstruct user: User, balance: 1000
  @accounts "contas.txt"

  @doc """
  Essa função associa um usuário a uma conta.

  ## Parametro da função

  - user: estrutura de usuário

  ## Informações adicionais

  - usuário inicia a conta com o valor de 1000

  ## Exemplo

      iex> Account.register %User{name: "Luana", email: "luana@email.com"}
      :ok
  """
  def register(user) do
    case get_to_email(user.email) do
      nil ->
        binary =
          ([%__MODULE__{user: user}] ++ get_accounts())
          |> :erlang.term_to_binary()

        File.write!(@accounts, binary)

      _ ->
        {:error, "Account already exit!"}
    end
  end

  @doc """
  Função ler o arquivo `"contas.txt"` e exibe os dados salvos nele.

  ## Parametro da função

  ## Informações adicionais

  - caso não exista nenhum dado salvo é retornado uma lista vazia.

  ## Exemplo

      iex> Account.register(%User{name: "Henry", email: "henry@email.com"})
      iex> Account.get_accounts()
      [
        %Account{
          balance: 1000,
          user: %User{name: "Henry", email: "henry@email.com"}
        }
      ]

  """
  def get_accounts do
    {:ok, binary} = File.read(@accounts)
    :erlang.binary_to_term(binary)
  end

  @doc """
  Funcionalidade de executar uma transferencia de valores de uma conta para outra.

  ## Parametro da função

  - accounts: uma lista com as contas
  - of: conta que vai transferir o valor
  - to: conta que vai receber o valor
  - value: valor a ser transferido

  ## Informações adicionais

  - caso a conta que está enviando o valor, não tiver saldo é retornado um erro

  ## Exemplo

      iex> Account.register(%User{name: "Gissandro", email: "gissandro@email.com"})
      iex> Account.register(%User{name: "Henry", email: "henry@email.com"})
      iex> Account.transfer("gissandro@email.com", "henry@email.com", 500)
      :ok

  """
  def transfer(of, to, value) do
    of = get_to_email(of)
    to = get_to_email(to)

    cond do
      valid_balance(of.balance, value) ->
        {:error, "insufficient funds"}

      true ->
        accounts = delete([of, to])
        of = %Account{of | balance: of.balance - value}
        to = %Account{to | balance: to.balance + value}
        accounts = accounts ++ [of, to]

        Transactions.record("transaction", of, value, Date.utc_today(), to)

        File.write!(@accounts, :erlang.term_to_binary(accounts))
    end
  end

  defp get_to_email(email), do: Enum.find(get_accounts(), &(&1.user.email == email))

  def delete(account_delete) do
    Enum.reduce(account_delete, get_accounts(), fn c, acc -> List.delete(acc, c) end)
  end

  @doc """
  Função que permite que um usuário faça um saque.

  ## Parametro da função

  - account: conta que será retirado o dinheiro
  - value: valor do saque

  ## Informações adicionais

  - caso a conta não tiver saldo suficiente é retornado um erro

  ## Exemplo

      iex> Account.register(%User{name: "Gissandro", email: "gissandro@email.com"})
      iex> Account.withdraw("gissandro@email.com", 500)
      {:ok, %Account{
        balance: 500,
        user: %User{email: "gissandro@email.com", name: "Gissandro"}
      }, "email message sent"}

  """
  def withdraw(account, value) do
    account = get_to_email(account)

    cond do
      valid_balance(account.balance, value) ->
        {:error, "insufficient funds"}

      true ->
        accounts = delete([account])
        account = %Account{account | balance: account.balance - value}
        accounts = accounts ++ [account]

        Transactions.record("withdraw", account, value, Date.utc_today(), nil)

        File.write!(@accounts, :erlang.term_to_binary(accounts))
        {:ok, account, "email message sent"}
    end
  end

  defp valid_balance(balance, value), do: balance < value
end
