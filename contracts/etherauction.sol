contract EtherAuction {
	address public winner;
	uint public highestBid;
	uint public nextSale;
	uint public startBlock;
	uint public duration;
	uint public rollOverFactor;

	function EtherAuction(uint _duration, uint _rollOverFactor) {
		startBlock = block.number;
		winner = msg.sender;
		highestBid = 0;
		nextSale = 0;
		duration = _duration;
		rollOverFactor = _rollOverFactor;
	}

	event WinningBid(address newWinner, uint bid);

	event NewAuction(uint onSale, uint start, uint duration);

	function onSale() constant returns(uint) {
		return this.balance - nextSale;
	}
	function endBlock() constant returns(uint) {
		return startBlock + duration;
	}
	// Makes a new bid for the ether on sale  
	function bid() {
		if (startBlock + duration <= block.number) {throw;}
		if (msg.value <= highestBid) {throw;}
		if (highestBid > 0) {
			if (!winner.send(highestBid - highestBid/rollOverFactor)) {throw;}
			nextSale = nextSale - (highestBid - highestBid/rollOverFactor);
		}
		highestBid = msg.value;
		nextSale = nextSale + highestBid;
		winner = msg.sender;
		WinningBid(winner, highestBid);
	}
	// Claims the ether on sale for the winner and starts a new auction
	function claim() {
		if (startBlock + duration > block.number) {throw;}
		if (highestBid > 0) {
			nextSale = nextSale;
			if (!winner.send(this.balance - nextSale)) {throw;}
		}
		highestBid = 0;
		nextSale = 0;
		startBlock = block.number;
		NewAuction(this.balance, startBlock, duration);
	}

	// We will fallback to a bid
	function() {
		bid();
	}
}