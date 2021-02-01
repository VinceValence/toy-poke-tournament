# frozen_string_literal: true

# The following classes have static methods that print messages to
# standard output. The expression class << TMsgs allows for static
# methods.

# Tournament messages
class TMsgs
  class << TMsgs
    def welcome
      puts 'Welcome to the one and only Pokemon Tournament!'
    end

    def explain
      puts 'This tournament consists of sudden death duels '\
      '(i.e. pokemons lose once and they are disqualified). '\
      'Winners get paired with winners until only one, the '\
      'winner of the tournament, remains.'
      puts 'A pokemon has a base damage equal to the logarithm ' \
      'of its base stat, but that damage is modified by its type\'s ' \
      'related weaknesses or strengths, in addition to a random turn factor.'
      puts 'The health or hp of a pokemon is also determined ' \
      'by a logarithm over the base stat plus 10.'
    end

    def present_participants(participants)
      names = participants[0..-2].map(&:name).to_s[2..-3].tr('\"', '')
      last_name = participants[-1].name
      puts "Give a warm applause for this season's participants: " \
        "#{names} and #{last_name}!"
      puts
    end

    def start
      puts 'Let the duels Begin!'
    end

    def announce_duel_number(n)
      puts "Duel number #{n}!"
    end

    def announce_winner(winner)
      puts "#{winner.name} emerges victorious from the arduous " \
      "series of duels it faced. A roaring applause for #{winner.name}!"
    end

    def announce_phase(n)
      puts "Phase #{n} starts, in which #{8 / n} pokemons participate!"
      puts
    end
  end
end

# Duel messages
class DMsgs
  class << DMsgs
    def present_advantages(p1, p2)
      narration = "As a #{p1.type} type, #{p1.name} has "
      dmg_multiplier = p1.get_multiplier_against(p2)
      narration += if dmg_multiplier < 1.0
                     'an offensive disadvantage '
                   elsif dmg_multiplier == 1.0
                     'no offensive advantage or disadvantage '
                   else
                     'an offensive advantage '
                   end
      narration += "against #{p2.type} types. And #{p2.name} is of #{p2.type} type."
      puts narration
    end

    def present_participants(participants)
      p1 = participants[0]
      p2 = participants[1]
      puts "This duel will be between #{p1.name} and #{p2.name}. " \
      "#{p1.name} has a base stat of #{p1.base_stat}, #{p1.hp} health " \
      "and #{p1.base_dmg.round(0)} base damage. " \
      "#{p2.name} has a base stat of #{p2.base_stat}, #{p2.hp} health " \
      "and #{p2.base_dmg.round(0)} base damage. Remember " \
      'attack and health are based on the base stat.'
      DMsgs.present_advantages(p1, p2)
      DMsgs.present_advantages(p2, p1)
      puts 'May the best pokemon win!'
    end

    def win_duel_by_kill(winner, loser, turns_played)
      puts "#{winner.name} wins the duel against " \
      "#{loser.name} after #{turns_played} turns, " \
      "having reduced its opponent's health to 0!"
    end

    def win_duel_turn_limit(winner, loser, turns_played)
      # whoever has more hp wins, because turns ran out
      puts "#{winner.name} (with #{winner.hp.round(0)} hp remaining) wins the " \
      'duel against ' \
      "#{loser.name} (with #{loser.hp.round(0)} hp remaining), " \
      "having fought until the turn limit of #{turns_played}!"
    end
  end
end

# Pokemon messages
class PMsgs
  class << PMsgs
    # def prepare_attack(pokemon)
    #     puts "#{pokemon.name} prepares to attack!"
    # end
    def narrate_attack(dmg, source, target)
      puts "#{source.name} attacks and deals #{dmg.round(0)} " \
      "points of damage to #{target.name}, who is now " \
      "at #{target.hp >= 0 ? target.hp : 0} hp."
    end
  end
end
