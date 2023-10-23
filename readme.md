#About

This is a crowd sourcing app!

#Quick start and basic actions

install Chainlink contracts from https://github.com/smartcontractkit/chainlink-brownie-contracts

```
forge install /smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit
```

to make contracts see downloaded lib, need to add remappings: in foundry.toml file

```aidl
 remappings = ["@chainlink/contracts/=lib/chainlink-brownie-contracts/contracts"]
```

to install Foundry Devops library
```forge install Cyfrin/foundry-devops --no-commit```

Need to add .env with env vars

TO Run local network:

```
anvil
```

TO DEPLOY via Deploy script:

```
forge script script/DeployFundMe.s.sol
```

!!!! Casting Hex/binary to Dec !!!!!!:

```
cast --to-base 0x714e1 dec
```

if Env variables not seen

```
source .env
```

To deploy with ThirdWeb (https://thirdweb.com/contracts/deploy) :

```
npx thirdweb deploy
```

//////////////////////////////////////

to run Contracts methods via terminal run "ContractAddress"(0x5FbDB2315678afecb367f032d93F642f64180aa3) and NameOfFunctionWithSignature ("store(uint256)"):

```
cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 "store(uint256)" 123 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

```
cast call 0x5FbDB2315678afecb367f032d93F642f64180aa3 "retrieve()"
```

Run tests with or without logs:

```
forge test
forge test -vv
```

To run test on specific forked Chains

```
forge test --match-test testPriceFeedVersion -vvv --fork-url https://eth-sepolia.g.alchemy.com/v2/R8Iaep8aOpj1F3i1jn9S_iU8b8pwIo8Q
forge test --match-test testPriceFeedVersion -vvv --fork-url $SEPOLIA_RPC_URL
```

to run 1 specific test:

```
forge test --match-test test/testFundUpdatesAddressToAmountFundedDataStructure
```

to check test coverage:

```
forge coverage --fork-url $SEPOLIA_RPC_URL
```

to create snapshot document with gas spending for a test run 
```
forge snapshot  --match-test testWithdrawWithMultipleFunder
```

to Inspect Storage location of all Variabels:
```forge inspect FundMe storageLayout```

to check Storage usage for specific contract use:
```forge inspect FundMe storageLayout```

second way... 

step 1 
```anvil```
step 2: open new terminal( rps url and private key from anvil network)
```forge script script/DeployFundMe.s.sol --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast```

step 3: take contract addres from deployed contranct and number of storage block and run:
```cast storage 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 2```


IF MAKEFILE NOT WORKING use manual script 
```
forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --private-key $SEPOLIA_PRIVATE_KEY --verify --etherscan-api-key $ETHESCAN_API_KEY -vvvv
```
