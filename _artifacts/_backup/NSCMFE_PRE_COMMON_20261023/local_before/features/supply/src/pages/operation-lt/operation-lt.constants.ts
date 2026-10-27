export const MENU_ID = 'SCP0037' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Master.UIL SCP0037_OperationLT (단일 그리드 마스터 CRUD, pivot 없음):
//   설계 근거: .atlas/gscm-design/SCP0037/design/00_checklist.md ~ 03_grid-columns.md
//   - GET SP : SCP.SCP0037_GET_OPERATION_LT (5 param, 14컬럼 + 검증커서) — TO-BE PKG_SCP0037 미배포(convert-sp 후속)
//   - SAVE SP: SCP.SCP0037_SAVE_OPERATION_LT (10 param, MERGE + Project Route 검증)
//   - 조회조건 cascade: (Division ∪ LT Operation) -> clbPlantSite(다중) 재구성 (design 02 §3)
//   - INV_FLAG 조건부 컬럼 Visible(LT Operation=PRE_INSP) / 신규행 SCM_SITE_ID 셀콤보 행상태 종속 좁힘 (design 03)
export enum SHEETS {
  MAIN = 'main', // spdMain 단일 시트 (siMain, 13컬럼)
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = { MAIN: 'o_rc1' } as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 상수 그대로 (design 03 §0).
//   실측: PROGRAM_ID='SCP0037' 13컬럼, SHEET_NAME='Operation LT'. 라우팅 SHEETS value 와 분리.
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Operation LT',
};

// ====================================================================================
// 조회조건/셀 콤보 SQL_ID (design 02 §2 / 03 §1 — 전건 DB 실측 USE_YN='Y' 확인 2026-09-22)
// ====================================================================================
export const COMBO = {
  // Division_SCP = UP_FX_GetCommonDataList_SCP @Code='Division' (권한필터). 화면에서 ATTRIBUTE3<>'EE'
  //   (전극 제외) 클라 필터 재현 — GetDivisionWithoutEE (design 02 §2-1, combo-semantic-parity).
  DIVISION: 'Division_SCP',
  // PlantByDivisionOperNonOsp1_SCP_ALL = OSP_YN='N' 전체 (param 없음). 반환 CODE/NAME/OSP_YN/OPERATION_GROUP/DIVISION_ID.
  PLANT_NONOSP: 'PlantByDivisionOperNonOsp1_SCP_ALL',
  // PlantByDivisionOperOsp21_SCP_ALL = OSP_YN='Y' 전체 (@divisionId/@operationGroup 미전달 시 IS NULL -> 전체).
  PLANT_OSP: 'PlantByDivisionOperOsp21_SCP_ALL',
  // YesOrNo = 정적 Y/N (Site Item Valid 조회조건 + INV_FLAG/SITE_ITEM_VALID_YN 셀콤보).
  VALID: 'YesOrNo',
} as const;

// LT Operation lookup (design 02 §2-2 — OPERATION_LT, VALID_YN='Y' 노출 4건).
export const LT_OPERATION_LOOKUP = 'OPERATION_LT';

// LT Operation 코드 — cascade OPERATION_GROUP 분기 키 (design 02 §3 / 03 §3-2).
export const LT_OP = {
  SLITTING: 'SLITTING',
  PRE_INSP: 'PRE_INSP',
  OSP_LT: 'OSP_LT',
  CTP_LT: 'CTP_LT',
} as const;

// Site Item Valid = ALL / Y / N, 기본 ALL (ALL -> SP p_scm_valid_yn = NULL, design 02 §2-5).
export const VALID_ALL = 'ALL';

// AS-IS Validation MSG (design 00 §2b / 01 §2 R8/R9 / 03 §3-4).
//   AS-IS 번호 그대로 쓰지 않는다 — 문구 기준 SCM_ADM_MSG_M 역조회 TO-BE 코드 (hook #114).
//   실측(2026-09-22 SCM_ADM_MSG_M LANG_CD EN): 아래 매핑 전건 DB 확인.
export const MSG = {
  SAVE_SUCCESS: 'MSG00672', // "{0} data saved." (AS-IS MSG00004 "{0}개 저장" 등가 — 저장 건수)
  SAVE_FAIL: 'MSG00006', // "Failed to save." (AS-IS MSG00006 등가 — 일반 저장 실패)
  DUPLICATE: 'MSG01092', // "The same {0} exists." (AS-IS MSG00060 "동일한 {0}이(가) 존재합니다" 등가 — 4키 중복)
  REQUIRED_SELECT: 'MSG01122', // "Select {0}." (AS-IS MSG00093 "{0}을(를) 선택하십시오" 등가)
  NO_CHANGE: 'MSG00004', // "No changes to save." (저장 대상 0건)
  INSERT_GUIDE: 'MSG00662', // "Edit mode is available after search." (신규행 추가 사전조건 안내)
  LT_DAY_POSITIVE_INT: 'MSG00699', // "Enter an integer greater than 0." (LT(Day) 0 보다 큰 정수 거부, 형제 FormationGrid 와 동일)
} as const;

