import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';

/**
 * 그리드 레이아웃 개인화 — GSCM TitleSet(SCM_MST_TITLESET_USER) 승계 메커니즘의 공통 API.
 *
 * GSCM 방식과 동일하게 **사용자당 화면·시트별 1세트**(이름 없는 단일 레이아웃)이며,
 * 저장하면 다음 진입 시 자동 적용된다. 저장소는 기존 테이블/SP 재사용 — 신규 DB 작업 없음.
 *   저장: SCM0002_SET_TITLESET_POPUP (nscm-be 확장판 — columnWidth/cellColor/textColor 지원)
 *   조회: DMF0002_GET_TITLESET_POPUP (관리자 기본값 + 사용자 저장값 COALESCE 별칭으로 함께 반환)
 *
 * 원본 구현: features/master/.../columnLayoutModal/titleSet.api.ts (2026-08-05 shared 승격).
 * master 쪽 파일은 이 모듈의 재수출로 유지되어 기존 사용처 무변경.
 */

/* ------------------------------------------------------------------ */
/* TitleSet 원시 API (ColumnLayoutModal 등 팝업 공용)                     */
/* ------------------------------------------------------------------ */

/**
 * 컬럼/Measure 개인화 조회 — 공용 엔드포인트(POST /admin/menu/{mnuId}/titleset/search).
 *
 * ⭐ 화면별 `{menuId}/titleSet/SEARCH/call-proc` 을 쓰면 SCM_ADM_MNU_BTN_MPG_M 미등록 화면에서
 *   403 No Permission 이 난다. 대상 SP 는 programId/sheetName 인자라 메뉴 종속이 없으므로
 *   BE 고정 매핑 엔드포인트를 쓴다.
 * ⚠️ sheetName / columnType 은 저장과 반드시 동일해야 한다 — 다르면 저장은 되는데
 *   재진입 조회가 그 행을 못 찾아 개인화가 사라진다.
 *
 * @returns 조회 행 목록. `[]` = 저장된 개인화 없음(정상), `null` = 조회 실패.
 */
export const fetchTitleSet = async (params: {
  menuId: string;
  sheetName: string;
  /** 'C' = 컬럼 / 'M' = measure (화면에 따라 'main' 등 자체 값). */
  columnType: string;
  divisionId: string;
}): Promise<Record<string, string>[] | null> => {
  const { menuId, sheetName, columnType, divisionId } = params;
  try {
    const res = await apiClient.post<Record<string, string>[]>(
      `/admin/menu/${menuId}/titleset/search`,
      { sheetName, columnType, divisionId }
    );
    // ⚠️ HTTP/envelope 를 먼저 판정한다 — 403/500 은 interceptor 가 throw 없이 response 로 넘겨준다.
    if (res.status >= 400 || Number((res.data as { code?: string }).code)) return null;
    return res.data.result ?? [];
  } catch {
    return null;
  }
};

/** 컬럼 개인화 1행 — 저장 payload 로 변환되기 전의 화면 단위 표현. */
export interface TitleSetSaveRow {
  /** COLUMN_NAME */
  name: string;
  /** 표시 순서 (1-base). 미지정 시 배열 순서. */
  sortOrderNo?: number;
  /** 컬럼 폭. Measure('M') 저장 시엔 미전달. */
  colWidth?: number;
  /** 셀 배경색 hex ('' = 기본색). */
  cellColor?: string;
  /** 글자색 hex ('' = 기본색). */
  textColor?: string;
  subTotalFlag?: string;
  sortMethodCode?: string;
}

/**
 * 컬럼/Measure 개인화 영구 저장(SCM_MST_TITLESET_USER) — 공용 엔드포인트(POST /admin/menu/{mnuId}/titleset).
 *
 * ⚠️ 모든 값은 같은 길이의 '^' delim 문자열 — 순서가 곧 컬럼 대응 (SP 는 DELETE 후 INSERT).
 * ⚠️ 저장 계약(GSCM 원형): **표시 컬럼만** sortOrderNo 1..n 으로 저장 — 행 존재 = 표시.
 *   비표시 행은 저장하지 않는다 (기존 화면들의 검증된 계약과 동일).
 * @returns 저장 성공 여부. 실패 시 호출측이 사용자에게 반드시 알릴 것.
 */
