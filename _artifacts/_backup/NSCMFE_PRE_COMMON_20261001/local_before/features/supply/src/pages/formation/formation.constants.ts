export const MENU_ID = 'SCP0022' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  FORMATION = 'formation',
  EXCEPT = 'except',
  EXCEPT_LT = 'exceptLt',
}

export enum RESPONSE_SET {
  FORMATION = 'formation',
  EXCEPT = 'formationExcept',
  EXCEPT_LT = 'formationExceptLt',
}

export enum SHEET_INDEX {
  FORMATION,
  EXCEPT,
  EXCEPT_LT,
}

/**
 * 컬럼 메타 fetch(/admin/menu/SCP0022/column)의 sheetNm 은 SCM_MST_SHEET_COLUMNS.SHEET_NAME 과
 * 정확히 일치해야 한다(BE 가 문자열 그대로 매칭). SCP0022 는 공백 포함 표시명으로 배포돼 있어
 * 코드 키(SHEETS)와 분리한다.
 */
export const COLUMN_SHEET_NAME: Record<RESPONSE_SET, string> = {
  [RESPONSE_SET.FORMATION]: 'Formation',
  [RESPONSE_SET.EXCEPT]: 'Formation Except',
  [RESPONSE_SET.EXCEPT_LT]: 'Formation Except LT',
};

/**
 * setTotalYield — AS-IS FORMATION_TOTAL_YIELD 파생계산(SCP0022_Formation.cs L1846~1870).
 * 총수율 = 성형수율(%) × 화성수율(%). 둘 다 값이면 소수 2자리 절삭, 한쪽만 있으면 그 값 그대로.
 * 편집·저장 양쪽에서 동일하게 재현한다. TOTAL 컬럼은 read-only(잠금).
 */
export const calcTotalYield = (formationYield: number | string, charYield: number | string) => {
  const f = Number(formationYield);
  const c = Number(charYield);
  const fValid = !Number.isNaN(f) && f !== 0;
  const cValid = !Number.isNaN(c) && c !== 0;
  if (!fValid && !cValid) return '';
  if (!fValid) return c;
  if (!cValid) return f;
  return Math.trunc((f / 100) * (c / 100) * 10000) / 100;
};

/** 수율 입력 허용 범위 — AS-IS 2020-09-10 변경으로 MIN=1 (MSG00203 {1,100}). */
export const YIELD_MIN = 1;
export const YIELD_MAX = 100;
