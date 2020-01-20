pragma solidity ^0.6.1;

contract Insurance{

    address Owner;

    struct citizen{
        bool isIdGenearted;
        string name;
        uint amountInsurancedBalance;
    }

    mapping(address => citizen) public citizenmapping;
    mapping(address => bool) public doctormapping;

    constructor() public{
        Owner = msg.sender;
    }

    modifier onlyOwner(){
        require(Owner == msg.sender,'OnlyAdmin');
        _;
    }

    function setDoctor(address _address) onlyOwner() external {
        require(!doctormapping[_address]);
        doctormapping[_address]=true;

    }

    function setCitizendata(string calldata _name,uint _amountinsuranced)onlyOwner() payable external returns(address){
        bytes32 data =sha256(abi.encodePacked(msg.sender,now ));
        address uniqueID = address(uint160(uint256(data)));
        require(!citizenmapping[uniqueID].isIdGenearted);
        citizenmapping[uniqueID].isIdGenearted=true;
        citizenmapping[uniqueID].name=_name;
        citizenmapping[uniqueID].amountInsurancedBalance=_amountinsuranced;

        return uniqueID;

    }

    function useInsurance (address _uniqueId, uint _amountused) external returns( string memory){
        require(doctormapping[msg.sender]);
        if(citizenmapping[_uniqueId].amountInsurancedBalance < _amountused){
            revert();
        }

            citizenmapping[_uniqueId].amountInsurancedBalance -=_amountused;
            return "Insurance has been successfly";

    }




}