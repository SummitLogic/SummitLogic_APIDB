-- ============================================================================
-- SummitLogic Sample Data Population
-- Comprehensive flight, beverage, bottle, and event data
-- ============================================================================
-- NEW
-- ============================================================================
-- SECTION 1: AIRLINES (12 airlines - mix of low-cost, flag carriers, and international)
-- ============================================================================
INSERT INTO airlines (name, iata_code, icao_code) VALUES
('Aeromexico', 'AM', 'AMX'),
('Volaris', 'Y4', 'VOI'),
('VivaAerobus', 'VB', 'VBT'),
('Frontier Mexico', 'F9', 'FFT'),
('LATAM Mexico', 'LA', 'LAT'),
('United Express', 'UA', 'UAL'),
('American Airlines', 'AA', 'AAL'),
('Iberia', 'IB', 'IBE'),
('Lufthansa', 'LH', 'DLH'),
('China Southern', 'CZ', 'CSN'),
('All Nippon Airways', 'NH', 'ANA');

-- ============================================================================
-- SECTION 3: ITEMS - BEVERAGES
-- ============================================================================
INSERT INTO items (name, brand, category, unit_desc, size_desc, notes, is_active) VALUES
('Still Water', 'Evian', 'Beverage', 'bottle', '500ml', 'Standard cabin service', 1),
('Sparkling Water', 'Perrier', 'Beverage', 'bottle', '500ml', 'Premium option', 1),
('Orange Juice', 'Tropicana', 'Beverage', 'bottle', '200ml', 'Standard cabin service', 1),
('Tomato Juice', 'Clamato', 'Beverage', 'bottle', '150ml', 'Popular with breakfast', 1),
('Coffee', 'Nescafe', 'Beverage', 'cup', '200ml', 'Hot beverage service', 1),
('Tea', 'Lipton', 'Beverage', 'cup', '200ml', 'Hot beverage service', 1),
('Cola', 'Coca Cola', 'Beverage', 'can', '330ml', 'Standard service', 1),
('Sprite', 'Sprite', 'Beverage', 'can', '330ml', 'Standard service', 1),
('Red Wine', 'Santa Rita', 'Beverage', 'bottle', '187ml', 'Premium cabin beverages', 1),
('White Wine', 'Riesling', 'Beverage', 'bottle', '187ml', 'Premium cabin beverages', 1),
('Beer', 'Corona', 'Beverage', 'bottle', '355ml', 'Standard alcoholic option', 1),
('Whiskey', 'Jack Daniels', 'Beverage', 'bottle', '50ml', 'Mini bottle for service', 1),
('Tequila', 'Jose Cuervo', 'Beverage', 'bottle', '50ml', 'Mini bottle for service', 1),
('Rum', 'Bacardi', 'Beverage', 'bottle', '50ml', 'Mini bottle for service', 1);

-- ============================================================================
-- SECTION 4: ITEMS - SNACKS
-- ============================================================================
INSERT INTO items (name, brand, category, unit_desc, size_desc, notes, is_active) VALUES
('Peanuts', 'Planters', 'Snack', 'packet', '50g', 'Common snack option', 1),
('Pretzels', 'Rold Gold', 'Snack', 'packet', '28g', 'Salty snack', 1),
('Cookies', 'Bimbo', 'Snack', 'packet', '40g', 'Mexican brand snacks', 1),
('Fruit Mix', 'Del Monte', 'Snack', 'packet', '35g', 'Dried fruit mix', 1),
('Chocolate Bar', 'Hershey', 'Snack', 'bar', '45g', 'Sweet treat', 1);

-- ============================================================================
-- SECTION 5: ITEMS - FOOD
-- ============================================================================
INSERT INTO items (name, brand, category, unit_desc, size_desc, notes, is_active) VALUES
('Sandwich - Chicken', 'Fresh Meals', 'Food', 'unit', 'full wrap', 'Short to medium haul', 1),
('Sandwich - Veggie', 'Fresh Meals', 'Food', 'unit', 'full wrap', 'Vegetarian option', 1),
('Snack Box - Cheese', 'Iberia Meals', 'Food', 'unit', '150g', 'Cheese and crackers', 1),
('Snack Box - Fruit', 'Iberia Meals', 'Food', 'unit', '180g', 'Assorted fresh fruit', 1),
('Breakfast Box', 'Continental', 'Food', 'unit', '250g', 'Croissant, yogurt, jam', 1),
('Pasta Box', 'Premium Catering', 'Food', 'unit', '300g', 'Full meal service for long haul', 1);

-- ============================================================================
-- SECTION 6: BEVERAGES TABLE DETAILS
-- ============================================================================
INSERT INTO beverages (item_id, type, flavour, volume_ml, alcohol_pct, default_pack_qty) VALUES
(1, 'Water', 'Still', 500, NULL, 12),
(2, 'Water', 'Sparkling', 500, NULL, 12),
(3, 'Juice', 'Orange', 200, NULL, 24),
(4, 'Juice', 'Tomato', 150, NULL, 20),
(5, 'Hot Beverage', 'Coffee', 200, NULL, 40),
(6, 'Hot Beverage', 'Tea', 200, NULL, 40),
(7, 'Soft Drink', 'Cola', 330, NULL, 24),
(8, 'Soft Drink', 'Lemon-Lime', 330, NULL, 24),
(9, 'Wine', 'Red', 187, 12.5, 6),
(10, 'Wine', 'White', 187, 11.0, 6),
(11, 'Beer', 'Lager', 355, 4.6, 12),
(12, 'Spirits', 'Whiskey', 50, 40.0, 24),
(13, 'Spirits', 'Tequila', 50, 38.0, 24),
(14, 'Spirits', 'Rum', 50, 37.5, 24);

-- ============================================================================
-- SECTION 7: SNACKS TABLE DETAILS
-- ============================================================================
INSERT INTO snacks (item_id, type, size_grams, default_pack_qty) VALUES
(15, 'Nuts', 50, 18),
(16, 'Salty', 28, 24),
(17, 'Sweet', 40, 20),
(18, 'Dried Fruit', 35, 16),
(19, 'Chocolate', 45, 12);

