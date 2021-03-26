defmodule Bank do
  @moduledoc """
  Mundulo que contem funções parser para funções de outros modulos.
  """

  @doc """
  Função que cria os arquivos para adcionar os dados.

  ## Parametro da função

  ## Informações adicionais

  ## Exemplo

      iex> Bank.start()
      :ok

  """
  def start do
    File.write!("contas.txt", :erlang.term_to_binary([]))
    File.write!("transactions.txt", :erlang.term_to_binary([]))
  end
end
