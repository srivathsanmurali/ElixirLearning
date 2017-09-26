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
  
  ## Examples

      iex> deck = Cards.create_deck
      iex> Cards.contains?(deck, "Nine of Hearts")
      true
      iex> Cards.contains?(deck, "Ace of Waters")
      false
  """
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @doc """
    deals a hand of x numbers

  ## Examples

      iex> deck = Cards.create_deck
      iex> {hand, remaining_deck} = Cards.deal(deck, 1)
      iex> hand == ["Ace of Hearts"]
      true
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

  @doc """
    creates a deck, shuffles it then deals a hand
  """
  def create_hand(hand_size) do
    Cards.create_deck
    |> Cards.shuffle
    |> Cards.deal(hand_size)
  end
end
