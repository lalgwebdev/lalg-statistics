/* Snapshots (census) of Current state of the system. */

-- Sample on first run after end of previous month.  Get Date of end of month
SELECT @lastDay := LAST_DAY( DATE_FORMAT(CURDATE() - INTERVAL 1 MONTH,'%Y-%m-01'));
SET @sample_date = @lastDay;

-- View to include standard exclusions
CREATE OR REPLACE VIEW lalg_stats_filtered_contact AS 
  SELECT * FROM civicrm_contact 
  WHERE display_name NOT LIKE '%watir%' 
    AND is_deceased = 0;
	

-- Contacts by Contact Type & Membership Type
INSERT INTO lalg_stats_contacts

SELECT 
  NULL AS id,
  @sample_date AS Sample_Date, 
  contact.contact_type AS Contact_Type,
  m_type.name AS Membership_Type,
  COUNT(contact.id) AS Sample_Count

FROM lalg_stats_filtered_contact AS contact 
  INNER JOIN civicrm_membership AS membership ON contact.id = membership.contact_id
  INNER JOIN civicrm_membership_type AS m_type ON membership.membership_type_id = m_type.id 

WHERE membership.status_id IN (1, 2, 3, 9)  
  
  AND NOT EXISTS (
    SELECT id FROM lalg_stats_contacts WHERE Sample_Date = @sample_date
  )
  
GROUP BY Contact_Type, Membership_Type ;
 
 
-- Individual Member Age distribution by Decade 
INSERT INTO lalg_stats_individual_ages

SELECT 
  NULL AS id,
  @sample_date AS Sample_Date, 
  CONCAT(((FLOOR((YEAR(CURRENT_DATE()) - YEAR(contact.birth_date)) / 10.0)) * 10 ), "'s") AS Age_Decade, 
  COUNT(contact.id) AS Sample_Count  
  
FROM lalg_stats_filtered_contact AS contact  
  INNER JOIN civicrm_membership AS membership ON contact.id = membership.contact_id  
  
WHERE contact.contact_type = 'Individual'
  AND contact.birth_date IS NOT NULL
  AND membership.status_id IN (1, 2, 3, 9)
  
  AND NOT EXISTS (
    SELECT id FROM lalg_stats_individual_ages WHERE Sample_Date = @sample_date
  )
  
GROUP BY Age_Decade ;


-- Household distribution by number of Members
INSERT INTO lalg_stats_household_sizes

SELECT 
  NULL AS id,
  @sample_date AS Sample_Date, 
  Household_Size,
  COUNT(*) AS Sample_Count  
  
  FROM (
    SELECT COUNT(relationship.id) AS Household_Size
	
	FROM lalg_stats_filtered_contact AS contact  
      INNER JOIN civicrm_membership AS membership ON contact.id = membership.contact_id  
      INNER JOIN civicrm_relationship AS relationship ON contact.id = relationship.contact_id_b
  
    WHERE contact.contact_type = 'Household'
      AND relationship.relationship_type_id = 8				-- Household <-> Member
      AND membership.status_id IN (1, 2, 3, 9)

    GROUP BY relationship.contact_id_b 
  ) AS sizes 
  
  WHERE NOT EXISTS (
    SELECT id FROM lalg_stats_household_sizes WHERE Sample_Date = @sample_date
  )

  GROUP BY Household_Size ;

  
-- Household distribution by Postcode Area
INSERT INTO lalg_stats_household_postcodes

SELECT 
  NULL AS id,
  @sample_date AS Sample_Date, 
  LEFT(address.postal_code, (LOCATE(' ', address.postal_code) - 1)) AS Postcode_Area,
  COUNT(contact.id) AS Sample_Count  
  
FROM lalg_stats_filtered_contact AS contact  
  INNER JOIN civicrm_membership AS membership ON contact.id = membership.contact_id  
  INNER JOIN civicrm_address AS address ON contact.id = address.contact_id
  
WHERE contact.contact_type = 'Household'
  AND address.is_primary = 1
  AND address.location_type_id = 1				-- 'Home'
  AND membership.status_id IN (1, 2, 3, 9)
  
  AND NOT EXISTS (
    SELECT id FROM lalg_stats_household_postcodes WHERE Sample_Date = @sample_date
  )
  
GROUP BY Postcode_Area ;

 
-- Membership (Household) continuous Duration distribution 
INSERT INTO lalg_stats_membership_durations

SELECT 
  NULL AS id,
  @sample_date AS Sample_Date, 
  YEAR(CURRENT_DATE()) - YEAR(membership.start_date) AS Duration, 
  COUNT(contact.id) AS Sample_Count  
  
FROM lalg_stats_filtered_contact AS contact  
  INNER JOIN civicrm_membership AS membership ON contact.id = membership.contact_id  
  
WHERE contact.contact_type = 'Household'
  AND membership.status_id IN (1, 2, 3, 9)
  
  AND NOT EXISTS (
    SELECT id FROM lalg_stats_membership_durations WHERE Sample_Date = @sample_date
  )
  
GROUP BY Duration ;


-- Active Membership (Household) Status by Membership Type
INSERT INTO lalg_stats_membership_status

SELECT 
  NULL AS id,
  @sample_date AS Sample_Date, 
  m_type.name AS Membership_Type,
  CASE m_status.id
    WHEN '1' THEN '1' 
    WHEN '2' THEN '2'
	WHEN '9' THEN '3'
	WHEN '3' THEN '4'
    WHEN '4' THEN '5'
	WHEN '5' THEN '6'
    WHEN '6' THEN '7'
  END AS Status_Weight,
  m_status.label AS Membership_Status,
  COUNT(contact.id) AS Sample_Count

FROM lalg_stats_filtered_contact AS contact 
  INNER JOIN civicrm_membership AS membership ON contact.id = membership.contact_id
  INNER JOIN civicrm_membership_type AS m_type ON membership.membership_type_id = m_type.id 
  INNER JOIN civicrm_membership_status AS m_status ON membership.status_id = m_status.id

WHERE contact.contact_type = 'Household'
  
  AND NOT EXISTS (
    SELECT id FROM lalg_stats_membership_status WHERE Sample_Date = @sample_date
  )
  
GROUP BY Membership_Type, Membership_Status ;  

