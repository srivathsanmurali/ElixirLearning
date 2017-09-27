defmodule Identicon do
  @moduledoc """
    Generate identicon based on a string.
    -> Compute MD5
    -> List of number based on string
    -> Pick a color
    -> Build grid of squares
    -> Convert grid into image
    -> Save image
  """

  @doc """
    will be the main function that is called by the user.
  """
  def main(input) do 
    input
    |> hash_input
    |> pick_color
    |> build_grid
  end

  @doc """
    compute MD5 from string.
  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
          |> :binary.bin_to_list
    %Identicon.Image{hex: hex}
  end

  @doc """
    choose the first three numbers of the hex for RGB values
  """
  def pick_color(%Identicon.Image{hex: [r,g,b | _rest] } = image) do
    %Identicon.Image{image | color: {r,g,b}}
  end

  @doc """
    build the image grid 
  """
  def build_grid(%Identicon.Image{hex: hex_list} = image) do
    grid = hex_list
    |> Enum.chunk(3)
    |> Enum.map(fn [a,b,c] -> [a,b,c,b,a] end)

    %Identicon.Image{image | grid: grid}
  end
end
