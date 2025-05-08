#lang forge

// Base sigs

sig Voter {
    partyChoice: lone Party,
    firstChoice : lone Candidate
}

sig Candidate {
    party : one Party
}

sig Party {
    members : set Voter,
    candidates : set Candidate
}

// Election systems and voting

abstract sig ElectionSystem {}
sig SimpleMajority extends ElectionSystem{}

sig Winner {
    candidate: one Candidate,
    system: one ElectionSystem
}

// Helper functions for vote counting

fun firstChoiceVotes[c: Candidate]: Int {
    #{v: Voter | v.firstChoice = c}
}

// Predicates for the election system

pred simpleMajority {
    one w: Winner {
        w.system = SimpleMajority

        all other: (Candidate - w.candidate) | 
            firstChoiceVotes[w.candidate] > firstChoiceVotes[other]
    }
}

pred wellformed {
    all v: Voter | some v.firstChoice => v.firstChoice in v.partyChoice.candidates
}


run {
    wellformed
    simpleMajority
} for exactly 3 Candidate, 6 Voter, 2 Party, 1 Winner
