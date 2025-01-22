# Trustee Payout Test
// TODO: FIX README

To start up the enviroment, run:

```
forge install
```

There may be an issue with the libraries not being found in the `currency-1.5` git submodule. If this occurs, run:

```
cd lib/currency-1.5
yarn install
cd -
cd lib/op-eco
yarn install
cd -
forge remappings > remappings.txt
```

To build, run:

```
forge build
```

To test, run:

```
forge test
```

### For the Trustee Payout Proposal 

To run the script to run the proposal deploymeny to Tenderly, please run:
```
forge script script/Deploy.s.sol:Deploy --rpc-url $TENDERLY_VIRTUAL_FORK --broadcast
```

This requires an active Tenderly account with a virtual fork and valid key. After the simulation, run the proposal enactment using the Tenderly Simulation UI, and you can confirm it works.