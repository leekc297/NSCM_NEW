// AS-IS GSCM.SCP.Forms.UIL Master/SCP0041_StockOSP (Stock OSP / Pack Hold Stock):
//   설계 근거: .atlas/gscm-design/SCP0041/design/00_checklist.md ~ 03_grid-columns.md · convert-flow/{goal,plan}.md
//   - 2 시트: Osp Stock(shtMain, 조회 전용 14컬럼) / Pack Hold Stock(shtPacker, 15컬럼 HOLD행 조건부 편집)
//   - GET  SP(Osp)  : PKG_SCP0041.P_SCP0041_GET_STOCK_OSP       (IN 5)  — 배포 VALID
//   - GET  SP(Pack) : PKG_SCP0041.P_SCP0041_GET_PACK_HOLD_STOCK (IN 9)  — 배포 VALID
//   - SAVE SP(Pack) : PKG_SCP0041.P_SCP0041_SAVE_PACKER_HOLD_STOCK (IN 10, '^' bulk CLOB, action='M' 만) — 배포 VALID
//   - NSCM 표준: 그리드 상시 편집(Edit 토글 미이식, convert-core §2.1(11)) — 셀 편집가부는 메타 INPUT_TP_CD,
//     행 단위 편집은 Pack 시트 DIR='HOLD' 행만(design 03 §3 R2). Osp 시트는 순수 조회 뷰(저장 배선 없음).
export const MENU_ID = 'SCP0041' as const;
export type MENU_ID = typeof MENU_ID;

// BE 프로시저 라우팅 키(SCM_ADM_MNU_BTN_MPG_M.SHT_NM) — DB 실측 2026-09-27:
//   'Osp Stock' / 'Pack Hold Stock'. BE 버튼권한 검증은 대소문자 구분이므로 이 케이싱을 그대로 쓴다
//   (memory sht-nm-case-sensitive-per-screen — 전사 규약 아님, 화면별 DB 배포값 실측).
export enum SHEETS {
  OSP = 'Osp Stock',
  PACK = 'Pack Hold Stock',
}

// 2 탭 인덱스 (AS-IS iFocusTabIndex 0=Osp / 1=Pack, design 01·02 §4 탭 분기).
export enum TAB_INDEX {
  OSP = 0,
  PACK = 1,
}

// 커서 읽기키 — PROC_M COL_NM 실측 'o_rc1'(OUT). 두 GET SP(P_SCP0041_GET_STOCK_OSP /
//   P_SCP0041_GET_PACK_HOLD_STOCK) OUT 커서 COL_NM 모두 o_rc1 (2026-09-27 ora.py 실측, GAP-01).
//   주의: FE 읽기키가 COL_NM 과 불일치하면 그리드 항상 빈결과(memory proc-cursor-key-colnm-vs-fe-read).
export const RESPONSE_KEY = 'o_rc1' as const;

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS 원본명 그대로(design 03 §1).
//   실측: Osp Stock 14행 / Pack Hold Stock 15행.
export const ADMIN_SHEET_NAME: Record<SHEETS, string> = {
  [SHEETS.OSP]: 'Osp Stock',
  [SHEETS.PACK]: 'Pack Hold Stock',
};

// 조회조건 콤보 SQL_ID (design 02 §0 — DB 실측 USE_YN='Y' 4/4 확인 2026-09-27). 이름 유사 재사용 금지:
//   활성 소스(cs:48~53)가 쓰는 것은 Division_SCP + X1_SCP_ALL(1-suffix, 권한무시 ALL 변형)이다.
//   무-suffix MyDivision/PlantSiteByDivisionOSP/PlantSitePackerHoldStock 은 주석 심볼 — 배선 금지(design 02 §0 A).
export const COMBO = {
  DIVISION: 'Division_SCP', // @sesUserId,@mnuId — FE 클라 필터 ATTRIBUTE3!=='EE'(전극 제외) 필수
  PLANT_SITE_OSP: 'PlantSiteByDivisionOSP1_SCP_ALL', // @divisionId 콤마 다건 INSTR (SITE_TYPE='PLANT' OSP_YN='Y')
  SALE_SITE_OSP: 'SaleSiteByDivision1_SCP_ALL', // @divisionId 콤마 다건 INSTR (SITE_TYPE='SALES')
  PLANT_SITE_PACK: 'PlantSitePackerHoldStock1_SCP_ALL', // @divisionId 단일 등호 (SITE_TYPE='PLANT' OSP_YN='Y')
} as const;

