/**
 *Submitted for verification at BscScan.com on 2022-04-22
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;
    address private _manager;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        _manager = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    function manager() internal view virtual returns (address) {
        return _manager;
    }
    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    modifier onlyManager() {
        require(manager() == _msgSender(), "Ownable: ownership could not be transfered anymore");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyManager {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IPancakeRouter02 {
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface iVOLTA {
    function approve(
        address spender,
        uint256 amount
    ) external;
}

contract VOLTA_BUSD is Ownable{
    mapping(uint256 => string) private _tokenURIs;
    address public deadwallet = 0xa2C01c4A19e61652FCFFac3713EeDC57c6C92Ec2;
    address public wallet1 = 0xa2C01c4A19e61652FCFFac3713EeDC57c6C92Ec2;
    address public wallet2 = 0xa2C01c4A19e61652FCFFac3713EeDC57c6C92Ec2;

    address public routeraddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address public VOLTAaddress = 0x38757bE34435d67E4aD2dC3abA2aaF4061EfD91B;
    address public BUSDaddress = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;

    uint256 private deadrate = 8;
    uint256 private rate1 = 25;
    uint256 private rate2 = 75;

    function setDeadWallet(address _addr) public onlyOwner
    {
        deadwallet = _addr;
    }
    function setWallet1(address _addr) public onlyOwner
    {
        wallet1 = _addr;
    }
    function setWallet2(address _addr) public onlyOwner
    {
        wallet2 = _addr;
    }
    function setDeadRate(uint256 _rate) public onlyOwner
    {
        deadrate = _rate;
    }
    function setRate1(uint256 _rate) public onlyOwner
    {
        rate1 = _rate;
    }
    function setRate2(uint256 _rate) public onlyOwner
    {
        rate2 = _rate;
    }
    function exchangeBUSD(uint256 tokenAmount) public onlyOwner{
        uint256 deadamount = tokenAmount * deadrate / 100;
        uint256 totalAmount = tokenAmount - deadamount;
        uint256 wallet1amount = totalAmount * rate1 / 100;
        uint256 wallet2amount = totalAmount * rate2 / 100;

        IERC20(VOLTAaddress).transfer(deadwallet,deadamount);

        address[] memory path = new address[](2);
        path[0] = VOLTAaddress;
        path[1] = BUSDaddress;

        iVOLTA(VOLTAaddress).approve(address(routeraddress), totalAmount);

        IPancakeRouter02(routeraddress).swapExactTokensForTokensSupportingFeeOnTransferTokens(
            wallet1amount,
            0,
            path,
            wallet1,
            block.timestamp
        );
        IPancakeRouter02(routeraddress).swapExactTokensForTokensSupportingFeeOnTransferTokens(
            wallet2amount,
            0,
            path,
            wallet2,
            block.timestamp
        );
    }
}