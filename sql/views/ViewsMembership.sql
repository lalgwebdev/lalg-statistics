/* Create Views to aggregate or filter Tables for Membership Statistics */

-- Annual aggregation of Membership Actions
CREATE OR REPLACE SQL SECURITY INVOKER VIEW lalg_stats_view_annual_actions AS

SELECT YEAR(Sample_Date), Membership_Action, Action_Weight, SUM(Sample_Count) 
FROM lalg_stats_membership_actions 
GROUP BY YEAR(Sample_Date), Membership_Action;

-- Annual aggregation of Payment Revenue
CREATE OR REPLACE SQL SECURITY INVOKER VIEW lalg_stats_view_annual_revenue AS

SELECT YEAR(Sample_Date), Revenue_Account, SUM(Total_Value) 
FROM lalg_stats_revenue
GROUP BY YEAR(Sample_Date), Revenue_Account;

  
/* Views with sub-queries cause Backup errors.  Suspected MySQL bug */
/* 
-- Select Membership Status for Latest Month
CREATE OR REPLACE SQL SECURITY INVOKER VIEW lalg_stats_view_latest_status AS

SELECT a.*
FROM lalg_stats_membership_status AS a
JOIN ( 
       SELECT MAX(Sample_Date) AS maxd
       FROM lalg_stats_membership_status
     ) AS b 
  ON a.Sample_date = b.maxd ; 
  
  
-- Select Membership Durations for Latest Month
CREATE OR REPLACE SQL SECURITY INVOKER VIEW lalg_stats_view_latest_duration AS

SELECT a.*
FROM lalg_stats_membership_durations AS a
JOIN ( 
       SELECT MAX(Sample_Date) AS maxd
       FROM lalg_stats_membership_durations
     ) AS b 
  ON a.Sample_date = b.maxd ; 
  
    
-- Select Payments for Latest Month
CREATE OR REPLACE SQL SECURITY INVOKER VIEW lalg_stats_view_latest_payment AS

SELECT a.*
FROM lalg_stats_payments AS a
JOIN ( 
       SELECT MAX(Sample_Date) AS maxd
       FROM lalg_stats_payments
     ) AS b 
  ON a.Sample_date = b.maxd;  
*/  
  