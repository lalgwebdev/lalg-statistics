/* Create the Tables for Payment Statistics */

-- Count Payments in month by Payment Type
CREATE TABLE IF NOT EXISTS lalg_stats_payments
  (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  Sample_Date DATE,				
  Payment_Type VARCHAR(30),
  Payment_Source VARCHAR(20),
  Revenue_Account VARCHAR(30),
  Sample_Count INT,
  
  INDEX date_index (Sample_Date),
  INDEX payment_type_index (Payment_Type),
  INDEX payment_source_index (Payment_Source),
  INDEX revenue_account_index (Revenue_Account)
  );
  
  
-- Revenue in month by Account
CREATE TABLE IF NOT EXISTS lalg_stats_revenue
  (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  Sample_Date DATE,				
  Revenue_Account VARCHAR(30),
  Total_Value DECIMAL(10,2),
  Net_Value DECIMAL(10,2),
  
  INDEX date_index (Sample_Date),
  INDEX revenue_account_index (Revenue_Account)
  );
  