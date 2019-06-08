# Blockchain & Law workshop - Rental contract

### Online playground for contract development:
* https://ethfiddle.com/

### Rental contract V0.1 (RentalSimple)
* Specifications: [link](docs/RentalContractV0_1.md)
* Recommended values for deploying the contracts:
  * _tenant: the first address
  * _landlord: the second address
  * _paymentPeriod: 300 (5min)
  * _rentPerPeriod: 2000000000000000000 (2 Ethers)
* Step 1: copy the contract code [here](contracts/RentalSimple.sol) to ethfiddle
* Step 2: deploy with the configs above
* Step 3: explore!
  * checkAddressBalance: input an address to check its Ether balance
  * checkContractBalance: check the balance in the contract

### Rental contract V0.5 (RentalSimple2)
* Specifications: [link](docs/RentalContractV0_5.md)
* Recommended values for deploying the contracts:
  * _authority: the first address
  * _tenant: the second address
  * _landlord: the third address
  * _paymentPeriod: 300 (5min)
  * _numberOfPeriods: 4
  * _rentPerPeriod: 2000000000000000000 (2 Ethers)
  * _depositAmount: 3000000000000000000 (3 Ethers)

### Rental contract V1 (Rental)
* Specifications: [link](docs/RentalContractV1_0.md)
* Recommended values for deploying the contracts:
  * _authority: the first address
  * _tenant: the second address
  * _landlord: the third address
  * _startDate: 0
  * _paymentPeriod: 300 (5min)
  * _numberOfPeriods: 4
  * _rentPerPeriod: 2000000000000000000 (2 Ethers)
  * _paymentDeadlineSincePeriodStart: 60 (1min)
  * _maximumLatePaymentDuration: 240 (4 min)
  * _terminationNotice: 180 (3 min)
  * _depositAmount: 3000000000000000000 (3 Ethers)
