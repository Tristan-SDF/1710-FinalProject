#lang forge/temporal

open "RankedChoice.frg"

------------------------------------------------------------------------

pred winnerExists {
    some c1 : Candidate {
        c1 in Winner.winner
    }
}
pred notWinnerExists {
    all c1 : Candidate {
        c1 not in Winner.winner
    }
}
pred winsoutright {
    some c1,c2,c3:Candidate {
        c1 != c2 
        c1 != c3
        c2 != c1
        c2 != c3
        c3 != c1
        c3 != c2
        #{firstChoiceVotes[c1]} > add[#{firstChoiceVotes[c2]}, #{firstChoiceVotes[c3]}] implies c1 in Winner.winner
        #{firstChoiceVotes[c1]} > add[#{firstChoiceVotes[c2]}, #{firstChoiceVotes[c3]}] implies c2 not in Winner.winner and c3 not in Winner.winner
    }
}

pred notwinsoutright {
    all c1,c2,c3:Candidate {
        c1 != c2 
        c1 != c3
        c2 != c1
        c2 != c3
        c3 != c1
        c3 != c2
        #{firstChoiceVotes[c1]} > 3
        #{firstChoiceVotes[c2]} < 2
        #{firstChoiceVotes[c3]} < 2
        c1 not in Winner.winner
    }
}
pred secondChoiceWin {
    some c1,c2,c3:Candidate {
        c1 != c2 
        c1 != c3
        c2 != c1
        c2 != c3
        c3 != c1
        c3 != c2
        #{firstChoiceVotes[c1]} < add[#{firstChoiceVotes[c2]}, #{firstChoiceVotes[c3]}] 
        #{firstChoiceVotes[c2]} < add[#{firstChoiceVotes[c1]}, #{firstChoiceVotes[c3]}] 
        #{firstChoiceVotes[c3]} < add[#{firstChoiceVotes[c1]}, #{firstChoiceVotes[c2]}] 
        
        (#{firstChoiceVotes[c1]} < #{firstChoiceVotes[c2]} and #{firstChoiceVotes[c1]} < #{firstChoiceVotes[c3]}) implies {
            c1 not in Winner.winner
            #{(firstChoiceVotes[c1] & secondChoiceVotes[c2]) + firstChoiceVotes[c2]} > #{(firstChoiceVotes[c1] & secondChoiceVotes[c3]) + firstChoiceVotes[c3]} implies c2 in Winner.winner
            #{(firstChoiceVotes[c1] & secondChoiceVotes[c3]) + firstChoiceVotes[c3]} > #{(firstChoiceVotes[c1] & secondChoiceVotes[c2]) + firstChoiceVotes[c2]} implies c3 in Winner.winner
        }
    }
}
pred notSecondChoiceWin {
    some c1,c2,c3:Candidate {
        c1 != c2 
        c1 != c3
        c2 != c1
        c2 != c3
        c3 != c1
        c3 != c2
        #{firstChoiceVotes[c1]} < add[#{firstChoiceVotes[c2]}, #{firstChoiceVotes[c3]}] 
        #{firstChoiceVotes[c2]} < add[#{firstChoiceVotes[c1]}, #{firstChoiceVotes[c3]}] 
        #{firstChoiceVotes[c3]} < add[#{firstChoiceVotes[c1]}, #{firstChoiceVotes[c2]}] 
        
        (#{firstChoiceVotes[c1]} < #{firstChoiceVotes[c2]} and #{firstChoiceVotes[c1]} < #{firstChoiceVotes[c3]}) 
        c1 in Winner.winner
    }
}

test suite for election {
    assert winnerExists and election is sat
    assert winsoutright and election is sat
    assert notwinsoutright and election is unsat
    assert notWinnerExists and election is unsat
    assert secondChoiceWin and election is sat
    assert notSecondChoiceWin and election is unsat
}



