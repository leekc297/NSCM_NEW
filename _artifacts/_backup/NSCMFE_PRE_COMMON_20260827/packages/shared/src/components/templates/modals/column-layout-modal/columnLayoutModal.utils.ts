import type { RawFlexGridColumnConfig } from '@foundation/models';

import type { ColumnLayoutRow } from '../../../molecules/columnLayoutList/ColumnLayoutList';
import type { ColumnMetaRow } from '../../../organisms/data-grid/titleSetApi';

// ⭐ 2026-08-05 features/master/.../columnLayoutModal 에서 shared 공통 승격 (내용 동일).

/** BE 결과 없을 때 팝업 목록을 만들 fallback (FE column meta). */
export interface ColumnSettingFallback {
  key: string;
  header: string;
  width?: number;
  /** DEFAULT_FLAG — 저장된 개인화가 없을 때의 기본 표시 여부. 미지정 = 표시. */
  display?: boolean;
  /** USER_SELECTABLE_FLAG — 사용자 표시/비표시 변경 가능 여부. false = 고정(좌우 이동 잠금). */
  personalizable?: boolean;
}

export const DEFAULT_COL_WIDTH = 100;

// 컬럼 판정은 SHEET_COLUMNS 플래그 3종으로만 한다 (2026-08-17 사용자 확정).
//   VISIBLE_FLAG         (visible)        = 관리 노출 여부. 'N' 이면 그리드에도 팝업 목록에도 없다.
//   DEFAULT_FLAG         (display)        = 기본 표시 여부. 저장된 개인화가 없을 때의 좌/우 배치.
//   USER_SELECTABLE_FLAG (personalizable) = 사용자 변경 가능 여부. 'N' 이면 좌/우 이동이 잠긴다.
// 금지: 라벨 끝의 '*' 로 필수 컬럼을 판정하지 말 것. 라벨은 표시용 문자열일 뿐인데 이걸로 강제
//   표시하면 DEFAULT_FLAG='N' 인 컬럼이 팝업에는 Visible 로 보이면서 그리드에는 없는 상태가 된다
//   (Sales Plan Text 컬럼 — 신규 행 저장 시 필수값 팝업만 뜨고 입력할 칸이 없던 결함).
//   타입 안전 변환 — string/number 만 문자열로 본다(객체는 ''). no-base-to-string 회피.
const flagIs = (v: unknown, expected: 'Y' | 'N'): boolean => {
  const s = typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
  return s.trim().toUpperCase() === expected;
};

/** 고정(이동 불가) 컬럼 판정 — USER_SELECTABLE_FLAG='N'. 값 미제공은 '변경 가능' 으로 본다. */
export const deriveIsKey = (row: Record<string, unknown>): boolean =>
  flagIs(row.USER_SELECTABLE_FLAG, 'N');

/**
 * 값이 실제로 내려왔는지 — null/undefined/공백은 '미제공'으로 본다.
 * 주의: SP 응답은 타입상 Record<string,string> 이지만 런타임엔 숫자가 그대로 온다
 *   (COLUMN_WIDTH/SORT_ORDER_NO). string 전제로 .trim() 호출 시 TypeError (2026-07-27).
 */
