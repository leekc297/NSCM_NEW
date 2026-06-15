export const MENU_ID = 'DMF0072' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0072_NNMasterMapping.cs / .Designer.cs:
//   - Main(L477):  DMF0072_GET_NNMASTER_MAPPING (7 IN + cursor)
//   - DataType(L200): GetLookupValues("DM_EDI_DATA_TYPE_CODE")
//   - Division(L154): Data.Common(Data.Type.MyDivision) — DMF0008_GET_MY_DIVISION_LIST 재사용
//   - Team(L159):     SetChangeControl("UserTeamByDivision", sDivision)
//   - EndCustomer(L165~178): div=40 → EndCustomerByDivision40 / 그 외 → EndCustomerByDivision
//   - SalesSite(L186): SetChangeControl("UserSiteByEndCustomer", divisions, endCustomer)
export enum SHEETS {
  MAIN = 'main',
  DATA_TYPE = 'dataType',
  DIVISION = 'division',
  TEAM = 'team',
  END_CUSTOMER = 'endCustomer',
  SALES_SITE = 'salesSite',
}

// const object — enum 대체 (NSCM 단일 cursor 표준 'o_rc1' 다수 중복 허용)
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  DATA_TYPE: 'o_rc1',
  DIVISION: 'o_rc1',
  TEAM: 'o_rc1',
  END_CUSTOMER: 'o_rc1',
  SALES_SITE: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// AS-IS .cs 의 main grid column 정의 (23 컬럼)
// merge=true: 사용자 요구 2026-06-02 — Data Type ~ MDM Code (ITEM_ID) 15개 컬럼 세로 머지 (As-Is .cs L515 `siMain.SmartColMerge()` 대응)
// As-Is DefColumnsLabel.ITEM_ID = "MDM_CODE" — Item ID 컬럼이 MDM Code 라벨로 표시되는 컬럼
//
// Column 메타 표준 (룰 12 §11.7 + hook grid-column-meta-mandatory.md, 2026-06-02 적용):
//   _ctrlType    : FPText/FPModal/FPComboBox/FPCheckBox/FPDate/FPDateTime — DMF0004 표준
//   _inputEditType: S (read-only) / M (필수) / O (선택) / IM (신규 필수) / IO (신규 선택)
//   _modalKey    : popup cell 의 modal 식별자 — dblClick handler 의 switch case 키
//
// AS-IS .cs InsertRow (L538~602) + EditButton (L281~310) + 필수 Validation (L789~875) 매핑:
//   - DATA_TYPE_CODE: InsertRow 'SCM' fixed + LockRange (수정 불가) → S (사실상)
//   - DIVISION_ID: search div 자동 set + EditButton 영역 lock → S
//   - COMPANY_ID: InsertRow SetCellTypeCombo (DM_EDI_COMPANY_LIST) + Edit 시 lock → IM (신규만)
//   - END_CUSTOMER: InsertRow SetCellTypeCombo + Edit 시 lock + 필수(L793) → IM
//   - UNLOADING_POINT/CUSTOMER_PLANT/CUSTOMER_ITEM_ID: Edit 시 lock, 신규 자유 입력 → IO
//   - SOLDTO_CODE/SHIPTO_CODE: InsertRow cellTypeImage (popup) + Edit 시 lock + 필수(I 시) → IM + FPModal
//   - SCM_SITE_ID: InsertRow SetCellTypeCombo + 필수(I 시) → IM + FPComboBox
//   - PROJECT_CODE: InsertRow cellTypeImage (popup, div!=40) + 필수(I 시) → IM + FPModal
//   - FCST_TYPE/INCOTERMS/DOM_EXP: 필수(I 시, L852~868) → IM + FPComboBox
//   - ITEM_ID (MDM Code): InsertRow cellTypeImage (popup) + 필수(I 시) → IM + FPModal
//   - MAPPING_ITEM_ID: cellTypeImage (popup, 신규+수정 모두) → M + FPModal
//   - MAPPING_ITEM_ID_ORIGINAL: 항상 LockColumn (L296) → S
//   - VALID_START_DATE/VALID_END_DATE: 신규+수정 가능 + 필수(L692) → M + FPDate
//   - ACTIVE_YN: 신규 'Y' default + 신규+수정 가능 + 필수(L878) → M + FPCheckBox
//   - LAST_UPDATE_DATE: LockRange(true) (L590) → S + FPDateTime
//   - LAST_UPDATED_BY: LockRange(true) (L589) → S + FPText
//   - DC_LEVEL: 신규+수정 가능 → M
export interface NnColumnMeta {
  key: string;
  header: string;
  width?: number;
  merge?: boolean;
  _ctrlType?: 'FPText' | 'FPModal' | 'FPComboBox' | 'FPCheckBox' | 'FPDate' | 'FPDateTime' | 'FPNumberText';
  _inputEditType?: 'S' | 'O' | 'M' | 'IO' | 'IM';
  _modalKey?: 'customerByDivisionModal' | 'projectByDivisionModal' | 'itemByDivisionModal';
}

