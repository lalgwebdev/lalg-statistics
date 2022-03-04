/* Counts of Activity during a (monthly) period. */

-- Get period to sample
SET @months_ago = 1 ;						-- Default to previous month

SET @firstDay = DATE_FORMAT(CURDATE() - INTERVAL @months_ago MONTH,'%Y-%m-01');
SET @lastDay = LAST_DAY(@firstDay);

-- Membership Actions in Month by Membership Type
  INSERT INTO lalg_stats_membership_actions 

  SELECT 
    NULL AS id,
    @lastDay AS Sample_Date, 
    m_type.name AS Membership_Type,
    CASE m_log.status_id
      WHEN '1' THEN 'New Join' 
      WHEN '2' THEN CASE WHEN m_log.start_date = m_log.modified_date THEN 'Re-Join' ELSE 'Renewal' END
      WHEN '4' THEN 'Lapsed'
	  WHEN '6' THEN 'Cancelled'
    END AS Membership_Action,
    COUNT(m_log.id) AS Sample_Count

  FROM civicrm_membership_log AS m_log 
    INNER JOIN civicrm_membership AS membership ON membership.id = m_log.membership_id
    INNER JOIN civicrm_membership_type AS m_type ON m_type.id = membership.membership_type_id
    INNER JOIN civicrm_membership_status AS status ON status.id = m_log.status_id
    INNER JOIN civicrm_contact AS contact ON contact.id = membership.contact_id

  WHERE m_log.modified_date >= @firstDay
    AND m_log.modified_date <= @lastDay
    AND contact.contact_type = 'Household'
	AND contact.display_name NOT LIKE '%watir%'
    AND m_log.status_id IN ('1', '2', '4', '6')
	
	AND NOT EXISTS (
	  SELECT id FROM lalg_stats_membership_actions WHERE Sample_Date = @lastDay
	)
	AND contact.is_deleted = 0

  GROUP BY Membership_Type, Membership_Action ;


-- Payments in Month by Payment Type, Account and Source
  INSERT INTO lalg_stats_payments
  
  SELECT 
    NULL AS id,
    @lastDay AS Sample_Date, 
    p_type.name AS Payment_Type,
	CASE 
	  WHEN LEFT(contribution.source, 4) = 'User' THEN 'Online'
	  ELSE 'Offline'
	END AS Payment_Source,
	p_account.name AS Revenue_Account,
	COUNT(contribution.id) AS Sample_Count

  FROM civicrm_contribution AS contribution
    INNER JOIN civicrm_payment_processor AS p_type ON p_type.id = contribution.payment_instrument_id
    INNER JOIN civicrm_financial_type AS p_account ON p_account.id = contribution.financial_type_id
    INNER JOIN civicrm_contact AS contact ON contact.id = contribution.contact_id
	
  WHERE DATE(contribution.receive_date) >= @firstDay
    AND DATE(contribution.receive_date) <= @lastDay
	AND contact.display_name NOT LIKE '%watir%'
	
	AND NOT EXISTS (
	  SELECT id FROM lalg_stats_payments WHERE Sample_Date = @lastDay
	)

  GROUP BY p_type.name, Payment_Source, Revenue_Account ;


-- Payment Value in Month by Payment Account 
  INSERT INTO lalg_stats_revenue
  
  SELECT 
    NULL AS id,
    @lastDay AS Sample_Date, 
 	p_account.name AS Revenue_Account,
	SUM(contribution.total_amount) AS Total_Value,
	SUM(contribution.net_amount) AS Net_Value

  FROM civicrm_contribution AS contribution
    INNER JOIN civicrm_financial_type AS p_account ON p_account.id = contribution.financial_type_id
    INNER JOIN civicrm_contact AS contact ON contact.id = contribution.contact_id
	
  WHERE DATE(contribution.receive_date) >= @firstDay
    AND DATE(contribution.receive_date) <= @lastDay
	AND contact.display_name NOT LIKE '%watir%'
	
	AND NOT EXISTS (
	  SELECT id FROM lalg_stats_revenue WHERE Sample_Date = @lastDay
	)

  GROUP BY Revenue_Account ;
