# Advanced Sample Hardhat Project

This project demonstrates an advanced Hardhat use case, integrating other tools commonly used alongside Hardhat in the ecosystem.

The project comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts. It also comes with a variety of other tools, preconfigured to work with the project code.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
npx hardhat help
REPORT_GAS=true npx hardhat test
npx hardhat coverage
npx hardhat run scripts/deploy.ts
TS_NODE_FILES=true npx ts-node scripts/deploy.ts
npx eslint '**/*.{js,ts}'
npx eslint '**/*.{js,ts}' --fix
npx prettier '**/*.{json,sol,md}' --check
npx prettier '**/*.{json,sol,md}' --write
npx solhint 'contracts/**/*.sol'
npx solhint 'contracts/**/*.sol' --fix
```

# Etherscan verification

To try out Etherscan verification, you first need to deploy a contract to an Ethereum network that's supported by Etherscan, such as Ropsten.

In this project, copy the .env.example file to a file named .env, and then edit it to fill in the details. Enter your Etherscan API key, your Ropsten node URL (eg from Alchemy), and the private key of the account which will send the deployment transaction. With a valid .env file in place, first deploy your contract:

```shell
hardhat run --network ropsten scripts/deploy.ts
```

Then, copy the deployment address and paste it in to replace `DEPLOYED_CONTRACT_ADDRESS` in this command:

```shell
npx hardhat verify --network ropsten DEPLOYED_CONTRACT_ADDRESS "Hello, Hardhat!"
```

# Performance optimizations

For faster runs of your tests and scripts, consider skipping ts-node's type checking by setting the environment variable `TS_NODE_TRANSPILE_ONLY` to `1` in hardhat's environment. For more details see [the documentation](https://hardhat.org/guides/typescript.html#performance-optimizations).


## Testing
| Test Case # | Feature/Functionality         | Input/Action                                              | Expected Output                | Error Case / Validation                | Test Steps                                                                 | Result                        |
|-------------|------------------------------|----------------------------------------------------------|--------------------------------|----------------------------------------|--------------------------------------------------------------------------|-------------------------------|
| 1           | Property NFT Minting         | Property details, metadata URI                           | NFT minted, token ID returned  | Missing data → Show error              | 1. Enter property info 2. Submit mint 3. Check for NFT creation           | Pass (if NFT created)         |
| 2           | Property Listing             | NFT token ID, price                                      | Listing created                | Invalid price → Show error             | 1. Select NFT 2. Set price 3. List property 4. Verify listing             | Pass (if listing appears)     |
| 3           | Property Purchase            | Listing ID, payment                                      | Ownership transferred          | Insufficient funds → Show error        | 1. Select listing 2. Pay 3. Confirm ownership transfer                    | Pass (if ownership changes)   |
| 4           | View All Listings            | User visits marketplace page                             | Listings displayed             | No listings → Show empty state         | 1. Go to listings page 2. Check property list                             | Pass (if listings shown)      |
| 5           | User Profile/Assets          | User logs in, views profile                              | Owned NFTs/listings shown      | Not logged in → Redirect/login prompt  | 1. Log in 2. Go to profile 3. Check owned properties                      | Pass (if assets shown)        |
| 6           | Commission Distribution      | Sale transaction                                         | Commissions auto-distributed   | Incorrect split → Show error/log       | 1. Complete sale 2. Check balances of seller, marketplace, government     | Pass (if funds split correctly)|

## Literature review

| Area of Study                               | Key Insights from Existing Research                                                                                                | How It Shapes Our Project                                                                                                                                  |
| :------------------------------------------ | :--------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Blockchain Applications in Real Estate**  | Confirms blockchain's ability to boost transaction security, increase transparency in ownership records, and streamline processes. | Justifies using blockchain as the core technology to build a more trustworthy and efficient property ownership system.                                       |
| **NFTs for Representing Unique Assets**     | Shows Non-Fungible Tokens (NFTs) are effective for creating unique digital versions of real-world items, like property.            | Provides the method for turning physical properties into distinct, digitally verifiable assets (NFTs) that can be easily managed and traded.                |
| **Smart Contracts for Fractional Ownership** | Demonstrates smart contracts can automatically manage shared ownership and DeFi principles can make high-value assets more accessible. | Guides our approach to (or future goal of) allowing property NFTs to be divided into shares, opening up real estate investment to more people.                |
