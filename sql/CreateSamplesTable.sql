/* Create the LALG Statistics Table */

CREATE TABLE IF NOT EXISTS lalg_statistics
  (
  id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  sample_date date,				
  sample_period varchar(15),		-- Snapshot, (Week), Month
  sample_object varchar(15),		-- Household, Member, Payment, Activity, Event, Booking
  dimension1 varchar(20),			-- Specify: e.g. Membership Status, Activity Type, Payment Type, etc.
  dimension2 varchar(20),			-- Specify: e.g. Membership Type, Payment Account
  dimension1_value varchar(50),
  dimension2_value varchar(50),
  sample_count int,
  
  INDEX date_index (sample_date),
  INDEX sample_object_index (sample_object),
  INDEX sample_period_index (sample_period),
  INDEX dimension1_index (dimension1_value),
  INDEX dimension2_index (dimension2_value)
  );
