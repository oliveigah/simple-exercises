defmodule ShoppingCartTest do
  use ExUnit.Case

  test "1 book" do
    sc =
      ShoppingCart.new()
      |> ShoppingCart.add_book(1, 1)

    assert %{1 => 1} = sc.cart
    assert sc.full_price == 8
    assert sc.discount_amount == 0
    assert sc.final_price == 8
  end

  test "2 copies of the same book" do
    sc =
      ShoppingCart.new()
      |> ShoppingCart.add_book(1, 2)

    assert %{1 => 2} = sc.cart
    assert sc.full_price == 16
    assert sc.discount_amount == 0
    assert sc.final_price == 16
  end

  test "2 different books" do
    sc =
      ShoppingCart.new()
      |> ShoppingCart.add_book(1, 1)
      |> ShoppingCart.add_book(2, 1)

    assert %{1 => 1, 2 => 1} = sc.cart
    assert sc.full_price == 16
    assert sc.discount_amount == 16 * 0.05
    assert sc.final_price == 16 - 16 * 0.05
  end

  test "3 different books" do
    sc =
      ShoppingCart.new()
      |> ShoppingCart.add_book(1, 1)
      |> ShoppingCart.add_book(2, 1)
      |> ShoppingCart.add_book(3, 1)

    assert %{1 => 1, 2 => 1, 3 => 1} = sc.cart
    assert sc.full_price == 24
    assert sc.discount_amount == 24 * 0.10
    assert sc.final_price == 24 - 24 * 0.10
  end

  test "4 different books" do
    sc =
      ShoppingCart.new()
      |> ShoppingCart.add_book(1, 1)
      |> ShoppingCart.add_book(2, 1)
      |> ShoppingCart.add_book(3, 1)
      |> ShoppingCart.add_book(4, 1)

    assert %{1 => 1, 2 => 1, 3 => 1, 4 => 1} = sc.cart
    assert sc.full_price == 32
    assert sc.discount_amount == 32 * 0.20
    assert sc.final_price == 32 - 32 * 0.20
  end

  test "5 different books" do
    sc =
      ShoppingCart.new()
      |> ShoppingCart.add_book(1, 1)
      |> ShoppingCart.add_book(2, 1)
      |> ShoppingCart.add_book(3, 1)
      |> ShoppingCart.add_book(4, 1)
      |> ShoppingCart.add_book(5, 1)

    assert %{1 => 1, 2 => 1, 3 => 1, 4 => 1, 5 => 1} = sc.cart
    assert sc.full_price == 40
    assert sc.discount_amount == 40 * 0.25
    assert sc.final_price == 40 - 40 * 0.25
  end

  test "2 copies of 1 book and 4 different books" do
    sc =
      ShoppingCart.new()
      |> ShoppingCart.add_book(1, 2)
      |> ShoppingCart.add_book(2, 1)
      |> ShoppingCart.add_book(3, 1)
      |> ShoppingCart.add_book(4, 1)
      |> ShoppingCart.add_book(5, 1)

    assert %{1 => 2, 2 => 1, 3 => 1, 4 => 1, 5 => 1} = sc.cart
    assert sc.full_price == 48
    assert sc.discount_amount == 40 * 0.25
    assert sc.final_price == 48 - 40 * 0.25
  end

  test "3 copies of 1 book and 4 different books" do
    sc =
      ShoppingCart.new()
      |> ShoppingCart.add_book(1, 3)
      |> ShoppingCart.add_book(2, 1)
      |> ShoppingCart.add_book(3, 1)
      |> ShoppingCart.add_book(4, 1)
      |> ShoppingCart.add_book(5, 1)

    assert %{1 => 3, 2 => 1, 3 => 1, 4 => 1, 5 => 1} = sc.cart
    assert sc.full_price == 56
    assert sc.discount_amount == 40 * 0.25
    assert sc.final_price == 56 - 40 * 0.25
  end

  test "2 copies of 2 books and 3 different books" do
    sc =
      ShoppingCart.new()
      |> ShoppingCart.add_book(1, 2)
      |> ShoppingCart.add_book(2, 2)
      |> ShoppingCart.add_book(3, 1)
      |> ShoppingCart.add_book(4, 1)
      |> ShoppingCart.add_book(5, 1)

    assert %{1 => 2, 2 => 2, 3 => 1, 4 => 1, 5 => 1} = sc.cart
    assert sc.full_price == 56
    assert sc.discount_amount == 40 * 0.25 + 16 * 0.05
    assert sc.final_price == 56 - (40 * 0.25 + 16 * 0.05)
  end

  test "2 copies of 3 books and 2 different books" do
    sc =
      ShoppingCart.new()
      |> ShoppingCart.add_book(1, 2)
      |> ShoppingCart.add_book(2, 2)
      |> ShoppingCart.add_book(3, 2)
      |> ShoppingCart.add_book(4, 1)
      |> ShoppingCart.add_book(5, 1)

    assert %{1 => 2, 2 => 2, 3 => 2, 4 => 1, 5 => 1} = sc.cart
    assert sc.full_price == 64
    assert sc.discount_amount == 40 * 0.25 + 24 * 0.10
    assert sc.final_price == 64 - (40 * 0.25 + 24 * 0.10)
  end

  test "2 copies of 4 books and 1 different book" do
    sc =
      ShoppingCart.new()
      |> ShoppingCart.add_book(1, 2)
      |> ShoppingCart.add_book(2, 2)
      |> ShoppingCart.add_book(3, 2)
      |> ShoppingCart.add_book(4, 2)
      |> ShoppingCart.add_book(5, 1)

    assert %{1 => 2, 2 => 2, 3 => 2, 4 => 2, 5 => 1} = sc.cart
    assert sc.full_price == 72
    assert sc.discount_amount == 40 * 0.25 + 32 * 0.20
    assert sc.final_price == 72 - (40 * 0.25 + 32 * 0.20)
  end

  test "2 copies of 5 books" do
    sc =
      ShoppingCart.new()
      |> ShoppingCart.add_book(1, 2)
      |> ShoppingCart.add_book(2, 2)
      |> ShoppingCart.add_book(3, 2)
      |> ShoppingCart.add_book(4, 2)
      |> ShoppingCart.add_book(5, 2)

    assert %{1 => 2, 2 => 2, 3 => 2, 4 => 2, 5 => 2} = sc.cart
    assert sc.full_price == 80
    assert sc.discount_amount == 40 * 0.25 + 40 * 0.25
    assert sc.final_price == 80 - (40 * 0.25 + 40 * 0.25)
  end

  test "5,4,3,2,1 copies of different books" do
    sc =
      ShoppingCart.new()
      |> ShoppingCart.add_book(1, 5)
      |> ShoppingCart.add_book(2, 4)
      |> ShoppingCart.add_book(3, 3)
      |> ShoppingCart.add_book(4, 2)
      |> ShoppingCart.add_book(5, 1)

    assert %{1 => 5, 2 => 4, 3 => 3, 4 => 2, 5 => 1} = sc.cart
    assert sc.full_price == 15 * 8
    assert sc.discount_amount == 40 * 0.25 + 32 * 0.20 + 24 * 0.10 + 16 * 0.05
    assert sc.final_price == 15 * 8 - (40 * 0.25 + 32 * 0.20 + 24 * 0.10 + 16 * 0.05)
  end

  test "7 different books " do
    sc =
      ShoppingCart.new()
      |> ShoppingCart.add_book(1, 1)
      |> ShoppingCart.add_book(2, 1)
      |> ShoppingCart.add_book(3, 1)
      |> ShoppingCart.add_book(4, 1)
      |> ShoppingCart.add_book(5, 1)
      |> ShoppingCart.add_book(6, 1)
      |> ShoppingCart.add_book(7, 1)

    assert %{1 => 1, 2 => 1, 3 => 1, 4 => 1, 5 => 1, 6 => 1, 7 => 1} = sc.cart
    assert sc.full_price == 7 * 8
    assert sc.discount_amount == 5 * 8 * 0.25 + 2 * 8 * 0.05
    assert sc.final_price == 7 * 8 - (40 * 0.25 + 16 * 0.05)
  end

  test "2 copies of 7 different books " do
    sc =
      ShoppingCart.new()
      |> ShoppingCart.add_book(1, 2)
      |> ShoppingCart.add_book(2, 2)
      |> ShoppingCart.add_book(3, 2)
      |> ShoppingCart.add_book(4, 2)
      |> ShoppingCart.add_book(5, 2)
      |> ShoppingCart.add_book(6, 2)
      |> ShoppingCart.add_book(7, 2)

    assert %{1 => 2, 2 => 2, 3 => 2, 4 => 2, 5 => 2, 6 => 2, 7 => 2} = sc.cart
    assert sc.full_price == 14 * 8
    assert sc.discount_amount == 5 * 8 * 0.25 + 5 * 8 * 0.25 + 2 * 8 * 0.05 + 2 * 8 * 0.05
    assert sc.final_price == 14 * 8 - (5 * 8 * 0.25 + 5 * 8 * 0.25 + 2 * 8 * 0.05 + 2 * 8 * 0.05)
  end

  test "2 copies of 2 books and other 5 different books" do
    sc =
      ShoppingCart.new()
      |> ShoppingCart.add_book(1, 2)
      |> ShoppingCart.add_book(2, 2)
      |> ShoppingCart.add_book(3, 1)
      |> ShoppingCart.add_book(4, 1)
      |> ShoppingCart.add_book(5, 1)
      |> ShoppingCart.add_book(6, 1)
      |> ShoppingCart.add_book(7, 1)

    assert %{1 => 2, 2 => 2, 3 => 1, 4 => 1, 5 => 1, 6 => 1, 7 => 1} = sc.cart
    assert sc.full_price == 9 * 8
    assert sc.discount_amount == 5 * 8 * 0.25 + 4 * 8 * 0.2
    assert sc.final_price == 9 * 8 - (5 * 8 * 0.25 + 4 * 8 * 0.2)
  end

  test "1,2,3,4,5,6,7 copies of different book" do
    sc =
      ShoppingCart.new()
      |> ShoppingCart.add_book(1, 1)
      |> ShoppingCart.add_book(2, 2)
      |> ShoppingCart.add_book(3, 3)
      |> ShoppingCart.add_book(4, 4)
      |> ShoppingCart.add_book(5, 5)
      |> ShoppingCart.add_book(6, 6)
      |> ShoppingCart.add_book(7, 7)

    assert %{1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7} = sc.cart
    assert sc.full_price == 28 * 8

    assert sc.discount_amount ==
             5 * 8 * 0.25 + 5 * 8 * 0.25 + 5 * 8 * 0.25 + 4 * 8 * 0.2 + 3 * 8 * 0.1 + 2 * 8 * 0.05 +
               2 * 8 * 0.05

    assert sc.final_price ==
             28 * 8 -
               (5 * 8 * 0.25 + 5 * 8 * 0.25 + 5 * 8 * 0.25 + 4 * 8 * 0.2 + 3 * 8 * 0.1 +
                  2 * 8 * 0.05 + 2 * 8 * 0.05)
  end
end
