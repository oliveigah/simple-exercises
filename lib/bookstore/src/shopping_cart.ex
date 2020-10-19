defmodule ShoppingCart do
  @book_price 8

  @discounts %{
    2 => 0.05,
    3 => 0.1,
    4 => 0.2,
    5 => 0.25
  }

  defstruct cart: %{},
            discount_path: [],
            discount_amount: 0,
            full_price: 0,
            final_price: 0

  def new() do
    %ShoppingCart{}
  end

  def add_book(%ShoppingCart{} = shopping_cart, book, quantity) when quantity > 0 do
    shopping_cart
    |> update_cart(:add, book, quantity)
  end

  def remove_book(%ShoppingCart{} = shopping_cart, book, quantity) when quantity > 0 do
    shopping_cart
    |> update_cart(:remove, book, quantity)
  end

  def apply_discount(%ShoppingCart{} = shopping_cart) do
    IO.puts("---------------------------------")
    IO.inspect(shopping_cart.cart)

    shopping_cart
    |> update_full_price()
    |> update_discount()
    |> update_final_price()
  end

  defp update_cart(%ShoppingCart{} = shopping_cart, :add, book, quantity) do
    current_cart = Map.get(shopping_cart, :cart)
    current_quantity = Map.get(current_cart, book, 0)

    new_quantity = current_quantity + quantity
    new_cart = Map.put(current_cart, book, new_quantity)

    Map.put(shopping_cart, :cart, new_cart)
  end

  defp update_cart(%ShoppingCart{} = shopping_cart, :remove, book, quantity) do
    current_cart = Map.get(shopping_cart, :cart)
    current_quantity = Map.get(current_cart, book, 0)

    new_quantity = current_quantity - quantity

    new_cart =
      if new_quantity > 0,
        do: Map.put(current_cart, book, new_quantity),
        else: Map.delete(current_cart, book)

    Map.put(shopping_cart, :cart, new_cart)
  end

  defp update_full_price(%ShoppingCart{} = shopping_cart) do
    shopping_cart
    |> Map.put(:full_price, calculate_full_price(shopping_cart.cart))
  end

  defp calculate_full_price(cart) do
    cart
    |> Enum.reduce(0, fn {_book, quantity}, acc -> acc + quantity * @book_price end)
  end

  defp update_discount(%ShoppingCart{} = shopping_cart) do
    {discount, path} = calculate_discount(shopping_cart.cart)

    shopping_cart
    |> Map.put(:discount_amount, discount)
    |> Map.put(:discount_path, path)
  end

  defp calculate_discount(%{} = cart) do
    bundles = map_size(@discounts) + 1

    Enum.map(2..bundles, fn bundle_size ->
      calculate_discount_recursive(cart, bundle_size, {0, []})
    end)
    |> find_biggest()
  end

  defp calculate_discount_recursive(cart, bundle_size, {acc_discount, acc_path})
       when map_size(cart) >= bundle_size do
    discount_rate = Map.get(@discounts, bundle_size, 0)
    discount_amount = acc_discount + discount_rate * (bundle_size * @book_price)
    remaining_cart = remove_unique_books(cart, bundle_size)
    bundles = map_size(@discounts) + 1

    # This line prevents spend computation on paths that will result on termination
    # For instance if the cart only has 3 different books remaining,
    # all bundles with size 4 or more will lead to branch termination
    # and this will lead to a lower discount value since it still has enough books to discount.
    # The max(2, (...)) is used, because the recursion must end, and the guard map_size(cart) >= bundle_size does that
    # if a cart has less books than the lowest bundle size it will be terminated
    # Without max, the new_bundles could be a value lower than 2, leading to undesired behaviour
    # So the minimal bundle size must be the lowest key on @discounts
    new_bundles = max(2, min(bundles, map_size(remaining_cart)))

    Enum.map(2..new_bundles, fn next_bundle_size ->
      calculate_discount_recursive(
        remaining_cart,
        next_bundle_size,
        {discount_amount, acc_path ++ [bundle_size]}
      )
    end)
    |> find_biggest()
  end

  defp calculate_discount_recursive(_, _, {result_discount, result_path}) do
    IO.puts(inspect({result_path, result_discount}))
    {result_discount, result_path}
  end

  defp find_biggest(list) do
    list
    |> Enum.reduce({0, []}, fn {discount, path}, acc ->
      if discount >= elem(acc, 0), do: {discount, path}, else: acc
    end)
  end

  defp remove_unique_books(%{} = cart, qty_to_remove) do
    {books_to_remove, rest} = Enum.split(cart, qty_to_remove)

    new_books =
      books_to_remove
      |> Stream.map(fn {book, quantity} -> {book, quantity - 1} end)
      |> Enum.filter(fn {_book, quantity} -> quantity > 0 end)

    (new_books ++ rest)
    |> Enum.reduce(%{}, fn {book, quantity}, acc -> Map.put(acc, book, quantity) end)
  end

  defp update_final_price(%ShoppingCart{} = shopping_cart) do
    final_price = shopping_cart.full_price - shopping_cart.discount_amount
    Map.put(shopping_cart, :final_price, final_price)
  end
end
