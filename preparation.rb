# frozen_string_literal: true

require 'json'
require 'net/http'

def gen_ids
  # Generate eight ids in the range 1..151,
  # making sure they are different.

  last_poke_ids = []
  poke_id = 0
  Array.new(8) do
    last_poke_ids.push poke_id
    # generate a new, different id
    poke_id = rand(1..151) while last_poke_ids.include? poke_id
    poke_id
  end
end

def parse_dmg_rel(dmg_rel)
  # Cleans damage relation hash,
  # removing clutter urls

  dmg_rel.each do |k, v|
    clean_array = []
    v.each do |h|
      clean_array.push h['name']
    end
    dmg_rel[k] = clean_array
  end
end

def get_pokes(ids)

  all_pokes = []

  ids.each do |id|
    poke_uri = URI("https://pokeapi.co/api/v2/pokemon/#{id}")
    poke_str = Net::HTTP.get(poke_uri)
    poke_hash = JSON.parse(poke_str)
    base_stat = poke_hash['stats'][0]['base_stat']
    type_name = poke_hash['types'][0]['type']['name']
    name = poke_hash['name']

    type_uri = URI("https://pokeapi.co/api/v2/type/#{type_name}")
    type_str = Net::HTTP.get(type_uri)
    type_hash = JSON.parse(type_str)
    dmg_rel = type_hash['damage_relations']
    clean_dmg_rel = parse_dmg_rel(dmg_rel)

    all_pokes.push({
        name: name, base_stat: base_stat,
        type: type_name, dmg_rel: clean_dmg_rel
    })
  end

  all_pokes

end

p get_pokes gen_ids
