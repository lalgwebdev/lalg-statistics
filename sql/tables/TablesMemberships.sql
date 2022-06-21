/* Create the Tables for Membership Statistics */

-- Distribution of Memberships by continuous Duration
CREATE TABLE IF NOT EXISTS lalg_stats_membership_durations
  (
  id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  Sample_Date varchar(15),	
  Duration int,
  Sample_Count int,
  
  INDEX date_index (Sample_Date),
  INDEX duration_index (Duration)
  );
  
  
-- Profile of current Memberships (Households) by Status
CREATE TABLE IF NOT EXISTS lalg_stats_membership_status
  (
  id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  Sample_Date varchar(15),					
  Membership_Type varchar(50),
  Membership_Status varchar (20),
  Status_Weight int,
  Sample_Count int,
  
  INDEX date_index (Sample_Date),
  INDEX membership_type_index (Membership_Type),
  INDEX membership_status_index (Membership_Status)
  );
  
  
-- Profile of monthly Membership Actions by Type
CREATE TABLE IF NOT EXISTS lalg_stats_membership_actions
  (
  id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  Sample_Date varchar(15),					
  Membership_Type varchar(50),
  Membership_Action varchar (20),
  Action_Weight int,
  Sample_Count int,
  
  INDEX date_index (Sample_Date),
  INDEX membership_type_index (Membership_Type),
  INDEX membership_action_index (Membership_Action)
  );
  
 
-- Profile of current Memberships (Households) by Renewal Date
CREATE TABLE IF NOT EXISTS lalg_stats_membership_renewal_dates
  (
  id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  Sample_Date varchar(15),					
  Membership_Type varchar(50),
  Renewal_Month varchar(15),
  Sample_Count int,
  
  INDEX date_index (Sample_Date),
  INDEX membership_type_index (Membership_Type),
  INDEX renewal_month_index(Renewal_Month)
  );
   