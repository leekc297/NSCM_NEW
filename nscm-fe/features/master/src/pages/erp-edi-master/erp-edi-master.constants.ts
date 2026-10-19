export const MENU_ID = 'DMF0008' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS Designer.cs 4 layer (사용자 명시 3단 구조 + 검색):
//   [검색] usrLayoutControl1 — Division + Period
//   [1단] spdSummary  → DMF0008_GET_EDI_MST_SUMMARY (sheet 'main')
//   [2단] spdRepair   → DMF0008_GET_EDI_MST_REPAIR (sheet 'repair')
//   [3단 = 2 tab] spdSub
//     - TAB 1: SALES_SITE → DMF0008_GET_SALES_SITE (sheet 'salesSite')
//     - TAB 2: SSPM       → DMF0008_GET_SALES_SITE_PROJECT_MODEL (sheet 'sspm')
export enum SHEETS {
  // BE 메타 SHT_NM = 'summary' (SCM_ADM_MNU_BTN_MPG_M cross-check 2026-06-10). 'main' 은 alias 로 procedures.d.ts 에만 존재
  SUMMARY = 'summary',
  REPAIR = 'repair',
  SALES_SITE = 'salesSite',
  SSPM = 'sspm',
  DIVISION = 'division',
  UPDATE_HISTORY = 'updateHistory', // AS-IS .cs L2918: DMF0000_GET_UPDATE_HISTORY (SDATE/EDATE/UPDATED_BY)
}

// const object — enum 대체 (NSCM 단일 cursor 표준 'o_rc1' 다수 중복 허용)
export const RESPONSE_SET = {
  SUMMARY: 'o_rc1',
  REPAIR: 'o_rc1',
  SALES_SITE: 'O_RESULT_CURSOR',
  SSPM: 'o_rc1',
  DIVISION: 'o_rc1',
  UPDATE_HISTORY: 'o_rc1',
  O_RC1: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// AS-IS .cs L734/L740
/**
 * Repair 제목 줄의 "정비 필요 합계 수량 : N"(CNT 합계) 표시 여부.
 *
 * 2026-10-08 에 AS-IS lblRepair_Cnt 파리티로 추가했으나 화면에서 빼 달라는 요청(2026-10-12)으로
 * 표시만 끈다. 합계 계산(ErpEdiMaster.tsx repairTotalCnt)과 스타일(.repairCount)은 그대로 두어
 * 다시 보이게 할 때 이 값만 true 로 바꾸면 된다.
 */
export const SHOW_REPAIR_TOTAL_CNT = false;

export const VALIDATION_MSG = {
  PERIOD_INVALID: 'MSG00108',
  PERIOD_RANGE: 'MSG00164',
} as const;

// AS-IS Designer.cs L58 + .cs L729 — 사용자 권한 기반 동적 lookup (SHEETS.DIVISION 호출)
// 정적 fallback (SP 호출 실패 시 — minyonglee1 권한 division 인벤토리)
export const DIVISION_FALLBACK: ReadonlyArray<{ value: string; label: string }> = [
  { value: '40', label: '40 (Mobility & IT Battery)' },
  { value: '81', label: '81 (ESS)' },
];

// AS-IS .cs FindData_SubRepair 의 flag 옵션 (.cs L832~852 추정 — 정합성/정비대상 등)
export const REPAIR_FLAG_OPTIONS: ReadonlyArray<{ value: string; label: string }> = [
  { value: 'ALL', label: 'ALL' },
  { value: 'Y', label: '정비 필요' },
  { value: 'N', label: '정상' },
];

export enum SHEET_INDEX {
  SALES_SITE,
  SSPM,
}
