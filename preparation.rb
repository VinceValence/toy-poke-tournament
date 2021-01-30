# frozen_string_literal: true

require 'net/http'

def gen_ids
    # Generate eight ids in the range 1..151.
    # Here, an id candidate is generated eight
    # times, in each 
    last_poke_ids = []
    poke_id = 0
    poke_ids = Array.new(8) do
        last_poke_ids.push poke_id
        while last_poke_ids.include? poke_id do
            poke_id = rand(1..10)
        end
        poke_id
    end
    poke_ids
end

# uri = URI('https://pokeapi.co/api/v2/pokemon?limit=1')
# p Net::HTTP.get(uri)
