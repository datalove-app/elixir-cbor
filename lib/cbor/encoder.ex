defmodule Cbor.Encoder do
  alias Cbor.Types

  def encode(value) do
      case value do
        value when is_integer(value) ->
          concat(Types.unsigned_integer, encode_unsigned_int(value))
        value when is_atom(value) ->
          concat(Types.string, encode_string(value))
        value when is_list(value) ->
          concat(Types.array, encode_array(value))
        value when is_map(value) ->
          concat(Types.map, encode_map(value))
      end
  end

  def concat(left, right) do
    <<left::bitstring, right::bitstring>>
  end

  def encode_array(value) do
    length = encode_unsigned_int(length(value))
    values =  Enum.map(value, &encode/1) |> Enum.join

    concat(length, values)
  end

  def encode_map(value) do
    length = encode_unsigned_int(map_size(value))
    values =  value
      |> Map.keys()
      |> Enum.map(fn(key) ->
        # IO.inspect key
        # IO.inspect value[key]
        # IO.inspect encode(key)
        # IO.inspect encode(value[key])
        concat(encode(key), encode(value[key]))
      end)
      |> Enum.reduce(<<>>, &concat/2)

    # IO.inspect length
    # IO.inspect values
    concat(length, values)
  end

  def encode_string(value) do
    string = to_string(value)
    length = encode_unsigned_int(String.length(string))
    concat(length, string)
  end

  def encode_unsigned_int(value) do
    case value do
      value when value in 0..24 ->
        <<value::5>>
      value when value in 25..0x100 ->
        <<24::size(5), value>>
    end
  end
end
