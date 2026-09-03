# Business Insights

## 1. Overview

The Supply Chain & Logistics Analytics project analyzes 180,519 order-item records representing 65,752 unique orders. The analysis focuses on delivery performance, shipping modes, regional operations, product categories, customer segments, and the business impact associated with delayed deliveries.

The analysis combines SQL-based business analysis and Power BI visualization to identify operational patterns and areas that may require further investigation.

---

## 2. Delivery Performance

### High Delivery Delay Rate

A total of 103,400 order items were classified as delayed, representing **57.28%** of all order items.

This indicates that delivery delays are a significant operational issue within the analyzed dataset and should be a key area of supply chain performance monitoring.

The remaining 42.72% of order items were classified as non-late, consisting of:

- **24.02%** delivered early
- **18.70%** delivered exactly on time

Therefore, while 42.72% of shipments were not late, the proportion delivered exactly on time was considerably lower at 18.70%.

---

## 3. Shipping Mode Performance

Shipping performance varies substantially across shipping modes.

| Shipping Mode  | Non-Late Rate | Delay Rate | Avg. Delivery Time | Avg. Scheduled Time |
| -------------- | ------------: | ---------: | -----------------: | ------------------: |
| Standard Class |        60.23% |     39.77% |          4.00 days |           4.00 days |
| Same Day       |        52.17% |     47.83% |          0.48 days |           0.00 days |
| Second Class   |        20.27% |     79.73% |          3.99 days |           2.00 days |
| First Class    |         0.00% |    100.00% |          2.00 days |            1.00 day |

First Class and Second Class shipments recorded substantially higher delay rates than Standard Class shipments.

First Class recorded a **100% delay rate**, while Second Class recorded a **79.73% delay rate**.

These results indicate substantial differences in delivery performance across shipping modes. However, the analysis identifies an association rather than proving that the shipping mode itself causes delivery delays.

---

## 4. Regional Delivery Performance

Delivery performance also varies across regions.

**Central Africa** recorded the highest delay rate at **60.70%**, followed by **Western Europe at 58.52%** and **South Asia at 58.50%**.

However, regional delay rates should be evaluated together with order volume.

Central Africa had only **556 orders**, meaning its high delay rate represents a relatively small operational volume compared with larger regions.

This highlights the importance of considering both **delay rate and operational volume** when prioritizing improvement initiatives.

---

## 5. Delayed Order Volume

High delay rates are not the only concern. The number of delayed order items is also important when assessing operational impact.

**Central America** and **Western Europe** represent two of the largest contributors to delayed order-item volume, with approximately **16.2K and 15.9K delayed order items** respectively.

This suggests that improvement efforts may benefit from prioritizing regions with both:

1. High delay rates, and
2. High volumes of delayed order items.

---

## 6. Category-Level Performance

Category-level analysis shows differences in delivery delay rates and delayed order-item volumes.

Some product categories recorded relatively high delay rates, while other categories contributed a larger number of delayed order items because of their higher order volume.

Categories with high delay rates should therefore be investigated further to determine whether there are underlying operational factors associated with their delivery performance.

The analysis does not establish that a specific category directly causes delivery delays.

---

## 7. Customer Segment Performance

Delivery performance is relatively consistent across customer segments.

| Customer Segment | Delay Rate |
| ---------------- | ---------: |
| Home Office      |     57.52% |
| Consumer         |     57.29% |
| Corporate        |     57.11% |

The difference between the highest and lowest segment delay rate is only **0.41 percentage points**.

This indicates that delivery delays are not strongly concentrated within a particular customer segment in the analyzed dataset.

Therefore, operational improvement efforts should not focus exclusively on one customer segment.

---

## 8. Business & Financial Impact

Delayed order items represented approximately **$21.03M in sales**, equivalent to **57.16% of total sales**.

This represents a substantial amount of sales associated with delayed order items and demonstrates the importance of monitoring delivery performance from a business perspective.

However, this figure should be interpreted as **sales exposure associated with delayed order items**, not as revenue lost because of delivery delays.

The dataset also shows approximately **-$2.25M in negative recorded benefit** among delayed order items.

This indicates that delayed order items were associated with a substantial amount of negative recorded benefit. However, the analysis does not establish that delivery delays directly caused this negative benefit.

---

## 9. Key Findings

The main findings from the analysis are:

1. **Delivery delays are a major operational issue**, with 57.28% of order items classified as late.

2. **Exact on-time delivery is relatively low**, with only 18.70% of order items delivered exactly on time.

3. **Shipping mode performance differs substantially**, with First Class and Second Class showing considerably higher delay rates than Standard Class.

4. **Regional performance varies**, but both delay rate and order volume should be considered when prioritizing operational improvements.

5. **Delayed order items represent significant business exposure**, accounting for approximately $21.03M or 57.16% of total sales.

6. **Delayed orders are associated with negative recorded benefit**, totaling approximately $2.25M in negative benefit.

7. **Customer segment performance is relatively consistent**, with delay rates ranging from 57.11% to 57.52%.

---

## 10. Analytical Considerations

The findings in this report describe patterns and associations observed in the dataset. They should not be interpreted as evidence of direct causation.

For example:

- A higher delay rate for a shipping mode does not necessarily mean the shipping mode causes delays.
- Sales associated with delayed orders do not represent sales lost due to delays.
- Negative benefit associated with delayed orders does not necessarily represent financial losses caused by delivery delays.
- A high regional delay rate should be evaluated together with order volume before determining operational priorities.
