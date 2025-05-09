#lang forge

// Import the original model
open "electoral_college.frg"

/*
 * Test 1: Basic instance check
 * Verifies that a valid instance can be created 
 * with the minimum requirements
 */
test expect {
  basic: {
    electoralCollegeSystem
  } is sat
}

/*
 * Test 2: Verifies that the wellformed predicate enforces 
 * proper voter choice constraints
 */
test expect {
  voterChoiceConstraints: {
    wellformed
    some v: Voter | v.secondChoice = v.firstChoice
  } is unsat
}

/*
 * Test 3: Verify that a county's neighbors must be symmetric
 */
test expect {
  countyRelationshipSymmetry: {
    wellformed
    some c1, c2: County | c1 in c2.neighbors and c2 not in c1.neighbors
  } is unsat
}

/*
 * Test 4: Verify that candidates' voters sets match correctly
 */
test expect {
  candidateVoterSetCorrect: {
    wellformed
    some c: Candidate | c.voters != {v: Voter | v.firstChoice = c}
  } is unsat
}

/*
 * Test 5: Test that there is always exactly one electoral winner
 */
test expect {
  oneElectoralWinner: {
    electoralCollegeSystem
    no c: Candidate | isElectoralWinner[c]
  } is unsat
}

/*
 * Test 6: Popular vote winner can lose electoral college
 */
test expect {
  popularVsElectoral: {
    electoralCollegeSystem
    popularVoteWinnerLoses
  } is sat
}

/*
 * Test 7: Test consistency of party membership
 */
test expect {
  partyMembership: {
    wellformed
    some v: Voter, p: Party | v.party = p and v not in p.members
  } is unsat
}

/*
 * Test 8: Test that electoral votes are positive
 */
test expect {
  positiveElectoralVotes: {
    wellformed
    some c: County | c.electoralVotes <= 0
  } is unsat
}

/*
 * Test 9: Test that county neighbor relationship is irreflexive
 */
test expect {
  irreflexiveNeighbors: {
    wellformed
    some c: County | c in c.neighbors
  } is unsat
}

/*
 * Test 10: Different voter distributions can lead to different winners
 */
test expect {
  differentDistributions: {
    electoralCollegeSystem
    
    // There are exactly two candidates
    #Candidate = 2
    let c1 = min[Candidate], c2 = max[Candidate] | {
      // c1 wins more counties
      #{county: County | countyWinner[county] = c1} > 
      #{county: County | countyWinner[county] = c2}
      
      // But c2 wins the electoral college
      isElectoralWinner[c2]
    }
  } is sat
}

/*
 * Test 11: Test ranked choice constraints
 */
test expect {
  rankedChoiceConstraints: {
    wellformed
    all v: Voter | v.secondChoice in Candidate implies v.secondChoice != v.firstChoice
    all v: Voter | v.thirdChoice in Candidate implies 
      v.thirdChoice != v.firstChoice and v.thirdChoice != v.secondChoice
  } is sat
}

/*
 * Test 12: Verify that vote counting works correctly
 */
test expect {
  voteCounting: {
    wellformed
    some c: Candidate, county: County | {
      votesForCandidateInCounty[c, county] = #{v: Voter | v.county = county and v.firstChoice = c}
    }
  } is sat
}

/*
 * Test 13: Verify that electoral vote calculation works correctly
 */
test expect {
  electoralVoteCalculation: {
    wellformed
    some c: Candidate | {
      let votes = sum county: County | {
        countyWinner[county] = c implies county.electoralVotes else 0
      } |
      electoralVotesForCandidate[c] = votes
    }
  } is sat
}

/*
 * Test 14: Test that each voter belongs to exactly one county
 */
test expect {
  voterInOneCounty: {
    wellformed
    some v: Voter | #{c: County | v.county = c} != 1
  } is unsat
}

/*
 * Test 15: Test that each candidate belongs to exactly one party
 */
test expect {
  candidateInOneParty: {
    wellformed
    some c: Candidate | #{p: Party | c.p = p} != 1
  } is unsat
}