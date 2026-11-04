# Data Science in Context: in-stock sell rate for replenishment
# Billy's Bears is a made-up brand. All numbers below are synthetic.
#
# The idea from the talk: average daily sales should only count the days a
# product could actually sell. Days it was out of stock make demand look lower
# than it is, which leads to under-ordering and another stockout.

suppressPackageStartupMessages(library(dplyr))

set.seed(607)

# 30 days of sales for one bear, out of stock on days 11 to 20
days <- tibble(
  day      = 1:30,
  in_stock = !(day %in% 11:20)
) |>
  mutate(units = ifelse(in_stock, rpois(n(), lambda = 7.5), 0))

# One spike day (a viral post), so we can see why spikes are handled separately
days$units[25] <- 60

naive_rate <- sum(days$units) / nrow(days)

in_stock_days <- days |> filter(in_stock)

# Flag spikes as days more than 3 MADs above the in-stock median
med  <- median(in_stock_days$units)
mad_ <- mad(in_stock_days$units)
in_stock_days <- in_stock_days |> mutate(spike = units > med + 3 * mad_)

in_stock_rate <- mean(in_stock_days$units)
clean_rate    <- mean(in_stock_days$units[!in_stock_days$spike])

# Reorder sizing: cover lead time plus a buffer, minus what is on hand and on order,
# rounded up to full cases
reorder_qty <- function(rate, on_hand, on_order, lead_days = 45, buffer_days = 30, case_pack = 24) {
  need <- rate * (lead_days + buffer_days) - on_hand - on_order
  if (need <= 0) return(0)
  ceiling(need / case_pack) * case_pack
}

on_hand  <- 181
on_order <- 0

results <- tibble(
  method     = c("Naive (all 30 days)", "In-stock days only", "In-stock, spike removed"),
  units_day  = round(c(naive_rate, in_stock_rate, clean_rate), 1)
) |>
  mutate(order_units = sapply(units_day, reorder_qty, on_hand = on_hand, on_order = on_order))

print(results)
