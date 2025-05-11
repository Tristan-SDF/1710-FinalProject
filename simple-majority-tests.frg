#lang forge

open "simple-majority.frg"

// Tests for simple majority voting system model

test suite for wellformed {
    example everyoneOneFirstChoice is {wellformed} for {
        Voter = `V1 + `V2 + `V3 + `V4 + `V5 + `V6
        Candidate = `C1 + `C2
        Party = `P1 + `P2

        `C1.party = `P1
        `C2.party = `P2

        `P1.candidates = `C1
        `P2.candidates = `C2

        `P1.members = `V1 + `V2 + `V5
        `P2.members = `V3 + `V4 + `V6

        `V1.partyChoice = `P1
        `V2.partyChoice = `P1
        `V3.partyChoice = `P2
        `V4.partyChoice = `P2
        `V5.partyChoice = `P1
        `V6.partyChoice = `P2

        `V1.firstChoice = `C1
        `V2.firstChoice = `C1
        `V3.firstChoice = `C2
        `V4.firstChoice = `C2
        `V5.firstChoice = `C1
        `V6.firstChoice = `C2
    }

    example firstChoicesNoParty is {wellformed} for {
        Voter = `V1 + `V2 + `V3 + `V4 + `V5 + `V6
        Candidate = `C1 + `C2
        Party = `P1 + `P2

        `C1.party = `P1
        `C2.party = `P2

        `P1.candidates = `C1
        `P2.candidates = `C2

        `P1.members = `V1 + `V2 + `V5
        `P2.members = `V3 + `V4

        `V1.partyChoice = `P1
        `V2.partyChoice = `P1
        `V3.partyChoice = `P2
        `V4.partyChoice = `P2
        `V5.partyChoice = `P1

        `V1.firstChoice = `C1
        `V2.firstChoice = `C1
        `V3.firstChoice = `C2
        `V4.firstChoice = `C2
        `V5.firstChoice = `C1
        `V6.firstChoice = `C2
    }

    example notEveryoneOneFirstChoice is {not wellformed} for {
        Voter = `V1 + `V2 + `V3 + `V4 + `V5 + `V6
        Candidate = `C1 + `C2
        Party = `P1 + `P2

        `C1.party = `P1
        `C2.party = `P2

        `P1.candidates = `C1
        `P2.candidates = `C2

        `P1.members = `V1 + `V2 + `V5
        `P2.members = `V3 + `V4 + `V6

        `V1.partyChoice = `P1
        `V2.partyChoice = `P1
        `V3.partyChoice = `P2
        `V4.partyChoice = `P2
        `V5.partyChoice = `P1
        `V6.partyChoice = `P2

        `V1.firstChoice = `C1
        `V3.firstChoice = `C2
        `V4.firstChoice = `C2
        `V5.firstChoice = `C1
        `V6.firstChoice = `C2
    }

    example notEveryoneParty is {not wellformed} for {
        Voter = `V1 + `V2 + `V3 + `V4 + `V5 + `V6
        Candidate = `C1 + `C2
        Party = `P1 + `P2

        `C1.party = `P1
        `C2.party = `P2

        `P1.candidates = `C1
        `P2.candidates = `C2

        `P1.members = `V1 + `V2 + `V5
        `P2.members = `V3 + `V4

        `V1.partyChoice = `P1
        `V2.partyChoice = `P1
        `V3.partyChoice = `P2
        `V4.partyChoice = `P2
        `V5.partyChoice = `P1

        `V1.firstChoice = `C1
        `V2.firstChoice = `C2
        `V3.firstChoice = `C2
        `V4.firstChoice = `C2
        `V5.firstChoice = `C1
        `V6.firstChoice = `C2
    }

    example partylessCandidate is {not wellformed} for {
        Voter = `V1 + `V2 + `V3 + `V4 + `V5 + `V6
        Candidate = `C1 + `C2
        Party = `P1 + `P2

        `C1.party = `P1

        `P1.candidates = `C1

        `P1.members = `V1 + `V2 + `V5
        `P2.members = `V3 + `V4 + `V6

        `V1.partyChoice = `P1
        `V2.partyChoice = `P1
        `V3.partyChoice = `P2
        `V4.partyChoice = `P2
        `V5.partyChoice = `P1
        `V6.partyChoice = `P2

        `V1.firstChoice = `C1
        `V2.firstChoice = `C1
        `V3.firstChoice = `C2
        `V4.firstChoice = `C2
        `V5.firstChoice = `C1
        `V6.firstChoice = `C2
    }
}

test suite for simpleMajority {
    example candidate1Wins is {simpleMajority} for {
        Voter = `V1 + `V2 + `V3 + `V4 + `V5 + `V6
        Candidate = `C1 + `C2
        Party = `P1 + `P2
        Winner = `W

        `C1.party = `P1
        `C2.party = `P2
        `P1.candidates = `C1
        `P2.candidates = `C2

        `P1.members = `V1 + `V2 + `V5 + `V4
        `P2.members = `V3 + `V6

        `V1.partyChoice = `P1
        `V2.partyChoice = `P1
        `V3.partyChoice = `P2
        `V4.partyChoice = `P1
        `V5.partyChoice = `P1
        `V6.partyChoice = `P2

        `V1.firstChoice = `C1
        `V2.firstChoice = `C1
        `V3.firstChoice = `C2
        `V4.firstChoice = `C1
        `V5.firstChoice = `C1
        `V6.firstChoice = `C2

        `W.candidate = `C1
        ElectionSystem = `SimpleMajority
        `W.system = `SimpleMajority
    }

    example tie is {not simpleMajority} for {
        Voter = `V1 + `V2 + `V3 + `V4
        Candidate = `C1 + `C2
        Party = `P1 + `P2
        Winner = `W

        `C1.party = `P1
        `C2.party = `P2
        `P1.candidates = `C1
        `P2.candidates = `C2

        `P1.members = `V1 + `V2
        `P2.members = `V3 + `V4

        `V1.partyChoice = `P1
        `V2.partyChoice = `P1
        `V3.partyChoice = `P2
        `V4.partyChoice = `P2

        `V1.firstChoice = `C1
        `V2.firstChoice = `C2
        `V3.firstChoice = `C1
        `V4.firstChoice = `C2

        `W.candidate = `C1
        ElectionSystem = `SimpleMajority
        `W.system = `SimpleMajority
    }

    example oneVoterElection is {simpleMajority} for {
        Voter = `V1
        Candidate = `C1
        Party = `P1
        Winner = `W

        `C1.party = `P1
        `P1.candidates = `C1
        `P1.members = `V1
        `V1.partyChoice = `P1
        `V1.firstChoice = `C1

        `W.candidate = `C1
        ElectionSystem = `SimpleMajority
        `W.system = `SimpleMajority
    }
}

// assert simpleMajority is sufficient for wellformed for 1 Winner // failing test
