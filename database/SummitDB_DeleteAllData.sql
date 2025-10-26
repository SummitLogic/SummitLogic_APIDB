-- ============================================================================
-- SummitLogic Database - DELETE ALL DATA
-- This script clears all data from the database while preserving schema/tables
-- Execute this before running SummitDB_SampleData.sql to start fresh
-- ============================================================================

-- Disable foreign key constraints temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================================
-- SECTION 1: DELETE FROM DEPENDENT TABLES (must delete in correct order)
-- ============================================================================

-- Delete bottle events first (depends on bottle_instances and flights)
TRUNCATE TABLE bottle_events;

-- Delete bottle instances (depends on beverages and airlines)
TRUNCATE TABLE bottle_instances;

-- Delete pack plan items (depends on pack_plans and items)
TRUNCATE TABLE pack_plan_items;

-- Delete pack plans (depends on flights and users)
TRUNCATE TABLE pack_plans;

-- Delete audits (depends on flights and users)
TRUNCATE TABLE audits;

-- Delete flights (depends on airlines)
TRUNCATE TABLE flights;

-- ============================================================================
-- SECTION 2: DELETE FROM INDEPENDENT TABLES
-- ============================================================================

-- Delete airline beverage rules (depends on airlines and items)
TRUNCATE TABLE airline_beverage_rules;

-- Delete food items
TRUNCATE TABLE food;

-- Delete snacks
TRUNCATE TABLE snacks;

-- Delete beverages
TRUNCATE TABLE beverages;

-- Delete items (base inventory)
TRUNCATE TABLE items;

-- Delete airlines
TRUNCATE TABLE airlines;

-- Delete users (if they exist and were added back)
-- TRUNCATE TABLE users;

-- ============================================================================
-- SECTION 3: RE-ENABLE FOREIGN KEY CONSTRAINTS
-- ============================================================================
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- VERIFICATION QUERIES (optional - uncomment to verify deletion)
-- ============================================================================
-- SELECT COUNT(*) as airlines_count FROM airlines;
-- SELECT COUNT(*) as items_count FROM items;
-- SELECT COUNT(*) as flights_count FROM flights;
-- SELECT COUNT(*) as bottle_instances_count FROM bottle_instances;
-- SELECT COUNT(*) as bottle_events_count FROM bottle_events;

-- ============================================================================
-- NOTE: After running this script, execute SummitDB_SampleData.sql
-- to populate the database with fresh sample data including alcoholic beverages only
-- ============================================================================