export const saveTitleSet = async (params: {
  menuId: string;
  sheetName: string;
  columnType: string;
  rows: TitleSetSaveRow[];
}): Promise<boolean> => {
  const { menuId, sheetName, columnType, rows } = params;
  if (rows.length === 0) return false;
  try {
    const res = await apiClient.post<{ CODE?: string }[]>(`/admin/menu/${menuId}/titleset`, {
      sheetName,
      columnType,
      activeFlag: rows.map(() => 'Y').join('^'),
      columnName: rows.map(r => r.name).join('^'),
      sortOrderNo: rows.map((r, i) => String(r.sortOrderNo || i + 1)).join('^'),
      subTotalFlag: rows.map(r => r.subTotalFlag ?? 'N').join('^'),
      sortMethodCode: rows.map(r => r.sortMethodCode ?? 'ASC').join('^'),
      columnWidth: rows.map(r => String(r.colWidth ?? '')).join('^'),
      cellColor: rows.map(r => r.cellColor ?? '').join('^'),
      textColor: rows.map(r => r.textColor ?? '').join('^'),
    });
    // ⚠️ HTTP/envelope 를 먼저 판정 — 결과 행 없음을 성공으로 보면 SP no-op 이 '저장 성공' 으로 보인다.
    if (res.status >= 400 || Number((res.data as { code?: string }).code)) return false;
    const row = (res.data.result ?? [])[0];
    return !row || row.CODE === undefined || String(row.CODE) === '0';
  } catch {
    return false;
  }
};

/** admin 컬럼 메타 1행 중 컬럼 설정 팝업이 쓰는 부분 (`/admin/menu/{mnuId}/column` = GridColumn DTO). */
export interface ColumnMetaRow {
  colNm: string;
  /** SCM_MST_SHEET_COLUMNS.VISIBLE_FLAG — 관리 노출 여부. false = 화면·팝업 어디에도 안 뜬다. */
  visible?: boolean;
  /** DISPLAY_FLAG — 기본 표시 여부. 사용자가 켤 수 있으므로 팝업 목록에는 남아야 한다. */
  display?: boolean;
}

/**
 * admin 컬럼 메타 조회 (PR_GET_SHEET_COLUMN_LIST) — 팝업 목록에서 뺄 컬럼 판정용.
 * ⚠️ 실패 시 `[]` — 필터가 no-op 이 되어 종전 동작(전 컬럼 표시)으로 떨어진다.
 *   메타 조회 실패로 팝업이 통째로 비는 쪽이 훨씬 나쁘다.
 */
export const fetchColumnMeta = async (params: {
  menuId: string;
  sheetName: string;
  divisionId: string;
}): Promise<ColumnMetaRow[]> => {
  const { menuId, sheetName, divisionId } = params;
  try {
    const res = await apiClient.post<ColumnMetaRow[]>(`/admin/menu/${menuId}/column`, {
      sheetNm: sheetName,
      divisionId,
    });
    if (res.status >= 400 || Number((res.data as { code?: string }).code)) return [];
    return res.data.result ?? [];
  } catch {
    return [];
  }
};

/* ------------------------------------------------------------------ */
/* DataGrid 레이아웃 개인화 (컨텍스트 메뉴 Save/Load/Reset Layout)         */
/* ------------------------------------------------------------------ */

/**
 * DataGrid 레이아웃 개인화 키 — 이 prop 을 준 그리드만 활성화(opt-in).
 * ⚠️ sheetName 은 admin SHEET_NAME(컬럼 메타 조회 `sheetNm` 과 동일한 값)이어야 한다.
 *   FE 내부 시트 코드('main' 등)와 혼동 금지 — 키가 다르면 저장/조회가 어긋난다.
 */
