# frozen_string_literal: true

require_relative 'messages'

class Duel
  TURN_LIMIT = 10

  def initialize(participants)
    @participants = participants
  end

  def begin_attack_cycle
    who_died = -> { @participants.find(&:dead) }
    dead = nil
    attacking = @participants[0]
    defending = @participants[1]
    turns_played = 0
    until dead
      # perform the attack
      attacking.attack(defending)

      # check for a death
      dead = who_died.call

      # swap who attacks and who defends
      attacking, defending = defending, attacking

      turns_played += 1

      # stop fight if turn limit is reached
      break if turns_played == TURN_LIMIT
    end
    [dead, turns_played]
  end

  def duel
    DMsgs.present_participants(@participants)

    # dead is the pokemon who died
    # or an empty array if no one died
    dead, turns_played = begin_attack_cycle

    # determine winner by remaining hp
    winner = @participants.max_by(&:hp)
    loser = @participants.min_by(&:hp)

    # winner's hp resets to maximum for next duel
    winner.reset_hp

    # Announce winner and type of victory
    if dead
      DMsgs.win_duel_by_kill(winner, loser, turns_played)
    else
      DMsgs.win_duel_turn_limit(winner, loser, turns_played)
    end

    # disqualify loser
    loser.disqualified = true
  end
end