-- ============================================================================
-- SECTION 8: FOOD TABLE DETAILS
-- ============================================================================
INSERT INTO food (item_id, ingredients, serving_size, default_pack_qty) VALUES
(20, 'Bread, Chicken, Lettuce, Tomato', '1 wrap', 24),
(21, 'Bread, Vegetables, Spreads', '1 wrap', 24),
(22, 'Cheese, Crackers, Jam', '150g', 20),
(23, 'Apple, Banana, Orange, Berries', '180g', 20),
(24, 'Croissant, Yogurt, Jam, Butter', '250g', 24),
(25, 'Pasta, Sauce, Vegetables, Protein', '300g', 12);

-- ============================================================================
-- SECTION 9: AIRLINE BEVERAGE RULES
-- ============================================================================
-- Aeromexico (Premium/Flag Carrier - Stricter, discards more, no combining)
INSERT INTO airline_beverage_rules (airline_id, beverage_item_id, min_full_pct_to_keep, combine_allowed, expiry_days, tamper_seal_required, notes) VALUES
(1, 1, 90.00, 0, 30, 1, 'Premium carrier: only 90%+ full kept'),
(1, 3, 85.00, 0, 5, 1, 'Fresh juice only, premium standard'),
(1, 9, 95.00, 0, 30, 1, 'Wine: strict standard, no combining'),
(1, 11, 90.00, 0, 60, 1, 'Beer: high standard, tamper seal required');

-- Volaris (Low-Cost Carrier - Moderate reuse, some combining allowed)
INSERT INTO airline_beverage_rules (airline_id, beverage_item_id, min_full_pct_to_keep, combine_allowed, expiry_days, tamper_seal_required, notes) VALUES
(2, 1, 60.00, 1, 30, 0, 'Budget carrier: reuse at 60%+, can combine'),
(2, 3, 50.00, 1, 3, 0, 'Budget: can combine partially used juice'),
(2, 9, 70.00, 1, 30, 0, 'Wine: reused if 70%+, combining allowed'),
(2, 11, 65.00, 1, 60, 0, 'Beer: reused at 65%+, no seal needed');

-- VivaAerobus (Ultra Low-Cost - Aggressive reuse)
INSERT INTO airline_beverage_rules (airline_id, beverage_item_id, min_full_pct_to_keep, combine_allowed, expiry_days, tamper_seal_required, notes) VALUES
(3, 1, 45.00, 1, 30, 0, 'Ultra budget: reuse at 45%+'),
(3, 3, 35.00, 1, 3, 0, 'Aggressive reuse policy'),
(3, 9, 55.00, 1, 30, 0, 'Wine: reused if 55%+ full'),
(3, 11, 45.00, 1, 60, 0, 'Beer: reused if 45%+ full');

-- Frontier Mexico (Low-Cost Carrier)
INSERT INTO airline_beverage_rules (airline_id, beverage_item_id, min_full_pct_to_keep, combine_allowed, expiry_days, tamper_seal_required, notes) VALUES
(4, 1, 55.00, 1, 30, 0, 'Budget carrier: moderate reuse policy'),
(4, 3, 45.00, 1, 3, 0, 'Can combine juice bottles'),
(4, 9, 65.00, 1, 30, 0, 'Wine: reused at 65%+'),
(4, 11, 60.00, 1, 60, 0, 'Beer: moderate reuse');

-- LATAM Mexico (Premium/Flag Carrier)
INSERT INTO airline_beverage_rules (airline_id, beverage_item_id, min_full_pct_to_keep, combine_allowed, expiry_days, tamper_seal_required, notes) VALUES
(5, 1, 85.00, 0, 30, 1, 'Premium service standard'),
(5, 3, 80.00, 0, 5, 1, 'Fresh juice only'),
(5, 9, 90.00, 0, 30, 1, 'Premium wine service'),
(5, 11, 85.00, 0, 60, 1, 'Premium beer service');

-- Iberia (European Premium Flag Carrier)
INSERT INTO airline_beverage_rules (airline_id, beverage_item_id, min_full_pct_to_keep, combine_allowed, expiry_days, tamper_seal_required, notes) VALUES
(8, 1, 88.00, 0, 30, 1, 'European premium standard'),
(8, 3, 85.00, 0, 5, 1, 'Fresh juice premium'),
(8, 9, 92.00, 0, 30, 1, 'Wine: strict European standards'),
(8, 11, 88.00, 0, 60, 1, 'Beer: premium European carrier');

-- Lufthansa (European Premium Flag Carrier)
INSERT INTO airline_beverage_rules (airline_id, beverage_item_id, min_full_pct_to_keep, combine_allowed, expiry_days, tamper_seal_required, notes) VALUES
(9, 1, 90.00, 0, 30, 1, 'Premium German carrier standard'),
(9, 3, 87.00, 0, 5, 1, 'Fresh juice strict standards'),
(9, 9, 95.00, 0, 30, 1, 'Wine: highest European standards'),
(9, 12, 90.00, 0, 60, 1, 'Spirits: strict German regulations');

-- China Southern (Asian Carrier)
INSERT INTO airline_beverage_rules (airline_id, beverage_item_id, min_full_pct_to_keep, combine_allowed, expiry_days, tamper_seal_required, notes) VALUES
(10, 1, 75.00, 1, 30, 1, 'Asian carrier: moderate reuse'),
(10, 3, 65.00, 1, 5, 1, 'Can combine juice'),
(10, 9, 80.00, 0, 30, 1, 'Wine: strict on alcohol'),
(10, 11, 75.00, 0, 60, 1, 'Beer: premium service');

