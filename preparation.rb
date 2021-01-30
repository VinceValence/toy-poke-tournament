# frozen_string_literal: true

require 'net/http'

def gen_ids
  # Generate eight ids in the range 1..151.
  # Here, an id candidate is generated eight
  # times, in each
  last_poke_ids = []
  poke_id = 0
  Array.new(8) do
    last_poke_ids.push poke_id
    poke_id = rand(1..151) while last_poke_ids.include? poke_id
    poke_id
  end
end

# uri = URI('https://pokeapi.co/api/v2/pokemon?limit=1')
# p Net::HTTP.get(uri)
