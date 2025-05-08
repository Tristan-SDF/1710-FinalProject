#lang forge/temporal

// Base sigs

sig Voter {
    firstChoice : one Candidate,
    secondChoice : one Candidate
    //thirdChoice : one Candidate
}
sig Candidate {
}
one sig Winner {
    winner : set Candidate
}

------------------------------------------------------------------------------------

// Helper functions for vote counting

fun firstChoiceVotes[c: Candidate]: set Voter {
    {v: Voter | v.firstChoice = c}
}

fun secondChoiceVotes[c: Candidate]: set Voter {
    {v: Voter | v.secondChoice = c}
}

pred init {
    #{Winner.winner} = 1
}

pred rankedChoice {
    some c1, c2, c3: Candidate {
        //c1,2,3 > 50%
        c1 != c2 
        c1 != c3

        c2 != c1
        c2 != c3

        c3 != c1
        c3 != c2
        //If a canidate has more than 50% of the first choice votes they win outright
        //MAY OVERFLOW IF TOO MANY VOTERS
        #{firstChoiceVotes[c1]} > add[#{firstChoiceVotes[c2]}, #{firstChoiceVotes[c3]}] implies c1 in Winner.winner and c2 not in Winner.winner and c3 not in Winner.winner
        #{firstChoiceVotes[c2]} > add[#{firstChoiceVotes[c1]}, #{firstChoiceVotes[c3]}] implies c2 in Winner.winner and c1 not in Winner.winner and c3 not in Winner.winner
        #{firstChoiceVotes[c3]} > add[#{firstChoiceVotes[c1]}, #{firstChoiceVotes[c2]}] implies c3 in Winner.winner and c1 not in Winner.winner and c2 not in Winner.winner
        
        //No candidate won outright, eliminate the candidate with the fewest first choice votes
        //c1 is eliminated, recount with c2, c3
        (#{firstChoiceVotes[c1]} < #{firstChoiceVotes[c2]} and #{firstChoiceVotes[c1]} < #{firstChoiceVotes[c3]}) implies {
            c1 not in Winner.winner
            #{(firstChoiceVotes[c1] & secondChoiceVotes[c2]) + firstChoiceVotes[c2]} > #{(firstChoiceVotes[c1] & secondChoiceVotes[c3]) + firstChoiceVotes[c3]} implies c2 in Winner.winner
            #{(firstChoiceVotes[c1] & secondChoiceVotes[c3]) + firstChoiceVotes[c3]} > #{(firstChoiceVotes[c1] & secondChoiceVotes[c2]) + firstChoiceVotes[c2]} implies c3 in Winner.winner
        }

        //c2 is eliminated, recount with c1,c3
        (#{firstChoiceVotes[c2]} < #{firstChoiceVotes[c1]} and #{firstChoiceVotes[c2]} < #{firstChoiceVotes[c3]}) implies {
            c2 not in Winner.winner
            #{(firstChoiceVotes[c2] & secondChoiceVotes[c1]) + firstChoiceVotes[c1]} > #{(firstChoiceVotes[c2] & secondChoiceVotes[c3]) + firstChoiceVotes[c3]} implies c1 in Winner.winner
            #{(firstChoiceVotes[c2] & secondChoiceVotes[c3]) + firstChoiceVotes[c3]} > #{(firstChoiceVotes[c2] & secondChoiceVotes[c1]) + firstChoiceVotes[c1]} implies c3 in Winner.winner
        }
        //c3 is eliminated, recount with c1,c2
        (#{firstChoiceVotes[c3]} < #{firstChoiceVotes[c1]} and #{firstChoiceVotes[c3]} < #{firstChoiceVotes[c2]}) implies {
            c3 not in Winner.winner
            #{(firstChoiceVotes[c3] & secondChoiceVotes[c1]) + firstChoiceVotes[c1]} > #{(firstChoiceVotes[c3] & secondChoiceVotes[c2]) + firstChoiceVotes[c2]} implies c1 in Winner.winner
            #{(firstChoiceVotes[c3] & secondChoiceVotes[c2]) + firstChoiceVotes[c2]} > #{(firstChoiceVotes[c3] & secondChoiceVotes[c1]) + firstChoiceVotes[c1]} implies c2 in Winner.winner
        }
    }
}
pred election{
    init
    rankedChoice
}

run {
    election
} for exactly 1 Winner, exactly 3 Candidate, exactly 8 Voter