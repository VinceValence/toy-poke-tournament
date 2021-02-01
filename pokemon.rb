# frozen_string_literal: true

class Pokemon
  # I don't think this is the right place for this.
  # Maybe I should have put it in poke_retrieval.
  @@dmg_translator = {
    'double_damage_from': 2.0,
    'double_damage_to': 2.0,
    'half_damage_from': 0.5,
    'half_damage_to': 0.5,
    'no_damage_from': 0,
    'no_damage_to': 0
  }

  attr_reader :name, :type, :dead, :beat, :hp, :base_stat
  attr_writer :dead

  def initialize(name, type, base_stat, dmg_rel)
    @name = name.capitalize
    @type = type
    @base_stat = base_stat
    @dmg_rel = dmg_rel
    @hp = self.reset_hp
    @dead = false
  end

  def reset_hp
    @hp = (Math.log(@base_stat, 10) + 10).round(0)
  end

  def attack(other)
    PMsgs.prepare_attack(self)

    dmg_multiplier = self.get_multiplier_against(other)

    # damage is @base_stat under a logarithm and is scaled
    # by the damage multiplier related to the pokemon's type
    base_dmg = Math.log(@base_stat)
    random_factor = rand(0.5..1.5)
    outgoing_dmg = (base_dmg * dmg_multiplier * random_factor).round(0)
    other.defend(outgoing_dmg)
    PMsgs.narrate_attack(outgoing_dmg, self, other)
  end

  def defend(incoming_dmg)
    @hp -= incoming_dmg
    return unless @hp <= 0
    @dead = true
  end

  def get_multiplier_against(other)
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
    return dmg_multiplier
  end
end