const has = (v: unknown): boolean => {
  if (v === undefined || v === null) return false;
  if (typeof v === 'string') return v.trim() !== '';
  return typeof v === 'number' || typeof v === 'boolean';
};

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
      // 주의: 표시 판정은 VISIBLE_FLAG(visible) 와 DEFAULT_FLAG(display) 둘 다 본다.
      //   admin 원본에서는 둘이 다를 수 있어(visible=Y / display=N) visible 만 보면
      //   기본 미표시 컬럼까지 Default 에서 전부 켜진다 (2026-07-27 실측).
      //   개인화 적용본은 store 가 둘을 같이 세팅하므로 동작 변화 없음.
      USER_FLAG: c.visible === false || c.display === false ? 'N' : 'Y',
      SORT_ORDER_NO: i + 1,
      COL_WIDTH: c.colWth ?? DEFAULT_COL_WIDTH,
      CELL_COLOR: c.cellColor ?? '',
      TEXT_COLOR: c.textColor ?? '',
      isKey: c.personalizable === false,
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
  // 좌/우 배치 = 사용자 저장값(USER_FLAG) 우선, 없으면 관리자 기본값(DEFAULT_FLAG).
  //   금지: VISIBLE_FLAG 폴백 — 그건 목록 포함 여부(isVisibleColumn)만 결정한다. 폴백으로 쓰면
  //   기본 미표시 컬럼(DEFAULT_FLAG='N')까지 전부 우측(표시)으로 켜진다.
  const beFlag = has(r.USER_FLAG) ? r.USER_FLAG : (r.DEFAULT_FLAG ?? 'Y');
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
    USER_FLAG: flagIs(beFlag, 'Y') ? 'Y' : 'N',
    SORT_ORDER_NO: Number(r.USER_SORT_ORDER_NO ?? r.SORT_ORDER_NO ?? i + 1),
    COL_WIDTH: Number.isFinite(width) && width > 0 ? width : DEFAULT_COL_WIDTH,
    CELL_COLOR: String(r.CELL_COLOR ?? ''),
    TEXT_COLOR: String(r.TEXT_COLOR ?? ''),
    isKey: deriveIsKey(r),
  };
};

const mapFallback = (c: ColumnSettingFallback, i: number): ColumnLayoutRow => ({
  COLUMN_NAME: c.key,
  COLUMN_LABEL_NAME: c.header,
  USER_FLAG: c.display === false ? 'N' : 'Y',
  SORT_ORDER_NO: i + 1,
  COL_WIDTH: c.width ?? DEFAULT_COL_WIDTH,
  CELL_COLOR: '',
  TEXT_COLOR: '',
  isKey: c.personalizable === false,
});

const hasWidth = (r: Record<string, string>): boolean =>
  has(r.USER_COLUMN_WIDTH) || has(r.COLUMN_WIDTH) || has(r.COL_WIDTH) || has(r.COL_WTH);

const hasOrder = (r: Record<string, string>): boolean =>
  has(r.USER_SORT_ORDER_NO) || has(r.SORT_ORDER_NO);

/**
 * 팝업 목록에 올릴 컬럼인지 — admin 메타의 VISIBLE_FLAG(= 관리 노출 여부) 기준.
 *
 * ⭐ GET_TITLESET_POPUP 은 sheet 메타에 등록된 컬럼을 전부 내려주므로, 관리자가 노출 대상에서
 *   뺀 컬럼(VISIBLE_FLAG='N')까지 좌측 Invisible 에 쌓인다. 그리드는 VISIBLE_FLAG='N' 을
 *   애초에 그리지 않으므로, 팝업에서도 선택지 자체에서 제외한다.
 * ⚠️ 표시/비표시(좌·우) 판정은 여전히 USER_FLAG 다 — VISIBLE_FLAG 는 "목록에 존재하는가" 만 본다.
 * ⚠️ 값이 안 내려온 행은 남긴다 — VISIBLE_FLAG 를 커서에 포함하지 않는 SP 방어.
 */
export const isVisibleColumn = (r: Record<string, string>): boolean =>
  !has(r.VISIBLE_FLAG) || String(r.VISIBLE_FLAG).toUpperCase() === 'Y';

// 인자를 unknown 으로 받는 이유: 타입은 number 지만 SP 응답은 문자열('0')로 오기도 한다.
const isZeroWidth = (w: unknown): boolean => {
  if (!has(w)) return false;
  const n = Number(w);
  return Number.isFinite(n) && n <= 0;
};

