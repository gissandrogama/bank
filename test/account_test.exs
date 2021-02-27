defmodule AccountTest do
  use ExUnit.Case
  doctest Account

  test "account structure" do
    assert %Account{} == %Account{balance: 1000, user: User}
  end

  describe "register/1" do
    test "create an account for a user" do
      account = Account.register(%User{name: "Gissandro", email: "gissandro@gmail.com"})

      assert account.user.name == "Gissandro"
    end
  end

  describe "transfer/1" do
    test "retornar uma lista de contas com a transferencia feita" do
      c1 = Account.register(%User{name: "jose", email: "jose@email.com"})
      c2 = Account.register(%User{name: "maria", email: "maria@gmail.com"})

      assert Account.transfer([c1, c2], c1, c2, 550) == [
               %Account{balance: 450, user: %User{email: "jose@email.com", name: "jose"}},
               %Account{balance: 1550, user: %User{email: "maria@gmail.com", name: "maria"}}
             ]
    end

    test "retornar um erro quando a conta não tem saldo suficiente" do
      c1 = Account.register(%User{name: "jose", email: "jose@email.com"})
      c2 = Account.register(%User{name: "maria", email: "maria@gmail.com"})

      assert Account.transfer([c1, c2], c1, c2, 2000) == {:error, "insufficient funds"}
    end
  end

  describe "withdraw/2" do
    test "retornar conta com calculo feirto e mensagem" do
      c1 = Account.register(%User{name: "jose", email: "jose@email.com"})
      {:ok, account, message} = Account.withdraw(c1, 200)

      assert account.balance == 800
      assert message == "email message sent"
    end
  end
end
