require_relative 'duel'
require_relative 'messages'

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
        TMsgs.welcome
        TMsgs.explain
        TMsgs.present_participants(@participants)
        TMsgs.start
        # take remaining participants and make them duel
        remaining = @participants
        duels = 1
        phase1_thresh = 4
        phase2_thresh = 2
        TMsgs.announce_phase(1)
        while remaining.length > 1
            if remaining.length == 4
                TMsgs.announce_phase(2)
            elsif remaining.length == 2
                TMsgs.announce_phase(3)
            end
            remaining.each_slice(2) do |pair|
                if pair.length == 2
                    TMsgs.announce_duel_number(duels)
                    duel = Duel.new(pair)
                    duel.duel
                    duels += 1
                    
                    puts 'Press enter for next duel...'
                    gets.chomp
                end
            end
            remaining = get_remaining
        end
        TMsgs.announce_winner(remaining[0])
    end
end
