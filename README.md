# SoccerTransfers
An application in which multiple teams with multiple players are present. Each team will have a manager. 
For each player multiple teams can bid. The bid will be accepted /rejected/stalled by the manager. Highest 
bids are accepted. If bid amount is not greater than the current highest bid, the bid will not go through.


Tables:
Player
Manager
Transfer bids
Teams
Countries
Team Stats

Views:
Each team has a view ( eg : fc Barcelona, Real Madrid, FC Bayern Munich, Manchester City, 
Manchester United)
Transfers accepted.
Transfers rejected.

Transactions:
For each player only one bid is accepted, transaction on transfer request.


Triggers:
When a bid is accepted, as the date changes, the bid status changes from pending bid to approved.
The status is changed from pending to approved and the player is team ID is upated
