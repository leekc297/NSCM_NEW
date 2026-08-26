import { apiClient } from '@foundation/apis';

/**
 * 컬럼/Measure 개인화 조회 (DMF0002_GET_TITLESET_POPUP) — 공용 Column 팝업 전용.
 *
 * ⭐ 화면별 `{menuId}/titleSet/SEARCH/call-proc` 대신 **공용 엔드포인트**를 쓴다 (saveTitleSet 과 대칭).
 *   call-proc 경로는 SCM_ADM_MNU_BTN_MPG_M 에 (MNU_ID, 'titleSet', 'SEARCH') 행이 화면마다
 *   등록돼 있어야 하고, 미등록 화면은 버튼 권한 검사에서 **403 No Permission** 이 난다
 *   (DMF0042 진입 즉시 발생 — 2026-07-29). 대상 SP 는 programId/sheetName 을 인자로 받아
 *   메뉴 종속이 없으므로 BE 가 고정 매핑으로 호출한다(POST /admin/menu/{mnuId}/titleset/search).
 *
 * ⚠️ sheetName / columnType 은 **저장(saveTitleSet)·팝업이 쓰는 값과 반드시 동일**해야 한다.
 *   하나라도 다르면 저장은 되는데 재진입 조회가 그 행을 못 찾아 개인화가 사라진다.
 *
 * @returns 조회 행 목록. `[]` = 저장된 개인화 없음(정상), `null` = 조회 실패.
 *   둘을 합치면 "저장했는데 재진입 시 원복" 과 "애초에 저장 안 함" 이 구분되지 않는다.
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

/** admin 컬럼 메타 1행 중 팝업이 쓰는 부분 (`/admin/menu/{mnuId}/column` = GridColumn DTO). */
export interface ColumnMetaRow {
  colNm: string;
  /** SCM_MST_SHEET_COLUMNS.VISIBLE_FLAG — 관리 노출 여부. false = 화면·팝업 어디에도 안 뜬다. */
  visible?: boolean;
  /** DISPLAY_FLAG — 기본 표시 여부. 사용자가 켤 수 있으므로 팝업 목록에는 남아야 한다. */
  display?: boolean;
}

/**
 * admin 컬럼 메타 조회 (PR_GET_SHEET_COLUMN_LIST) — 팝업 목록에서 뺄 컬럼 판정용.
 *
 * ⭐ 화면마다 prop 으로 넘기지 않고 팝업이 직접 조회한다(공통 처리). 각 화면 store 의
 *   fetchStaticColumns 와 **같은 엔드포인트·같은 인자**(mnuId + sheetNm + divisionId)라 결과도 같다.
 *
 * ⚠️ 실패 시 `[]` — 필터가 no-op 이 되어 종전 동작(전 컬럼 표시)으로 떨어진다. 메타 조회 실패로
 *   팝업이 통째로 비는 쪽이 훨씬 나쁘다.
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

/** 컬럼 개인화 1행 — 저장 payload 로 변환되기 전의 화면 단위 표현. */
export interface TitleSetSaveRow {
  /** COLUMN_NAME */
  name: string;
  /** 표시 순서 (1-base). 미지정 시 배열 순서. */
  sortOrderNo?: number;
  /** 컬럼 폭 (2026-07-27 BE 확장분). Measure('M') 저장 시엔 미전달. */
  colWidth?: number;
  /** 셀 배경색 hex ('' = 기본색). */
  cellColor?: string;
  /** 글자색 hex ('' = 기본색). */
  textColor?: string;
  subTotalFlag?: string;
  sortMethodCode?: string;
}

/**
 * 컬럼/Measure 개인화 영구 저장 (SCM_MST_TITLESET_USER) — 공용 Column 팝업 전용.
 *
 * ⭐ 화면별 `{menuId}/titleSet/SAVE/call-proc` 대신 **공용 엔드포인트**를 쓴다.
 *   call-proc 경로는 SCM_ADM_MNU_BTN_MPG_M 에 (MNU_ID, 'titleSet', 'SAVE') 행이 화면마다
 *   등록돼 있어야 하는데(미등록 화면은 저장 자체가 404/미배선), 대상 프로시저
 *   SCM0002_SET_TITLESET_POPUP 은 programId/sheetName 을 인자로 받아 메뉴 종속이 없다.
 *   → BE 가 고정 매핑으로 호출(POST /admin/menu/{mnuId}/titleset). 화면이 늘어도 메타 등록 불필요.
 *   조회 메타(/admin/menu/{mnuId}/column)와 동일한 방식.
 *
 * ⚠️ sheetName / columnType 은 **팝업이 조회에 쓰는 값과 반드시 동일**해야 한다. 하나라도 다르면
 *   저장은 성공하는데 재진입 조회가 그 행을 못 찾아 개인화가 사라진다
 *   (forecast-price 2026-07-27 / sales-monitoring 2026-07-04 동일 사고).
 *
 * @returns 저장 성공 여부. 실패 시 호출측이 사용자에게 반드시 알릴 것 —
 *   조용히 삼키면 "저장했는데 재진입 시 원복" 과 구분되지 않는다.
 */
export const saveTitleSet = async (params: {
  menuId: string;
  sheetName: string;
  /** 'C' = 컬럼 / 'M' = measure (화면에 따라 'main' 등 자체 값). */
  columnType: string;
  rows: TitleSetSaveRow[];
}): Promise<boolean> => {
  const { menuId, sheetName, columnType, rows } = params;
  if (rows.length === 0) return false;
  try {
    // ⚠️ 모든 값은 같은 길이의 '^' delim 문자열 — 순서가 곧 컬럼 대응이다 (SP DELETE 후 INSERT).
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
    // ⚠️ HTTP/envelope 를 먼저 판정한다 — 결과 행이 없다고 성공으로 보면 SP 미배선·no-op 이
    //   '저장 성공' 으로 보고돼 "저장했는데 재진입 시 원복" 과 구분이 안 된다 (2026-07-27).
    if (res.status >= 400 || Number((res.data as { code?: string }).code)) return false;
    const row = (res.data.result ?? [])[0];
    return !row || row.CODE === undefined || String(row.CODE) === '0';
  } catch {
    return false;
  }
};
