/*
=========================================================
Supply Chain & Logistics Analytics
=========================================================

Database : PostgreSQL
Schema   : supply_chain
Table    : order_items

Purpose:
Business-focused analysis of delivery performance,
operational performance, and customer impact.

Grain:
Order-item level unless otherwise specified.

Notes:
- Order-level metrics use COUNT(DISTINCT order_id).
- Order-item metrics use COUNT(*) or order_item_id.
- Delivery performance is evaluated primarily at
  order-item level because delivery indicators are
  recorded for each order item.
=========================================================
*/


-- =====================================================
-- 1. DELIVERY PERFORMANCE
-- =====================================================

-- -----------------------------------------------------
-- 1.1 Overall Delivery KPIs
-- -----------------------------------------------------

SELECT
    COUNT(DISTINCT order_id) AS total_orders,

    COUNT(*) AS total_order_items,

    COUNT(DISTINCT CASE
        WHEN order_status = 'COMPLETE'
        THEN order_id
    END) AS delivered_orders,

    SUM(
        CASE
            WHEN is_late_delivery = 1
            THEN 1
            ELSE 0
        END
    ) AS delayed_order_items,

    SUM(
        CASE
            WHEN is_late_delivery = 0
            THEN 1
            ELSE 0
        END
    ) AS on_time_order_items,

    ROUND(
        SUM(
            CASE
                WHEN is_late_delivery = 0
                THEN 1
                ELSE 0
            END
        )::numeric
        / COUNT(*) * 100,
        2
    ) AS on_time_delivery_rate,

    ROUND(
        SUM(
            CASE
                WHEN is_late_delivery = 1
                THEN 1
                ELSE 0
            END
        )::numeric
        / COUNT(*) * 100,
        2
    ) AS delay_rate,

    ROUND(
        AVG(days_for_shipping_real)::numeric,
        2
    ) AS avg_delivery_time_days,

    ROUND(
        AVG(days_for_shipment_scheduled)::numeric,
        2
    ) AS avg_scheduled_shipping_time_days

FROM supply_chain.order_items;


-- -----------------------------------------------------
-- 1.2 Order Status Overview
-- -----------------------------------------------------

SELECT
    order_status,

    COUNT(DISTINCT order_id) AS orders,

    COUNT(*) AS order_items

FROM supply_chain.order_items

GROUP BY order_status

ORDER BY orders DESC;


-- =====================================================
-- 2. OPERATIONAL PERFORMANCE
-- =====================================================

-- -----------------------------------------------------
-- 2.1 Orders by Region
-- -----------------------------------------------------

SELECT
    order_region,

    COUNT(DISTINCT order_id) AS orders,

    COUNT(*) AS order_items,

    ROUND(
        SUM(sales)::numeric,
        2
    ) AS total_sales

FROM supply_chain.order_items

GROUP BY order_region

ORDER BY orders DESC;


-- -----------------------------------------------------
-- 2.2 Orders by Shipping Mode
-- -----------------------------------------------------

SELECT
    shipping_mode,

    COUNT(DISTINCT order_id) AS orders,

    COUNT(*) AS order_items,

    ROUND(
        SUM(sales)::numeric,
        2
    ) AS total_sales

FROM supply_chain.order_items

GROUP BY shipping_mode

ORDER BY orders DESC;


-- -----------------------------------------------------
-- 2.3 Delivery Performance by Region
-- -----------------------------------------------------

SELECT
    order_region,

    COUNT(DISTINCT order_id) AS orders,

    COUNT(*) AS order_items,

    SUM(
        CASE
            WHEN is_late_delivery = 1
            THEN 1
            ELSE 0
        END
    ) AS delayed_order_items,

    SUM(
        CASE
            WHEN is_late_delivery = 0
            THEN 1
            ELSE 0
        END
    ) AS on_time_order_items,

    ROUND(
        SUM(
            CASE
                WHEN is_late_delivery = 0
                THEN 1
                ELSE 0
            END
        )::numeric
        / COUNT(*) * 100,
        2
    ) AS on_time_delivery_rate,

    ROUND(
        SUM(
            CASE
                WHEN is_late_delivery = 1
                THEN 1
                ELSE 0
            END
        )::numeric
        / COUNT(*) * 100,
        2
    ) AS delay_rate,

    ROUND(
        AVG(days_for_shipping_real)::numeric,
        2
    ) AS avg_delivery_time_days,

    ROUND(
        AVG(days_for_shipment_scheduled)::numeric,
        2
    ) AS avg_scheduled_shipping_time_days,

    ROUND(
        SUM(sales)::numeric,
        2
    ) AS total_sales

FROM supply_chain.order_items

GROUP BY order_region

ORDER BY delay_rate DESC;


-- -----------------------------------------------------
-- 2.4 Delivery Performance by Category
-- -----------------------------------------------------

