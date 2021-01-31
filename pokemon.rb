# frozen_string_literal: true

class Pokemon
  # I don't think this is the right place for this.
  # Maybe I should have put it in poke_retrieval.
  @@dmg_translator = {
    'double_damage_from': 2.0,
    'double_damage_to': 2.0,
    'half_damage_from': 0.5,
    'half_damage_to': 0.5,
    'no_damage_from': 0.1,
    'no_damage_to': 0.1
  }

  attr_reader :name, :type, :dead, :beat

  def initialize(name, type, base_stat, dmg_rel)
    @name = name
    @type = type
    @base_stat = base_stat
    @dmg_rel = dmg_rel
    @hp = base_stat * 1.5
    @dead = false
    @beat = []
  end

  def attack(other)
    dmg_multiplier = 1
    @dmg_rel.each do |relation, types|
      # if the dmg rel is offensive
      next unless relation.rpartition('_').last == 'to'

      # if the other's type is in the relations array
      if types.include? other.type
        # change the multiplier accordingly
        dmg_multiplier = @@dmg_translator[relation.to_sym]
      end
    end
    # damage is @base_stat under a logarithm and is scaled
    # by the damage multiplier related to the pokemon's type
    outgoing_dmg = Math.log(@base_stat) * dmg_multiplier
    other.defend(other, outgoing_dmg)
  end

  def defend(other, incoming_dmg)
    dmg_multiplier = 1
    @dmg_rel.each do |relation, types|
      # if the dmg rel is defensive
      next unless relation.rpartition('_').last == 'from'

      # if the other's type is in the relations array
      if types.include? other.type
        # change the multiplier accordingly
        dmg_multiplier = @@dmg_translator[relation.to_sym]

      end
    end
    @hp -= incoming_dmg * dmg_multiplier
    return unless @hp <= 0

    @dead = true
    other.beat.push(self)
  end
end
