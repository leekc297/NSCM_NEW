export const MENU_ID = 'SCP0028' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Forms.UIL SCP0028_Shipment_Lot_Size (단일 그리드 spdMain):
//   domain = SSP(Shipping) — 메뉴코드 접두어(SCP)와 트리 도메인(SSP)이 어긋나는 SCM0008 유형.
//   FE 배치 features/shipping/src/pages/shipment-lot-size, ROUTE_PATH shipping/shipping-master/shipment-lot-size.
//   설계 근거: .atlas/gscm-design/SCP0028/design/00_checklist.md ~ 03_grid-columns.md. 상세 매핑 __asis-mapping__.md.
//   - GET   SP : PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE       (SHT_NM='main',  IN 7 / OUT o_rc1)
//   - SAVE  SP : PKG_SCP0028.P_SCP0028_SAVE_SHIPMENT_LOT_SIZE      (SHT_NM='main', active_flag M/D 2분기, CLOB '^'-fold
//                — 'M'=UPDATE 후 미적중 시 INSERT(upsert), 'D'=DELETE. 'I' 분기 없음: body 690~751 실측)
//   - INPUT SP : PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT (SHT_NM='main' INSERT 버튼 API, 후보 조회)
//   - POPUP SP : PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP (SHT_NM='popup', 일괄입력/삭제 후보)
//   조회조건: Division(단일 필수, EE 제외)/Operation Group/From·To Site(다중)/Trans Mode(다중)/Valid/Model(팝업).
//   그리드: 18칼럼, 편집 4(LOT_SIZE/INCREMENT/VALID_YN/SPLIT_YN, 편집모드에서만), 셀콤보 3, 세로병합, auto-sync.
export enum SHEETS {
  MAIN = 'main', // spdMain (GET/SAVE, API 매핑 SHT_NM='main')
  INPUT = 'input', // 일괄입력 후보 조회(INSERT 버튼 API — P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT)
  POPUP = 'popup', // 일괄입력/삭제 팝업 후보(SHT_NM='popup' — P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP)
}

// NSCM 단일 cursor 표준 'o_rc1' — PROC_M 실측 SORT_ORD 100=o_rc1(데이터), 101=O_RESULT_CURSOR(결과).
export const RESPONSE_SET = { MAIN: 'o_rc1', INPUT: 'o_rc1', POPUP: 'o_rc1' } as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — 컬럼메타 등록명 그대로 (design 03 §0).
//   DB 실측(2026-09-26 ora.py): PROGRAM_ID='SCP0028', SHEET_NAME='Shipment Lot Size' 18행(전 'S' →
//   편집 4컬럼 05_register.sql 로 'M' 정비, design 03 §6 B1).
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Shipment Lot Size',
};

// ====================================================================================
// 조회조건 콤보 (design 02 §2·§5 — DB 실측 SQL_ID 확정, convert-core §2.6 의미 파리티)
// ====================================================================================
export const COMBO = {
  // Division = Division_SCP(권한필터). AS-IS GetDivisionWithoutEE 의 EE 제외는 CMBO WHERE 에 없어
  //   FE 클라필터(ATTRIBUTE3<>'EE')로 재현(design 02 §2 #1, SCP0006 실사고). MyDivision 재사용 금지.
  DIVISION: 'Division_SCP',
  // Operation Group / Trans Mode = LookupCommon(@lookupType). TransportMode(NAME=코드)/TransMode(BOD) 재사용 금지.
  LOOKUP_COMMON: 'LookupCommon',
  // Valid = 정적 Y/N(YesOrNo). ALL 선택 시 SP p_valid=null(.cs:357).
  VALID: 'YesOrNo',
  // From/To Site = cascade 하위(@divisionId 재조회). From=SITE_TYPE='PLANT', To=무필터(후보범위 다름 유지).
  FROM_SITE: 'FromSiteByDivision',
  TO_SITE: 'ToSiteByDivision',
} as const;

export const LOOKUP_TYPE = {
  OPERATION_GROUP: 'OPERATION_GROUP',
  TRANSPORT_MODE: 'TRANSPORT_MODE_CODE',
} as const;

// EE 제외 클라필터 대상 attribute (Division_SCP 반환 ATTRIBUTE3). design 02 §2 #1.
export const DIVISION_EE_EXCLUDE = 'EE';

