# Data Science in Context: Running out vs. overbuying

DATA 607 presentation, November 4, 2026.

How much should a brand reorder, and when? A walkthrough of the replenishment logic I use for ecommerce inventory, shown on **Billy's Bears**, a made-up stuffed animal brand with synthetic data.

## Links

- **Slides:** [Billy's Bears: Data Science in Context](https://claude.ai/artifact/E7ucjvjaanyriT2aZowtmX)
- **Live dashboard demo:** [Billy's Bears Inventory](https://claude.ai/artifact/TrcXCbQbAe9bLJ8oQPriNx)
- **R example:** [`in_stock_velocity.R`](in_stock_velocity.R)

## The pipeline

Daily Python script pulls from Amazon's SP-API → cleanup and outlier flags → raw files in S3 → cleaned tables in Supabase (Postgres) → replenishment dashboard.

## The data science part

Average daily sales should only count the days a product could actually sell. Out-of-stock days drag the average down, which leads to under-ordering and another stockout. Spike days (one viral post) get flagged so they don't inflate the order either.

Running the R example:

| Method | Units / day | Order units |
|---|---|---|
| Naive (all 30 days) | 6.8 | 336 |
| In-stock days only | 10.2 | 600 |
| In-stock, spike removed | 7.6 | 408 |

The reorder decision itself uses the expected value framework from Provost & Fawcett's *Data Science for Business*: weigh the chance and cost of running out against the chance and cost of holding too much.

```r
Rscript in_stock_velocity.R
```

Requires `dplyr`.
