defmodule Identicon do
  @moduledoc """
  Documentation for Identicon.
  """

  #receive string input and pipe following functions
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250,250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) -> 
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  #compute MD5 hash of input string
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex} #assign hashed string to image struct

  end
  #pick color
  def pick_color(image) do
    %Identicon.Image{hex: [r, g, b | _tail]} = image #pattern match first 3 values of image hex
    %Identicon.Image{image | color: {r,g,b}}

  end

  #filter odd squares
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn({code, _index}) ->
      rem(code, 2) == 0
     end

     %Identicon.Image{image | grid: grid}
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  #build grid of squares
  def build_grid(image) do
    %Identicon.Image{hex: hex} = image
    grid = hex
    |> Enum.chunk(3)
    |> Enum.map(&mirror_row/1) #pass a reference to the mirror_row function that has an arity of 1
    |> List.flatten #prevent nested iteration in future
    |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  #mirror a row
  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first] #append first two elements to row
  end

  #convert grid into image

  #save image
end
