defmodule Bank do

  def start do
      File.write!("contas.txt", :erlang.term_to_binary([]))
  end
end
