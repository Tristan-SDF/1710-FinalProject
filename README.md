# 1710-FinalProject

# Ranked Choice Overview

For this election method we implemented ranked choice. For ranked choice voters are given a first choice, second choice, and third choice to vote for their candidate. The candidate with the majority of the votes wins outright. If this doesn't happen, the candidate with the fewest first choice votes is eliminated, and the voters who had them as their first choice have their second choice vote added to the recount. This cycle repeats until a majority is found.

When making this representation we had to make some tradeoffs, which limited the overall scope of the model. First, we only implemented voting for three candidates, which means voters only got a first and second choice. We chose this method as the model becomes exponentially more complex the more rounds that are added, which decreased the understandability of the model. Second, we chose to model individual voters as sigs, which drastically reduced the possible number of voters. This resulted in more ties, and possibly less applicability to the real world. Despite this, these assumptions on the scope of the project were necessary to create a model that could clearly be understood by the viewer without adding the complexity of a large population of voters.

When first starting ranked choice, I attempted to add traces. I found this to be unrealistic as the computation between rounds made modeling the problem significantly more complex. For this reason, the model is computed in one step through assigning a winner after evaluating the choices the voters made. When viewing an instance of our model each voter has a first choice, second choice, and third choice. The ranked choice voting system is calculated from these choices, resulting in a winner through the rules of ranked choice.

# Electoral College

Model Structure
Core Components

Voters: Represented by the Voter sig, each voter belongs to a county, is affiliated with a party, and has ranked preferences for candidates (first, second, and third choices).
Counties: Represented by the County sig, counties have electoral votes and neighbor relationships with other counties.
Candidates: Represented by the Candidate sig, candidates are affiliated with a party and have a set of voters who support them.
Parties: Represented by the Party sig, parties have member voters and affiliated candidates.

Key Predicates and Functions

wellformed: Ensures the model maintains proper relationships (voter choices are valid, party memberships are consistent, etc.)
votesForCandidateInCounty: Counts votes for a candidate in a specific county
isCountyWinner: Determines if a candidate wins a specific county
countyWinner: Returns the winner of a county, with tiebreaking mechanisms
electoralVotesForCandidate: Calculates the total electoral votes a candidate receives
isElectoralWinner: Determines if a candidate wins the electoral college
popularVotesForCandidate: Counts total popular votes for a candidate
popularVoteWinnerLoses: Tests for scenarios where the popular vote winner doesn't win the electoral college

Design Decisions and Tradeoffs
Representation Choices

County Structure: We represented counties as nodes in a graph with neighbor relationships to model geographical adjacency. This allows for potential future analysis of geographical voting patterns.
Electoral Vote Allocation: We assigned electoral votes as integer values to counties rather than using a more complex allocation based on population. This simplification was necessary due to Forge's limitations in handling complex arithmetic but still captures the essential "winner-takes-all" nature of the electoral college.
Ranked Preferences: Even though the Electoral College system only uses first choices, we included second and third choices to maintain compatibility with our ranked choice voting system model, making it easier to compare outcomes across different systems.

Assumptions and Limitations

Scope: Our model assumes a simplified Electoral College with fewer counties and candidates than a real election. We found that bounds of 4 candidates, 20 voters, 8 counties, 2 parties, and a bitwidth of 5 for integers provided a good balance between instance complexity and solver performance.
Tiebreaking: We implemented a consistent tiebreaking mechanism that selects the candidate with the lowest ID in case of ties. While this is deterministic, real electoral systems have more complex tiebreaking procedures.
Party Influence: We model party affiliation but don't currently model how parties might influence voter preferences over time, as noted in our proposal's limitation section.

Key Findings

Popular Vote vs. Electoral College: Our model successfully demonstrates scenarios where the popular vote winner loses the electoral college. This confirms one of the most criticized aspects of the Electoral College system.
County Significance: Counties with high electoral vote counts have disproportionate influence on the final outcome, demonstrating how campaigns strategically focus on "swing states" with high electoral value.