-- ANA (All Nippon Airways - Premium Asian Carrier)
INSERT INTO airline_beverage_rules (airline_id, beverage_item_id, min_full_pct_to_keep, combine_allowed, expiry_days, tamper_seal_required, notes) VALUES
(11, 1, 92.00, 0, 30, 1, 'Premium Japanese carrier: highest standards'),
(11, 3, 90.00, 0, 5, 1, 'Fresh juice premium only'),
(11, 9, 95.00, 0, 30, 1, 'Wine: Japanese premium standards'),
(11, 11, 92.00, 0, 60, 1, 'Beer: premium service');

-- ============================================================================
-- SECTION 10: REGIONAL MEXICO FLIGHTS (60 flights - short-haul)
-- ============================================================================
INSERT INTO flights (airline_id, flight_number, direction, aircraft_type, departure_airport, arrival_airport, scheduled_departure, scheduled_arrival, capacity_seats, load_factor_pct, service_date) VALUES
-- MEX to GDL routes (multiple airlines, various load factors)
(1, 'AM001', 'Outbound', 'Boeing 737', 'MEX', 'GDL', '2025-10-25 08:00:00', '2025-10-25 09:15:00', 150, 95.00, '2025-10-25'),
(1, 'AM002', 'Inbound', 'Boeing 737', 'GDL', 'MEX', '2025-10-25 10:00:00', '2025-10-25 11:15:00', 150, 75.50, '2025-10-25'),
(2, 'Y4001', 'Outbound', 'Boeing 737', 'MEX', 'GDL', '2025-10-25 06:30:00', '2025-10-25 07:45:00', 160, 65.40, '2025-10-25'),
(2, 'Y4002', 'Inbound', 'Boeing 737', 'GDL', 'MEX', '2025-10-25 08:30:00', '2025-10-25 09:45:00', 160, 78.20, '2025-10-25'),
(3, 'VB001', 'Outbound', 'Airbus A320', 'MEX', 'GDL', '2025-10-25 07:00:00', '2025-10-25 08:15:00', 180, 45.00, '2025-10-25'),
(3, 'VB002', 'Inbound', 'Airbus A320', 'GDL', 'MEX', '2025-10-25 09:00:00', '2025-10-25 10:15:00', 180, 70.50, '2025-10-25'),

-- MEX to CUN routes (beach destination)
(1, 'AM003', 'Outbound', 'Airbus A320', 'MEX', 'CUN', '2025-10-25 12:30:00', '2025-10-25 14:30:00', 180, 88.30, '2025-10-25'),
(1, 'AM004', 'Inbound', 'Airbus A320', 'CUN', 'MEX', '2025-10-25 15:00:00', '2025-10-25 17:00:00', 180, 92.20, '2025-10-25'),
(2, 'Y4003', 'Outbound', 'Boeing 737', 'MEX', 'CUN', '2025-10-25 14:00:00', '2025-10-25 16:00:00', 160, 100.00, '2025-10-25'),
(2, 'Y4004', 'Inbound', 'Boeing 737', 'CUN', 'MEX', '2025-10-25 16:30:00', '2025-10-25 18:30:00', 160, 55.30, '2025-10-25'),

-- MEX to PVR routes (Puerto Vallarta)
(1, 'AM005', 'Outbound', 'Boeing 737', 'MEX', 'PVR', '2025-10-26 06:00:00', '2025-10-26 07:45:00', 150, 85.30, '2025-10-26'),
(1, 'AM006', 'Inbound', 'Boeing 737', 'PVR', 'MEX', '2025-10-26 08:30:00', '2025-10-26 10:15:00', 150, 73.30, '2025-10-26'),
(2, 'Y4005', 'Outbound', 'Boeing 737', 'MEX', 'PVR', '2025-10-26 14:00:00', '2025-10-26 15:45:00', 160, 100.00, '2025-10-26'),
(2, 'Y4006', 'Inbound', 'Boeing 737', 'PVR', 'MEX', '2025-10-26 16:30:00', '2025-10-26 18:15:00', 160, 55.30, '2025-10-26'),
(3, 'VB003', 'Outbound', 'Airbus A320', 'MEX', 'PVR', '2025-10-26 13:00:00', '2025-10-26 14:45:00', 180, 48.30, '2025-10-26'),
(3, 'VB004', 'Inbound', 'Airbus A320', 'PVR', 'MEX', '2025-10-26 15:30:00', '2025-10-26 17:15:00', 180, 95.50, '2025-10-26'),

-- MEX to MTY routes (Monterrey)
(1, 'AM007', 'Outbound', 'Boeing 737', 'MEX', 'MTY', '2025-10-26 07:15:00', '2025-10-26 08:30:00', 150, 79.30, '2025-10-26'),
(1, 'AM008', 'Inbound', 'Boeing 737', 'MTY', 'MEX', '2025-10-26 09:15:00', '2025-10-26 10:30:00', 150, 86.60, '2025-10-26'),
(2, 'Y4007', 'Outbound', 'Boeing 737', 'MEX', 'MTY', '2025-10-26 13:00:00', '2025-10-26 14:15:00', 160, 91.20, '2025-10-26'),
(2, 'Y4008', 'Inbound', 'Boeing 737', 'MTY', 'MEX', '2025-10-26 15:00:00', '2025-10-26 16:15:00', 160, 68.00, '2025-10-26'),

-- MEX to HMO routes (Hermosillo)
(3, 'VB005', 'Outbound', 'Airbus A320', 'MEX', 'HMO', '2025-10-27 06:45:00', '2025-10-27 08:30:00', 180, 50.00, '2025-10-27'),
(3, 'VB006', 'Inbound', 'Airbus A320', 'HMO', 'MEX', '2025-10-27 09:15:00', '2025-10-27 11:00:00', 180, 95.50, '2025-10-27'),
(4, 'F9001', 'Outbound', 'Boeing 737', 'MEX', 'HMO', '2025-10-27 08:00:00', '2025-10-27 09:30:00', 160, 55.60, '2025-10-27'),
(4, 'F9002', 'Inbound', 'Boeing 737', 'HMO', 'MEX', '2025-10-27 10:15:00', '2025-10-27 11:45:00', 160, 81.20, '2025-10-27'),

