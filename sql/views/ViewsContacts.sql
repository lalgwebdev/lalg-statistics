/* Create Views to aggregate or filter Tables for Contacts Statistics */

-- Select Household Sizes for Latest Month
CREATE OR REPLACE SQL SECURITY INVOKER VIEW lalg_stats_view_latest_sizes AS

SELECT a.*
FROM lalg_stats_household_sizes AS a
JOIN ( 
       SELECT MAX(Sample_Date) AS maxd
       FROM lalg_stats_household_sizes
     ) AS b 
  ON a.Sample_date = b.maxd
  
  
-- Select Household Postcodes for Latest Month
CREATE OR REPLACE SQL SECURITY INVOKER VIEW lalg_stats_view_latest_postcodes AS

SELECT a.*
FROM lalg_stats_household_postcodes AS a
JOIN ( 
       SELECT MAX(Sample_Date) AS maxd
       FROM lalg_stats_household_postcodes
     ) AS b 
  ON a.Sample_date = b.maxd  
  
  