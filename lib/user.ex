defmodule User do
  @moduledoc """
  Esse modulo possui a strutura de um usuário e função para criar um cliente.

  A função é: `new/2`
  """
  defstruct name: nil, email: nil

  @doc """
  Função permite criar um novo usuário.

  ## Parametro da função

  - name: nome do usuário
  - email: email de contato

  ## Informações adicionais

  - nome e email é atribuido a uma estrutura de usuário

  ## Exemplo

      iex> User.new "Luana",  "luana@email.com"
      %User{email: "luana@email.com", name: "Luana"}

  """
  def new(name, email), do: %__MODULE__{name: name, email: email}
end
