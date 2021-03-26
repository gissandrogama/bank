defmodule TransactionsTest do
  use ExUnit.Case
  doctest Trasactions

  setup do
    File.write!("contas.txt", :erlang.term_to_binary([]))
    File.write!("transactions.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("contas.txt")
      File.rm("transactions.txt")
    end)
  end

  test "trasactions structure" do
    assert %Trasactions{} == %Trasactions{
             date: Date.utc_today(),
             of: nil,
             to: nil,
             type: nil,
             value: 0
           }
  end

  describe "get_all/0" do
    test "get all transactions" do
      Account.register(%User{name: "Gissandro", email: "gissandro@gmail.com"})
      Account.register(%User{name: "Gissandro", email: "luana@gmail.com"})
      Account.transfer("gissandro@gmail.com", "luana@gmail.com", 500)

      assert Trasactions.get_all() == [
               %Trasactions{
                 date: ~D[2021-03-26],
                 of: %Account{
                   balance: 500,
                   user: %User{email: "gissandro@gmail.com", name: "Gissandro"}
                 },
                 to: %Account{
                   balance: 1500,
                   user: %User{email: "luana@gmail.com", name: "Gissandro"}
                 },
                 type: "transaction",
                 value: 500
               }
             ]
    end
  end
end
