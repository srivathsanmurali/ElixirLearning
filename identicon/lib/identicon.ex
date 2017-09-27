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
    |> filter_grid
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
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
    grid =
      hex_list
      |> Enum.chunk(3)
      |> Enum.map(fn [a,b,c] -> [a,b,c,b,a] end)
      |> List.flatten

    %Identicon.Image{image | grid: grid}
  end

  @doc """
    Filtering out the image for pixels that will be coloured

    Rule:
    -> remove multiples of 3
  """
  def filter_grid(%Identicon.Image{grid: grid} = image) do
    grid =
      grid
      |> Enum.with_index
      |> Enum.filter(fn {x, _ind} -> rem(x,3) == 0 end)
    %Identicon.Image{image | grid: grid}
  end

  @doc """
    Builds a pixel map with current grid
  """
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = 
      Enum.map grid, fn {_code, index} ->
        hor = rem(index, 5) * 50
        vert = div(index,5) * 50
        
        {{hor, vert}, {hor+50, vert+50}}
      end
    %Identicon.Image{image | pixel_map: pixel_map}
  end

  @doc """
    Draw the image
  """
  def draw_image(%Identicon.Image{pixel_map: pixel_map, color: color}) do
    image = :egd.create(250,250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn {start, stop} ->
      # Modifying image variable
      :egd.filledRectangle(image, start, stop, fill)
    end
    
    :egd.render(image)
  end

  @doc """
    Save to image
  """
  def save_image(image, input) do
    File.write("#{input}.png", image) 
  end
end
