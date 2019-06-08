pragma solidity ^0.4.25;

contract RentalSimple2 {
    address public authority;
    address public tenant;
    address public landlord;

    uint public startDate;

    uint public paymentPeriod;
    uint public numberOfPeriods;
    uint public rentPerPeriod;

    uint public periodPaidUntil;

    uint public finalPeriod;

    constructor(
        address _authority,
        address _tenant,
        address _landlord,

        uint _paymentPeriod,
        uint _numberOfPeriods,
        uint _rentPerPeriod,
    ) public {
        authority = _authority;
        tenant = _tenant;
        landlord = _landlord;

        startDate = now;

        paymentPeriod = _paymentPeriod;
        numberOfPeriods = _numberOfPeriods;
        finalPeriod = _numberOfPeriods;
        rentPerPeriod = _rentPerPeriod;
    }

    function checkAddressBalance(address a) public view returns (uint) {
        return a.balance;
    }

    function checkContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    function currentPeriod() public view returns(uint) {
        return (now - startDate) / paymentPeriod + 1;
    }

    function payRent(uint _periods) public payable {
        // anyone can pay rent
        uint rentAmount = _periods * rentPerPeriod;
        require(msg.value >= rentAmount);
        tenant.transfer(msg.value - rentAmount); // return left-over funds back to tenant
        landlord.transfer(rentAmount);
        periodPaidUntil += _periods;
    }

    function authorityTerminate(uint _amountForTenant, uint _finalPeriod) public {
      require(msg.sender == authority);
      finalPeriod = _finalPeriod;
      require(_amountForTenant <= address(this).balance);
      tenant.transfer(_amountForTenant);
      landlord.transfer(address(this).balance);
      isTerminated = true;
      terminatedTime = now;
    }

}
