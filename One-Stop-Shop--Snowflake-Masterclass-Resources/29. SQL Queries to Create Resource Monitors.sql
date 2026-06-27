/* ============================================================================
   EXAMPLE 1: Standard Monthly Reset Monitor (Suspends at 100%)
   ============================================================================ */
USE ROLE accountadmin;

CREATE OR REPLACE RESOURCE MONITOR monitor1 
    CREDIT_QUOTA = 15
    TRIGGERS 
        ON 100 PERCENT DO SUSPEND;

ALTER WAREHOUSE compute_wh SET resource_monitor = monitor1;


/* ============================================================================
   EXAMPLE 2: Strict Multilevel Account Protection (Suspend vs Suspend_Immediate)
   ============================================================================ */
USE ROLE accountadmin;

CREATE OR REPLACE RESOURCE MONITOR monitor2 
    CREDIT_QUOTA = 100
    TRIGGERS 
        ON 90 PERCENT DO SUSPEND
        ON 100 PERCENT DO SUSPEND_IMMEDIATE;

ALTER WAREHOUSE compute_wh SET resource_monitor = monitor2;


/* ============================================================================
   EXAMPLE 3: Granular Notifications with a 10% Quota Over-Grace Allocation
   ============================================================================ */
USE ROLE accountadmin;

CREATE OR REPLACE RESOURCE MONITOR monitor3 
    CREDIT_QUOTA = 120
    TRIGGERS 
        ON 50 PERCENT DO NOTIFY
        ON 75 PERCENT DO NOTIFY
        ON 100 PERCENT DO SUSPEND
        ON 110 PERCENT DO SUSPEND_IMMEDIATE;

ALTER WAREHOUSE compute_wh SET resource_monitor = monitor3;


/* ============================================================================
   EXAMPLE 4: Explicit Frequency Control Ingestion (Resets Monthly)
   ============================================================================ */
USE ROLE accountadmin;

CREATE OR REPLACE RESOURCE MONITOR monitor_freq1 
    CREDIT_QUOTA = 50
    FREQUENCY = MONTHLY
    START_TIMESTAMP = '2026-06-27 23:25' -- Fixed: Explicit string literal timestamp matching the current time
    TRIGGERS 
        ON 100 PERCENT DO SUSPEND;

ALTER WAREHOUSE compute_wh SET resource_monitor = monitor_freq1;


/* ============================================================================
   EXAMPLE 5: Future Dated Weekly Reset Monitor with Multiple Warehouses
   ============================================================================ */
USE ROLE accountadmin;

CREATE OR REPLACE RESOURCE MONITOR monitor_freq2
    CREDIT_QUOTA = 200,
    FREQUENCY = WEEKLY,
    START_TIMESTAMP = '2026-06-28 00:00' -- Validated: Strict minutes grain constraint matching your June 28 timeline
    TRIGGERS 
        ON 80 PERCENT DO SUSPEND
        ON 100 PERCENT DO SUSPEND_IMMEDIATE;

ALTER WAREHOUSE compute_wh SET resource_monitor = monitor_freq2;
ALTER WAREHOUSE pc_matillion_wh SET resource_monitor = monitor_freq2;


/* ============================================================================
   EXAMPLE 6: Account-Level Global Resource Guardrails
   ============================================================================ */
USE ROLE accountadmin;

CREATE OR REPLACE RESOURCE MONITOR account_monitor 
    CREDIT_QUOTA = 500
    TRIGGERS 
        ON 100 PERCENT DO SUSPEND;

ALTER ACCOUNT SET resource_monitor = account_monitor;


/* ============================================================================
   EXAMPLE 7: Maintenance - Altering Existing Quotas Dynamically
   ============================================================================ */
ALTER RESOURCE MONITOR monitor1 SET CREDIT_QUOTA = 150;