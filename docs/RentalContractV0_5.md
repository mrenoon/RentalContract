### Rental Agreement Smart contract V0.5

1. Parameters of the agreement:

```
address authority,
address tenant,
address landlord,

uint startDate,
uint paymentPeriod,
uint numberOfPeriods,
uint rentPerPeriod,
```

2. `startDate` (in Unix timestamp) is the starting time of the rental.

3. The `tenant` can pay rent in advance

4. The `authority` can terminate the agreement anytime, while specifying how much of the deposit will go to the `tenant` and `landlord`
