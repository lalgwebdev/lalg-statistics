/* Create the Tables for Contact Statistics */

-- Count Active Contacts by Contact Type & Membership Type
CREATE TABLE IF NOT EXISTS lalg_stats_contacts
  (
  id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  Sample_Date varchar(15),
  Contact_Type varchar(15),  
  Membership_Type varchar(50),
  Sample_Count int,
  
  INDEX date_index (Sample_Date),
  INDEX contact_type_index (Contact_Type),
  INDEX membership_type_index (Membership_Type)
  );
  
-- Distribution of Member's ages by Decade 
CREATE TABLE IF NOT EXISTS lalg_stats_individual_ages
  (
  id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  Sample_Date varchar(15),	
  Age_Decade varchar(15),
  Sample_Count int,
  
  INDEX date_index (Sample_Date),
  INDEX decade_index (Age_Decade)
  );  
  
-- Distribution of Households by number of Members
CREATE TABLE IF NOT EXISTS lalg_stats_household_sizes
  (
  id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  Sample_Date varchar(15),				
  Household_Size int,
  Sample_Count int,
  
  INDEX date_index (Sample_Date),
  INDEX household_size_index (Household_Size)
  );

-- Distribution of Households by Postcode Area
CREATE TABLE IF NOT EXISTS lalg_stats_household_postcodes
  (
  id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  Sample_Date varchar(15),					
  Postcode_Area varchar(15),
  Sample_Count int,
  
  INDEX date_index (Sample_Date),
  INDEX postcode_area_index (Postcode_Area)
  );
  

  