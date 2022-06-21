/* Create Views to aggregate or filter Tables for Contacts Statistics */

-- Select Household Sizes for Latest Month
CREATE OR REPLACE SQL SECURITY INVOKER VIEW lalg_stats_view_latest_sizes AS

SELECT * FROM lalg_stats_household_sizes AS a 
WHERE (a.Sample_Date = (SELECT MAX(b.Sample_Date) FROM lalg_stats_household_sizes AS b));

  
-- Select Household Postcodes for Latest Month
CREATE OR REPLACE SQL SECURITY INVOKER VIEW lalg_stats_view_latest_postcodes AS

SELECT * FROM lalg_stats_household_postcodes AS a 
WHERE (a.Sample_Date = (SELECT MAX(b.Sample_Date) FROM lalg_stats_household_postcodes AS b));
 
  
-- Annual aggregation of Contact numbers
CREATE OR REPLACE SQL SECURITY INVOKER VIEW lalg_stats_view_annual_contacts AS

SELECT YEAR(Sample_Date) AS Year, Contact_Type, Membership_Type, 
	ROUND(AVG(Sample_Count), 0) AS Average, MAX(Sample_Count) AS Max, MIN(Sample_Count) AS Min
FROM lalg_stats_contacts 
GROUP BY YEAR(Sample_Date), Contact_Type, Membership_Type
ORDER BY YEAR(Sample_Date);

  
-- Select Household Renewal Dates for Latest Month
CREATE OR REPLACE SQL SECURITY INVOKER VIEW lalg_stats_view_latest_renewal_dates AS

SELECT * FROM lalg_stats_membership_renewal_dates AS a 
WHERE (a.Sample_Date = (SELECT MAX(b.Sample_Date) FROM lalg_stats_membership_renewal_dates AS b));

