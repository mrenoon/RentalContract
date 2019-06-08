pragma solidity ^0.4.25;

contract Rental {
    address public authority;
    address public tenant;
    address public landlord;

    uint public startDate;
    bool public isTerminated;

    uint public paymentPeriod;
    uint public numberOfPeriods;
    uint public rentPerPeriod;
    uint public paymentDeadlineSincePeriodStart;
    uint public maximumLatePaymentDuration;
    uint public terminationNotice;

    uint public depositAmount;

    uint public periodPaidUntil;

    bool landlordSigned;
    bool tenantSigned;
    uint public terminatedTime;
    uint public finalPeriod;

    constructor(
        address _authority,
        address _tenant,
        address _landlord,

        uint _startDate,
        uint _paymentPeriod,
        uint _numberOfPeriods,
        uint _rentPerPeriod,
        uint _paymentDeadlineSincePeriodStart,
        uint _maximumLatePaymentDuration,
        uint _terminationNotice,

        uint _depositAmount
    ) public {
        authority = _authority;
        tenant = _tenant;
        landlord = _landlord;

        startDate = _startDate == 0 ? now : _startDate;
        paymentPeriod = _paymentPeriod;
        numberOfPeriods = _numberOfPeriods;
        rentPerPeriod = _rentPerPeriod;
        paymentDeadlineSincePeriodStart = _paymentDeadlineSincePeriodStart;
        maximumLatePaymentDuration = _maximumLatePaymentDuration;
        terminationNotice = _terminationNotice;
        finalPeriod = _numberOfPeriods;
        depositAmount = _depositAmount;
    }

    modifier ifActive() {
        require(isActive());
        _;
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

    function isActive() public view returns (bool) {
        uint endDate = startDate + paymentPeriod * numberOfPeriods;
        return landlordSigned && tenantSigned && !isTerminated && now < endDate;
    }

    function sign() public payable {
        if (msg.sender == tenant) {
            require(msg.value >= depositAmount);
            tenant.transfer(msg.value - depositAmount);
            tenantSigned = true;
        }
        if (msg.sender == landlord) {
            landlordSigned = true;
        }
    }

    function payRent(uint _periods) public payable ifActive {
        // anyone can pay rent
        // there is a slight problem here. What is it?

        uint rentAmount = _periods * rentPerPeriod;
        require(msg.value >= rentAmount);
        tenant.transfer(msg.value - rentAmount);
        landlord.transfer(rentAmount);
        periodPaidUntil += _periods;
        if (periodPaidUntil >= numberOfPeriods) {
          tenant.transfer(depositAmount);
        }
    }

    function terminate() public {
        require(msg.sender == tenant || msg.sender == landlord);
        uint previousPaymentDeadline = startDate + periodPaidUntil * paymentPeriod + paymentDeadlineSincePeriodStart;
        if (msg.sender == landlord && previousPaymentDeadline + maximumLatePaymentDuration < now) {
            // this is 5a
            isTerminated = true;
            terminatedTime = now;
            finalPeriod = periodPaidUntil + depositAmount / rentPerPeriod;
            landlord.transfer(depositAmount);
            return;
        }

        // this is 5b
        finalPeriod = (now + terminationNotice - paymentDeadlineSincePeriodStart) / paymentPeriod + 2;
        uint pendingPayment = (finalPeriod - periodPaidUntil) * rentPerPeriod;
        uint amountForTenant = depositAmount - min(depositAmount, pendingPayment); // if the pending payment is more, then just send all the deposit to landlord
        isTerminated = true;
        terminatedTime = now;
        tenant.transfer(amountForTenant);
        landlord.transfer(depositAmount - amountForTenant);
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

    function min(uint a, uint b) internal pure returns(uint) {
      if (a > b) {
        return b;
      }
      return a;
    }

}
