/* View for report Members by Month and Type */

CREATE OR REPLACE VIEW view_member_history AS

SELECT LAST_DAY(sample_date) AS Date,
  dimension1_value AS Membership_Type,
  SUM(sample_count) AS Membership_Count
  
FROM lalg_statistics

WHERE sample_period = 'Snapshot'
  AND sample_object = 'Individual'
  AND dimension1 = 'Membership Type'
  AND dimension2 = 'Membership Status'
  
GROUP BY Date, dimension1_value  

ORDER BY Date
;