// 다국어 LABEL (design 02 §4.5 — 전건 SCM_ADM_MSG_M 존재, 신규 등록 0).
export const LBL = {
  LT_OPERATION: 'LBL00009',
  DIVISION: 'LBL00001',
  PLANT_SITE: 'LBL00005',
  MATERIAL: 'LBL00021',
  SITE_ITEM_VALID: 'LBL00007',
  SEARCH: 'LBL00112',
} as const;

// 컬럼 메타 fallback (admin SCM_MST_SHEET_COLUMNS 미등록 시). 실측 등록본과 동일 13컬럼 (design 03 §1).
//   운영은 admin 동적 fetch(staticColumns)가 authoritative — 이 상수는 fallback 전용(하드코딩 아님).
export interface ColumnMeta {
  key: string;
  header: string;
  width?: number;
  align?: 'L' | 'C' | 'R';
  _ctrlType?: 'FPText' | 'FPComboBox' | 'FPNumber' | 'FPDateTime';
  _comboKey?: string;
}

export const MAIN_COLUMNS: ColumnMeta[] = [
  { key: 'DIVISION_ID', header: 'Division*', width: 150, align: 'C', _ctrlType: 'FPText' },
  { key: 'PLANT_SITE_ID', header: 'Plant Site Code', width: 100, align: 'C', _ctrlType: 'FPText' },
  { key: 'SCM_SITE_ID', header: 'Plant Site*', width: 220, align: 'L', _ctrlType: 'FPComboBox', _comboKey: 'PlantByDivisionOperation' },
  { key: 'ITEM_ID', header: 'Material*', width: 115, align: 'L', _ctrlType: 'FPText' },
  { key: 'NICK_NAME', header: 'Nick Name', width: 80, align: 'L', _ctrlType: 'FPText' },
  { key: 'LT_OPERATION', header: 'LT Operation', width: 115, align: 'L', _ctrlType: 'FPComboBox', _comboKey: 'LookupCommon' },
  { key: 'LT_DAY', header: 'LT(Day)*', width: 100, align: 'R', _ctrlType: 'FPNumber' },
  { key: 'INV_FLAG', header: 'Inv Flag', width: 80, align: 'C', _ctrlType: 'FPComboBox', _comboKey: 'YesOrNo' },
  { key: 'SITE_ITEM_VALID_YN', header: 'Site Item Valid', width: 100, align: 'C', _ctrlType: 'FPComboBox', _comboKey: 'YesOrNo' },
  { key: 'CREATED_BY', header: 'Created By', width: 90, align: 'L', _ctrlType: 'FPText' },
  { key: 'CREATION_DATE', header: 'Creation Date', width: 150, align: 'C', _ctrlType: 'FPDateTime' },
  { key: 'LAST_UPDATED_BY', header: 'Last Updated By', width: 90, align: 'L', _ctrlType: 'FPText' },
  { key: 'LAST_UPDATE_DATE', header: 'Last Update Date', width: 150, align: 'C', _ctrlType: 'FPDateTime' },
];

// 신규행 편집 허용 컬럼 (design 03 §3-1 — 신규행: SCM_SITE_ID/ITEM_ID/LT_DAY/INV_FLAG).
export const NEW_ROW_EDITABLE = ['SCM_SITE_ID', 'ITEM_ID', 'LT_DAY', 'INV_FLAG'] as const;
// 기존행 편집 허용 컬럼 (design 03 §3-1 — 기존행: LT_DAY/INV_FLAG(PRE_INSP)).
export const EXISTING_ROW_EDITABLE = ['LT_DAY', 'INV_FLAG'] as const;

// 저장 필수 컬럼 (design 03 §5-8 — 라벨 '*' : SCM_SITE_ID/ITEM_ID/LT_OPERATION/LT_DAY).
export const REQUIRED_COLUMNS = ['SCM_SITE_ID', 'ITEM_ID', 'LT_OPERATION', 'LT_DAY'] as const;
// 4키 중복검증 (design 01 §2 R9 / 03 §3-4 — DIVISION+SCM_SITE+ITEM+LT_OPERATION).
export const DUP_KEY_COLUMNS = ['DIVISION_ID', 'SCM_SITE_ID', 'ITEM_ID', 'LT_OPERATION'] as const;