export const MAIN_COLUMNS: ReadonlyArray<NnColumnMeta> = [
  { key: 'DATA_TYPE_CODE', header: 'Data Type', width: 100, merge: true, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'DIVISION_ID', header: 'Division', width: 80, merge: true, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'COMPANY_ID', header: 'Company', width: 90, merge: true, _ctrlType: 'FPComboBox', _inputEditType: 'IM' },
  { key: 'END_CUSTOMER', header: 'End Customer', width: 130, merge: true, _ctrlType: 'FPComboBox', _inputEditType: 'IM' },
  { key: 'UNLOADING_POINT', header: 'Unloading Point', width: 130, merge: true, _ctrlType: 'FPText', _inputEditType: 'IO' },
  { key: 'CUSTOMER_PLANT', header: 'Customer Plant', width: 130, merge: true, _ctrlType: 'FPText', _inputEditType: 'IO' },
  { key: 'SOLDTO_CODE', header: 'SoldTo', width: 110, merge: true, _ctrlType: 'FPModal', _inputEditType: 'IM', _modalKey: 'customerByDivisionModal' },
  { key: 'SHIPTO_CODE', header: 'ShipTo', width: 110, merge: true, _ctrlType: 'FPModal', _inputEditType: 'IM', _modalKey: 'customerByDivisionModal' },
  { key: 'SCM_SITE_ID', header: 'SCM Site', width: 160, merge: true, _ctrlType: 'FPComboBox', _inputEditType: 'IM' },
  { key: 'PROJECT_CODE', header: 'Project', width: 110, merge: true, _ctrlType: 'FPModal', _inputEditType: 'IM', _modalKey: 'projectByDivisionModal' },
  { key: 'FCST_TYPE', header: 'FCST Type', width: 90, merge: true, _ctrlType: 'FPComboBox', _inputEditType: 'IM' },
  { key: 'INCOTERMS', header: 'Incoterms', width: 90, merge: true, _ctrlType: 'FPComboBox', _inputEditType: 'IM' },
  { key: 'DOM_EXP', header: 'Dom/Exp', width: 80, merge: true, _ctrlType: 'FPComboBox', _inputEditType: 'IM' },
  { key: 'CUSTOMER_ITEM_ID', header: 'Customer Item', width: 140, merge: true, _ctrlType: 'FPText', _inputEditType: 'IO' },
  { key: 'ITEM_ID', header: 'MDM Code', width: 140, merge: true, _ctrlType: 'FPModal', _inputEditType: 'IM', _modalKey: 'itemByDivisionModal' },
  { key: 'MAPPING_ITEM_ID', header: 'Mapping Item', width: 140, _ctrlType: 'FPModal', _inputEditType: 'M', _modalKey: 'itemByDivisionModal' },
  { key: 'MAPPING_ITEM_ID_ORIGINAL', header: 'Mapping Item (Org)', width: 160, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'VALID_START_DATE', header: 'Valid Start', width: 110, _ctrlType: 'FPDate', _inputEditType: 'M' },
  { key: 'VALID_END_DATE', header: 'Valid End', width: 110, _ctrlType: 'FPDate', _inputEditType: 'M' },
  { key: 'ACTIVE_YN', header: 'Active', width: 70, _ctrlType: 'FPCheckBox', _inputEditType: 'M' },
  { key: 'LAST_UPDATE_DATE', header: 'Last Update', width: 140, _ctrlType: 'FPDateTime', _inputEditType: 'S' },
  { key: 'LAST_UPDATED_BY', header: 'Updated By', width: 110, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'DC_LEVEL', header: 'DC Level', width: 90, _ctrlType: 'FPText', _inputEditType: 'M' },
];

// 빈 SP 결과 대응 fallback (lookup SP 호출 실패 시)
export const FALLBACK_ALL: ReadonlyArray<{ value: string; label: string }> = [
  { value: 'ALL', label: 'ALL' },
];
