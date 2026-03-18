// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FlashArb is Ownable {
    ISwapRouter public constant swapRouter = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);

    constructor() Ownable(msg.sender) {}

    struct FlashCallbackData {
        uint256 amount0;
        uint256 amount1;
        address payer;
        uint24 poolFee;
    }

    function initiateFlash(
        address poolAddress,
        uint256 amount0,
        uint256 amount1,
        uint24 poolFee
    ) external onlyOwner {
        IUniswapV3Pool pool = IUniswapV3Pool(poolAddress);
        
        bytes memory data = abi.encode(FlashCallbackData({
            amount0: amount0,
            amount1: amount1,
            payer: msg.sender,
            poolFee: poolFee
        }));

        pool.flash(address(this), amount0, amount1, data);
    }

    function uniswapV3FlashCallback(
        uint256 fee0,
        uint256 fee1,
        bytes calldata data
    ) external {
        FlashCallbackData memory decoded = abi.decode(data, (FlashCallbackData));
        
        // --- ARBITRAGE LOGIC START ---
        // Example: If we borrowed Token0, we swap it for Token1 elsewhere, 
        // then swap back to Token0 to realize a profit.
        // This is where your custom logic for the secondary exchange goes.
        // --- ARBITRAGE LOGIC END ---

        // Repay the loan
        if (decoded.amount0 > 0) {
            uint256 amountToRepay = decoded.amount0 + fee0;
            IERC20(IUniswapV3Pool(msg.sender).token0()).transfer(msg.sender, amountToRepay);
        }
        if (decoded.amount1 > 0) {
            uint256 amountToRepay = decoded.amount1 + fee1;
            IERC20(IUniswapV3Pool(msg.sender).token1()).transfer(msg.sender, amountToRepay);
        }
    }

    function withdrawToken(address token) external onlyOwner {
        uint256 balance = IERC20(token).balanceOf(address(this));
        IERC20(token).transfer(owner(), balance);
    }
}
