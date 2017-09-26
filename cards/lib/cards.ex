defmodule Cards do
  @moduledoc """
    Module to handles a deck of cards.
  """

  @doc """
    Creates a list of cards are in a deck.
  """
  def create_deck do
    suites = ["Hearts", "Spades", "Diamonds", "Clubs"]
    numbers = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine",
                "Ten", "Jack", "Queen", "King"]
    for suit <- suites, number <- numbers do "#{number} of #{suit}" end
  end
  
  @doc """
    takes a list of strings and returns a shuffled list
  """
  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @doc """
    takes a list of strings and checks if a card is in the deck
  """
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @doc """
    deals a hand of x numbers
  """
  def deal(deck , hand_num) do
    Enum.split(deck, hand_num)
  end

  @doc """
    save a deck/hand to file
  """
  def save(hand, filepath) do
    binary = :erlang.term_to_binary(hand)
    File.write(filepath, binary)
  end

  @doc """
    load deck/hand from file
  """
  def load(filepath) do
    case File.read(filepath) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, _} -> "That file doesn't exist"
    end
  end
end