defmodule Cbor.Types do
  @unsigned_integer <<0b000::3>>
  @byte_string <<0b010::3>>
  @string <<0b011::3>>
  @array <<0b100::3>>
  @map <<0b101::3>>
  @primative <<0b111::3>>

  def unsigned_integer, do: @unsigned_integer
  def byte_string, do: @byte_string
  def string, do: @string
  def array, do: @array
  def map, do: @map
  def primative, do: @primative
end
