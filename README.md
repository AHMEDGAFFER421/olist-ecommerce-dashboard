# Olist E-Commerce Analytics Dashboard

A 7-page end-to-end business intelligence project analyzing 100,000+ orders from Brazil's largest e-commerce marketplace. Built on a PostgreSQL → Power BI pipeline with a star schema data model.

---

## Project Overview

Olist is a Brazilian e-commerce platform connecting small merchants to major marketplaces. This dashboard answers the question: **why is revenue stagnating despite high order volume?**

The analysis surfaces four connected root causes — logistics gaps in Northeast Brazil, two distinct seller failure patterns, a freight-weight delivery problem, and an 88% customer non-return rate — and translates each finding into an actionable recommendation.

---

## Key Findings

| # | Finding | Metric |
|---|---------|--------|
| 1 | Revenue peaked mid-2018 and began stagnating | Sales trend flattens Q3–Q4 2018 |
| 2 | Northeast Brazil has both the worst delivery times and lowest retention | 8.4–10.2% retention vs 12.5%+ in Southeast |
| 3 | Two distinct seller failure types: high-volume/low-score vs low-volume/inactive | Identified via seller performance clustering |
| 4 | Heavier products correlate with late delivery and lower review scores | Freight weight drives delivery delay |
| 5 | 88% of customers never place a second order | Platform is acquisition-dependent, not retention-driven |

---

## Dashboard Pages

| Page | Title | Purpose |
|------|-------|---------|
| 1 | Executive Overview | Revenue trend, order volume, KPIs, geographic sales distribution |
| 2 | Operations & Delivery | On-time rate, avg delivery days, late delivery by state, delay drivers |
| 3 | Sellers | Seller performance segmentation, volume vs score analysis |
| 4 | Payments | Payment method breakdown, installment adoption rate |
| 5 | Products | Category performance, freight weight vs delivery time |
| 6 | Customers | Retention rate, 88% single-purchase finding, retention by state |
| 7 | Insights | 5 key findings summary with supporting visuals and recommendations |

---

## Tech Stack

- **Database:** PostgreSQL — data cleaning, transformation, and business logic
- **Data Model:** Star schema — 1 fact table, 4 dimension tables, pre-aggregated views
- **Visualization:** Power BI Desktop — DAX measures, cross-page filtering, custom visuals
- **ETL Pattern:** SQL views as the semantic layer; Power BI connects directly to views, not raw tables

---

## Data Model

```
dim_date ─────┐
dim_customers ─┤
dim_sellers ───┼──► fact_orders
dim_products ──┘

Supporting views:
- seller_performance   (pre-aggregated seller metrics)
- retention_by_state   (customer retention rate per state)
- payment_analysis     (payment type and installment breakdown)
```

The star schema keeps Power BI relationships clean and pushes heavy aggregation into PostgreSQL where it belongs.

---

## Selected DAX Measures

```dax
-- Total Sales (product price + freight)
Total Sales = SUM(Fact_table[price]) + SUM(Fact_table[freight_value])

-- On-Time Delivery Rate
On-Time Rate =
DIVIDE(
    CALCULATE(COUNTROWS(fact_orders), fact_orders[delivery_status] = "On Time"),
    COUNTROWS(fact_orders),
    0
)

-- Installment Adoption Rate
Installment Adoption Rate =
DIVIDE(
    CALCULATE(
        DISTINCTCOUNT(payment_analysis[order_id]),
        payment_analysis[payment_installments] > 1
    ),
    DISTINCTCOUNT(payment_analysis[order_id]),
    0
)
```

---

## Selected SQL (PostgreSQL)

```sql
-- Retention rate by state (identifies Northeast logistics problem)
SELECT
    c.customer_state,
    COUNT(DISTINCT c.customer_id)                                AS total_customers,
    COUNT(DISTINCT CASE
        WHEN r.customer_type = 'Returning'
        THEN c.customer_id
    END)                                                         AS returning_customers,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN r.customer_type = 'Returning'
            THEN c.customer_id
        END) * 100.0 / COUNT(DISTINCT c.customer_id), 1
    )                                                            AS retention_rate
FROM dim_customers c
LEFT JOIN repeated_customers r ON c.customer_id = r.customer_id
GROUP BY c.customer_state
HAVING COUNT(DISTINCT c.customer_id) > 100
ORDER BY retention_rate ASC;
```

**Business question answered:** Which states have the worst customer retention — and does it correlate with late delivery?

Result: AM, PI, AL, CE, PE (all Northeast) cluster at the bottom with 8–10% retention, while SE, SP, RJ (Southeast) sit at 12.5%+. Confirms that geography → late delivery → customer loss is a single connected problem.

---

## Story Architecture

The dashboard is designed to tell one connected story across 7 pages:

```
Overview (what's happening)
    ↓
Operations (where delivery breaks down)
    ↓
Sellers / Products (who and what is causing it)
    ↓
Customers (the consequence: they don't come back)
    ↓
Insights (so what do we do about it)
```

Each page answers 1–2 business questions and feeds into the next.

---

## Dataset

**Source:** [Olist Brazilian E-Commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) — Kaggle  
**Size:** ~100,000 orders, 2016–2018  
**Tables used:** orders, order_items, order_payments, order_reviews, customers, sellers, products, geolocation

---

## Repository Structure

```
olist-ecommerce-dashboard/
│
├── README.md
├── sql/
│   ├── schema/          # Star schema view definitions
│   ├── analysis/        # Business question queries
│   └── views/           # Supporting pre-aggregated views
│
├── powerbi/
│   └── olist_dashboard.pbix
│
└── assets/
    └── screenshots/     # Dashboard page previews
```

---

## What I Learned

- Pre-aggregating in SQL and connecting Power BI to views (not raw tables) keeps the data model clean and improves performance
- Star schema discipline matters: when the model starts drifting (snow, then something worse), every DAX measure gets harder to write
- Naming queries from day one (`retention_by_state`, not `Query7`) is not optional
- The most valuable insight in this project came from joining two separate findings (late delivery + low retention by state) into one connected story — neither finding alone was as compelling as the combination
