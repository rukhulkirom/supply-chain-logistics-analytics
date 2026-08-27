-- ============================================================
-- SUPPLY CHAIN & LOGISTICS ANALYTICS
-- PostgreSQL Database Setup
-- ============================================================
--
-- Purpose:
--   Create the PostgreSQL schema and order_items table for the
--   Supply Chain & Logistics Analytics project.
--
-- Dataset grain:
--   One row = one order item
--
-- Database:
--   supply_chain
--
-- Schema:
--   supply_chain
--
-- ============================================================
-- SETUP INSTRUCTIONS
-- ============================================================
--
-- STEP 1 — Create the database
--
-- Run the following statement while connected to PostgreSQL:
--
--     CREATE DATABASE supply_chain;
--
-- STEP 2 — Connect to the "supply_chain" database.
--
-- In pgAdmin:
--   Databases → supply_chain → Query Tool
--
-- STEP 3 — Run this script to create the schema and table.
--
-- STEP 4 — Import the cleaned dataset.
--
-- The cleaned dataset is located at:
--
--     data/processed/cleaned_supply_chain.csv
--
-- OPTION A — pgAdmin
--
--   1. Open:
--      supply_chain → Schemas → supply_chain → Tables
--   2. Right-click "order_items"
--   3. Select "Import/Export Data..."
--   4. Choose:
--      data/processed/cleaned_supply_chain.csv
--   5. Set:
--      Format     : csv
--      Header     : Yes
--      Delimiter  : ,
--      Quote      : "
--   6. Import the data.
--
-- OPTION B — psql
--
-- If using psql, the CSV can be imported with:
--
--     \copy supply_chain.order_items
--     FROM 'path/to/cleaned_supply_chain.csv'
--     WITH (
--         FORMAT CSV,
--         HEADER TRUE,
--         DELIMITER ',',
--         QUOTE '"'
--     );
--
-- Replace the file path with the actual location of the CSV file.
--
-- STEP 5 — Verify the imported data:
--
--     SELECT COUNT(*)
--     FROM supply_chain.order_items;
--
-- Expected result:
--
--     180519
--
-- ============================================================


-- ============================================================
-- 1. CREATE SCHEMA
-- ============================================================

CREATE SCHEMA IF NOT EXISTS supply_chain;


-- ============================================================
-- 2. RECREATE ORDER ITEMS TABLE
-- ============================================================
--
-- WARNING:
--   DROP TABLE removes the existing order_items table and
--   all data stored in it.
--
--   This makes the setup script rerunnable from a clean state.
--   Remove or comment out the DROP statement if you do not
--   want to overwrite an existing table.
-- ============================================================

DROP TABLE IF EXISTS supply_chain.order_items;


CREATE TABLE supply_chain.order_items (

    -- --------------------------------------------------------
    -- Original Dataset Columns
    -- --------------------------------------------------------

    payment_type                   TEXT,
    days_for_shipping_real         INTEGER,
    days_for_shipment_scheduled    INTEGER,
    benefit_per_order              NUMERIC(12, 2),
    sales_per_customer             NUMERIC(12, 2),
    delivery_status                TEXT,
    late_delivery_risk             SMALLINT,

    category_id                    BIGINT,
    category_name                  TEXT,

    customer_city                  TEXT,
    customer_country               TEXT,
    customer_id                    BIGINT NOT NULL,
    customer_segment               TEXT,
    customer_state                 TEXT,
    customer_zipcode               DOUBLE PRECISION,

    department_id                  BIGINT,
    department_name                TEXT,

    latitude                       DOUBLE PRECISION,
    longitude                      DOUBLE PRECISION,

    market                         TEXT,

    order_city                     TEXT,
    order_country                  TEXT,
    order_customer_id              BIGINT NOT NULL,
    order_date                     TIMESTAMP,
    order_id                       BIGINT NOT NULL,

    order_item_cardprod_id         BIGINT,
    order_item_discount            NUMERIC(12, 2),
    order_item_discount_rate       NUMERIC(5, 4),
    order_item_id                  BIGINT NOT NULL,
    order_item_product_price       NUMERIC(12, 2),
    order_item_profit_ratio        NUMERIC(8, 4),
    order_item_quantity             INTEGER,

    sales                          NUMERIC(12, 2),
    order_item_total               NUMERIC(12, 2),
    order_profit_per_order         NUMERIC(12, 2),

    order_region                   TEXT,
    order_state                    TEXT,
    order_status                   TEXT,

    product_card_id                BIGINT,
    product_category_id            BIGINT,
    product_name                   TEXT,
    product_price                  NUMERIC(12, 2),

    shipping_date                  TIMESTAMP,
    shipping_mode                  TEXT,


    -- --------------------------------------------------------
    -- Engineered Features
    -- --------------------------------------------------------

    shipping_delay_days            INTEGER,
    is_late_delivery               SMALLINT,
    shipping_performance           TEXT,

    order_year                     SMALLINT,
    order_month                    SMALLINT,
    order_quarter                  SMALLINT,
    order_day                      SMALLINT,
    order_day_of_week              SMALLINT,
    order_week_of_year             SMALLINT,


    -- --------------------------------------------------------
    -- Primary Key
    -- --------------------------------------------------------

    CONSTRAINT order_items_pkey
        PRIMARY KEY (order_item_id)
);


-- ============================================================
-- 3. VERIFY TABLE CREATION
-- ============================================================

SELECT
    table_schema,
    table_name
FROM information_schema.tables
WHERE table_schema = 'supply_chain'
  AND table_name = 'order_items';


-- ============================================================
-- 4. VERIFY TABLE STRUCTURE
-- ============================================================

SELECT
    ordinal_position,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'supply_chain'
  AND table_name = 'order_items'
ORDER BY ordinal_position;


-- ============================================================
-- 5. POST-IMPORT ROW COUNT CHECK
-- ============================================================
--
-- Run this query after importing the cleaned dataset.
--
-- Expected row count: 180,519
-- ============================================================

SELECT
    COUNT(*) AS total_rows
FROM supply_chain.order_items;