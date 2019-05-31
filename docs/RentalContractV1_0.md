### Rental Agreement Smart contract V1.0

1. Parameters of the agreement:

```
address authority,
address tenant,
address landlord,

uint startDate,
uint isTerminated,
uint paymentPeriod,
uint numberOfPeriods,
uint rentPerPeriod,
uint paymentDeadlineSincePeriodStart,
uint public maximumLatePaymentDuration;

uint depositAmount
```

2. The agreement is considered "active" after the `landlord` signed the agreement and the `tenant` sent the deposit (`depositAmount` in Ethers).

3. `startDate` (in Unix timestamp) is the starting time of the rental.

4. Every `paymentPeriod` (in seconds), the `tenant` must pay the `rentPerPeriod` (in Ethers) before the payment deadline for that payment period, which is `paymentDeadlineSincePeriodStart` seconds from the start of that particular period.

5. The `tenant` can pay rent in advance

6. The agreement can be terminated in these scenarios:
    * 5a. If the tenant fails to pay the rent within `maximumLatePaymentDuration` (in seconds) from the payment deadline, the landlord can terminate it. The landlord keeps the deposit in this case. The last period of rental that the tenant can stay until would be the last period that the deposit could be used to pay for rent.
      * For example: the payment period is every month. The tenant paid until May 2019, but is late for June 2019 rent payment. If the deposit is 1.5 times the rent, the landlord can terminate the agreement and the tenant can only stay until June 2019 (the deposit could be used to pay for the last month of rent).

    * 5b. Either party can terminate the agreement at least `terminationNotice` (in seconds) before the last payment deadline of the last rental period. The deposit minus the last payment(s) (if not already paid) will be returned to the tenant. The landlord will receive the last payment(s) as well.

      * For example: the payment period is every month. The payment deadline is the 8th day of the month. The notice period is 45 days. Lets say the tenant terminates the agreement on 15th May, 45 days after that would be 29th June. Hence, the last payment date would be the 8th of July. The last rental period would be July. The tenant would need to pay the rent for June and July as well.

    * 5c. The `authority` can terminate the agreement anytime, while specifying how much of the deposit will go to the `tenant` and `landlord`

7. After the last payment, the deposit will be returned to the tenant, and the agreement is no longer active
