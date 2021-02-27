defmodule UserTest do
  use ExUnit.Case
  doctest User

  test "account structure" do
    assert %User{} == %User{email: nil, name: nil}
  end

  describe "new/1" do
    test "create an user" do
      user = User.new("Gissandro","gissandro@gmail.com")

      assert user.name == "Gissandro"
    end
  end

end
