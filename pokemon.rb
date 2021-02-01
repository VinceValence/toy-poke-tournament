# frozen_string_literal: true

class Pokemon
  DMG_MULT_TRANSLATOR = {
    'double_damage_from': 2.0,
    'double_damage_to': 2.0,
    'half_damage_from': 0.5,
    'half_damage_to': 0.5,
    'no_damage_from': 0,
    'no_damage_to': 0
  }.freeze

  attr_reader :name, :type, :beat, :dead,
              :hp, :base_stat, :base_dmg
  attr_accessor :disqualified

  def initialize(name, type, base_stat, dmg_rel)
    @name = name.capitalize
    @type = type
    @base_stat = base_stat
    @base_dmg = Math.log(@base_stat)
    @dmg_rel = dmg_rel
    @hp = reset_hp
    @dead = false
    @disqualified = false
  end

  def reset_hp
    @hp = (Math.log(@base_stat, 10) + 10).round(0)
  end

  def attack(other)
    dmg_multiplier = get_multiplier_against(other)

    random_factor = rand(0.5..1.5)
    outgoing_dmg = (@base_dmg * dmg_multiplier * random_factor).round(0)
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
      # continue if the dmg rel is offensive (e.g. no_damage_to)
      next unless relation.rpartition('_').last == 'to'

      # if the other's type is in the relations array
      if types.include? other.type
        # change the multiplier accordingly (to 0, 0.5 or 2)
        dmg_multiplier = DMG_MULT_TRANSLATOR[relation.to_sym]
      end
    end
    dmg_multiplier
  end
end
