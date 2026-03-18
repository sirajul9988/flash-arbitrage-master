# Flash Arbitrage Master

This repository contains a professional-grade smart contract for performing **Flash Loan Arbitrage** using Uniswap V3. It allows users to borrow massive capital without collateral, execute trades across different liquidity pools, and repay the loan in a single transaction.

## Core Logic
* **Flash Loan:** Borrows assets from a Uniswap V3 pool using the `flash` function.
* **Arbitrage Execution:** Swaps the borrowed assets in a secondary pool where the price is higher.
* **Repayment:** Returns the original capital plus the pool fee to the source.
* **Profit:** Any remaining balance is transferred to the contract owner.

## Safety Features
* **Ownership Control:** Only the deployer can trigger the flash loan.
* **Slippage Checks:** Minimum output amounts are enforced to prevent front-running losses.
* **Emergency Withdraw:** Allows the owner to recover any stuck tokens.

## Setup
1. Define your `fee` levels (e.g., 500, 3000, 10000).
2. Deploy to a network with Uniswap V3 (Mainnet, Arbitrum, Optimism).
3. Call `initiateFlash` with the desired borrow amount.
