export const MENU_ID = 'DMF0008' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  SUMMARY = 'summary',
  REPAIR = 'repair',
  SALES_SITE = 'salesSite',
  SSPM = 'sspm',
  SPREAD_TITLE = 'spreadTitle',
  UPDATE_HISTORY = 'updateHistory',
}

// 카논 컨벤션: CUD 용 단일 멤버. 데이터 접근은 literal `data?.o_rc1` 사용 (RESPONSE_SET 매개 X).
// 4개 query SHEET 가 모두 cursor 이름 `o_rc1` 을 반환하므로, 별도 SHEET 별 멤버를 만들면
// no-duplicate-enum-values lint 발화. SAVE_SALES_SITE / SAVE_SSPM 두 mutation 이 동일 cursor 사용.
export enum RESPONSE_SET {
  CUD = 'o_rc1',
}

export enum SHEET_INDEX {
  SALES_SITE,
  SSPM,
}
