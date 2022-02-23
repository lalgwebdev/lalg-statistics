/* Count of Memberships by Contact Type, Membership Type and Status */

INSERT INTO lalg_statistics

SELECT 
  NULL AS id,
  CURRENT_DATE() AS sample_date, 
  'Snapshot' AS sample_period,
  contact_type AS sample_object,
  'Membership Type' AS dimension1,
  'Membership Status' AS dimension2,  
  m_type.name AS dimension1_value,
  status.label AS dimension2_value,
  COUNT(contact.id) AS sample_count

FROM civicrm_contact AS contact 
  INNER JOIN civicrm_membership AS membership ON contact.id = membership.contact_id
  INNER JOIN civicrm_membership_type AS m_type ON membership.membership_type_id = m_type.id 
  INNER JOIN civicrm_membership_status AS status ON membership.status_id = status.id
  
GROUP BY sample_object, dimension1_value, dimension2_value ;
  
 