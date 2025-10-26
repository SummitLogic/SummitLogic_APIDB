-- ============================================================================
-- SummitLogic Sample Data - POPULATE QR URLS
-- Updates bottle_instances with QR codes and URLs from generated_urls.csv
-- Maps beverages to their corresponding QR URLs
-- ============================================================================

-- ============================================================================
-- SECTION 1: CREATE TABLE FOR QR URLS (Permanent)
-- ============================================================================
-- This table holds the mapping of beverage items to their QR URLs
-- The scanner endpoint uses this table to validate QR codes
CREATE TABLE IF NOT EXISTS known_qr_codes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    beverage_name VARCHAR(255) UNIQUE,
    qr_url LONGTEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_qr_url (qr_url(255))
);

-- ============================================================================
-- SECTION 2: INSERT QR URL MAPPINGS
-- ============================================================================
-- Mapping from generated_urls.csv - Alcoholic beverages only (for bottle_instances)
-- Using INSERT IGNORE to avoid errors if records already exist
INSERT IGNORE INTO known_qr_codes (beverage_name, qr_url) VALUES
('Red Wine', 'https://jsonplaceholder.typicode.com/posts/9'),
('White Wine', 'https://jsonplaceholder.typicode.com/posts/10'),
('Beer', 'https://jsonplaceholder.typicode.com/posts/11'),
('Whiskey', 'https://jsonplaceholder.typicode.com/posts/12'),
('Tequila', 'https://jsonplaceholder.typicode.com/posts/13'),
('Rum', 'https://jsonplaceholder.typicode.com/posts/14');

-- ============================================================================
-- SECTION 3: UPDATE BOTTLE INSTANCES WITH QR URLs
-- ============================================================================
-- Aeromexico Red Wine bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 1 AND i.id = 9;

-- Aeromexico White Wine bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 1 AND i.id = 10;

-- Aeromexico Whiskey bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 1 AND i.id = 12;

-- Aeromexico Beer bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 1 AND i.id = 11;

-- Volaris Beer bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 2 AND i.id = 11;

-- Volaris Red Wine bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 2 AND i.id = 9;

-- Volaris Rum bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 2 AND i.id = 14;

-- Volaris White Wine bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 2 AND i.id = 10;

-- VivaAerobus Beer bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 3 AND i.id = 11;

-- VivaAerobus Whiskey bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 3 AND i.id = 12;

-- VivaAerobus Red Wine bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 3 AND i.id = 9;

-- VivaAerobus White Wine bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 3 AND i.id = 10;

-- Frontier Mexico Beer bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 4 AND i.id = 11;

-- Frontier Mexico Red Wine bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 4 AND i.id = 9;

-- LATAM Mexico Beer bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 5 AND i.id = 11;

-- LATAM Mexico Red Wine bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 5 AND i.id = 9;

-- LATAM Mexico Whiskey bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 5 AND i.id = 12;

-- United Express Beer bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 6 AND i.id = 11;

-- United Express White Wine bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 6 AND i.id = 10;

-- United Express Whiskey bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 6 AND i.id = 12;

-- Iberia Beer bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 8 AND i.id = 11;

-- Iberia Red Wine bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 8 AND i.id = 9;

-- Iberia White Wine bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 8 AND i.id = 10;

-- Iberia Whiskey bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 8 AND i.id = 12;

-- Lufthansa Beer bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 9 AND i.id = 11;

-- Lufthansa White Wine bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 9 AND i.id = 10;

-- Lufthansa Whiskey bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 9 AND i.id = 12;

-- Lufthansa Rum bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 9 AND i.id = 14;

-- China Southern Beer bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 10 AND i.id = 11;

-- China Southern Whiskey bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 10 AND i.id = 12;

-- China Southern Red Wine bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 10 AND i.id = 9;

-- ANA Beer bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 11 AND i.id = 11;

-- ANA White Wine bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 11 AND i.id = 10;

-- ANA Whiskey bottles
UPDATE bottle_instances bi
JOIN items i ON bi.beverage_item_id = i.id
JOIN known_qr_codes q ON i.name = q.beverage_name
SET bi.qr_url = q.qr_url
WHERE bi.airline_id = 11 AND i.id = 12;

-- ============================================================================
-- SECTION 4: VERIFICATION AND SUMMARY
-- ============================================================================
-- Verify updates (optional - uncomment to check)
-- SELECT 
--   bi.id,
--   i.name,
--   a.name as airline,
--   bi.qr_url,
--   CASE WHEN bi.qr_url IS NOT NULL THEN 'Has QR' ELSE 'Missing QR' END as qr_status
-- FROM bottle_instances bi
-- JOIN items i ON bi.beverage_item_id = i.id
-- JOIN airlines a ON bi.airline_id = a.id
-- ORDER BY a.name, i.name;

-- View known QR codes table
-- SELECT * FROM known_qr_codes;

-- ============================================================================
-- COMPLETION NOTE
-- ============================================================================
-- This script has successfully:
-- 1. Created the known_qr_codes table (permanent, used by scanner endpoint)
-- 2. Populated known_qr_codes with 6 alcoholic beverage QR URLs
-- 3. Updated all bottle_instances with matching QR URLs from known_qr_codes
-- 
-- The known_qr_codes table persists in the database and is used by the
-- scanner endpoint to validate incoming QR codes.
-- ============================================================================
