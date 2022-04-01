/* Create Views to aggregate or filter Tables for Membership Statistics */

-- Annual aggregation of Membership Actions
CREATE OR REPLACE VIEW lalg_stats_view_annual_actions AS

SELECT YEAR(Sample_Date), Membership_Action, Action_Weight, SUM(Sample_Count) 
FROM lalg_stats_membership_actions 
GROUP BY YEAR(Sample_Date), Membership_Action;
  
  
-- Select Membership Status for Latest Month
CREATE OR REPLACE VIEW lalg_stats_view_latest_status AS

SELECT a.*
FROM lalg_stats_membership_status AS a
JOIN ( 
       SELECT MAX(Sample_Date) AS maxd
       FROM lalg_stats_membership_status
     ) AS b 
  ON a.Sample_date = b.maxd  
  
  
-- Select Membership Durations for Latest Month
CREATE OR REPLACE VIEW lalg_stats_view_latest_duration AS

SELECT a.*
FROM lalg_stats_membership_durations AS a
JOIN ( 
       SELECT MAX(Sample_Date) AS maxd
       FROM lalg_stats_membership_durations
     ) AS b 
  ON a.Sample_date = b.maxd  
  