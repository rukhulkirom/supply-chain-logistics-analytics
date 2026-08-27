-- ============================================================
-- SUPPLY CHAIN & LOGISTICS ANALYTICS
-- DATABASE VALIDATION
-- ============================================================
--
-- Purpose:
-- Validate the integrity, consistency, and analytical readiness
-- of the cleaned Supply Chain dataset stored in PostgreSQL.
--
-- Expected table:
--     supply_chain.order_items
--
-- Dataset grain:
--     One row = one order item
--
-- Expected row count:
--     180,519
--
-- Expected unique orders:
--     65,752
--
-- Expected unique customers:
--     20,652
--
-- Prerequisite:
--     1. PostgreSQL database has been created.
--     2. supply_chain schema exists.
--     3. order_items table has been created and populated.
--
-- Recommended execution:
--     Run this file after executing 01_database_setup.sql
--     and importing cleaned_supply_chain.csv.
--
-- ============================================================


-- ============================================================
-- 0. SET SCHEMA
-- ============================================================

SET search_path TO supply_chain;


-- ============================================================
-- 1. ROW COUNT VALIDATION
-- ============================================================
-- Confirms that all cleaned order-item records were imported.

SELECT
    COUNT(*) AS total_rows
FROM order_items;


-- ============================================================
-- 2. ORDER ITEM ID UNIQUENESS
-- ============================================================
-- The analytical grain is one row per order item.
-- Therefore, order_item_id must be unique.

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_item_id) AS unique_order_item_ids,
    COUNT(*) - COUNT(DISTINCT order_item_id)
        AS duplicate_order_item_ids
FROM order_items;


-- ============================================================
-- 3. NULL PRIMARY KEY VALIDATION
-- ============================================================
-- order_item_id is the primary key and must never be NULL.

SELECT
    COUNT(*) FILTER (
        WHERE order_item_id IS NULL
    ) AS null_order_item_ids
FROM order_items;


-- ============================================================
-- 4. ORDER AND CUSTOMER COUNTS
-- ============================================================
-- Provides a high-level check of the dataset structure.

SELECT
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM order_items;


-- ============================================================
-- 5. MISSING VALUE VALIDATION
-- ============================================================
-- Customer zipcode is the only field intentionally remaining
-- with missing values after data cleaning.

SELECT
    COUNT(*) FILTER (
        WHERE customer_zipcode IS NULL
    ) AS missing_customer_zipcode
FROM order_items;


-- ============================================================
-- 6. DATE VALIDATION
-- ============================================================
-- Checks for missing dates and invalid date relationships.

SELECT
    COUNT(*) FILTER (
        WHERE order_date IS NULL
    ) AS invalid_order_dates,

    COUNT(*) FILTER (
        WHERE shipping_date IS NULL
    ) AS invalid_shipping_dates,

    COUNT(*) FILTER (
        WHERE shipping_date < order_date
    ) AS shipping_before_order
FROM order_items;


-- ============================================================
-- 7. SHIPPING DAYS VALIDATION
-- ============================================================
-- Shipping duration should not contain negative values.

SELECT
    COUNT(*) FILTER (
        WHERE days_for_shipping_real < 0
    ) AS negative_actual_shipping_days,

    COUNT(*) FILTER (
        WHERE days_for_shipment_scheduled < 0
    ) AS negative_scheduled_shipping_days
FROM order_items;


-- ============================================================
-- 8. ORDER QUANTITY VALIDATION
-- ============================================================
-- Every order item should have a positive quantity.

SELECT
    COUNT(*) FILTER (
        WHERE order_item_quantity <= 0
    ) AS invalid_order_quantities
FROM order_items;


-- ============================================================
-- 9. DISCOUNT VALIDATION
-- ============================================================
-- Discount amount cannot be negative.
-- Discount rate must be between 0 and 1.

SELECT
    COUNT(*) FILTER (
        WHERE order_item_discount < 0
    ) AS negative_discounts,

    COUNT(*) FILTER (
        WHERE order_item_discount_rate < 0
           OR order_item_discount_rate > 1
    ) AS invalid_discount_rates
FROM order_items;


-- ============================================================
-- 10. DELIVERY STATUS VALIDATION
-- ============================================================
-- Checks whether delivery_status contains only expected values.

SELECT
    COUNT(*) FILTER (
        WHERE delivery_status NOT IN (
            'Advance shipping',
            'Late delivery',
            'Shipping on time',
            'Shipping canceled'
        )
    ) AS invalid_delivery_status
FROM order_items;


