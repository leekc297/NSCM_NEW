// SCP0039 Master Validation (Supply Master) — read-only 검증 대시보드.
//   AS-IS: GSCM.SCP.Master.UIL / SCP0039_ValidationMaster (Insert/Edit/Delete/Save = NO-OP override).
//   design: .atlas/gscm-design/SCP0039/design/00_checklist.md ~ 03_grid-columns.md
//
//   구조: 좌 마스터목록(lookup MASTER_VALIDATION 12행) | 우 detail(검증유형별 SP 결과) 2-pane.
//   QUERY 클릭 = 그 행 PROCEDURE_NAME(코드)로 PKG_SCP0039 멤버 SP dispatch -> COUNT + detail 바인딩.
//   OPEN 클릭 = PROGRAM_ID(SEGMENT4) MDI 오픈(또는 http URL).

import type { ComboResponse } from '@foundation/models';

export const MENU_ID = 'SCP0039' as const;
export type MENU_ID = typeof MENU_ID;

// lookup type — 마스터 목록 원천(SCM_ADM_LOOKUP_MASTER_DETAIL, 13행/활성 12).
export const MASTER_LOOKUP_TYPE = 'MASTER_VALIDATION';

// FE 라우팅 SHT_NM (SCM_ADM_MNU_BTN_MPG_M.SHT_NM = procedures.d.ts SHEETS value).
//   MAIN 은 마스터 목록(admin/lookup 로 조회, proc 아님). 나머지 12 = 검증유형별 GET SP dispatch.
//   ITEM_SEARCH = Model/Item 팝업(convert-sp 후속 — 아래 주석 참조).
export enum SHEETS {
  MAIN = 'main',
  BOM = 'bom',
  PROJECT_ROUTE = 'projectRoute',
  PROJECT_ROUTE_ELEC = 'projectRouteElec',
  BOD = 'bod',
  LINE_ASSIGN = 'lineAssign',
  TACT_TIME = 'tactTime',
  TACT_TIME_OSP = 'tactTimeOsp',
  OUTSOURCING_CAPACITY = 'outsourcingCapacity',
  STOCK_OSP = 'stockOsp',
  PLAN_GROUP = 'planGroup',
  INTRANSIT_INVENTORY = 'intransitInventory',
  YIELD = 'yield',
  ITEM_SEARCH = 'itemSearch',
}

// NSCM 단일 cursor 표준 'o_rc1'.
export const RESPONSE_SET = {
  [SHEETS.BOM]: 'o_rc1',
  [SHEETS.PROJECT_ROUTE]: 'o_rc1',
  [SHEETS.PROJECT_ROUTE_ELEC]: 'o_rc1',
  [SHEETS.BOD]: 'o_rc1',
  [SHEETS.LINE_ASSIGN]: 'o_rc1',
  [SHEETS.TACT_TIME]: 'o_rc1',
  [SHEETS.TACT_TIME_OSP]: 'o_rc1',
  [SHEETS.OUTSOURCING_CAPACITY]: 'o_rc1',
  [SHEETS.STOCK_OSP]: 'o_rc1',
  [SHEETS.PLAN_GROUP]: 'o_rc1',
  [SHEETS.INTRANSIT_INVENTORY]: 'o_rc1',
  [SHEETS.YIELD]: 'o_rc1',
  [SHEETS.ITEM_SEARCH]: 'o_rc1',
} as const;

// 검증유형 dispatch 테이블 — 키 = lookup VALIDATION_TYPE(SEGMENT1 코드, 대소문자·truncation 불변).
//   sheet   = FE 라우팅 SHT_NM(callProc sheetName).
//   adminSheetName = SCM_MST_SHEET_COLUMNS.SHEET_NAME 실측 표기(대소문자 그대로 — 컬럼 fetch 키).
//     주의: lookup SHEET_NAME(SEGMENT2)과 등록 SHEET_NAME 이 대소문자 불일치 3건
//     (CAPA:Line Assign / CAPA:Tact Time / Intransit Inventory) — 여기 등록 표기로 정규화(design 03 §6-1).
//   sp      = 배포된 PKG_SCP0039 멤버명(all_procedures 실측 — SEGMENT5 truncation 3건 반영, design 03 §6-2).
export interface ValidationSpec {
  sheet: SHEETS;
  adminSheetName: string;
  sp: string;
}
export const VALIDATION_MAP: Record<string, ValidationSpec> = {
  BOM: { sheet: SHEETS.BOM, adminSheetName: 'BOM', sp: 'P_SCP0039_GET_VALIDATION_BOM' },
  PROJECT_ROUTE: {
    sheet: SHEETS.PROJECT_ROUTE,
    adminSheetName: 'Project Route',
    sp: 'P_SCP0039_GET_VALIDATION_PROJECT_ROUTE',
  },
  PROJECT_ROUTE_ELEC: {
    sheet: SHEETS.PROJECT_ROUTE_ELEC,
    adminSheetName: 'Project Route (Elec)',
    sp: 'P_SCP0039_GET_VALIDATION_PR_ELEC',
  },
  BOD: { sheet: SHEETS.BOD, adminSheetName: 'BOD / BOD Item', sp: 'P_SCP0039_GET_VALIDATION_BOD' },
  LINE_ASSIGN: {
    sheet: SHEETS.LINE_ASSIGN,
    adminSheetName: 'Capa : Line Assign',
    sp: 'P_SCP0039_GET_VALIDATION_LINE_ASSIGN',
  },
  TACT_TIME: {
    sheet: SHEETS.TACT_TIME,
    adminSheetName: 'Capa : Tact Time',
    sp: 'P_SCP0039_GET_VALIDATION_TACT_TIME',
  },
  TACT_TIME_OSP: {
    sheet: SHEETS.TACT_TIME_OSP,
    adminSheetName: 'Tact Time(OSP) [82]',
    sp: 'P_SCP0039_GET_VALIDATION_TACT_TIME_OSP',
  },
  OUTSOURCING_CAPACITY: {
    sheet: SHEETS.OUTSOURCING_CAPACITY,
    adminSheetName: 'Outsourcing Capacity [40]',
    sp: 'P_SCP0039_GET_VALIDATION_OS_CAPACITY',
  },
  STOCK_OSP: {
    sheet: SHEETS.STOCK_OSP,
    adminSheetName: 'Stock OSP',
    sp: 'P_SCP0039_GET_VALIDATION_STOCK_OSP',
  },
  PLAN_GROUP: {
    sheet: SHEETS.PLAN_GROUP,
    adminSheetName: 'Plan Group',
    sp: 'P_SCP0039_GET_VALIDATION_PLAN_GROUP',
  },
  INTRANSIT_INVENTORY: {
    sheet: SHEETS.INTRANSIT_INVENTORY,
    adminSheetName: 'INTRANSIT INVENTORY',
    sp: 'P_SCP0039_GET_VALIDATION_INTRANSIT_INV',
  },
  YIELD: {
    sheet: SHEETS.YIELD,
    adminSheetName: 'CAPA : Yield (Formation)',
    sp: 'P_SCP0039_GET_VALIDATION_YIELD',
  },
};

