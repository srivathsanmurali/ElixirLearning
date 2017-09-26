defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "create_deck makes 52 cards" do
    deck_length = Cards.create_deck |> length
    assert deck_length == 52
  end

  test "saving and loading hand doesn't change it" do
    hand = Cards.create_hand(5)
    Cards.save(hand, "myhand")
    loaded_hand = Cards.load("myhand")
    assert hand == loaded_hand
  end
end