/**
 * admin 메타에서 노출 금지된 컬럼명 집합 — `visible === false` (= VISIBLE_FLAG 'N')
 * 또는 관리자 기본 폭이 0 (= COLUMN_WIDTH 0).
 *
 * 주의: `display === false` 는 넣지 않는다. 그건 "기본 미표시"일 뿐 사용자가 켤 수 있어야 하므로
 *   좌측 Invisible 목록에 남아야 한다. 둘을 섞으면 한 번 숨긴 컬럼을 영영 되살릴 수 없다.
 * 주의: `visible` 미제공(undefined)은 제외하지 않는다 — 메타가 없을 때 목록이 통째로 비는 사고 방지.
 * 폭 0 = 그리드에서 폭 없이 그려지는(= 안 보이는) 컬럼이라 admin 이 숨김 용도로 쓴다.
 *   VISIBLE_FLAG='N' 과 동일하게 팝업 좌/우 목록에서 아예 뺀다 (2026-08-23 요청).
 *   폭 미제공(undefined/null)이나 숫자가 아닌 값은 제외하지 않는다 — 0 으로 단정하면 메타에
 *   폭이 없는 화면의 목록이 통째로 빈다.
 */
export const toHiddenColumnSet = (cols: Partial<ColumnMetaRow>[]): Set<string> =>
  new Set(
    cols
      .filter(c => c.colNm && (c.visible === false || isZeroWidth(c.colWth)))
      .map(c => String(c.colNm))
  );

/**
 * **관리자 기본 폭이 0** 인 컬럼명 집합 — Column Setting 목록에서 감출 대상
 * (사용자 지시 2026-08-22: "GRID COLUMN SETTING 에서 WIDTH = 0 이면 목록에서 보이지 않도록").
 *
 * ⚠️ `ColumnLayoutRow.COL_WIDTH` 로는 판별할 수 없다 — `mapBeRow` 가 `width > 0 ? width :
 *   DEFAULT_COL_WIDTH` 로 **0 을 100 으로 정규화**하기 때문이다. 그 정규화는 그리드 렌더 폴백이라
 *   그대로 두고, 여기서는 **raw 응답**을 본다.
 * ⚠️ 판정 축은 `COLUMN_WIDTH`(관리자 기본)이지 `USER_COLUMN_WIDTH`(사용자 저장값)가 아니다.
 *   사용자가 개인화로 0 을 넣었다고 목록에서 사라지면 되살릴 방법이 없다.
 * ⚠️ 값이 안 내려온 경우(null/undefined/공백)는 **제외하지 않는다** — 메타 결손으로 목록이 통째로
 *   비는 사고를 막는다(`toHiddenColumnSet` 과 같은 방침).
 */
export const toZeroWidthColumnSet = (
  beRows: Record<string, string>[],
  fallbackColumns: ColumnSettingFallback[] = []
): Set<string> => {
  const out = new Set<string>();
  beRows.forEach(r => {
    const name = String(r.COLUMN_NAME ?? '');
    if (!name || !has(r.COLUMN_WIDTH)) return;
    if (Number(r.COLUMN_WIDTH) === 0) out.add(name);
  });
  // BE 응답이 없어 fallbackColumns 로 목록을 만드는 경로 — 그리드 실컬럼 폭이 곧 관리자 폭이다.
  fallbackColumns.forEach(c => {
    if (c.key && c.width === 0) out.add(String(c.key));
  });
  return out;
};

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
      // 고정 컬럼(isKey)도 표시 여부는 덮어쓴다 — isKey 는 '사용자가 못 바꾼다' 는 뜻이지
      //   '항상 표시' 가 아니다. 강제 'Y' 로 두면 DEFAULT_FLAG='N' 인 컬럼이 팝업에만 뜬다.
      USER_FLAG: o.USER_FLAG,
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
 *   않은 필드만 보완한다. BE 응답이 0건일 때만 fallbackColumns 를 base 로 쓰고,
 *   이때는 initialSettings 를 그대로 적용한다.
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
        USER_FLAG: has(raw.USER_FLAG) ? row.USER_FLAG : o.USER_FLAG,
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

