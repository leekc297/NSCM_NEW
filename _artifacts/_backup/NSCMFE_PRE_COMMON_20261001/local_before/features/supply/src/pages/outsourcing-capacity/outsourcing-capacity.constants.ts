export const MENU_ID = 'SCP0023' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Master.UIL SCP0023_OutsourcingCapacity (단일 그리드 spdMain "Outsourcing Capacity"):
//   설계 근거: .atlas/gscm-design/SCP0023/design/00_checklist.md ~ 03_grid-columns.md + 07_human-doc-supplement.md
//   - GET SP : SCP.SCP0023_GET_OUTSOURCING_CAPA (조회) — TO-BE PKG_SCP0023 미배포(convert-sp 후속)
//   - SAVE SP: SCP.SCP0023_SAVE_OUTSOURCING_CAPA (저장, action I/M/D 다행 UPSERT)
//   - 조회조건: cboDivision(EE 제외) -> clbPlantSite(다중, OSP cascade), Model(팝업)/Nick Name(LIKE)
//   - 편집셀 = daily_capa_qty 만(정수, 최소 1). Insert/Delete = AS-IS NO-OP.
export enum SHEETS {
  MAIN = 'main', // spdMain 단일 시트 (SCM_MST_SHEET_COLUMNS SHEET_NAME='Outsourcing Capacity', 13컬럼)
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 상수 그대로 (design 03 §1).
//   라우팅 SHEETS value('main') 와 분리. 컬럼 메타 DB 등록 확인: PROGRAM_ID='SCP0023' 13행 실측(design 03 §0).
export const ADMIN_SHEET_NAME: Record<SHEETS, string> = {
  [SHEETS.MAIN]: 'Outsourcing Capacity',
};

// Daily Capacity 하한 (design 03 §3 #6 / 07 §1.5 — 정수, 음수 불가, 최소 1, MSG00085).
export const DAILY_CAPA_MIN = 1;

// 조회조건 콤보 ID (design 02 §5 — DB 실측 SCM_ADM_CMBO_SQL_M 등록 확정).
export const COMBO = {
  // Division_SCP = 권한 division(@sesUserId·@mnuId), ATTRIBUTE3 반환 → FE 에서 전극(EE) 제외 재현.
  //   AS-IS BLUtils.GetDivisionWithoutEE = 공통 division + 클라 필터 ATTRIBUTE3<>'EE' (design 02 §2.1).
  DIVISION: 'Division_SCP',
  // PlantByDivisionOperOsp_SCP = OSP_YN='Y' 외주 플랜트, @divisionId cascade(@operationGroup=null).
  //   AS-IS SCM0001_GET_PLANT_SITE_BY_DIVISION_OSP 와 등가 (design 02 §2.2, 의미 패리티 convert-core §2.6).
  PLANT_SITE: 'PlantByDivisionOperOsp_SCP',
} as const;

// 전극(Electrode) 제외 필터값 — Division 콤보 ATTRIBUTE3<>'EE' (design 02 §2.1, AGENT.md §3 화면 재구현).
export const DIVISION_EXCLUDE_ATTRIBUTE3 = 'EE';

// item_id '-' 집계행의 표시 라벨 — GET SP 가 '-'→'Total' 로 변환해 반환(design 03 §4.1). Plant별 Total 행.
export const TOTAL_ITEM_LABEL = 'Total';

// AS-IS Validation MSG -> TO-BE SCM_ADM_MSG_M 실측 역매핑 (2026-09-22 ora.py 실측).
//   AS-IS MSG 번호와 TO-BE 번호 체계가 달라 재매핑함(자매 SCP0020 검증 매핑 재사용).
//   'TO-BE 미등록' = 등가 메시지가 없어 영문 defaultValue 로 표시(엉뚱한 한글 매핑 회피, hook #114).
export const MSG = {
  REQUIRED_FIELD: 'MSG00429', // {0} value is required. (AS-IS checkRequiredOfSearch Division*)
  CONFIRM_SAVE: 'MSG00617', // Would you like to save row {0}? (AS-IS MSG00012 저장확인)
  SAVE_SUCCESS: 'MSG00002', // Saved successfully. (AS-IS MSG00020)
  NO_CHANGE: 'MSG00004', // No changes to save.
  DAILY_CAPA_MIN: 'MSG00085', // Only values greater than or equal to {0} are allowed. (AS-IS MSG00085 하한)
  PLANT_TOTAL_REQUIRED: 'MSG00258', // Plant's Total is not entered.({0}) — TO-BE 등록완료(2026-09-22, AS-IS TB_FX_MessageInfo 복사). design 03 §4.2
} as const;
