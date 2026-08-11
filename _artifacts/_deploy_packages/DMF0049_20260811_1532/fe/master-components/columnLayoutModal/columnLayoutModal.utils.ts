import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { ColumnLayoutRow } from '@shared/components';

import type { ColumnSettingFallback } from '../columnSettingModal/ColumnSettingModal';

export const DEFAULT_COL_WIDTH = 100;

export const deriveIsKey = (label: string): boolean => label.trim().endsWith('*');

/**
 * 화면 grid 메타(SHEET_COLUMNS) → 팝업 initialSettings/defaultSettings 변환.
 *
 * titleSet SP 계약(COLUMN_NAME/COLUMN_LABEL)에는 width/color 가 없으므로, 팝업의 Width 기본값은
 * grid 가 실제로 쓰는 `colWth`(= SCM_MST_SHEET_COLUMNS.COLUMN_WIDTH) 에서 와야 한다.
 * 배열 순서를 SORT_ORDER_NO 로 삼는다 — grid 가 배열 순서를 컬럼 순서로 쓰는 것과 동일 규칙.
 */
export const toColumnLayoutSettings = (rawColumns: RawFlexGridColumnConfig[]): ColumnLayoutRow[] =>
  rawColumns.map((c, i) => {
    const label = c.colLblNm ?? c.colNm;
    return {
      COLUMN_NAME: c.colNm,
      COLUMN_LABEL_NAME: label,
      // ⚠️ 표시 판정은 VISIBLE_FLAG(visible) 와 DISPLAY_FLAG(display) 둘 다 본다.
      //   admin 원본에서는 둘이 다를 수 있어(visible=Y / display=N) visible 만 보면
      //   기본 미표시 컬럼까지 Default 에서 전부 켜진다 (2026-07-27 실측).
      //   개인화 적용본은 store 가 둘을 같이 세팅하므로 동작 변화 없음.
      USER_FLAG: c.visible === false || c.display === false ? 'N' : 'Y',
      SORT_ORDER_NO: i + 1,
      COL_WIDTH: c.colWth ?? DEFAULT_COL_WIDTH,
      CELL_COLOR: c.cellColor ?? '',
      TEXT_COLOR: c.textColor ?? '',
      isKey: deriveIsKey(label),
    };
  });

export const parseWidth = (raw: string, fallback: number): number => {
  const t = raw.trim();
  if (t === '') return fallback;
  const n = Number(t);
  if (!Number.isFinite(n)) return fallback;
  return n < 0 ? 0 : Math.floor(n);
};

const mapBeRow = (r: Record<string, string>, i: number): ColumnLayoutRow => {
  const label = String(r.COLUMN_LABEL_NAME ?? r.COLUMN_NAME ?? '');
  const beFlag = String(r.USER_FLAG ?? r.VISIBLE_FLAG ?? 'Y');
  // ⭐ 사용자 저장값 우선 (2026-07-27 SP 실측) — GET_TITLESET_POPUP 은 관리자 기본값과 사용자값을
  //   별칭으로 나눠 둘 다 내려준다:
  //     COLUMN_WIDTH   = SCM_MST_SHEET_COLUMNS (관리자 기본)
  //     USER_COLUMN_WIDTH = COALESCE(TITLESET_USER.COLUMN_WIDTH, 관리자값)  ← 사용자 저장값
  //   관리자쪽을 읽으면 저장한 폭이 영원히 안 보인다. SORT_ORDER_NO 도 동일 구조.
  const width = Number(
    r.USER_COLUMN_WIDTH ?? r.COLUMN_WIDTH ?? r.COL_WIDTH ?? r.COL_WTH ?? DEFAULT_COL_WIDTH
  );
  return {
    COLUMN_NAME: String(r.COLUMN_NAME ?? ''),
    COLUMN_LABEL_NAME: label,
    USER_FLAG: beFlag === 'Y' ? 'Y' : 'N',
    SORT_ORDER_NO: Number(r.USER_SORT_ORDER_NO ?? r.SORT_ORDER_NO ?? i + 1),
    COL_WIDTH: Number.isFinite(width) && width > 0 ? width : DEFAULT_COL_WIDTH,
    CELL_COLOR: String(r.CELL_COLOR ?? ''),
    TEXT_COLOR: String(r.TEXT_COLOR ?? ''),
    isKey: deriveIsKey(label),
  };
};

const mapFallback = (c: ColumnSettingFallback, i: number): ColumnLayoutRow => ({
  COLUMN_NAME: c.key,
  COLUMN_LABEL_NAME: c.header,
  USER_FLAG: 'Y',
  SORT_ORDER_NO: i + 1,
  COL_WIDTH: c.width ?? DEFAULT_COL_WIDTH,
  CELL_COLOR: '',
  TEXT_COLOR: '',
  isKey: deriveIsKey(c.header),
});

