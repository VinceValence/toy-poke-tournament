require_relative 'duel'

class Tournament

    # a sudden death Pokemon tournament

    def initialize(participants)
        @participants = participants
        # these are the number of times pairings must be made
        @phases = Math.log2(participants.length).ceil
        @current_phase = 1  # 1 to @phases (1..@phases)
    end

    def get_remaining
        # get all participants that are still alive
        @participants.find_all { |p| !p.dead }
    end
    
    def begin
        p 'tournament started'
        # take remaining participants and make them duel
        remaining = @participants
        while remaining.length > 1
            remaining.each_slice(2) do |pair|
                if pair.length == 2
                    duel = Duel.new(pair)
                    duel.duel
                end
            end
            remaining = get_remaining
        end
    end
end
