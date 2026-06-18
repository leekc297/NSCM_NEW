/**
 * DMF0008 ERP EDI Master — Search Param types
 */
export interface SearchParamProps {
  divisionId: string;
  teamId: string;
  endCustomer: string;
  salesSite: string;
  soldToCode: string;
  shipToCode: string;
  activeFlag: string;
  periodFrom: string; // YYYYMMDD
  periodTo: string; // YYYYMMDD
}
