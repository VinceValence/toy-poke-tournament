class Pokemon

    # I don't think this is the right place for this.
    # Maybe I should have put it in poke_retrieval.
    @@dmg_translator = {
        'double_damage_from': 2,
        'double_damage_to': 2,
        'half_damage_from': 1/2,
        'half_damage_to': 1/2,
        'no_damage_from': 0,
        'no_damage_to': 0
    }

    def initialize(name, type, base_stat, dmg_rel)
        @name = name
        @type = type
        @base_stat = base_stat
        @dmg_rel = dmg_rel
        @hp = base_stat*1.5
    end

    def attack(other)
        dmg_multiplier = 1
        @dmg_rel.each do |relation,types|
            # if the dmg rel is offensive
            if relation.rpartition('_').last == 'to'
                # if the other's type is in the relations array
                if types.include? other.type
                    # change the multiplier accordingly
                    dmg_multiplier = @@dmg_translator[relation]
                end
            end
        end
        # damage is @base_stat under a logarithm and is scaled
        # by the damage multiplier related to the pokemon's type
        outgoing_dmg = Math.log(@base_stat)*dmg_multiplier
        other.defend(other, outgoing_dmg)
    end

    def defend(other, incoming_dmg)
        dmg_multiplier = 1
        @dmg_rel each do |relation,types|
            # if the dmg rel is defensive
            if relation.rpartition('_').last == 'from'
                # if the other's type is in the relations array
                if types.include? other.type
                    # change the multiplier accordingly
                    dmg_multiplier = @@dmg_translator[relation]
                end
            end
        @hp -= incoming_dmg*dmg_multiplier
end