-- MEX to CLQ routes (Colima)
(1, 'AM009', 'Outbound', 'Airbus A320', 'MEX', 'CLQ', '2025-10-27 11:00:00', '2025-10-27 12:30:00', 180, 76.10, '2025-10-27'),
(1, 'AM010', 'Inbound', 'Airbus A320', 'CLQ', 'MEX', '2025-10-27 13:15:00', '2025-10-27 14:45:00', 180, 60.00, '2025-10-27'),
(5, 'LA001', 'Outbound', 'Boeing 787', 'MEX', 'CLQ', '2025-10-27 12:30:00', '2025-10-27 14:00:00', 250, 82.40, '2025-10-27'),
(5, 'LA002', 'Inbound', 'Boeing 787', 'CLQ', 'MEX', '2025-10-27 14:45:00', '2025-10-27 16:15:00', 250, 70.00, '2025-10-27'),

-- MEX to MZT routes (Mazatlan)
(1, 'AM011', 'Outbound', 'Boeing 737', 'MEX', 'MZT', '2025-10-28 08:30:00', '2025-10-28 10:00:00', 150, 82.00, '2025-10-28'),
(1, 'AM012', 'Inbound', 'Boeing 737', 'MZT', 'MEX', '2025-10-28 10:45:00', '2025-10-28 12:15:00', 150, 88.70, '2025-10-28'),
(2, 'Y4009', 'Outbound', 'Boeing 737', 'MEX', 'MZT', '2025-10-28 05:30:00', '2025-10-28 07:00:00', 160, 92.50, '2025-10-28'),
(2, 'Y4010', 'Inbound', 'Boeing 737', 'MZT', 'MEX', '2025-10-28 07:45:00', '2025-10-28 09:15:00', 160, 61.20, '2025-10-28'),

-- MEX to SJD routes (Los Cabos)
(3, 'VB007', 'Outbound', 'Airbus A320', 'MEX', 'SJD', '2025-10-28 14:00:00', '2025-10-28 15:30:00', 180, 48.30, '2025-10-28'),
(3, 'VB008', 'Inbound', 'Airbus A320', 'SJD', 'MEX', '2025-10-28 16:15:00', '2025-10-28 17:45:00', 180, 100.00, '2025-10-28'),
(4, 'F9003', 'Outbound', 'Boeing 737', 'MEX', 'SJD', '2025-10-28 11:30:00', '2025-10-28 13:00:00', 160, 77.50, '2025-10-28'),
(4, 'F9004', 'Inbound', 'Boeing 737', 'SJD', 'MEX', '2025-10-28 13:45:00', '2025-10-28 15:15:00', 160, 90.60, '2025-10-28'),

-- GDL to CUN cross routes
(5, 'LA003', 'Outbound', 'Airbus A320', 'GDL', 'CUN', '2025-10-29 09:00:00', '2025-10-29 11:30:00', 200, 85.50, '2025-10-29'),
(5, 'LA004', 'Inbound', 'Airbus A320', 'CUN', 'GDL', '2025-10-29 12:15:00', '2025-10-29 14:45:00', 200, 72.00, '2025-10-29'),

-- MTY to CUN cross route
(1, 'AM013', 'Outbound', 'Boeing 737', 'MTY', 'CUN', '2025-10-29 13:00:00', '2025-10-29 15:00:00', 150, 91.70, '2025-10-29'),
(1, 'AM014', 'Inbound', 'Boeing 737', 'CUN', 'MTY', '2025-10-29 15:45:00', '2025-10-29 17:45:00', 150, 65.00, '2025-10-29'),

-- PVR to GDL
(2, 'Y4011', 'Outbound', 'Boeing 737', 'PVR', 'GDL', '2025-10-29 08:45:00', '2025-10-29 09:45:00', 160, 68.10, '2025-10-29'),
(2, 'Y4012', 'Inbound', 'Boeing 737', 'GDL', 'PVR', '2025-10-29 10:30:00', '2025-10-29 11:30:00', 160, 85.60, '2025-10-29'),

-- Additional variety flights
(3, 'VB009', 'Outbound', 'Airbus A320', 'CUN', 'MTY', '2025-10-30 06:00:00', '2025-10-30 08:00:00', 180, 52.20, '2025-10-30'),
(3, 'VB010', 'Inbound', 'Airbus A320', 'MTY', 'CUN', '2025-10-30 08:45:00', '2025-10-30 10:45:00', 180, 94.40, '2025-10-30'),
(4, 'F9005', 'Outbound', 'Boeing 737', 'GDL', 'MTY', '2025-10-30 07:15:00', '2025-10-30 08:30:00', 160, 84.40, '2025-10-30'),
(4, 'F9006', 'Inbound', 'Boeing 737', 'MTY', 'GDL', '2025-10-30 09:15:00', '2025-10-30 10:30:00', 160, 64.30, '2025-10-30'),
(1, 'AM015', 'Outbound', 'Airbus A320', 'MEX', 'MZT', '2025-10-31 06:30:00', '2025-10-31 08:00:00', 180, 81.10, '2025-10-31'),
(1, 'AM016', 'Inbound', 'Airbus A320', 'MZT', 'MEX', '2025-10-31 08:45:00', '2025-10-31 10:15:00', 180, 69.40, '2025-10-31'),
(2, 'Y4013', 'Outbound', 'Boeing 737', 'PVR', 'CUN', '2025-10-31 10:00:00', '2025-10-31 12:00:00', 160, 77.50, '2025-10-31'),
(2, 'Y4014', 'Inbound', 'Boeing 737', 'CUN', 'PVR', '2025-10-31 12:45:00', '2025-10-31 14:45:00', 160, 90.60, '2025-10-31'),
(5, 'LA005', 'Outbound', 'Boeing 787', 'MEX', 'GDL', '2025-11-01 09:30:00', '2025-11-01 10:45:00', 250, 83.60, '2025-11-01'),
(5, 'LA006', 'Inbound', 'Boeing 787', 'GDL', 'MEX', '2025-11-01 11:30:00', '2025-11-01 12:45:00', 250, 79.20, '2025-11-01'),
(3, 'VB011', 'Outbound', 'Airbus A320', 'MEX', 'HMO', '2025-11-01 07:00:00', '2025-11-01 08:30:00', 180, 46.10, '2025-11-01'),
(3, 'VB012', 'Inbound', 'Airbus A320', 'HMO', 'MEX', '2025-11-01 09:15:00', '2025-11-01 10:45:00', 180, 96.20, '2025-11-01'),
(4, 'F9007', 'Outbound', 'Boeing 737', 'MEX', 'CUN', '2025-11-01 11:30:00', '2025-11-01 13:30:00', 160, 82.30, '2025-11-01'),
(4, 'F9008', 'Inbound', 'Boeing 737', 'CUN', 'MEX', '2025-11-01 14:15:00', '2025-11-01 16:15:00', 160, 59.40, '2025-11-01'),
(1, 'AM017', 'Outbound', 'Boeing 737', 'MEX', 'MTY', '2025-11-02 08:00:00', '2025-11-02 09:15:00', 150, 87.30, '2025-11-02'),
(1, 'AM018', 'Inbound', 'Boeing 737', 'MTY', 'MEX', '2025-11-02 10:00:00', '2025-11-02 11:15:00', 150, 76.60, '2025-11-02'),
(2, 'Y4015', 'Outbound', 'Boeing 737', 'MEX', 'PVR', '2025-11-02 12:45:00', '2025-11-02 14:30:00', 160, 99.50, '2025-11-02'),
(2, 'Y4016', 'Inbound', 'Boeing 737', 'PVR', 'MEX', '2025-11-02 15:15:00', '2025-11-02 17:00:00', 160, 58.70, '2025-11-02');

