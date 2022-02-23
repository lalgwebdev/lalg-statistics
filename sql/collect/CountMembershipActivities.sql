/* Count of Membership Activities by Membership Type*/

SELECT @firstDay := DATE_FORMAT(CURDATE() - INTERVAL 1 MONTH,'%Y-%m-01');
SELECT @lastDay := LAST_DAY(@firstDay);

INSERT INTO lalg_statistics

SELECT 
  NULL AS id,
  @lastDay AS sample_date, 
  'Month' AS sample_period,
  'Activity' AS sample_object,
  'Membership Type' AS dimension1,
  'Activity Type' AS dimension2,  
  m_type.name AS dimension1_value,
  CASE m_log.status_id
    WHEN '1' THEN 'New Join' 
    WHEN '2' THEN CASE WHEN m_log.start_date = m_log.modified_date THEN 'Re-Join' ELSE 'Renewal' END
    WHEN '4' THEN 'Lapsed'
	WHEN '6' THEN 'Cancelled'
  END AS dimension2_value,
  COUNT(contact.id) AS sample_count

FROM civicrm_membership_log AS m_log 
  INNER JOIN civicrm_membership AS membership ON membership.id = m_log.membership_id
  INNER JOIN civicrm_membership_type AS m_type ON m_type.id = membership.membership_type_id
  INNER JOIN civicrm_membership_status AS status ON status.id = m_log.status_id
  INNER JOIN civicrm_contact AS contact ON contact.id = membership.contact_id

WHERE m_log.modified_date >= @firstDay
  AND m_log.modified_date <= @lastDay
  AND contact.contact_type = 'Household'
  AND m_log.status_id IN ('1', '2', '4', '6')
  
GROUP BY dimension1_value, dimension2_value ;
  
 