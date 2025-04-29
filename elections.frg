#lang forge/temporal

// Base sigs

sig Voter {
    county : one County,
    party: one Party,
    firstChoice : one Candidate,
    secondChoice : lone Candidate,
    thirdChoice : lone Candidate
}
sig County {
    neighbors: set County,
    electoralVotes: one Int
}
sig Candidate {
    party : one Party,
    voters : set Voter
}
sig Party {
    members : set Voter,
    candidates : set Candidate
}

// Election systems and voting

abstract sig ElectionSystem {}
sig SimpleMajority, ElectoralCollege, RankedVoting extends ElectionSystem{}

sig Winner {
    system: one ElectionSystem,
    candidate: one Candidate
}


pred ElectionsInit {
    
    //Voters can't share 
    all v: Voter | {
        v.firstChoice != v.secondChoice 
        v.firstChoice != v.thirdChoice
        
        v.secondChoice != v.firstChoice
        v.secondChoice != v.thirdChoice

        v.thirdChoice != v.firstChoice
        v.thirdChoice != v.secondChoice
    }
    //Can't vote more than once

    //Electoral votes depends on voters 
    all c: County
}

-- count votes (connect voters' votes to candidate votes)
-- calculate win under different systems

// Helper functions for vote counting

fun firstChoiceVotes[c: Candidate]: set Voter {
    {v: Voter | v.firstChoice = c}
}

fun secondChoiceVotes[c: Candidate]: set Voter {
    {v: Voter | v.secondChoice = c}
}

fun thirdChoiceVotes[c: Candidate]: set Voter {
    {v: Voter | v.thirdChoice = c}
}

fun votesByCounty[county: County, c: Candidate]: set Voter {
    {v: Voter | v.county = county and v.firstChoice = c}
}

fun countyWinnter[county: County]: lone Candidate {
    {c: Candidate | all other: Candidate - c | #votesInCounty[county, c] >= #votesInCounty[county, other]}
}


// Predicates for different election systems

pred simpleMajority {
    some w: Winner {
        some c2, c3: Candidate {
            #{firstChoiceVotes[w.candidate]} > #{firstChoiceVotes[c2]}
            #{firstChoiceVotes[w.candidate]} > #{firstChoiceVotes[c3]}
        }
    }
}

    some w: Winner {
 {

    some w: Winner {
}

pred rankedChoice {
    
}

// electoral college - ricardo
pred electoralCollegeSystem{

}

run {
    simpleMajority
    electoralCollege
    rankedChoice
} for exactly 3 Candidate, 5 County