-- ============================================================================
-- SECTION 11: INTERNATIONAL FLIGHTS (16 flights - Americas, Europe, and Asia routes)
-- ============================================================================
INSERT INTO flights (airline_id, flight_number, direction, aircraft_type, departure_airport, arrival_airport, scheduled_departure, scheduled_arrival, capacity_seats, load_factor_pct, service_date) VALUES
-- Mexico to USA (Dallas, Chicago, New York)
(6, 'UA100', 'Outbound', 'Boeing 737', 'MEX', 'DFW', '2025-10-25 10:00:00', '2025-10-25 12:30:00', 140, 87.14, '2025-10-25'),
(6, 'UA101', 'Inbound', 'Boeing 737', 'DFW', 'MEX', '2025-10-25 14:00:00', '2025-10-25 16:30:00', 140, 71.43, '2025-10-25'),
(7, 'AA200', 'Outbound', 'Airbus A321', 'MEX', 'JFK', '2025-10-26 11:00:00', '2025-10-26 18:00:00', 190, 94.74, '2025-10-26'),
(7, 'AA201', 'Inbound', 'Airbus A321', 'JFK', 'MEX', '2025-10-26 19:30:00', '2025-10-27 02:00:00', 190, 82.11, '2025-10-26'),
(6, 'UA102', 'Outbound', 'Boeing 787', 'MEX', 'ORD', '2025-10-28 09:15:00', '2025-10-28 11:30:00', 242, 93.39, '2025-10-28'),
(6, 'UA103', 'Inbound', 'Boeing 787', 'ORD', 'MEX', '2025-10-28 13:00:00', '2025-10-28 15:15:00', 242, 74.38, '2025-10-28'),

-- Mexico to Canada/Central America/Miami
(1, 'AM300', 'Outbound', 'Boeing 787', 'MEX', 'YYZ', '2025-10-29 13:00:00', '2025-10-29 17:15:00', 242, 89.26, '2025-10-29'),
(1, 'AM301', 'Inbound', 'Boeing 787', 'YYZ', 'MEX', '2025-10-29 18:00:00', '2025-10-29 22:15:00', 242, 76.45, '2025-10-29'),
(5, 'LA400', 'Outbound', 'Boeing 787', 'MEX', 'MIA', '2025-10-30 08:00:00', '2025-10-30 11:00:00', 250, 92.00, '2025-10-30'),
(5, 'LA401', 'Inbound', 'Boeing 787', 'MIA', 'MEX', '2025-10-30 12:00:00', '2025-10-30 15:00:00', 250, 80.00, '2025-10-30'),

-- Aeromexico to Asia (Seoul and Tokyo direct flights)
(1, 'AM701', 'Outbound', 'Boeing 787-9', 'MEX', 'ICN', '2025-10-31 22:00:00', '2025-11-02 10:00:00', 242, 88.43, '2025-10-31'),
(1, 'AM702', 'Inbound', 'Boeing 787-9', 'ICN', 'MEX', '2025-11-02 14:30:00', '2025-11-04 02:30:00', 242, 85.12, '2025-11-02'),
(1, 'AM703', 'Outbound', 'Boeing 787-9', 'MEX', 'NRT', '2025-11-01 20:15:00', '2025-11-03 14:15:00', 242, 91.74, '2025-11-01'),
(1, 'AM704', 'Inbound', 'Boeing 787-9', 'NRT', 'MEX', '2025-11-03 18:45:00', '2025-11-05 06:45:00', 242, 87.60, '2025-11-03'),

-- European carriers serving Mexico
(8, 'IB601', 'Outbound', 'Airbus A350', 'MEX', 'MAD', '2025-11-01 13:00:00', '2025-11-02 07:00:00', 325, 86.15, '2025-11-01'),
(8, 'IB602', 'Inbound', 'Airbus A350', 'MAD', 'MEX', '2025-11-02 10:00:00', '2025-11-03 04:00:00', 325, 83.08, '2025-11-02'),
(9, 'LH501', 'Outbound', 'Airbus A340', 'MEX', 'FRA', '2025-11-02 11:30:00', '2025-11-03 08:30:00', 295, 89.49, '2025-11-02'),
(9, 'LH502', 'Inbound', 'Airbus A340', 'FRA', 'MEX', '2025-11-03 12:00:00', '2025-11-04 09:00:00', 295, 81.36, '2025-11-03'),