// Status 조회조건 lookup — SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP_TYPE='PACKER_HOLD_STATUS'(design 02 §0):
//   HOLD/Hold, RELEASE/Release. 그리드 DIR 컬럼 표시·조회조건 cboStatus 공용. add-ALL 기본 전체(단일선택).
export const STATUS_LOOKUP = 'PACKER_HOLD_STATUS' as const;

// 전극(EE) 사업부 제외 필터 — AS-IS GetDivisionWithoutEE 가 C# 헬퍼로 후처리하던 화면 전용 필터.
//   TO-BE Division_SCP SQL 은 ATTRIBUTE3<>'EE' 를 걸지 않으므로 FE 클라에서 재현(design 02 §2-1).
export const EE_ATTRIBUTE = 'EE' as const;

// 편집 컬럼(Pack 시트 DIR='HOLD' 행만, design 03 §1-B / §3 R2). DB 메타는 전 컬럼 INPUT_TP_CD='S'(조회전용)라
//   beginningEdit 조건부 허용으로만 편집을 되살린다(메타 리터럴 덮어쓰기 금지 — hook #130, 04_react-gap §1).
export const EDITABLE_COLUMNS = ['QTY', 'DATE_FORECAST_START', 'DATE_FORECAST_FINISH'] as const;

// 행 편집 판정 키 — DIR='HOLD' 행만 편집 허용, 그 외(RELEASE/공백)는 행 전체 잠금(design 03 §3 R2).
//   DIR 은 편집조건 판정 키이므로 반드시 행 데이터에 포함(GET_PACK_HOLD_STOCK 반환, design 03 §4).
export const ROW_EDIT_COLUMN = 'DIR';
export const ROW_EDIT_VALUE = 'HOLD';

// 역전 검증 대상 날짜쌍 (design 03 §3 R3 — start>finish 면 경고 후 원복). 저장 재검증도 동일(R4).
export const DATE_START_COLUMN = 'DATE_FORECAST_START';
export const DATE_FINISH_COLUMN = 'DATE_FORECAST_FINISH';

// 저장 검증오류 강조색 — AS-IS LightPink(cs:443~450 BackColor). hook #95 잠금 Gray 와 구분되는 오류 표기색(design 03 §3 R4).
export const VALIDATION_ERROR_BG = '#ffb6c1';

// 다국어 LABEL (design 02 §0 — 전건 SCM_ADM_MSG_M 존재, 신규 등록 0. AS-IS 번호 임의 재사용 금지 #114).
export const LBL = {
  DIVISION: 'LBL00641', // Division
  PLANT_SITE: 'LBL00005', // Plant Site
  MODEL: 'LBL00669', // Model (Item ID 조건)
  PERIOD: 'LBL00013', // Period
  INSPECTION: 'LBL01086', // Inspection (Pack 탭 전용)
  STATUS: 'LBL00014', // Status (Pack 탭 전용)
  CUTOFF_DATE: 'LBL00029', // Cutoff Date (Pack 탭 전용)
} as const;

// TO-BE MSG (design 02/03 §확인, hook #114 — AS-IS 동번호 의미 상이 시 재사용 금지).
export const MSG = {
  REQUIRE_DIVISION: 'MSG00097', // Please select Division. (권한 0건 게이트, design 02 §6-8)
  DATE_REVERSAL: 'MSG00108', // 시작일이 종료일보다 클 수 없습니다. (R3/R4 역전검증, design 03 §3)
  SAVE_SUCCESS: 'MSG00672', // {0}개의 데이터가 저장되었습니다.
  SAVE_FAIL: 'MSG00006', // Failed to save.
  NO_CHANGE: 'MSG00004', // No changes to save. (저장 대상 0건)
} as const;
