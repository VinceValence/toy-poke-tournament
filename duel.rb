# frozen_string_literal: true

require_relative 'messages'

class Duel
  def initialize(participants)
    @participants = participants
  end

  def duel
    DMsgs.present_participants(@participants)

    who_died = -> { @participants.find(&:dead) }
    dead = nil
    attacking = @participants[0]
    defending = @participants[1]
    turns_played = 0
    turn_limit_reached = false
    until dead
      # perform the attack
      attacking.attack(defending)

      # check for a death
      dead = who_died.call

      # swap who attacks and who defends
      old_attacking = attacking
      attacking = defending
      defending = old_attacking

      turns_played += 1
      # turn limit
      break if turns_played == TURN_LIMIT
    end

    winner = @participants.max_by {|p| p.hp}
    loser = @participants.min_by {|p| p.hp}
    winner.reset_hp
    if dead
      puts "#{winner.name} wins the duel against " \
        "#{loser.name} after #{turns_played} turns, " \
        "having reduced its opponent's health to 0!"
    else
      # whoever has more hp wins, because turns ran out
      puts "#{winner.name} (with #{winner.hp.round(0)} hp remaining) wins the " \
        "duel against " \
        "#{loser.name} (with #{loser.hp.round(0)} hp remaining), " \
        "having fought until the turn limit of #{turns_played}!"
      # we need to kill the pokemon anyway. A better term would be disqualified
      loser.dead = true
    end
  end
end
