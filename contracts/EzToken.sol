pragma solidity ^0.4.2;

interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract EZToken {
    using SafeMath for uint256;

    // Public variables of the token
    string public name = "EZToken" ;
    string public symbol = "EZT";
    uint8 public decimals = 8;
    uint256 public totalSupply = 0;
    uint256 public icoSupply = 11500000;
    uint256 public foundersSupply = 3500000;
    uint256 public yearlySupply = 3500000;
	
	
	
    mapping (address => uint) public freezedAccounts;

	
    uint founderFronzenUntil = 1530403200;  //2018-07-01
    uint year1FronzenUntil = 1546300800; //2019-01-01
    uint year2FronzenUntil = 1577836800; //2020-01-01
    uint year3FronzenUntil = 1609459200; //2021-01-01
    uint year4FronzenUntil = 1640995200; //2022-01-01
    uint year5FronzenUntil = 1672531200; //2023-01-01
    uint year6FronzenUntil = 1704067200; //2024-01-01
    uint year7FronzenUntil = 1735689600; //2025-01-01
    uint year8FronzenUntil = 1767225600; //2026-01-01
    uint year9FronzenUntil = 1798761600; //2027-01-01
    uint year10FronzenUntil = 1830297600; //2028-01-01
	
    // This creates an array with all balances
    mapping (address => uint256) internal balances;
    mapping (address => mapping (address => uint256)) internal allowed;

	bool public transfersEnabled = true;

    // This generates a public event on the blockchain that will notify clients
    event Transfer(address indexed from, address indexed to, uint256 value);

    // This notifies clients about the amount burnt
    event Burn(address indexed from, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * Constructor function
     *
     * Initializes contract with initial supply tokens to the creator of the contract
     */
    function EZToken(address _founderAddress, address _year1, address _year2, address _year3, address _year4, address _year5, address _year6, address _year7, address _year8, address _year9, address _year10 ) public {
		totalSupply = 50000000 * 10 ** uint256(decimals)
        
        balances[msg.sender] = icoSupply * 10 ** uint256(decimals);                 
        Transfer(address(0), msg.sender, icoSupply);
		
		
        freezedAccounts[_founderAddress] = founderFronzenUntil;
        balances[_founderAddress] = foundersSupply * 10 ** uint256(decimals);
        Transfer(address(0), _founderAddress, foundersSupply);
		
        freezedAccounts[_year1] = year1FronzenUntil;
        balances[_year1] = yearlySupply * 10 ** uint256(decimals);
        Transfer(address(0), _year1, yearlySupply);
        
		
        freezedAccounts[_year2] = year2FronzenUntil;
        balances[_year2] = yearlySupply * 10 ** uint256(decimals);
        Transfer(address(0), _year2, yearlySupply);
		
        freezedAccounts[_year3] = year3FronzenUntil;
        balances[_year3] = yearlySupply * 10 ** uint256(decimals);
        Transfer(address(0), _year3, yearlySupply);
		
        freezedAccounts[_year4] = year4FronzenUntil;
        balances[_year4] = yearlySupply * 10 ** uint256(decimals);
        Transfer(address(0), _year4, yearlySupply);
		
        freezedAccounts[_year5] = year5FronzenUntil;
        balances[_year5] = yearlySupply * 10 ** uint256(decimals);
        Transfer(address(0), _year5, yearlySupply);
		
        freezedAccounts[_year6] = year6FronzenUntil;
        balances[_year6] = yearlySupply * 10 ** uint256(decimals);
        Transfer(address(0), _year6, yearlySupply);
		
        freezedAccounts[_year7] = year7FronzenUntil;
        balances[_year7] = yearlySupply * 10 ** uint256(decimals);
        Transfer(address(0), _year7, yearlySupply);
		
        freezedAccounts[_year8] = year8FronzenUntil;
        balances[_year8] = yearlySupply * 10 ** uint256(decimals);
        Transfer(address(0), _year8, yearlySupply);
		
        freezedAccounts[_year9] = year9FronzenUntil;
        balances[_year9] = yearlySupply * 10 ** uint256(decimals);
        Transfer(address(0), _year9, yearlySupply);
		
        freezedAccounts[_year10] = year10FronzenUntil;
        balances[_year10] = yearlySupply * 10 ** uint256(decimals);
        Transfer(address(0), _year10, yearlySupply);
    }
	
	/**
     * Get the token balance for account `_owner`
     */
    function balanceOf(address _owner) public constant returns (uint256 balance) {
        return balances[_owner];
    }
	
    /**
     * Returns the amount of tokens approved by the owner that can be
     * transferred to the spender's account
     */
    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    /**
     * Transfer token for a specified address
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     */
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);
        require(freezedAccounts[msg.sender] == 0 || freezedAccounts[msg.sender] < now);
        require(freezedAccounts[_to] == 0 || freezedAccounts[_to] < now);

        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
     * Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint256 the amount of tokens to be transferred
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);
        require(freezedAccounts[_from] == 0 || freezedAccounts[_from] < now);
        require(freezedAccounts[_to] == 0 || freezedAccounts[_to] < now);

        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        Transfer(_from, _to, _value);
        return true;
    }

    

    /**
     * Set allowed for other address
     *
     * Allows `_spender` to spend no more than `_value` tokens on your behalf
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     */
    function approve(address _spender, uint256 _value) public
        returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
     * Set allowed for other address and notify
     *
     * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     * @param _extraData some extra information to send to the approved contract
     */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData)
        public
        returns (bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, this, _extraData);
            return true;
        }
    }

    /**
     * Destroy tokens
     *
     * Remove `_value` tokens from the system irreversibly
     *
     * @param _value the amount of money to burn
     */
    function burn(uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value);   // Check if the sender has enough
        balances[msg.sender] -= _value;            // Subtract from the sender
        totalSupply -= _value;                      // Updates totalSupply
        Burn(msg.sender, _value);
        return true;
    }

    /**
     * Destroy tokens from other account
     *
     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
     *
     * @param _from the address of the sender
     * @param _value the amount of money to burn
     */
    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(balances[_from] >= _value);                // Check if the targeted balance is enough
        require(_value <= allowed[_from][msg.sender]);    // Check allowed
        balances[_from] -= _value;                         // Subtract from the targeted balance
        allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowed
        totalSupply -= _value;                              // Update totalSupply
        Burn(_from, _value);
        return true;
    }
}
