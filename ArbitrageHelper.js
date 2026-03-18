const { ethers } = require("ethers");

async function calculateProfit(amountIn, priceImpact, gasCost) {
    // Simplified helper to estimate if an arb is worth the gas
    const estimatedReturn = amountIn * priceImpact;
    return estimatedReturn - gasCost;
}

module.exports = { calculateProfit };