export interface GridLayoutKey {
  menuId: string;
  sheetName: string;
  /** 기본 'C'(컬럼). 자체 규약을 쓰는 기존 화면과 분리하려는 경우에만 변경. */
  columnType?: string;
  divisionId?: string;
}

/** 그리드 적용용으로 파싱한 레이아웃 1행. */
export interface GridLayoutRow {
  name: string;
  visible: boolean;
  order: number;
  width?: number;
}

const toNumber = (value: unknown): number | undefined => {
  if (value === undefined || value === null || value === '') return undefined;
  const n = Number(value);
  return Number.isFinite(n) ? n : undefined;
};

/**
 * TitleSet 응답 → 레이아웃 행 파싱.
 * ⭐ 사용자 저장값(USER_* 별칭) 우선 — 관리자쪽(COLUMN_WIDTH/SORT_ORDER_NO)만 읽으면
 *   저장한 값이 영원히 안 보인다 (ColumnLayoutModal mapBeRow 와 동일 계약).
 */
export const parseGridLayout = (rows: Record<string, string>[]): GridLayoutRow[] =>
  rows
    .map((r, i) => {
      const flag = String(r.USER_FLAG ?? r.VISIBLE_FLAG ?? 'Y');
      const width = toNumber(r.USER_COLUMN_WIDTH ?? r.COLUMN_WIDTH ?? r.COL_WIDTH);
      return {
        name: String(r.COLUMN_NAME ?? ''),
        visible: flag === 'Y',
        order: toNumber(r.USER_SORT_ORDER_NO ?? r.SORT_ORDER_NO) ?? i + 1,
        width: width && width > 0 ? width : undefined,
      };
    })
    .filter(row => row.name !== '');

/** 저장된 레이아웃 조회 + 파싱. `null` = 없음/실패 → 적용하지 않음(admin 메타 그대로). */
export const fetchGridLayout = async (key: GridLayoutKey): Promise<GridLayoutRow[] | null> => {
  const rows = await fetchTitleSet({
    menuId: key.menuId,
    sheetName: key.sheetName,
    columnType: key.columnType ?? 'C',
    divisionId: key.divisionId ?? '40',
  });
  if (!rows || rows.length === 0) return null;
  return parseGridLayout(rows);
};

/**
 * admin 컬럼 메타 위에 사용자 레이아웃(표시/순서/폭)을 덮어쓴다.
 * sales-future-price `applyLayoutToColumns` 와 동일 계약을 공통화한 것:
 *   - 레이아웃에 있는 컬럼: visible = USER_FLAG, 폭 override, 저장 순서로 재정렬
 *   - 레이아웃에 없는 컬럼: 원본 유지, 맨 뒤 배치
 *   - 관리 노출 금지(visible === false) 컬럼은 사용자값과 무관하게 불변
 */
export const applyGridLayout = (
  columns: RawFlexGridColumnConfig[],
  layout: GridLayoutRow[] | null | undefined
): RawFlexGridColumnConfig[] => {
  if (!layout || layout.length === 0) return columns;

  const byName = new Map(layout.map(row => [row.name, row]));

  const applied = columns.map(column => {
    const row = byName.get(column.colNm);
    if (!row) return column;
    if (column.visible === false) return column;
    return {
      ...column,
      // 사용자가 켠 컬럼은 기본 미표시(display=false)여도 표시 — ColumnLayoutModal 재표시와 동일
      display: row.visible ? true : column.display,
      visible: row.visible,
      colWth: row.width ?? column.colWth,
    };
  });

  const orderOf = (column: RawFlexGridColumnConfig): number => {
    const row = byName.get(column.colNm);
    // 비표시/미등록 컬럼은 맨 뒤 — sort 는 stable 이므로 상대 순서는 보존된다
    return row && row.visible ? row.order : Number.MAX_SAFE_INTEGER;
  };

  return [...applied].sort((a, b) => orderOf(a) - orderOf(b));
};
