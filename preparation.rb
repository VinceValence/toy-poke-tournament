# frozen_string_literal: true

require 'net/http'

last_poke_id = 0
poke_id = 0
poke_ids = Array.new(8) do
    last_poke_id = poke_id
    until poke_id != last_poke_id do
        poke_id = rand(1..151)
    end
    poke_id
end

# uri = URI('https://pokeapi.co/api/v2/pokemon?limit=1')
# p Net::HTTP.get(uri)
