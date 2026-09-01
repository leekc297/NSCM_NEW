// AS-IS Designer.cs L57/L58 + .cs L729~745 — DMF0008 검색조건 + 메인 row 선택 시 전달값
export interface SearchCondition {
  fromYyyymmdd: string;
  toYyyymmdd: string;
  divisionId: string;
  senderName: string; // REPAIR 사용
  flag: string; // REPAIR 사용
  // SSPM 호출용 (메인 row 선택 시 설정)
  selectedItemId: string;
  selectedScmSiteId: string;
  // SALES_SITE 호출용 (메인 row 선택 시 설정)
  selectedSoldTo: string;
  selectedShipTo: string;
}
