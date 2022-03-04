<?php
use CRM_LalgStatistics_ExtensionUtil as E;

/**
 * LalgStatistics.Getsamples API specification (optional)
 * This is used for documentation and validation.
 *
 * @param array $spec description of fields supported by this API call
 *
 * @see https://docs.civicrm.org/dev/en/latest/framework/api-architecture/
 */
// function _civicrm_api3_lalg_statistics_Getsamples_spec(&$spec) {
  // $spec['api.required'] = 1;
// }

/**
 * LalgStatistics.Getsamples API
 *
 * @param array $params
 *   There are no parameters
 * @return array
 *   API result descriptor
 *
 * @see civicrm_api3_create_success
 *
 * @throws API_Exception
 */
function civicrm_api3_lalg_statistics_Getsamples($params) {
	$message = ['Completed normally.'];
	$collectorsDir = CRM_Core_Config::singleton()->extensionsDir . 'lalg-statistics/sql/collectors/';
    foreach (scandir($collectorsDir) as $file) {
        if ($file !== '.' && $file !== '..') {
			$message[] = $collectorsDir . $file;
			CRM_Utils_File::sourceSQLFile(
			  CIVICRM_DSN,
			  $collectorsDir . $file
			);
		}
    }
	return civicrm_api3_create_success($message, $params, 'LalgStatistics', 'Getsamples');
}
