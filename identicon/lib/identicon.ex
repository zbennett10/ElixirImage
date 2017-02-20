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
