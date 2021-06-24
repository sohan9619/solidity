pragma solidity ^0.4.2;
import "./Token.sol";
contract  TokenSale {
    address admin;
    Token public tokenContract;
    uint  public tokenPrice;
    uint256 public tokensSold;
    uint public inital;
    string public Presale;

    event Sell(address _buyer, uint256 _amount);
    

    constructor (Token _tokenContract ) public {
    
        admin = msg.sender;
        tokenContract = _tokenContract;
        
    }

    function multiply(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }

    function buyTokensinital(uint256 _numberOfTokens) public payable {
        if(tokensSold <= 30000000) {
        tokenPrice = 1;}else{tokenPrice= 2;}
        
        require(msg.value == multiply(_numberOfTokens, tokenPrice));
        require(tokenContract.balanceOf(this) >= _numberOfTokens);
        require(tokenContract.transfer(msg.sender, _numberOfTokens));

        tokensSold += _numberOfTokens;

       emit  Sell(msg.sender, _numberOfTokens);
    
    }

        
    
    
     

    function endSale() public {
        require(msg.sender == admin);
        require(tokenContract.transfer(admin, tokenContract.balanceOf(this)));

        // UPDATE: Let's not destroy the contract here
        // Just transfer the balance to the admin
        admin.transfer(address(this).balance);
    }
}
