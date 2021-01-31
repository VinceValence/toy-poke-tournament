# frozen_string_literal: true

class Duel
  def initialize(participants)
    @participants = participants
  end

  def duel
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
      old_attacking = attacking
      attacking = defending
      defending = old_attacking

      turns_played += 1
    end

    # NOTE: who attacked last is now in the defender var
    # and viceversa
    p "#{defending.name} wins the duel against " \
      "#{attacking.name} after #{turns_played} turns!"
  end
end
