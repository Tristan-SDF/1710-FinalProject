#lang forge

// Base sigs
sig Voter {
  county : one County,
  party: one Party,
  firstChoice : one Candidate,
  secondChoice : lone Candidate, // not used but may implement ranked voting 
  thirdChoice : lone Candidate
}

sig County {
  neighbors: set County,
  electoralVotes: one Int
}

sig Candidate {
  p : one Party,
  voters : set Voter
}

sig Party {
  members : set Voter,
  candidates : set Candidate
}

// Ensure model is well-formed
pred wellformed {
  // Voter choices must be valid candidates
  all v: Voter | v.firstChoice in Candidate // Voters can only choose real candidates
  all v: Voter | v.secondChoice in Candidate implies v.secondChoice != v.firstChoice
  all v: Voter | v.thirdChoice in Candidate implies {
    v.thirdChoice != v.firstChoice 
    v.thirdChoice != v.secondChoice
  } // No duplicates in the instance of ranked voting 

  // Party relationships are consistent
  all v: Voter | v in v.party.members // Voters must be members of their party
  all party: Party | all c: party.candidates | c.p = party // Candidates must belong to the party they're listed under

  // Each county has positive electoral votes
  all c: County | c.electoralVotes > 0 

  // Candidate's voters set matches voters who chose them first
  all c: Candidate | c.voters = {v: Voter | v.firstChoice = c} 
  
  // County neighbors relationship is symmetric and irreflexive
  all c1, c2: County | c1 in c2.neighbors implies c2 in c1.neighbors // If County A neighbors County B, then County B also neighbors County A
  all c: County | c not in c.neighbors // A county can't neighbor itself
}

// Count votes for a candidate in a specific county
fun votesForCandidateInCounty[cand: Candidate, targetCounty: County]: Int {
  #{v: Voter | v.county = targetCounty and v.firstChoice = cand}
}

// a candidate wins a county if:
// No other candidate got more votes than them in this county
// At least one other candidate got fewer votes than them
pred isCountyWinner[c: Candidate, county: County] {
  // Get votes for candidate c in this county
  let votes = votesForCandidateInCounty[c, county] | {
    // Either c has more votes than any other candidate
    all other: Candidate | other != c implies 
      votesForCandidateInCounty[other, county] <= votes
    
    // Make sure at least one other candidate has strictly fewer votes
    // (This ensures c has the most votes)
    some other: Candidate | other != c and 
      votesForCandidateInCounty[other, county] < votes
  }
}

// Get the unique winner for each county
// adds up electoral votes for a candidate following the "winner-take-all" rule
fun countyWinner[county: County]: one Candidate {
  {c: Candidate | isCountyWinner[c, county]}
}

// Calculate electoral votes for a candidate (winner-take-all system)
fun electoralVotesForCandidate[c: Candidate]: Int {
  sum county: County | (countyWinner[county] = c => county.electoralVotes else 0)
}

// Determine if a candidate is the electoral college winner
// In case of ties, uses consistent tie-breaking (lowest candidate ID)
pred isElectoralWinner[c: Candidate] {
  // Get electoral votes for candidate c
  let votes = electoralVotesForCandidate[c] | {
    // No other candidate has more electoral votes than c
    all other: Candidate | other != c implies 
      electoralVotesForCandidate[other] <= votes
    
    // Make sure at least one other candidate has strictly fewer votes
    // (This ensures c has the most votes)
    some other: Candidate | other != c and 
      electoralVotesForCandidate[other] < votes
  }
}
// Electoral college system predicate
pred electoralCollegeSystem {
  wellformed
  // There must be exactly one winner
  one c: Candidate | isElectoralWinner[c]
}

// Calculate total popular votes for a candidate
fun popularVotesForCandidate[c: Candidate]: Int {
  #{v: Voter | v.firstChoice = c}
}

// Property: Popular vote winner might not win the electoral college
pred popularVoteWinnerLoses {
  // Find a popular vote winner who doesn't win the electoral college
  some c1, c2: Candidate | {
    // c1 has the most total votes
    (all other: Candidate | other != c1 implies 
      popularVotesForCandidate[c1] >= popularVotesForCandidate[other])
    // But c2 wins the electoral college
    isElectoralWinner[c2]
    c1 != c2
  }
}

// Run a basic election
run {
  electoralCollegeSystem
  // Minimum number of elements for interesting results
  #Candidate >= 2
  #Voter >= 10
  #County >= 3
  #Party >= 2
} for 4 Candidate, 20 Voter, 8 County, 2 Party, 5 Int

// Predicate for checking one winner per county
pred oneWinnerPerCounty {
  wellformed implies {
    all county: County | {
      // There is at least one winner
      some c: Candidate | isCountyWinner[c, county]
      
      // There is at most one winner
      all c1, c2: Candidate | 
        (isCountyWinner[c1, county] and isCountyWinner[c2, county]) implies c1 = c2
    }
  }
}

// Check that there's always exactly one winner per county
check {oneWinnerPerCounty} for 4 Candidate, 20 Voter, 8 County, 2 Party, 5 Int

// Find an instance where the popular vote winner loses the electoral college
run popularVoteWinnerLoses for 4 Candidate, 20 Voter, 8 County, 2 Party, 5 Int