// ====================================================================================
// 조회조건 라벨 (design 02 §4.5 — SCM_ADM_MSG_M 실측 LBL, 전건 등재 확인. Hook #114 의도문구 역조회 완료)
// ====================================================================================
export const LBL = {
  DIVISION: 'LBL00001', // Division
  OPERATION_GROUP: 'LBL00027', // Operation group
  VALID: 'LBL00639', // Valid
  TRANS_MODE: 'LBL00025', // Trans Mode
  FROM_SITE: 'LBL00022', // From Site
  TO_SITE: 'LBL00023', // To Site
  MODEL: 'LBL00669', // Model (txtItemId — 값은 Item ID, AS-IS 표기 Model 유지)
  ITEM: 'LBL01142', // Item (팝업 참고 라벨)
  SEARCH: 'LBL00112', // Search (표준 LBL00112)
  INPUT: 'LBL00872', // Input (일괄입력 버튼/팝업 타이틀)
  DELETE: 'LBL00108', // Delete (일괄삭제 버튼/팝업 타이틀)
  OK: 'LBL00716', // OK (팝업 확인 버튼)
  CLOSE: 'LBL00627', // Close (팝업 닫기 버튼)
} as const;

// ====================================================================================
// 메시지 (design 01 R-msg / 03 §4.3). Hook #114: AS-IS MSG 번호 그대로 이식 금지 — TO-BE
//   SCM_ADM_MSG_M 실측(2026-09-26)으로 의도문구 역조회해 매핑. AS-IS 번호가 TO-BE 에서 다른
//   의도(MSG00004='No changes', MSG00284='grid not ready')거나 미등재(MSG00099/MSG00084)인 건
//   등가 재매핑 또는 영문 fallback(미등재 키는 fallback 이 항상 노출 — 잘못된 기존 코드 재사용 금지).
// ====================================================================================
export const MSG = {
  SAVE_SUCCESS: 'MSG00002', // Saved successfully. (실측 — AS-IS MSG00004 는 TO-BE 'No changes'라 재매핑)
  NO_CHANGE: 'MSG00133', // No modifications have been made. (실측 — modiCnt==0, design R-msg MSG00133)
  SAVE_FAIL: 'MSG00006', // Failed to save. (실측)
  DELETE_SUCCESS: 'MSG00031', // Deleted successfully. (실측 — Delete 팝업 SAVE active_flag='D')
  DELETE_FAIL: 'MSG00618', // An error occurred while saving. (실측 — AS-IS MSG00284 는 TO-BE 'grid not ready'라 재매핑)
  // LOT_SIZE < INCREMENT 차단 — TO-BE SCM_ADM_MSG_M 미등재(실측 0건). 영문 fallback 노출(미등재 키 → 항상 fallback).
  INC_GT_LOT: 'MSG00099',
  // LOT_SIZE==0 또는 INCREMENT==0 차단 — 실측 MSG00699('Please enter an integer greater than 0.') 의도 일치.
  ZERO_VALUE: 'MSG00699',
  // {0} value is required. — 필수 조회조건 공통. 본화면 Division(design R9) + Input/Delete 팝업 From Site
  //   (AS-IS SCM0002 팝업 cs:264 MSG00002 "{0} 값은 필수 입력입니다"의 TO-BE 등가. TO-BE MSG00002 는
  //   'Saved successfully.'라 번호 그대로 이식하면 오문구 — hook #114 재매핑).
  REQUIRE_VALUE: 'MSG00429',
  // Input/Delete 팝업 OK(AS-IS SCM0002 팝업 SaveData cs:319~364) 3종. AS-IS 번호 그대로 쓰면 오문구라
  //   TO-BE SCM_ADM_MSG_M 실측(2026-09-30)으로 의도문구 역조회해 재매핑했다(hook #114).
  POPUP_SEARCH_FIRST: 'MSG01091', // 조회 후 추가하십시오. / Check before adding. (AS-IS MSG00059 동일문구)
  POPUP_NO_ROW: 'MSG00014', // 행이 선택되지 않았습니다. / No row selected. (AS-IS MSG00071 '선택된 행이 없습니다')
  // 삭제 하시겠습니까? / Do you want to delete it? (AS-IS MSG00016 동일문구 —
  //   TO-BE MSG00016 은 'requested page could not be found' 라 번호 직이식 금지)
  POPUP_DELETE_CONFIRM: 'MSG00683',
  // 조회된 데이터가 없습니다. / No data have been retrieved. — 일괄입력 후보(GET_INPUT) 0건.
  //   0건이면 그리드가 조용히 비어 원인 불명 상태가 되므로 명시 안내한다(무음 실패 금지).
  NO_CANDIDATE: 'MSG00719',
} as const;

// ====================================================================================
// 그리드 편집/병합/파생 규칙 (design 03)
// ====================================================================================

// 편집 가능 화이트리스트 — 편집모드(isEditMode)에서만 편집. 그 외 전 컬럼(식별/표시/audit/OPERATION_GROUP_ID) 잠금.
//   design 03 §1·§3 (LockColumn 234/235 상수배열 이식 금지 → 화이트리스트 + INPUT_TP_CD 파리티, hook #130).
export const EDITABLE_COLUMNS = ['LOT_SIZE', 'INCREMENT', 'VALID_YN', 'SPLIT_YN'] as const;

