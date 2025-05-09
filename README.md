# 1710-FinalProject

# Project Overview

In this project we compared 3 common voting systems with Forge modeling. Each system model is outlined below. Run the models and accompanying visualizations, changing the number of voters and their party preferences, to observe how different voting systems can influence the outcome of an election! 

## Simple Majority

In the simple majority system model, voters are represented by the Voter sig, each with a party affiliation and a single first-choice candidate. Candidates are defined by the Candidate sig and are affiliated with a Party. Parties group voters and candidates together for consistency and party alignment. The election system is represented by an abstract ElectionSystem, with SimpleMajority extending it, and a Winner sig identifies the candidate who wins under this system.

The function firstChoiceVotes counts how many voters selected a candidate as their first choice. The simpleMajority predicate enforces that a winner must have more first-choice votes than any other candidate. The wellformed predicate ensures that voters’ choices are valid—specifically, that a voter’s selected candidate must belong to their affiliated party.

We chose a simple approach to voting to avoid the complexity of preference rankings or runoff logic. To maintain a manageable model size, we limited the scope to a couple candidates, voters, and parties. This kept the logic understandable and reduced the computational load in Forge. We also modeled voters with strict party loyalty to simplify voter-candidate relationships, although this does not fully reflect real-world electoral behavior.

This model assumes that voters always vote within their own party and that there is no ambiguity in vote counts (i.e., no ties are considered, the election is run again or else voter count is forced to be odd). It also simplifies real-world elections by using small, fixed numbers of voters and candidates, which may lead to a higher frequency of unrealistic or evenly split outcomes.

The simple majority system is straightforward but vulnerable to vote splitting, especially in elections with more than two candidates. Our model demonstrates how a candidate can win without an absolute majority, which may lead to questions about fairness and representation. Plurality voting comes with its downsides, but can still be an effective way to decide an election outcome. 

## Ranked Choice Overview

For this election method we implemented ranked choice. For ranked choice voters are given a first choice, second choice, and third choice to vote for their candidate. The candidate with the majority of the votes wins outright. If this doesn't happen, the candidate with the fewest first choice votes is eliminated, and the voters who had them as their first choice have their second choice vote added to the recount. This cycle repeats until a majority is found.

When making this representation we had to make some tradeoffs, which limited the overall scope of the model. First, we only implemented voting for three candidates, which means voters only got a first and second choice. We chose this method as the model becomes exponentially more complex the more rounds that are added, which decreased the understandability of the model. Second, we chose to model individual voters as sigs, which drastically reduced the possible number of voters. This resulted in more ties, and possibly less applicability to the real world. Despite this, these assumptions on the scope of the project were necessary to create a model that could clearly be understood by the viewer without adding the complexity of a large population of voters.

When first starting ranked choice, I attempted to add traces. I found this to be unrealistic as the computation between rounds made modeling the problem significantly more complex. For this reason, the model is computed in one step through assigning a winner after evaluating the choices the voters made. When viewing an instance of our model each voter has a first choice, second choice, and third choice. The ranked choice voting system is calculated from these choices, resulting in a winner through the rules of ranked choice.

## Electoral College

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


## Collaborators 

Ricardo, Sydney, and Tristan. 
