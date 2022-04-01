/* Create Views to aggregate or filter Tables for Membership Statistics */

-- Annual aggregation of Membership Actions
CREATE OR REPLACE VIEW lalg_stats_view_annual_actions AS

SELECT YEAR(Sample_Date), Membership_Action, Action_Weight, SUM(Sample_Count) 
FROM lalg_stats_membership_actions 
GROUP BY YEAR(Sample_Date), Membership_Action;