/**
 * titleSet 응답 1행 → 관리자 기본값만 담은 행 (mapBeRow 의 Default 용 쌍둥이).
 *
 * 금지: USER_FLAG / USER_SORT_ORDER_NO / USER_COLUMN_WIDTH 를 읽지 말 것 — 그게 개인화 저장값이다.
 *   COLUMN_WIDTH / SORT_ORDER_NO / DEFAULT_FLAG 만 관리자 원본(SCM_MST_SHEET_COLUMNS)이다.
 * 색은 admin 에 개념이 없으므로 항상 '' (자동색).
 */
const mapAdminRow = (r: Record<string, string>, i: number): ColumnLayoutRow => {
  const width = Number(r.COLUMN_WIDTH ?? r.COL_WIDTH ?? r.COL_WTH ?? DEFAULT_COL_WIDTH);
  return {
    COLUMN_NAME: String(r.COLUMN_NAME ?? ''),
    COLUMN_LABEL_NAME: String(r.COLUMN_LABEL_NAME ?? r.COLUMN_NAME ?? ''),
    USER_FLAG: has(r.DEFAULT_FLAG) ? (flagIs(r.DEFAULT_FLAG, 'Y') ? 'Y' : 'N') : 'Y',
    SORT_ORDER_NO: has(r.SORT_ORDER_NO) ? Number(r.SORT_ORDER_NO) : i + 1,
    COL_WIDTH: Number.isFinite(width) && width > 0 ? width : DEFAULT_COL_WIDTH,
    CELL_COLOR: '',
    TEXT_COLOR: '',
    isKey: deriveIsKey(r),
  };
};

/** 관리자 기본 폭이 titleSet 응답에 실려 왔는지 — 사용자 별칭(USER_COLUMN_WIDTH)은 제외한다. */
const hasAdminWidth = (r: Record<string, string>): boolean =>
  has(r.COLUMN_WIDTH) || has(r.COL_WIDTH) || has(r.COL_WTH);

/**
 * Default(리셋) 버튼용 행 구성 — DB 의 컬럼 기본 셋팅(SCM_MST_SHEET_COLUMNS) 그대로.
 *
 * buildInitialRows 와의 차이: 저장된 개인화를 일절 반영하지 않는다. 금지: Default 경로에서
 *   buildInitialRows 재사용 — mapBeRow 가 USER_* 우선이라 개인화가 그대로 남는다.
 *
 * 정본 = titleSet 응답의 관리자 별칭(DEFAULT_FLAG / SORT_ORDER_NO / COLUMN_WIDTH).
 *   admin 화면(UI Category Setup)의 Default · Sort Order No · Width 열이 그대로 내려오는 값이다.
 *
 * 금지: admin 컬럼 메타(metaRows)의 display 로 표시 여부를 판정하지 말 것.
 *   그 값은 DISPLAY_FLAG 이고 DEFAULT_FLAG 와 별개 컬럼이다(BE GridMeasure 가 둘을 따로 읽는다).
 *   조회 SP PR_GET_SHEET_COLUMN_LIST 는 userId 를 인자로 받아 사용자별로 계산된 값을 주므로
 *   개인화가 섞여 있다 — Default 가 그걸 읽으면 숨겨 뒀던 컬럼이 리셋 후에도 계속 숨겨진다
 *   (END_CUSTOMER40 이 admin Default='Y' 인데 좌측에 남던 결함).
 * metaRows 는 개인화와 무관한 항목에만 쓴다: personalizable(USER_SELECTABLE_FLAG) · 라벨,
 *   그리고 titleSet 이 관리자 별칭을 안 내려줬을 때의 폴백.
 */