// 마스터 그리드 "Validation Info" 컬럼 fetch 키(SCM_MST_SHEET_COLUMNS.SHEET_NAME 실측).
export const MASTER_ADMIN_SHEET_NAME = 'Validation Info';

// 조회조건 콤보 (DB 실측 확정 — design 02 §2).
//   DIVISION: Division_SCP(@sesUserId/@mnuId 권한필터) + FE opt.ATTRIBUTE3!=='EE' 필터(전극 제외 재현).
//     MyDivision 재사용 금지(convert-core §2.6 SCP0006 선례).
//   PLAN_GROUP: PlanGroup_SCP_ALL(전량) -> 선택 Division 의 DIVISION_ID 로 클라 필터(cascade, 서버 재조회 없음).
export const COMBO = {
  DIVISION: 'Division_SCP',
  PLAN_GROUP: 'PlanGroup_SCP_ALL',
} as const;

// Division 전극 제외 필터(AS-IS BLUtils.GetDivisionWithoutEE 후처리 재현 — CMBO SQL 엔 없음).
export const EXCLUDE_EE_DIVISION = (row: ComboResponse): boolean =>
  String(row.ATTRIBUTE3 ?? '') !== 'EE';

// Plan Group 전체선택 sentinel. ALL -> SP payload p_plan_group_id=''(전체).
export const PLAN_GROUP_ALL = 'ALL';

// 다국어 LABEL — DB SCM_ADM_MSG_M 실측(design 02 §4.5). AS-IS 번호 아닌 문구 역조회 확정값.
export const LBL = {
  DIVISION: 'LBL00001', // Division
  PLAN_GROUP: 'LBL00002', // Plan Group
  MODEL: 'LBL00669', // Model
  SEARCH: 'LBL00112', // Search(F5)
} as const;

// 마스터 "Validation Info" 그리드 컬럼은 SCM_MST_SHEET_COLUMNS 를 admin fetch 해 구동한다
//   (하드코딩 금지 — CLAUDE.md §2 체크3/4, design 03 §5 #03). fetch 키 = MASTER_ADMIN_SHEET_NAME.
//   QUERY/OPEN 은 메타상 FPButton 액션셀(binding QUERY/OPEN)이며 MasterGrid formatItem 이 라벨을 렌더한다.
//   표시열 정정: 설계 03 §1.1 대로 "Validation Type" 열이 SEGMENT2(친화명)를 보이도록 메타를 정비했다
//   (05_register.sql 7) — SHEET_NAME 열 노출, VALIDATION_TYPE(코드) 열 숨김. dispatch 는 row.VALIDATION_TYPE 사용.

// CONSTRAINTS01 파싱 — 'Const:...^PlanGroup' 토큰이면 PlanGroup 조건 잠금(design 01 §2-C R18).
export const isPlanGroupLocked = (constraints01: string | undefined): boolean =>
  /(^|\^)Const:.*PlanGroup/i.test(constraints01 ?? '') || /(^|\^)PlanGroup/i.test(constraints01 ?? '');

// 전체조회 시 division 종속 행 skip — CONSTRAINTS01 'Div:82'/'Div:40' 가 현재 division 과 다르면 skip
//   (design 01 §2-E R22, 03 §3). 'Div:' 토큰이 없으면 항상 조회 대상.
export const isDivisionSkipped = (constraints01: string | undefined, divisionId: string): boolean => {
  const match = /Div:(\w+)/i.exec(constraints01 ?? '');
  if (!match) return false;
  return match[1] !== divisionId;
};
