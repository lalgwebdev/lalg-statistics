/* Create Views to aggregate or filter Tables for Contacts Statistics */

-- Select Household Sizes for Latest Month
CREATE OR REPLACE SQL SECURITY INVOKER VIEW lalg_stats_view_latest_sizes AS

SELECT * FROM lalg_stats_household_sizes AS a 
WHERE (a.Sample_Date = (SELECT MAX(b.Sample_Date) FROM lalg_stats_household_sizes AS b));

  
-- Select Household Postcodes for Latest Month
CREATE OR REPLACE SQL SECURITY INVOKER VIEW lalg_stats_view_latest_postcodes AS

SELECT * FROM lalg_stats_household_postcodes AS a 
WHERE (a.Sample_Date = (SELECT MAX(b.Sample_Date) FROM lalg_stats_household_postcodes AS b));
 
  
