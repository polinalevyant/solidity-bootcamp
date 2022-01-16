// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
pragma abicoder v2;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

contract DeFi {

    uint24 public constant poolFee = 3000;

    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    
    ISwapRouter public immutable swapRouter;
    constructor() { swapRouter = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564); }

    function swapDAItoToken(uint256 amountIn, address _tokenAddress) external returns (uint256 amountOut) {
        require(amountIn > 0, "Amount cannot be less 0 or less");

         // Approve the router to spend DAI.
        TransferHelper.safeApprove(DAI, address(swapRouter), amountIn);

        ISwapRouter.ExactInputSingleParams memory params = 
        ISwapRouter.ExactInputSingleParams({
            tokenIn: DAI,
            tokenOut: _tokenAddress,
            fee: poolFee,
            recipient: msg.sender,
            deadline: block.timestamp,
            amountIn: amountIn,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });
        
        // The call to `exactInputSingle` executes the swap.
        amountOut = swapRouter.exactInputSingle(params);
        return amountOut;
    }
}
