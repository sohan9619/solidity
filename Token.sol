pragma solidity ^0.4.2;

contract Token {
    string  public name = "SohanToken";
    string  public symbol = "Sohan";
    string  public standard = "Sohan v1.0";
    uint256 public totalSupply;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor  (uint256 _initialSupply) public {
        balanceOf[msg.sender] = _initialSupply;
        totalSupply = _initialSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

       emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function approve(address _spender, uint256 _value) public  returns (bool success) {
        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public payable returns (bool success) {
       // require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);

       // balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        allowance[_from][msg.sender] -= _value;

       emit Transfer(_from, _to, _value);

        return true;
    }
}
contract TokenSale is Token{
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