-- ============================================================
-- 11. LATE DELIVERY FEATURE VALIDATION
-- ============================================================
-- Business rule:
--     shipping_delay_days > 0 → late
--     otherwise               → not late
--
-- This validates the engineered is_late_delivery feature.

SELECT
    COUNT(*) FILTER (
        WHERE is_late_delivery NOT IN (0, 1)
    ) AS invalid_late_delivery_flags,

    COUNT(*) FILTER (
        WHERE is_late_delivery =
            CASE
                WHEN shipping_delay_days > 0 THEN 1
                ELSE 0
            END
    ) AS matching_late_delivery_flags,

    COUNT(*) FILTER (
        WHERE is_late_delivery <>
            CASE
                WHEN shipping_delay_days > 0 THEN 1
                ELSE 0
            END
    ) AS mismatched_late_delivery_flags
FROM order_items;


-- ============================================================
-- 12. SHIPPING DELAY FEATURE VALIDATION
-- ============================================================
-- Business rule:
--     shipping_delay_days =
--     actual shipping days - scheduled shipping days

SELECT
    COUNT(*) AS total_rows,

    COUNT(*) FILTER (
        WHERE shipping_delay_days =
              days_for_shipping_real
              - days_for_shipment_scheduled
    ) AS matching_shipping_delay,

    COUNT(*) FILTER (
        WHERE shipping_delay_days <>
              days_for_shipping_real
              - days_for_shipment_scheduled
    ) AS mismatched_shipping_delay
FROM order_items;


-- ============================================================
-- 13. SHIPPING PERFORMANCE VALIDATION
-- ============================================================
-- Business rule:
--     delay > 0 → Late
--     delay = 0 → On Time
--     delay < 0 → Early

SELECT
    COUNT(*) FILTER (
        WHERE shipping_performance =
            CASE
                WHEN shipping_delay_days > 0
                    THEN 'Late'
                WHEN shipping_delay_days = 0
                    THEN 'On Time'
                WHEN shipping_delay_days < 0
                    THEN 'Early'
                ELSE 'Unknown'
            END
    ) AS matching_shipping_performance,

    COUNT(*) FILTER (
        WHERE shipping_performance <>
            CASE
                WHEN shipping_delay_days > 0
                    THEN 'Late'
                WHEN shipping_delay_days = 0
                    THEN 'On Time'
                WHEN shipping_delay_days < 0
                    THEN 'Early'
                ELSE 'Unknown'
            END
    ) AS mismatched_shipping_performance
FROM order_items;


-- ============================================================
-- 14. CUSTOMER ID CONSISTENCY
-- ============================================================
-- customer_id and order_customer_id should refer to the same
-- customer within each order-item record.

SELECT
    COUNT(*) FILTER (
        WHERE customer_id <> order_customer_id
    ) AS customer_id_mismatches
FROM order_items;


-- ============================================================
-- 15. ORDER DATE FEATURE VALIDATION
-- ============================================================
-- Validates engineered date features against order_date.
--
-- Note:
-- Pandas dayofweek uses Monday=0 ... Sunday=6.
-- PostgreSQL DOW uses Sunday=0 ... Saturday=6.
-- Therefore, PostgreSQL DOW is converted to the Pandas convention.

SELECT
    COUNT(*) FILTER (
        WHERE order_year <> EXTRACT(YEAR FROM order_date)
    ) AS invalid_order_year,

    COUNT(*) FILTER (
        WHERE order_month <> EXTRACT(MONTH FROM order_date)
    ) AS invalid_order_month,

    COUNT(*) FILTER (
        WHERE order_quarter <> EXTRACT(QUARTER FROM order_date)
    ) AS invalid_order_quarter,

    COUNT(*) FILTER (
        WHERE order_day <> EXTRACT(DAY FROM order_date)
    ) AS invalid_order_day,

    COUNT(*) FILTER (
        WHERE order_day_of_week <>
              ((EXTRACT(DOW FROM order_date) + 6) % 7)
    ) AS invalid_day_of_week,

    COUNT(*) FILTER (
        WHERE order_week_of_year <>
              EXTRACT(WEEK FROM order_date)
    ) AS invalid_week_of_year
FROM order_items;


-- ============================================================
-- 16. DATE FEATURE RANGE VALIDATION
-- ============================================================
-- Confirms that engineered date features contain valid ranges.

