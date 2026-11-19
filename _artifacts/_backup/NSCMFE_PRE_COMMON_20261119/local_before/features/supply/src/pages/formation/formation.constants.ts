import type { CellRangeEventArgs, FlexGrid } from '@mescius/wijmo.grid';

export const MENU_ID = 'SCP0022' as const;
export type MENU_ID = typeof MENU_ID;

/**
 * i18n 라벨 코드 — SCM_ADM_MSG_M(MSG_TP_CD='LBL') 실측 역조회. 문구를 코드로 매핑한다.
 */
export const LBL = {
  SEARCH: 'LBL00112',
  DIVISION: 'LBL00001',
  PLANT_SITE: 'LBL00005',
  MATERIAL: 'LBL00021',
} as const;

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

// 저장검증 메시지 코드(SCM_ADM_MSG_M). 문구는 DB 공용 메시지를 쓴다.
export const MSG = {
  // 달력에 없는 날짜 차단(예: 20261232). SCP0006 N8_DATE_FORMAT 과 동일 코드.
  INVALID_DATE_FORMAT: 'MSG00611',
} as const;

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
  // (f/100)*(c/100)*10000 형태는 부동소수 오차로 1×3 → 2.9999… → 0.02 가 된다.
  // 곱을 한 번만 하고 toFixed(6) 으로 오차를 흡수한 뒤 절삭한다.
  return Math.trunc(Number((f * c).toFixed(6))) / 100;
};

/** 수율 입력 허용 범위 — AS-IS 2020-09-10 변경으로 MIN=1 (MSG00203 {1,100}). */
export const YIELD_MIN = 1;
export const YIELD_MAX = 100;

/**
 * 음수 입력 자체를 막는 컬럼 — AS-IS InitSpread 의 NumberCellType MinimumValue=0 재현
 * (SCP0022_Formation.cs L223 LT_FORMATION·L225~227 수율, MinimumValue=0 은 편집기가 '-' 입력을
 * 거부한다). ADD_LT_FORMATION 만 MinimumValue=-9999999999(L224)라 음수 허용이므로 제외한다.
 */
export const NEGATIVE_BLOCKED_COLUMNS: readonly string[] = [
  'LT_FORMATION',
  'FORMATION_YIELD',
  'CHAR_YIELD',
  'SSP_MODIFY_YIELD',
];

/**
 * 소수점 입력 자체를 막는 컬럼 — AS-IS InitSpread 의 NumberCellType 소수 자릿수 0 재현
 * (SCP0022_Formation.cs L223 LT_FORMATION 기본 0자리 · L224 ADD_LT_FORMATION 명시 0자리).
 */
export const DECIMAL_BLOCKED_COLUMNS: readonly string[] = ['LT_FORMATION', 'ADD_LT_FORMATION'];

/** 해당 컬럼에 들어갈 수 없는 문자('-' 또는 '.')가 text 에 있으면 true. */
const hasBlockedChar = (binding: string, text: string): boolean =>
  (NEGATIVE_BLOCKED_COLUMNS.includes(binding) && text.includes('-')) ||
  (DECIMAL_BLOCKED_COLUMNS.includes(binding) && text.includes('.'));

/**
 * NEGATIVE_BLOCKED_COLUMNS 의 음수 부호('-'), DECIMAL_BLOCKED_COLUMNS 의 소수점('.') 입력 자체를
 * 차단한다(입력 후 검증이 아니라 입력 시점 차단, 알림 없음 — AS-IS NumberCellType 동작 재현).
 *   - keydown: 편집 중 키 입력. wijmo 기본 처리보다 먼저 끊기 위해 캡처 단계로 등록.
 *   - pastingCell: 셀 선택 상태에서 Ctrl+V. 해당 셀만 붙여넣기 취소(범위 붙여넣기 시 나머지 셀은 반영).
 *   - paste: 편집기 안에서 Ctrl+V(브라우저 기본 붙여넣기라 pastingCell 을 타지 않음).
 * DataGrid 의 initialized 콜백에 그대로 전달해 각 그리드에 1회 부착한다. initialized 는 DataGrid
 * 내부 설정 이후 호출되므로 pastingCell 핸들러는 기본 편집가능 판정 뒤에 실행된다.
 */
export const attachNumberInputBlock = (grid: FlexGrid): void => {
  const currentBinding = () => grid.columns[grid.selection.col]?.binding ?? '';

  grid.hostElement.addEventListener(
    'keydown',
    event => {
      if (event.key !== '-' && event.key !== '.') return;
      if (hasBlockedChar(currentBinding(), event.key)) event.preventDefault();
    },
    true
  );

  grid.hostElement.addEventListener(
    'paste',
    event => {
      if (!grid.activeEditor) return;
      const text = event.clipboardData?.getData('text') ?? '';
      if (hasBlockedChar(currentBinding(), text)) event.preventDefault();
    },
    true
  );

  grid.pastingCell.addHandler((sender: FlexGrid, e: CellRangeEventArgs) => {
    const binding = sender.columns[e.col]?.binding ?? '';
    if (hasBlockedChar(binding, String(e.data ?? ''))) e.cancel = true;
  });
};