-- Asian carriers serving Mexico
(10, 'CZ801', 'Outbound', 'Airbus A350', 'MEX', 'CAN', '2025-11-03 15:45:00', '2025-11-05 09:45:00', 320, 84.69, '2025-11-03'),
(10, 'CZ802', 'Inbound', 'Airbus A350', 'CAN', 'MEX', '2025-11-05 13:15:00', '2025-11-07 07:15:00', 320, 79.69, '2025-11-05'),
(11, 'NH901', 'Outbound', 'Boeing 787-8', 'MEX', 'NRT', '2025-11-04 19:00:00', '2025-11-06 12:00:00', 242, 90.91, '2025-11-04'),
(11, 'NH902', 'Inbound', 'Boeing 787-8', 'NRT', 'MEX', '2025-11-06 15:30:00', '2025-11-08 08:30:00', 242, 86.78, '2025-11-06');

-- ============================================================================
-- SECTION 12: BOTTLE INSTANCES (45+ bottles with various conditions)
-- ============================================================================
-- Aeromexico bottles (Premium carrier - mostly full wines, beer, premium spirits)
INSERT INTO bottle_instances (beverage_item_id, airline_id, qr_code, qr_url, batch_code, initial_volume_ml, current_pct, status, last_flight_id) VALUES
(11, 1, NULL, NULL, 'BATCH-AMX-2501-001', 355, 100.00, 'InFlight', 1),
(9, 1, NULL, NULL, 'BATCH-AMX-2501-002', 187, 100.00, 'InFlight', 1),
(12, 1, NULL, NULL, 'BATCH-AMX-2501-003', 50, 100.00, 'InFlight', 1),
(11, 1, NULL, NULL, 'BATCH-AMX-2501-001', 355, 30.00, 'Returned', 1),
(9, 1, NULL, NULL, 'BATCH-AMX-2501-002', 187, 15.00, 'Returned', 1),
(10, 1, NULL, NULL, 'BATCH-AMX-2501-004', 187, 100.00, 'InFlight', 2),
(12, 1, NULL, NULL, 'BATCH-AMX-2501-005', 50, 100.00, 'InFlight', 2),
(9, 1, NULL, NULL, 'BATCH-AMX-2501-006', 187, 100.00, 'InFlight', 2),
(10, 1, NULL, NULL, 'BATCH-AMX-2501-004', 187, 60.00, 'Returned', 2),
(9, 1, NULL, NULL, 'BATCH-AMX-2501-006', 187, 85.00, 'Returned', 2),

-- Volaris bottles (Budget carrier - beer and wine focused)
(11, 2, NULL, NULL, 'BATCH-VOI-2501-001', 355, 100.00, 'InFlight', 5),
(9, 2, NULL, NULL, 'BATCH-VOI-2501-002', 187, 100.00, 'InFlight', 5),
(14, 2, NULL, NULL, 'BATCH-VOI-2501-003', 50, 100.00, 'InFlight', 5),
(11, 2, NULL, NULL, 'BATCH-VOI-2501-001', 355, 65.00, 'Kept', 5),
(9, 2, NULL, NULL, 'BATCH-VOI-2501-002', 187, 55.00, 'Kept', 5),
(14, 2, NULL, NULL, 'BATCH-VOI-2501-003', 50, 25.00, 'Discarded', 5),
(11, 2, NULL, NULL, 'BATCH-VOI-2501-004', 355, 100.00, 'InFlight', 6),
(10, 2, NULL, NULL, 'BATCH-VOI-2501-005', 187, 100.00, 'InFlight', 6),
(11, 2, NULL, NULL, 'BATCH-VOI-2501-004', 355, 70.00, 'Kept', 6),

-- VivaAerobus bottles (Ultra budget - aggressive reuse on beer and spirits)
(11, 3, NULL, NULL, 'BATCH-VBT-2501-001', 355, 100.00, 'InFlight', 7),
(12, 3, NULL, NULL, 'BATCH-VBT-2501-002', 50, 100.00, 'InFlight', 7),
(9, 3, NULL, NULL, 'BATCH-VBT-2501-003', 187, 100.00, 'InFlight', 7),
(11, 3, NULL, NULL, 'BATCH-VBT-2501-001', 355, 50.00, 'Kept', 7),
(12, 3, NULL, NULL, 'BATCH-VBT-2501-002', 50, 45.00, 'Kept', 7),
(11, 3, NULL, NULL, 'BATCH-VBT-2501-001', 355, 95.00, 'Combined', 7),
(12, 3, NULL, NULL, 'BATCH-VBT-2501-002', 50, 40.00, 'Discarded', 7),
(11, 3, NULL, NULL, 'BATCH-VBT-2501-004', 355, 100.00, 'InFlight', 8),
(10, 3, NULL, NULL, 'BATCH-VBT-2501-005', 187, 100.00, 'InFlight', 8),

-- Frontier Mexico bottles (Beer and wine selection)
(11, 4, NULL, NULL, 'BATCH-FFT-2501-001', 355, 100.00, 'InFlight', 11),
(9, 4, NULL, NULL, 'BATCH-FFT-2501-002', 187, 100.00, 'InFlight', 11),
(11, 4, NULL, NULL, 'BATCH-FFT-2501-001', 355, 58.00, 'Kept', 11),
(9, 4, NULL, NULL, 'BATCH-FFT-2501-002', 187, 42.00, 'Discarded', 11),

-- LATAM Mexico bottles (Premium carrier - strict standards on premium spirits and wines)
(11, 5, NULL, NULL, 'BATCH-LAT-2501-001', 355, 100.00, 'InFlight', 17),
(9, 5, NULL, NULL, 'BATCH-LAT-2501-002', 187, 100.00, 'InFlight', 17),
(12, 5, NULL, NULL, 'BATCH-LAT-2501-003', 50, 100.00, 'InFlight', 17),
(11, 5, NULL, NULL, 'BATCH-LAT-2501-001', 355, 92.00, 'Returned', 17),
(12, 5, NULL, NULL, 'BATCH-LAT-2501-003', 50, 95.00, 'Returned', 17),