export const buildDefaultRows = (
  beRows: Record<string, string>[],
  fallbackColumns: ColumnSettingFallback[],
  metaRows: Partial<ColumnMetaRow>[]
): ColumnLayoutRow[] => {
  const metaByName = new Map<string, { meta: Partial<ColumnMetaRow>; order: number }>(
    metaRows.filter(m => m.colNm).map((meta, i) => [String(meta.colNm), { meta, order: i + 1 }])
  );

  /** titleSet 이 값을 안 준 필드만 메타로 채운다(supplied=false 인 필드). */
  const withMeta = (
    row: ColumnLayoutRow,
    supplied: { flag: boolean; order: boolean; width: boolean }
  ): ColumnLayoutRow => {
    const hit = metaByName.get(row.COLUMN_NAME);
    if (!hit) return row;
    const { meta, order } = hit;
    const metaWidth = Number(meta.colWth);
    return {
      ...row,
      COLUMN_LABEL_NAME: meta.colLblNm ?? row.COLUMN_LABEL_NAME,
      USER_FLAG: supplied.flag ? row.USER_FLAG : meta.display === false ? 'N' : 'Y',
      SORT_ORDER_NO: supplied.order ? row.SORT_ORDER_NO : order,
      COL_WIDTH:
        supplied.width || !(Number.isFinite(metaWidth) && metaWidth > 0)
          ? row.COL_WIDTH
          : metaWidth,
      isKey: meta.personalizable === undefined ? row.isKey : meta.personalizable === false,
    };
  };

  // titleSet 응답이 0건이면 화면이 넘긴 FE 메타가 유일한 기본값이다 — 그대로 정본으로 본다.
  if (beRows.length === 0) {
    return fallbackColumns
      .map(mapFallback)
      .map(row => withMeta(row, { flag: true, order: true, width: true }));
  }
  return beRows.map((raw, i) =>
    withMeta(mapAdminRow(raw, i), {
      flag: has(raw.DEFAULT_FLAG),
      order: has(raw.SORT_ORDER_NO),
      width: hasAdminWidth(raw),
    })
  );
};

/**
 * 저장 payload 구성 — 표시 컬럼 1..n → 숨김 컬럼 후행 → 비표시 0.
 *
 * hiddenNames = 팝업 dual list 에서 감춘 컬럼(MEASURE 등). 사용자가 좌/우로 옮길 수 없으므로
 *   USER_FLAG 를 항상 'Y' 로 고정한다. 필수: 화면 저장은 USER_FLAG='Y' 행만 titleSet 에 넣고
 *   SP 는 DELETE 후 INSERT 라, 한 번 빠지면 개인화에서 영구 소실되는데 목록에 없어 되살릴 수도 없다.
 * 숨김 컬럼은 드래그 대상이 아니라 SORT_ORDER_NO 가 갱신되지 않는다 — 옛 순번이 남아 다른 컬럼
 *   사이에 끼지 않도록 항상 표시 컬럼 전부의 뒤로 보낸다.
 */
export const buildSavePayload = (
  rows: ColumnLayoutRow[],
  hiddenNames: ReadonlySet<string>
): ColumnLayoutRow[] => {
  const shown = rows
    .filter(r => r.USER_FLAG === 'Y' && !hiddenNames.has(r.COLUMN_NAME))
    .sort((a, b) => a.SORT_ORDER_NO - b.SORT_ORDER_NO);
  const hidden = rows.filter(r => hiddenNames.has(r.COLUMN_NAME));
  const invisible = rows.filter(r => r.USER_FLAG === 'N' && !hiddenNames.has(r.COLUMN_NAME));
  return [
    ...shown.map((r, i) => ({ ...r, SORT_ORDER_NO: i + 1 })),
    ...hidden.map((r, i) => ({
      ...r,
      USER_FLAG: 'Y' as const,
      SORT_ORDER_NO: shown.length + i + 1,
    })),
    ...invisible.map(r => ({ ...r, SORT_ORDER_NO: 0 })),
  ];
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
