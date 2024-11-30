# charity-donation-smart-contract

This is a smart contract for a charity donation system. The contract is written in Solidity and is deployed on the Ethereum blockchain.

## Installation
1. Clone the repository: `git clone https://github.com/CCBC2024/ccmp-606-smart-contract.git`
2. Navigate to the project directory: `cd ccmp-606-smart-contract`
3. Install the dependencies: `npm install`

## Configuration
Copy the `.env.example` file to `.env` and update the following environment variables:
- `MNEMONIC`: The mnemonic phrase for the Ethereum wallet.
- `API_URL`: The URL of the provider for the Ethereum blockchain (e.g., Infura).
- `USDC_SMART_CONTRACT_ADDRESS`: The address of the USDC smart contract on the Sepolia testnet. We already provided the default address in the `.env.example` file.

## Compile Smart Contract
To compile the smart contract, you can use the following command:
```
truffle compile
```

## Test
Currently, we just added two tests to ensure that the smart contract is deployed successfully.
In the future, we will add more tests to cover all the functionalities of the smart contract.
All functionalities of the smart contract are tested manually.

### Ganache
To run the tests on a local blockchain, you can use the following command:
```
truffle test --network development
```

### Sepolia Testnet
To run the tests on the Sepolia testnet, you can use the following command:
```
truffle test --network sepolia
```

## Deploy Smart Contract
### Ganache
To deploy the smart contract to a local blockchain, you can use the following command:
```
truffle migrate --network development
```

### Sepolia Testnet
To deploy the smart contract to the Sepolia testnet, you can use the following command:
```
truffle migrate --network sepolia
```