-- United Express international bottles (North American premium service)
(11, 6, NULL, NULL, 'BATCH-UAL-2501-001', 355, 100.00, 'InFlight', 37),
(10, 6, NULL, NULL, 'BATCH-UAL-2501-002', 187, 100.00, 'InFlight', 37),
(12, 6, NULL, NULL, 'BATCH-UAL-2501-003', 50, 100.00, 'InFlight', 37),

-- Iberia international bottles (Premium European carrier - Spanish wines and spirits)
(11, 8, NULL, NULL, 'BATCH-IBE-2501-001', 355, 100.00, 'InFlight', 45),
(9, 8, NULL, NULL, 'BATCH-IBE-2501-002', 187, 100.00, 'InFlight', 45),
(10, 8, NULL, NULL, 'BATCH-IBE-2501-003', 187, 100.00, 'InFlight', 45),
(12, 8, NULL, NULL, 'BATCH-IBE-2501-004', 50, 100.00, 'InFlight', 45),
(11, 8, NULL, NULL, 'BATCH-IBE-2501-001', 355, 95.00, 'Returned', 45),

-- Lufthansa international bottles (Premium European carrier - German beer and spirits)
(11, 9, NULL, NULL, 'BATCH-DLH-2501-001', 355, 100.00, 'InFlight', 47),
(10, 9, NULL, NULL, 'BATCH-DLH-2501-002', 187, 100.00, 'InFlight', 47),
(12, 9, NULL, NULL, 'BATCH-DLH-2501-003', 50, 100.00, 'InFlight', 47),
(14, 9, NULL, NULL, 'BATCH-DLH-2501-004', 50, 100.00, 'InFlight', 47),
(11, 9, NULL, NULL, 'BATCH-DLH-2501-001', 355, 88.00, 'Returned', 47),

-- China Southern international bottles (Asian carrier - quality spirits and beers)
(11, 10, NULL, NULL, 'BATCH-CSN-2501-001', 355, 100.00, 'InFlight', 49),
(12, 10, NULL, NULL, 'BATCH-CSN-2501-002', 50, 100.00, 'InFlight', 49),
(9, 10, NULL, NULL, 'BATCH-CSN-2501-003', 187, 100.00, 'InFlight', 49),
(11, 10, NULL, NULL, 'BATCH-CSN-2501-001', 355, 75.00, 'Kept', 49),

-- ANA (All Nippon Airways) international bottles (Premium Asian carrier - quality spirits, beer, wine)
(11, 11, NULL, NULL, 'BATCH-ANA-2501-001', 355, 100.00, 'InFlight', 51),
(10, 11, NULL, NULL, 'BATCH-ANA-2501-002', 187, 100.00, 'InFlight', 51),
(12, 11, NULL, NULL, 'BATCH-ANA-2501-003', 50, 100.00, 'InFlight', 51),
(11, 11, NULL, NULL, 'BATCH-ANA-2501-001', 355, 92.00, 'Returned', 51);

-- ============================================================================
-- SECTION 13: BOTTLE EVENTS (Events on specific flights)
-- ============================================================================
-- Flight AM001 (Flight ID 1) events
INSERT INTO bottle_events (bottle_id, flight_id, user_id, event_type, amount_ml, pct_after, created_at) VALUES
(1, 1, NULL, 'Scan', NULL, NULL, '2025-10-25 07:55:00'),
(1, 1, NULL, 'Place', NULL, NULL, '2025-10-25 07:56:00'),
(1, 1, NULL, 'PartialUse', 350, 30.00, '2025-10-25 08:30:00'),
(2, 1, NULL, 'Scan', NULL, NULL, '2025-10-25 07:57:00'),
(2, 1, NULL, 'PartialUse', 170, 15.00, '2025-10-25 08:45:00'),
(3, 1, NULL, 'Scan', NULL, NULL, '2025-10-25 08:00:00'),
(3, 1, NULL, 'Place', NULL, NULL, '2025-10-25 08:15:00'),
(4, 1, NULL, 'Discard', NULL, NULL, '2025-10-25 09:00:00'),
(5, 1, NULL, 'Discard', NULL, NULL, '2025-10-25 09:01:00');

-- Flight AM002 (Flight ID 2) events
INSERT INTO bottle_events (bottle_id, flight_id, user_id, event_type, amount_ml, pct_after, created_at) VALUES
(6, 2, NULL, 'Scan', NULL, NULL, '2025-10-25 09:50:00'),
(6, 2, NULL, 'PartialUse', 200, 60.00, '2025-10-25 10:30:00'),
(7, 2, NULL, 'Scan', NULL, NULL, '2025-10-25 09:55:00'),
(8, 2, NULL, 'Scan', NULL, NULL, '2025-10-25 10:00:00'),
(8, 2, NULL, 'PartialUse', 28, 85.00, '2025-10-25 10:45:00'),
(9, 2, NULL, 'Scan', NULL, NULL, '2025-10-25 10:05:00'),
(10, 2, NULL, 'Place', NULL, NULL, '2025-10-25 10:10:00');

-- Flight Y4001 (Volaris budget - Flight ID 5) - Combining bottles
INSERT INTO bottle_events (bottle_id, flight_id, user_id, event_type, amount_ml, pct_after, created_at) VALUES
(11, 5, NULL, 'Scan', NULL, NULL, '2025-10-25 06:20:00'),
(11, 5, NULL, 'PartialUse', 175, 65.00, '2025-10-25 07:00:00'),
(12, 5, NULL, 'Scan', NULL, NULL, '2025-10-25 06:22:00'),
(12, 5, NULL, 'PartialUse', 90, 55.00, '2025-10-25 07:10:00'),
(13, 5, NULL, 'PartialUse', 82, 25.00, '2025-10-25 07:20:00');

