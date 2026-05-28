export const MENU_ID = 'DMF0082' as const;
export type MENU_ID = typeof MENU_ID;

/**
 * SHEETS — value 는 `{화면ID}.S1.db.md` 의 `SHEET_NAME` 문자 그대로.
 * - `FCST_N_PRICE_40` = 메인 조회/저장 (Division 40 고정 — Insert 가능 컬럼 메타가 정확)
 * - `SPREAD_TITLE`    = `DMF0082_GET_SPREAD_TITLE` 동적 컬럼 정의 (Two-pass 2차)
 */
export enum SHEETS {
  FCST_N_PRICE_40 = 'fcstNPrice_40',
  SPREAD_TITLE = 'spreadTitle',
}

/**
 * RESPONSE_SET — `useProcMutation` 의 3 번째 generic 용 단일 멤버.
 * 데이터 접근은 literal cursor 이름 (`data?.fcstNPrice` 등) 으로 수행.
 */
export enum RESPONSE_SET {
  SAVE_RESULT = 'o_rc1',
}