SELECT
    category_name,

    COUNT(DISTINCT order_id) AS orders,

    COUNT(*) AS order_items,

    SUM(
        CASE
            WHEN is_late_delivery = 1
            THEN 1
            ELSE 0
        END
    ) AS delayed_order_items,

    SUM(
        CASE
            WHEN is_late_delivery = 0
            THEN 1
            ELSE 0
        END
    ) AS on_time_order_items,

    ROUND(
        SUM(
            CASE
                WHEN is_late_delivery = 0
                THEN 1
                ELSE 0
            END
        )::numeric
        / COUNT(*) * 100,
        2
    ) AS on_time_delivery_rate,

    ROUND(
        SUM(
            CASE
                WHEN is_late_delivery = 1
                THEN 1
                ELSE 0
            END
        )::numeric
        / COUNT(*) * 100,
        2
    ) AS delay_rate,

    ROUND(
        AVG(days_for_shipping_real)::numeric,
        2
    ) AS avg_delivery_time_days,

    ROUND(
        AVG(days_for_shipment_scheduled)::numeric,
        2
    ) AS avg_scheduled_shipping_time_days,

    ROUND(
        SUM(sales)::numeric,
        2
    ) AS total_sales

FROM supply_chain.order_items

GROUP BY category_name

ORDER BY delay_rate DESC;


-- -----------------------------------------------------
-- 2.5 Delivery Performance by Shipping Mode
-- -----------------------------------------------------

SELECT
    shipping_mode,

    COUNT(DISTINCT order_id) AS orders,

    COUNT(*) AS order_items,

    SUM(
        CASE
            WHEN is_late_delivery = 1
            THEN 1
            ELSE 0
        END
    ) AS delayed_order_items,

    SUM(
        CASE
            WHEN is_late_delivery = 0
            THEN 1
            ELSE 0
        END
    ) AS on_time_order_items,

    ROUND(
        SUM(
            CASE
                WHEN is_late_delivery = 0
                THEN 1
                ELSE 0
            END
        )::numeric
        / COUNT(*) * 100,
        2
    ) AS on_time_delivery_rate,

    ROUND(
        SUM(
            CASE
                WHEN is_late_delivery = 1
                THEN 1
                ELSE 0
            END
        )::numeric
        / COUNT(*) * 100,
        2
    ) AS delay_rate,

    ROUND(
        AVG(days_for_shipping_real)::numeric,
        2
    ) AS avg_delivery_time_days,

    ROUND(
        AVG(days_for_shipment_scheduled)::numeric,
        2
    ) AS avg_scheduled_shipping_time_days,

    ROUND(
        SUM(sales)::numeric,
        2
    ) AS total_sales

FROM supply_chain.order_items

GROUP BY shipping_mode

ORDER BY delay_rate DESC;


-- =====================================================
-- 3. CUSTOMER IMPACT
-- =====================================================

-- -----------------------------------------------------
-- 3.1 Delivery Performance by Customer Segment
-- -----------------------------------------------------

SELECT
    customer_segment,

    COUNT(DISTINCT order_id) AS orders,

    COUNT(*) AS order_items,

    SUM(
        CASE
            WHEN is_late_delivery = 1
            THEN 1
            ELSE 0
        END
    ) AS delayed_order_items,

    SUM(
        CASE
            WHEN is_late_delivery = 0
            THEN 1
            ELSE 0
        END
    ) AS on_time_order_items,

    ROUND(
        SUM(
            CASE
                WHEN is_late_delivery = 0
                THEN 1
                ELSE 0
            END
        )::numeric
        / COUNT(*) * 100,
        2
    ) AS on_time_delivery_rate,

    ROUND(
        SUM(
            CASE
                WHEN is_late_delivery = 1
                THEN 1
                ELSE 0
            END
        )::numeric
        / COUNT(*) * 100,
        2
    ) AS delay_rate,

    ROUND(
        AVG(days_for_shipping_real)::numeric,
        2
    ) AS avg_delivery_time_days,

    ROUND(
        SUM(sales)::numeric,
        2
    ) AS total_sales

FROM supply_chain.order_items

GROUP BY customer_segment

ORDER BY delay_rate DESC;


-- -----------------------------------------------------
-- 3.2 Cancellation Status & Delivery Performance
-- -----------------------------------------------------

SELECT
    CASE
        WHEN order_status = 'CANCELED'
        THEN 'Canceled'
        ELSE 'Non-Canceled'
    END AS cancellation_status,

    COUNT(DISTINCT order_id) AS orders,

    COUNT(*) AS order_items,

    SUM(
        CASE
            WHEN is_late_delivery = 1
            THEN 1
            ELSE 0
        END
    ) AS delayed_order_items,

    SUM(
        CASE
            WHEN is_late_delivery = 0
            THEN 1
            ELSE 0
        END
    ) AS on_time_order_items,

    ROUND(
        SUM(
            CASE
                WHEN is_late_delivery = 1
                THEN 1
                ELSE 0
            END
        )::numeric
        / COUNT(*) * 100,
        2
    ) AS delay_rate,

    ROUND(
        AVG(days_for_shipping_real)::numeric,
        2
    ) AS avg_delivery_time_days,

    ROUND(
        SUM(sales)::numeric,
        2
    ) AS total_sales

FROM supply_chain.order_items

GROUP BY
    CASE
        WHEN order_status = 'CANCELED'
        THEN 'Canceled'
        ELSE 'Non-Canceled'
    END

ORDER BY cancellation_status;