-- Flight Y4003 (Volaris - high load - Flight ID 7) - Full flight
INSERT INTO bottle_events (bottle_id, flight_id, user_id, event_type, amount_ml, pct_after, created_at) VALUES
(14, 7, NULL, 'Scan', NULL, NULL, '2025-10-25 13:50:00'),
(14, 7, NULL, 'Place', NULL, NULL, '2025-10-25 13:55:00'),
(15, 7, NULL, 'Scan', NULL, NULL, '2025-10-25 13:52:00'),
(15, 7, NULL, 'Place', NULL, NULL, '2025-10-25 13:57:00'),
(16, 7, NULL, 'Scan', NULL, NULL, '2025-10-25 13:54:00'),
(16, 7, NULL, 'Place', NULL, NULL, '2025-10-25 13:59:00');

-- Flight VB001 (Low load - Flight ID 9) - Low utilization
INSERT INTO bottle_events (bottle_id, flight_id, user_id, event_type, amount_ml, pct_after, created_at) VALUES
(18, 9, NULL, 'Scan', NULL, NULL, '2025-10-25 06:50:00'),
(18, 9, NULL, 'PartialUse', 250, 50.00, '2025-10-25 07:20:00'),
(19, 9, NULL, 'Scan', NULL, NULL, '2025-10-25 06:52:00'),
(19, 9, NULL, 'PartialUse', 90, 45.00, '2025-10-25 07:25:00');

-- Flight LA001 (LATAM premium - Flight ID 17) - Premium handling
INSERT INTO bottle_events (bottle_id, flight_id, user_id, event_type, amount_ml, pct_after, created_at) VALUES
(35, 17, NULL, 'Scan', NULL, NULL, '2025-10-26 14:20:00'),
(35, 17, NULL, 'Place', NULL, NULL, '2025-10-26 14:25:00'),
(36, 17, NULL, 'Scan', NULL, NULL, '2025-10-26 14:22:00'),
(36, 17, NULL, 'PartialUse', 190, 92.00, '2025-10-26 15:10:00'),
(37, 17, NULL, 'Scan', NULL, NULL, '2025-10-26 14:24:00'),
(37, 17, NULL, 'Place', NULL, NULL, '2025-10-26 14:29:00');

-- Flight UA100 (United international - Flight ID 37) - International long-haul
INSERT INTO bottle_events (bottle_id, flight_id, user_id, event_type, amount_ml, pct_after, created_at) VALUES
(39, 37, NULL, 'Scan', NULL, NULL, '2025-10-25 09:50:00'),
(39, 37, NULL, 'Place', NULL, NULL, '2025-10-25 09:55:00'),
(40, 37, NULL, 'Scan', NULL, NULL, '2025-10-25 09:52:00'),
(40, 37, NULL, 'Place', NULL, NULL, '2025-10-25 09:57:00'),
(41, 37, NULL, 'Scan', NULL, NULL, '2025-10-25 09:54:00'),
(41, 37, NULL, 'PartialUse', 50, 85.00, '2025-10-25 11:00:00');

-- ============================================================================
-- SECTION 14: PACK PLANS (Beverage allocation for flights)
-- NOTE: Pack plans require user references which are managed separately
-- Uncomment and update created_by user_id when users are added to the system
-- ============================================================================
-- INSERT INTO pack_plans (flight_id, load_factor_pct, created_by, status) VALUES
-- (1, 95.00, 5, 'active'),
-- (2, 75.50, 5, 'active'),
-- (5, 65.40, 6, 'active'),
-- (7, 100.00, 6, 'active'),
-- (9, 45.00, 6, 'draft'),
-- (17, 82.40, 5, 'active'),
-- (37, 87.14, 5, 'active');

-- Pack plan items for flights
-- INSERT INTO pack_plan_items (pack_plan_id, item_id, quantity_units) VALUES
-- (1, 1, 24),   -- Water for AM001 (95% full 150-seat)
-- (1, 3, 18),   -- Orange juice
-- (1, 11, 12),  -- Beer
-- (2, 1, 20),   -- Water for AM002 (75% full)
-- (2, 9, 8),    -- Wine
-- (3, 1, 16),   -- Water for Y4001 (65% full, 160-seat budget)
-- (3, 7, 12),   -- Cola
-- (4, 1, 32),   -- Water for Y4003 (100% full, 160-seat)
-- (4, 7, 24),   -- Cola
-- (4, 11, 16),  -- Beer
-- (5, 1, 8),    -- Water for VB001 (45% full, 180-seat)
-- (5, 3, 6),    -- Orange juice
-- (6, 1, 18),   -- Water for LA001 (82% full, 250-seat premium)
-- (6, 9, 8),    -- Wine
-- (6, 11, 10),  -- Beer
-- (7, 1, 24),   -- Water for UA100 (87% international, 140-seat)
-- (7, 3, 12),   -- Orange juice
-- (7, 11, 8);   -- Beer

-- ============================================================================
-- SECTION 15: AUDITS (Compliance records)
-- NOTE: Audits require user references which are managed separately
-- Uncomment and update created_by user_id when users are added to the system
-- ============================================================================
-- INSERT INTO audits (flight_id, created_by, status, summary) VALUES
-- (1, 5, 'pass', 'All bottles properly scanned and sealed. Service completed successfully.'),
-- (2, 6, 'pass', 'Bottles returned in good condition. Minor sealing issues noted but resolved.'),
-- (5, 6, 'pass', 'Budget flight executed smoothly with reuse policy applied correctly.'),
-- (7, 6, 'pass', 'High-load flight executed smoothly. All beverage requirements met.'),
-- (9, 5, 'needs_review', 'Low load factor. Review reusable bottle inventory levels.'),
-- (17, 5, 'pass', 'Premium flight audit passed. All premium standards met.'),
-- (37, 5, 'pass', 'International flight audit complete. All bottles tracked with events logged.');