/**
 * 값이 실제로 내려왔는지 — null/undefined/공백은 '미제공'으로 본다.
 * ⚠️ SP 응답은 타입상 Record<string,string> 이지만 런타임엔 숫자가 그대로 온다
 *   (COLUMN_WIDTH/SORT_ORDER_NO). string 전제로 .trim() 호출 시 TypeError (2026-07-27).
 */
const has = (v: unknown): boolean => {
  if (v === undefined || v === null) return false;
  if (typeof v === 'string') return v.trim() !== '';
  return typeof v === 'number' || typeof v === 'boolean';
};

const hasWidth = (r: Record<string, string>): boolean =>
  has(r.USER_COLUMN_WIDTH) || has(r.COLUMN_WIDTH) || has(r.COL_WIDTH) || has(r.COL_WTH);

const hasOrder = (r: Record<string, string>): boolean =>
  has(r.USER_SORT_ORDER_NO) || has(r.SORT_ORDER_NO);

/** base 행에 settings 를 강제로 덮어쓴다 (Default 원복 등 — DB 값보다 우선시켜야 할 때). */
export const overrideRows = (
  base: ColumnLayoutRow[],
  settings: ColumnLayoutRow[]
): ColumnLayoutRow[] => {
  const map = new Map(settings.map(s => [s.COLUMN_NAME, s]));
  return base.map(row => {
    const o = map.get(row.COLUMN_NAME);
    if (!o) return row;
    return {
      ...row,
      USER_FLAG: row.isKey ? 'Y' : o.USER_FLAG,
      SORT_ORDER_NO: o.SORT_ORDER_NO,
      COL_WIDTH: o.COL_WIDTH,
      CELL_COLOR: o.CELL_COLOR,
      TEXT_COLOR: o.TEXT_COLOR,
    };
  });
};

/**
 * 팝업 초기 행 구성.
 *
 * ⭐ 우선순위 = DB(BE 응답) > 화면 상태(initialSettings) (2026-07-27 요청).
 *   저장된 개인화가 있으면 그게 최우선으로 보여야 하므로, initialSettings 는 BE 가 값을 주지
 *   않은 필드만 보완한다. (구 구현은 initialSettings 가 무조건 덮어써서, DB 에 저장된 값이
 *   화면 store 값에 가려졌다.)
 *   BE 응답이 0건일 때만 fallbackColumns 를 base 로 쓰고, 이때는 initialSettings 를 그대로 적용한다.
 */
export const buildInitialRows = (
  beRows: Record<string, string>[],
  fallbackColumns: ColumnSettingFallback[],
  initialSettings?: ColumnLayoutRow[]
): ColumnLayoutRow[] => {
  if (beRows.length > 0) {
    const overrideMap = new Map((initialSettings ?? []).map(s => [s.COLUMN_NAME, s]));
    return beRows.map((raw, i) => {
      const row = mapBeRow(raw, i);
      const o = overrideMap.get(row.COLUMN_NAME);
      if (!o) return row;
      return {
        ...row,
        USER_FLAG: row.isKey ? 'Y' : has(raw.USER_FLAG) ? row.USER_FLAG : o.USER_FLAG,
        SORT_ORDER_NO: hasOrder(raw) ? row.SORT_ORDER_NO : o.SORT_ORDER_NO,
        COL_WIDTH: hasWidth(raw) ? row.COL_WIDTH : o.COL_WIDTH,
        CELL_COLOR: has(raw.CELL_COLOR) ? row.CELL_COLOR : o.CELL_COLOR,
        TEXT_COLOR: has(raw.TEXT_COLOR) ? row.TEXT_COLOR : o.TEXT_COLOR,
      };
    });
  }
  const base = fallbackColumns.map(mapFallback);
  return initialSettings && initialSettings.length > 0 ? overrideRows(base, initialSettings) : base;
};

export const toggleDisplay = (rows: ColumnLayoutRow[], key: string): ColumnLayoutRow[] =>
  rows.map(r =>
    r.COLUMN_NAME === key && !r.isKey ? { ...r, USER_FLAG: r.USER_FLAG === 'Y' ? 'N' : 'Y' } : r
  );

export const changeWidth = (
  rows: ColumnLayoutRow[],
  key: string,
  width: number
): ColumnLayoutRow[] => rows.map(r => (r.COLUMN_NAME === key ? { ...r, COL_WIDTH: width } : r));

export const changeCellColor = (
  rows: ColumnLayoutRow[],
  key: string,
  hex: string
): ColumnLayoutRow[] => rows.map(r => (r.COLUMN_NAME === key ? { ...r, CELL_COLOR: hex } : r));

export const changeTextColor = (
  rows: ColumnLayoutRow[],
  key: string,
  hex: string
): ColumnLayoutRow[] => rows.map(r => (r.COLUMN_NAME === key ? { ...r, TEXT_COLOR: hex } : r));

export const reorderRows = (rows: ColumnLayoutRow[], orderedKeys: string[]): ColumnLayoutRow[] =>
  rows.map(r => {
    const idx = orderedKeys.indexOf(r.COLUMN_NAME);
    return idx === -1 ? r : { ...r, SORT_ORDER_NO: idx + 1 };
  });
