defmodule ShoppingCart do
  @book_price 8

  @discounts %{
    2 => 0.05,
    3 => 0.1,
    4 => 0.2,
    5 => 0.25
  }

  defstruct cart: %{},
            discount_amount: 0,
            full_price: 0,
            final_price: 0

  def new() do
    %ShoppingCart{}
  end

  def add_book(%ShoppingCart{} = shopping_cart, book, quantity) when quantity > 0 do
    current_cart = Map.get(shopping_cart, :cart)
    current_quantity = Map.get(current_cart, book, 0)

    new_quantity = current_quantity + quantity
    new_cart = Map.put(current_cart, book, new_quantity)

    Map.put(shopping_cart, :cart, new_cart)
    |> update_full_price()
    |> update_discount()
    |> update_final_price()
  end

  def remove_book(%ShoppingCart{} = shopping_cart, book, quantity) when quantity > 0 do
    current_cart = Map.get(shopping_cart, :cart)
    current_quantity = Map.get(current_cart, book, 0)

    new_quantity = current_quantity - quantity

    new_cart =
      if new_quantity > 0,
        do: Map.put(current_cart, book, new_quantity),
        else: Map.delete(current_cart, book)

    Map.put(shopping_cart, :cart, new_cart)
    |> update_full_price()
    |> update_discount()
    |> update_final_price()
  end

  defp update_full_price(%ShoppingCart{} = shopping_cart) do
    shopping_cart
    |> Map.put(:full_price, calculate_full_price(shopping_cart.cart))
  end

  defp update_discount(%ShoppingCart{} = shopping_cart) do
    cart_list = Map.to_list(shopping_cart.cart)

    shopping_cart
    |> Map.put(:discount_amount, calculate_discount(cart_list))
  end

  defp update_final_price(%ShoppingCart{} = shopping_cart) do
    final_price = shopping_cart.full_price - shopping_cart.discount_amount
    Map.put(shopping_cart, :final_price, final_price)
  end

  defp calculate_discount(cart_list, discount \\ 0)

  defp calculate_discount([_h | [_ | _]] = cart_list, discount) do
    qtd_unique_books = length(cart_list)
    discount_rate = Map.get(@discounts, qtd_unique_books)
    discount_amount = discount + discount_rate * (qtd_unique_books * @book_price)

    cart_list
    |> remove_unique_books()
    |> calculate_discount(discount_amount)
  end

  defp calculate_discount(_, discount) do
    discount
  end

  defp remove_unique_books([_h | _t] = cart_list) do
    cart_list
    |> Stream.map(fn {book, quantity} -> {book, quantity - 1} end)
    |> Enum.filter(fn {_book, quantity} -> quantity > 0 end)
  end

  defp calculate_full_price(cart) do
    cart
    |> Enum.reduce(0, fn {_book, quantity}, acc -> acc + quantity * @book_price end)
  end
end
