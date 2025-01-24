# Trustee Payout Test

To start up the enviroment, run:

```sh
forge install
```

There may be an issue with the libraries not being found in the `currency-1.5` or `op-eco` git submodule. If this occurs, run:

```sh
cd lib/currency-1.5
yarn install
cd -
cd lib/op-eco
yarn install
cd -
```

The final echo is because of an issue where forge remappings don't pick up the op-eco openzeppelin library because of namespace conflict.

To build, run:

```sh
forge build
```

To test, run:

```sh
forge test
```

---

### Tenderly Deployment Scripts

These scripts require an active Tenderly account with a virtual fork of Mainnet (and Optimism for some cases) and valid key. After the simulation, run the proposal enactment using the Tenderly Simulation UI, and you can confirm it works as intended.

###### 1) For the Trustee Payout Proposal

To run the script to run the proposal deploymeny to Tenderly, please run:

```sh
forge script script/1_Trustee_Payout/Deploy.s.sol:Deploy --chain-id 1 --rpc-url $TENDERLY_VIRTUAL_FORK --etherscan-api-key $TENDERLY_ACCESS_KEY --verifier-url $TENDERLY_VERIFIER_URL --broadcast --verify -vvvv
```

###### 2) For the Change Pauser Proposal

To run the script to run the proposal deploymeny to Tenderly, please run:

```sh
forge script script/2_Change_Pauser/Deploy.s.sol:Deploy --chain-id 1 --rpc-url $TENDERLY_VIRTUAL_FORK --etherscan-api-key $TENDERLY_ACCESS_KEY --verifier-url $TENDERLY_VERIFIER_URL --broadcast --verify -vvvv
```

###### 3) For the Eco Zero Proposal

To run the script to run the proposal deploymeny to Tenderly, please run:

```sh
address=$(forge script script/3_Eco_Zero_Proposal/DeployOptimism.s.sol:DeployOptimism \
  --chain-id 10 \
  --rpc-url "$TENDERLY_OPTIMISM_VIRTUAL_FORK" \
  --etherscan-api-key "$TENDERLY_ACCESS_KEY" \
  --verifier-url "$TENDERLY_OPTIMISM_VERIFIER_URL" \
  --broadcast --verify -vvvv \
  | grep -i "Start verifying contract"|awk -F'\`' '{print $2}')

echo "Contract Address: $address"

forge script script/3_Eco_Zero_Proposal/DeployMainnet.s.sol:DeployMainnet \
  --sig "run(address)" $address \
  --chain-id 1 \
  --rpc-url "$TENDERLY_VIRTUAL_FORK" \
  --etherscan-api-key "$TENDERLY_ACCESS_KEY" \
  --verifier-url "$TENDERLY_VERIFIER_URL" \
  --broadcast --verify -vvvv

unset address
```
