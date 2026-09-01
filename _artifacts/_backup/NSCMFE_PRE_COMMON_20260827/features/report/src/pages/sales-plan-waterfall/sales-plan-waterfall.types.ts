import type { DateRangePickerValueType } from '@shared/lges';

export interface SearchParams {
  divisionId: string;
  team: string;
  endCustomer: string;
  salesSite: string;
  versionType: string;
  period: DateRangePickerValueType;
  bucket: string;
  isSumChecked: boolean;
  isColorChecked: boolean;
  isCellQtyChecked: boolean;
  krw: string;
  usd: string;
  loc: string;
  qty: string;
  projectCode: string;
  itemType: string;
  bizType: string;
  isInternalChecked: boolean;
  plantSiteId: string;
  owner: string;
  itemId: string;
}
