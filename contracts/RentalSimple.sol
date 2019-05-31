pragma solidity ^0.4.25;

contract RentalSimple {
    address public tenant;
    address public landlord;

    uint public startDate;

    uint public paymentPeriod;
    uint public rentPerPeriod;

    uint public periodPaidUntil;

    constructor(
        address _tenant,
        address _landlord,

        uint _paymentPeriod,
        uint _rentPerPeriod
    ) public {
        tenant = _tenant;
        landlord = _landlord;

        startDate = now;

        paymentPeriod = _paymentPeriod;
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
}
