/**
 * DMF0015 BOD — Search Param types
 */
export interface SearchParamProps {
  divisionId: string;       // AS-IS clbDivision.ControlValues
  bodType: string;          // AS-IS clbBodType.ControlValues
  fromSite: string;         // AS-IS clbFromSite.ControlValues
  toSite: string;           // AS-IS clbToSite.ControlValues
  activeFlag: string;       // AS-IS clbActive.SelectedItem
}