// 세로 병합 대상 — Division/Operation/Site/Item 반복값(design 03 §3-9·15). CustomMergeManager 좌측 누적 키라
//   컬럼 순서(1 DIVISION_ID > 2 OPERATION_GROUP_ID > 3 FROM_SITE_DESC > 4 TO_SITE_DESC > 5 ITEM_ID > 6 NICK_NAME)
//   계층으로 병합된다. 신규행('I')은 자동 제외(CustomMergeManager 기본 가드).
export const MERGE_COLUMNS = [
  'DIVISION_ID',
  'OPERATION_GROUP_ID',
  'FROM_SITE_DESCRIPTION',
  'TO_SITE_DESCRIPTION',
  'ITEM_ID',
  'NICK_NAME',
] as const;

// 정수 셀(소수 0자리, 우측정렬) — AS-IS SetReNumerCellType(...,0) (design 03 §3-1·2). 0 이상 정수.
export const NUMBER_COLUMNS = ['LOT_SIZE', 'INCREMENT'] as const;

// 저장 키(hidden) — 저장 payload 원천(design 03 §1 #16~18 / §4.3).
export const SAVE_KEY_COLUMNS = {
  FROM_SITE: 'FROM_SITE',
  TO_SITE: 'TO_SITE',
  TRANS_MODE_CODE: 'TRANS_MODE_CODE',
} as const;

// 저장 시 '기본값 회귀' 판정 — M행이 (LOT='' & INC='' & VALID='Y' & SPLIT='N')면 변경취소로 CRUD 해제
//   (design 03 §3-13, cs:594). EditTracker CRUD_TYPE 해제 대상.
export const DEFAULT_REVERT = { VALID_YN: 'Y', SPLIT_YN: 'N' } as const;

// ====================================================================================
// 컬럼 메타 fallback (design 03 §1 — 18칼럼). admin(SCM_MST_SHEET_COLUMNS) 등록본이 있으면 authoritative,
//   없으면(미등록/fetch 실패) 이 fallback. DB 실측(2026-09-26): SHEET_NAME='Shipment Lot Size' 18행
//   (표시 15 + hidden 3), 셀콤보 3(OPERATION_GROUP_ID→LookupCommon / VALID_YN·SPLIT_YN→YesOrNo).
// ====================================================================================
export interface LotSizeColumnMeta {
  key: string;
  header: string;
  width?: number;
  align?: 'L' | 'C' | 'R';
  scale?: number;
  visible?: boolean;
  _ctrlType?: 'FPComboBox' | 'FPNumber' | 'FPDateTime';
  _comboKey?: string;
}

export const LOT_SIZE_COLUMNS: LotSizeColumnMeta[] = [
  { key: 'DIVISION_ID', header: 'Division', width: 100, align: 'C' },
  { key: 'OPERATION_GROUP_ID', header: 'Operation Group', width: 130, align: 'L', _ctrlType: 'FPComboBox', _comboKey: 'LookupCommon' },
  { key: 'FROM_SITE_DESCRIPTION', header: 'From Site', width: 150, align: 'L' },
  { key: 'TO_SITE_DESCRIPTION', header: 'To Site', width: 150, align: 'L' },
  { key: 'ITEM_ID', header: 'Model', width: 130, align: 'L' },
  { key: 'NICK_NAME', header: 'Nick Name', width: 130, align: 'L' },
  { key: 'TRANS_MODE_NAME', header: 'Trans Mode', width: 100, align: 'C' },
  { key: 'LOT_SIZE', header: 'Lot Size*', width: 90, align: 'R', scale: 0, _ctrlType: 'FPNumber' },
  { key: 'INCREMENT', header: 'Increment*', width: 90, align: 'R', scale: 0, _ctrlType: 'FPNumber' },
  { key: 'VALID_YN', header: 'Valid*', width: 70, align: 'C', _ctrlType: 'FPComboBox', _comboKey: 'YesOrNo' },
  { key: 'SPLIT_YN', header: 'Container Split*', width: 110, align: 'C', _ctrlType: 'FPComboBox', _comboKey: 'YesOrNo' },
  { key: 'CREATED_BY', header: 'Created By', width: 100, align: 'L' },
  { key: 'CREATION_DATE', header: 'Creation Date', width: 130, align: 'L', _ctrlType: 'FPDateTime' },
  { key: 'LAST_UPDATED_BY', header: 'Last Updated By', width: 110, align: 'L' },
  { key: 'LAST_UPDATE_DATE', header: 'Last Update Date', width: 130, align: 'L', _ctrlType: 'FPDateTime' },
  { key: 'FROM_SITE', header: 'From Site', width: 80, align: 'C', visible: false },
  { key: 'TO_SITE', header: 'To Site', width: 80, align: 'C', visible: false },
  { key: 'TRANS_MODE_CODE', header: 'Trans Mode', width: 80, align: 'C', visible: false },
];