SELECT
    MIN(order_year) AS min_order_year,
    MAX(order_year) AS max_order_year,

    MIN(order_month) AS min_order_month,
    MAX(order_month) AS max_order_month,

    MIN(order_quarter) AS min_order_quarter,
    MAX(order_quarter) AS max_order_quarter,

    MIN(order_day) AS min_order_day,
    MAX(order_day) AS max_order_day,

    MIN(order_day_of_week) AS min_day_of_week,
    MAX(order_day_of_week) AS max_day_of_week,

    MIN(order_week_of_year) AS min_week_of_year,
    MAX(order_week_of_year) AS max_week_of_year
FROM order_items;


-- ============================================================
-- 17. ENGINEERED FEATURE COMPLETENESS
-- ============================================================
-- All required engineered features should be populated.

SELECT
    COUNT(*) FILTER (
        WHERE shipping_delay_days IS NULL
    ) AS missing_shipping_delay_days,

    COUNT(*) FILTER (
        WHERE is_late_delivery IS NULL
    ) AS missing_is_late_delivery,

    COUNT(*) FILTER (
        WHERE shipping_performance IS NULL
    ) AS missing_shipping_performance,

    COUNT(*) FILTER (
        WHERE order_year IS NULL
    ) AS missing_order_year,

    COUNT(*) FILTER (
        WHERE order_month IS NULL
    ) AS missing_order_month,

    COUNT(*) FILTER (
        WHERE order_quarter IS NULL
    ) AS missing_order_quarter,

    COUNT(*) FILTER (
        WHERE order_day IS NULL
    ) AS missing_order_day,

    COUNT(*) FILTER (
        WHERE order_day_of_week IS NULL
    ) AS missing_order_day_of_week,

    COUNT(*) FILTER (
        WHERE order_week_of_year IS NULL
    ) AS missing_order_week_of_year
FROM order_items;


-- ============================================================
-- 18. FINAL GRAIN VALIDATION
-- ============================================================
-- Confirms the analytical grain:
--     one row = one order item

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_item_id) AS unique_order_items,

    CASE
        WHEN COUNT(*) = COUNT(DISTINCT order_item_id)
            THEN TRUE
        ELSE FALSE
    END AS one_row_per_order_item
FROM order_items;


-- ============================================================
-- 19. FINAL DATA VALIDATION SUMMARY
-- ============================================================
-- High-level validation summary for quick review.
--
-- Expected:
--     total_rows               = 180519
--     unique_order_items       = 180519
--     unique_orders            = 65752
--     unique_customers         = 20652
--     missing_customer_zipcode = 3
--     invalid_date_relationships = 0
--     invalid_quantities       = 0
--     null_order_item_ids      = 0
--     duplicate_order_item_ids = 0

SELECT
    COUNT(*) AS total_rows,

    COUNT(DISTINCT order_item_id)
        AS unique_order_items,

    COUNT(DISTINCT order_id)
        AS unique_orders,

    COUNT(DISTINCT customer_id)
        AS unique_customers,

    COUNT(*) FILTER (
        WHERE customer_zipcode IS NULL
    ) AS missing_customer_zipcode,

    COUNT(*) FILTER (
        WHERE shipping_date < order_date
    ) AS invalid_date_relationships,

    COUNT(*) FILTER (
        WHERE order_item_quantity <= 0
    ) AS invalid_quantities,

    COUNT(*) FILTER (
        WHERE order_item_id IS NULL
    ) AS null_order_item_ids,

    COUNT(*) - COUNT(DISTINCT order_item_id)
        AS duplicate_order_item_ids
FROM order_items;


-- ============================================================
-- 20. FINAL PASS / FAIL CHECK
-- ============================================================
-- A compact automated check for the core data-quality rules.
--
-- PASS means the dataset satisfies the expected validation rules.
-- FAIL indicates that at least one core validation rule failed.

SELECT
    CASE
        WHEN COUNT(*) = 180519
         AND COUNT(*) = COUNT(DISTINCT order_item_id)
         AND COUNT(*) FILTER (
                WHERE order_item_id IS NULL
             ) = 0
         AND COUNT(*) FILTER (
                WHERE order_item_quantity <= 0
             ) = 0
         AND COUNT(*) FILTER (
                WHERE shipping_date < order_date
             ) = 0
         AND COUNT(*) FILTER (
                WHERE shipping_delay_days <>
                      days_for_shipping_real
                      - days_for_shipment_scheduled
             ) = 0
         AND COUNT(*) FILTER (
                WHERE is_late_delivery <>
                    CASE
                        WHEN shipping_delay_days > 0
                            THEN 1
                        ELSE 0
                    END
             ) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END AS validation_status
FROM order_items;


-- ============================================================
-- END OF DATABASE VALIDATION
-- ============================================================