# EtherAuction
This is my first attempt at a smart contract in Ethereum. It is a contract auctioning ether for highest ether bid.

## Rules

The rules of the auction is as follows:

### Bidding
At deployment whatever amount of ether deposited in the contract will be on auction for a given amount of time. People holding ether can make bids to try to buy the ether on auction by sending ether to the contract. If a new bid higher than the previously highest bid it will be stored in the contract. The previously highest bidder will be refunded his bid minus some given fraction which will "roll over" and be sold in the next auction.  

### Claiming
Once an auction is done one can call the `claim` function in order to start a new auction. This will pay out the amount of ether that was on sale in the current auction to the winner of that auction. It will also start a new auction to sell whatever ether was payed as the highest bid plus any ehter that "rolled over" as part of non-winning bid.  
