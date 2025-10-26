-- ============================================================================
-- SummitLogic Database Modifications
-- Run this file to update the bottle_instances table for QR code handling
-- ============================================================================

-- Modify bottle_instances table to support nullable QR codes and add QR URL column
ALTER TABLE bottle_instances 
MODIFY COLUMN qr_code VARCHAR(64) NULL,
ADD COLUMN qr_url VARCHAR(512) NULL AFTER qr_code;

-- Drop the UNIQUE constraint on qr_code since it will now allow NULL values
ALTER TABLE bottle_instances 
DROP INDEX uq_bottle_qr;

-- Re-add unique constraint that allows NULL values (in MySQL, NULL != NULL, so multiple NULLs are allowed)
ALTER TABLE bottle_instances 
ADD UNIQUE KEY uq_bottle_qr (qr_code);
