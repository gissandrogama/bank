defmodule AccountTest do
  use ExUnit.Case
  doctest Account

  setup do
    File.write!("contas.txt", :erlang.term_to_binary([]))
    File.write!("transactions.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("contas.txt")
      File.rm("transactions.txt")
    end)
  end

  test "account structure" do
    assert %Account{} == %Account{balance: 1000, user: User}
  end

  describe "register/1" do
    test "create an account for a user" do
      Account.register(%User{name: "Gissandro", email: "gissandro@gmail.com"})
      [account] = Account.get_accounts()

      assert account.user.name == "Gissandro"
    end
  end

  describe "transfer/1" do
    test "retornar uma lista de contas com a transferencia feita" do
      Account.register(%User{name: "jose", email: "jose@email.com"})
      Account.register(%User{name: "maria", email: "maria@gmail.com"})

      assert Account.transfer("jose@email.com", "maria@gmail.com", 550) == :ok

      assert Account.get_accounts() == [
               %Account{balance: 450, user: %User{email: "jose@email.com", name: "jose"}},
               %Account{balance: 1550, user: %User{email: "maria@gmail.com", name: "maria"}}
             ]
    end

    test "retornar um erro quando a conta não tem saldo suficiente" do
      Account.register(%User{name: "jose", email: "jose@email.com"})
      Account.register(%User{name: "maria", email: "maria@gmail.com"})

      assert Account.transfer("jose@email.com", "maria@gmail.com", 2000) ==
               {:error, "insufficient funds"}
    end
  end

  describe "withdraw/2" do
    test "retornar conta com calculo feirto e mensagem" do
      Account.register(%User{name: "jose", email: "jose@email.com"})
      {:ok, account, message} = Account.withdraw("jose@email.com", 200)

      assert account.balance == 800
      assert message == "email message sent"
    end
  end
end
