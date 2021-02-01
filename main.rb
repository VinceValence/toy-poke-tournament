# frozen_string_literal: true

require_relative 'pokemon'
require_relative 'poke_retrieval'
require_relative 'tournament'

if __FILE__ == $PROGRAM_NAME
  poke_info = get_pokes gen_ids
  participants = []
  poke_info.each do |info|
    participants.push(
      Pokemon.new(
        info[:name], info[:type],
        info[:base_stat], info[:dmg_rel]
      )
    )
  end

  tournament = Tournament.new(participants)
  tournament.begin
end
