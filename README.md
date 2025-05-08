# 1710-FinalProject



# Ranked Choice Overview

For this election method we implemented ranked choice. For ranked choice voters are given a first choice, second choice, and third choice to vote for their candidate. The candidate with the majority of the votes wins outright. If this doesn't happen, the candidate with the fewest first choice votes is eliminated, and the voters who had them as their first choice have their second choice vote added to the recount. This cycle repeats until a majority is found.

When making this representation we had to make some tradeoffs, which limited the overall scope of the model. First, we only implemented voting for three candidates, which means voters only got a first and second choice. We chose this method as the model becomes exponentially more complex the more rounds that are added, which decreased the understandability of the model. Second, we chose to model individual voters as sigs, which drastically reduced the possible number of voters. This resulted in more ties, and possibly less applicability to the real world. Despite this, these assumptions on the scope of the project were necessary to create a model that could clearly be understood by the viewer without adding the complexity of a large population of voters.

When first starting ranked choice, I attempted to add traces. I found this to be unrealistic as the computation between rounds made modeling the problem significantly more complex. For this reason, the model is computed in one step through assigning a winner after evaluating the choices the voters made. When viewing an instance of our model each voter has a first choice, second choice, and third choice. The ranked choice voting system is calculated from these choices, resulting in a winner through the rules of ranked choice.
