# GordoNFT
How does the Gordo NFT work? 
Every 1 hour for the next 10 Days the fully decentralized system randomly deactivates 10 Gordo NFTs until 4 Gordo Winner NFTs will remain. Each winner NFT holder earns 10% from the upcoming royalties for the next 10 days after the winner selection. 

How high is the Jackpot?
The 4 winner NFTs will win for the next 10 days (after the winners are selected) in total 40% royalties; Which means every winner NFT wins 10% royalties. The royalties amount depends on the NFT trading volume within the 10 days timeline after the winners get selected.

Can I sell my Winner NFT within the 10 royalty earning days?
If you have a buyer you can sell your winner NFT and the upcoming royalties will be transferred to the new owner.

How long will I earn the royalties?
As one of the 4 winner NFTs you can earn for 10 total days after the winners are selected.

How will I receive my winnings as the winner NFT owner?
You will receive the royalties automatically every 60 minutes into your wallet which holds the winner NFT.

How can I know if my NFT is still active in the lottery?
Your NFT is still active if it's still golden or black as winner NFTs afer refreshing the metadatas. 

When can I sell/list my NFT?
You can always list your NFT on any NFT Marketplace which supports our collection and if the buyers match your offer you can sell it. We listed our collection on the opensea.io Marketplace which you can find here. (link)

How high are the total royalties?
Total 47.5%
NFT Lottery 40%
Gordo Team 7.5%

How much Gordo NFTs do we have?
We have 10,000 Gordo NFTs, which is the max supply

How're the Gordo NFTs distributed?
The NFTs get distributed randomly to a part from the following NFT holders (upcoming)

# Contracts
## GordoNFT
This is ERC721 on-chain NFT, which have max supply 10000
## GordoVault
This is fee collect contract. 
When users buy/sell GordoNFT on market place, the royalty will go to this contract
## VRFv2DirectFundingConsumer
chainlink random number generator, which random numbers will be used to select 40 NFTs to make the inactive in each round.
callbackGasLimit : this value can be changed in live version deployment.
## Lottery
This is main contract of this project, which run lottery by chainlink custom upkeeper
there are 2 functions 
checkUpkeep : check running condition
performUpkeep : run in each 1 hours by chainlink automation

