import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { fetchTitleSet } from '@shared/components';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { MENU_ID, RESPONSE_SET, SHEETS } from './project-registration.constants';

// 컬럼 개인화(Column Setting 버튼, ColumnLayoutModal) 대상 시트 — 표시용 PROJECT/MY_PROJECT 그리드만.
type ColumnSheetName = RESPONSE_SET.PROJECT | RESPONSE_SET.MY_PROJECT;

/** ColumnLayoutModal 개인화 1행 — 표시/순서/폭/색 (sales-plan useSalesPlanStore.ts 와 동일 계약). */
export interface ColumnLayoutSetting {
  colNm: string;
  visible: boolean;
  width: number;
  cellColor: string;
  textColor: string;
  order: number;
}

// BE 가 폭을 안 내려줄 때의 기본 폭 (ColumnLayoutModal DEFAULT_COL_WIDTH 와 동일 계약).
const DEFAULT_COL_WIDTH = 100;

// ColumnLayoutModal 개인화 override — 표시/순서/폭/색을 admin 메타 위에 덧씌운다(sales-plan 동일 로직).
const applyLayoutToColumns = (
  cols: RawFlexGridColumnConfig[],
  settings: ColumnLayoutSetting[]
): RawFlexGridColumnConfig[] => {
  const byCol = new Map(settings.map(s => [s.colNm, s]));
  return cols
    .map(c => {
      const s = byCol.get(c.colNm);
      if (!s) return c;
      return {
        ...c,
        display: s.visible,
        colWth: s.width || DEFAULT_COL_WIDTH,
        cellColor: s.cellColor,
        textColor: s.textColor,
      };
    })
    .sort(
      (a, b) =>
        (byCol.get(a.colNm)?.order ?? Number.MAX_SAFE_INTEGER) -
        (byCol.get(b.colNm)?.order ?? Number.MAX_SAFE_INTEGER)
    );
};

// 조회조건(입력 중 값). CustomDropdown 계약(콤마 구분 string, 'ALL')을 그대로 따른다 —
// packages/shared/.../CustomDropdown.tsx 는 multiple 이어도 value 타입이 string 이다.
export interface SearchParamProps {
  divisionId: string;
  /** 고객(단일) */
  endCustomer: string;
  /** 나의 권한(단일) — SCM0001_GET_LOOKUP_VALUES p_lookup_type='SPMS_DPJT_AUTH_TYPE' */
  dpjtAuthType: string;
  /** 등록 상태(단일) — SCM0001_GET_LOOKUP_VALUES p_lookup_type='SPMS_DPJT_REG_STATUS' */
  dpjtRegStatus: string;
  /** 등록 완료일(from) — YYYY-MM-DD, 필수 */
  regCompDateFr: string;
  /** 등록 완료일(to) — YYYY-MM-DD, 필수 */
  regCompDateTo: string;
}

// PROJECT(TAB1)/MY_PROJECT(TAB2) 각 시트별 확정된 조회조건. 두 탭이 검색창 하나를 공유하지만
// 실제 SP 로 넘어가는 파라미터 모양은 다르다(아래 시트별 filter action 참고).
type FiltersBySheet = {
  [SHEETS.PROJECT]?: ProcRequest<MENU_ID, SHEETS.PROJECT>;
  [SHEETS.MY_PROJECT]?: ProcRequest<MENU_ID, SHEETS.MY_PROJECT>;
};

interface ProjectRegistrationState {
  /** 최초 진입 시 컬럼 메타/저장된 조회조건 복원이 끝났는지 — Step 3 fetchStaticColumns 참고 */
  initialized: boolean;
  // PROJECT/MY_PROJECT 는 조회조건(SearchArea)을 공유하지만 각자 독립된 그리드/SP 를 갖는
  // 동급(peer) 탭이다(화면설계서 레이아웃 시트 — sales-site 의 master-detail 구조와 다름).
  // 조회 버튼 클릭 시 두 필터를 동시에 확정한다.
  filters: FiltersBySheet;
  /** 입력 중인 값(아직 조회 안 함) — 조회 버튼(F5) 을 눌러야 filters 로 확정된다 */
  searchParams: SearchParamProps;
  /** 그리드 컬럼 메타 — /admin/menu/SDM1010/column 에서 시트별로 받아온다(하드코딩 금지) */
  staticColumns: {
    [RESPONSE_SET.PROJECT]: RawFlexGridColumnConfig[];
    [RESPONSE_SET.MY_PROJECT]: RawFlexGridColumnConfig[];
  };
  /** 컬럼 개인화 적용 전 admin 메타 원본(sheet별) — Column Setting 팝업 Default 버튼의 원복 기준. */
  originalStaticColumns: {
    [RESPONSE_SET.PROJECT]: RawFlexGridColumnConfig[];
    [RESPONSE_SET.MY_PROJECT]: RawFlexGridColumnConfig[];
  };
  /** Column Setting(ColumnLayoutModal) 저장값(titleSet) 복원 결과(sheet별). null = 미설정. */
  userColumnLayout: {
    [RESPONSE_SET.PROJECT]: ColumnLayoutSetting[] | null;
    [RESPONSE_SET.MY_PROJECT]: ColumnLayoutSetting[] | null;
  };
  /** SearchArea 열림/닫힘 (MainTitle 우측 토글) */
  openSearchArea: boolean;
}

interface ProjectRegistrationAction {
  reset: () => void;
  /** TAB1 즉시 조회/F5 — 사업부·사용자 조건만 PROJECT filter 로 확정한다 */
  setProjectFilters: () => void;
  /** TAB2 조회 버튼/F5 — 입력한 조회조건을 MY_PROJECT filter 로 확정한다 */
  setMyProjectFilters: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
  /** ColumnLayoutModal onSave — 표시/순서/폭/색을 staticColumns[sheetName] 에 즉시 반영. */
  applyColumnLayout: (sheetName: ColumnSheetName, settings: ColumnLayoutSetting[]) => void;
  /** 저장된 컬럼 개인화(titleSet) 복원 — fetchStaticColumns 가 await 후 메타에 적용. */
  fetchUserColumnLayout: (sheetName: ColumnSheetName) => Promise<ColumnLayoutSetting[] | null>;
}

// 등록완료일 기본값(M-1 ~ Today) 계산용 — 화면설계서 §개요 조회조건 F17.
const fmt = (d: Date) =>
  `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
const normalizeDate = (value: string) =>
  /^\d{8}$/.test(value) ? `${value.slice(0, 4)}-${value.slice(4, 6)}-${value.slice(6, 8)}` : value;
const today = new Date();
const oneMonthBefore = new Date(today.getFullYear(), today.getMonth() - 1, today.getDate());
const session = useSessionStore.getState().session;
const PROJECT_DIVISION_ID = session.div ?? '';

// 사업부는 로그인 세션, 옵션류는 전부 'ALL', 등록완료일은 M-1~Today.
const initSearchParams: SearchParamProps = {
  divisionId: PROJECT_DIVISION_ID,
  endCustomer: 'ALL',
  dpjtAuthType: 'ALL',
  dpjtRegStatus: 'ALL',
  regCompDateFr: fmt(oneMonthBefore),
  regCompDateTo: fmt(today),
};

const initState: ProjectRegistrationState = {
  initialized: false,
  filters: {
    [SHEETS.PROJECT]: undefined,
    [SHEETS.MY_PROJECT]: undefined,
  },
  searchParams: initSearchParams,
  staticColumns: {
    [RESPONSE_SET.PROJECT]: [],
    [RESPONSE_SET.MY_PROJECT]: [],
  },
  originalStaticColumns: {
    [RESPONSE_SET.PROJECT]: [],
    [RESPONSE_SET.MY_PROJECT]: [],
  },
  userColumnLayout: {
    [RESPONSE_SET.PROJECT]: null,
    [RESPONSE_SET.MY_PROJECT]: null,
  },
  openSearchArea: true,
};

export const useProjectRegistrationStore = createPersistedStoreWithTab<
  ProjectRegistrationState & ProjectRegistrationAction
>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setProjectFilters: () => {
      const currentSession = useSessionStore.getState().session;
      set(state => {
        // 요청 4: P_SES_* 값은 FE 세션에서 읽고 ses* 파라미터명으로 명확히 구분한다.
        state.filters[SHEETS.PROJECT] = {
          sesDivisionId: currentSession.div ?? '',
          sesUserId: currentSession.userId ?? '',
          sesMenuId: MENU_ID,
          sesUserGrId: currentSession.groupId ?? '',
        };
      });
    },
    setMyProjectFilters: () => {
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      set(state => {
        const params = {
          ...state.searchParams,
          regCompDateFr: normalizeDate(state.searchParams.regCompDateFr),
          regCompDateTo: normalizeDate(state.searchParams.regCompDateTo),
        };
        // 요청 4: TAB2의 P_SES_USER_ID도 세션값 + sesUserId 이름으로 전달한다.
        state.filters[SHEETS.MY_PROJECT] = { ...params, sesUserId };
      });
    },
    // 드롭다운 변경 시 호출 — 여기서는 서버를 부르지 않고 searchParams 에만 반영한다.
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
        // 사업부 변경 — 하위 조건을 초기화시키는 상위 조건이므로 컬럼 재조회 + 기존 filters 리셋.
        if (searchParams.divisionId) {
          void state.fetchStaticColumns();
          state.filters = initState.filters;
        }
      });
    },
    // 그리드 컬럼 메타 로드(항상 실행) + 저장된 조회조건 복원(최초 1회만, initialized 가드).
    fetchStaticColumns: async () => {
      // 컬럼 개인화(Column Setting) 복원 — 진입 시 1회만(모달 OK 직후 재조회는 이미 있는 값 유지).
      //   admin 메타보다 먼저 조회해도 무방 — fetchUserColumnLayout 은 staticColumns 가 아직
      //   비어 있으면(최초 진입) 저장만 해 두고, 아래에서 admin 메타에 적용한다.
      if (get().userColumnLayout[RESPONSE_SET.PROJECT] === null) {
        await get().fetchUserColumnLayout(RESPONSE_SET.PROJECT);
      }
      if (get().userColumnLayout[RESPONSE_SET.MY_PROJECT] === null) {
        await get().fetchUserColumnLayout(RESPONSE_SET.MY_PROJECT);
      }
      const [project, myProject] = await Promise.all([
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: RESPONSE_SET.PROJECT,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: RESPONSE_SET.MY_PROJECT,
        }),
      ]);
      set(state => {
        const fetchedProject = project.data.result;
        const fetchedMyProject = myProject.data.result;
        // 개인화 적용 전 원본 보관 — 팝업 Default 원복 기준(개인화로 덮이지 않는다).
        state.originalStaticColumns = {
          [RESPONSE_SET.PROJECT]: fetchedProject,
          [RESPONSE_SET.MY_PROJECT]: fetchedMyProject,
        };
        const projectLayout = state.userColumnLayout[RESPONSE_SET.PROJECT];
        const myProjectLayout = state.userColumnLayout[RESPONSE_SET.MY_PROJECT];
        state.staticColumns = {
          [RESPONSE_SET.PROJECT]:
            projectLayout && projectLayout.length > 0
              ? applyLayoutToColumns(fetchedProject, projectLayout)
              : fetchedProject,
          [RESPONSE_SET.MY_PROJECT]:
            myProjectLayout && myProjectLayout.length > 0
              ? applyLayoutToColumns(fetchedMyProject, myProjectLayout)
              : fetchedMyProject,
        };
      });
      if (get().initialized) return;
      const param = await apiClient.get<{ paramNm: keyof SearchParamProps; paramCtn: string }[]>(
        `/admin/menu/${MENU_ID}/search-conditions`
      );
      if (param.data.result?.length > 0) {
        const restored = param.data.result.reduce((acc, curr) => {
          acc[curr.paramNm] = curr.paramCtn;
          return acc;
        }, {} as SearchParamProps);
        set(state => {
          state.searchParams = { ...restored, divisionId: PROJECT_DIVISION_ID };
        });
      }
      set(state => {
        state.initialized = true;
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      });
    },
    // Column Setting 팝업 OK — 표시/순서/폭/색을 grid 에 즉시 반영(영구 저장은 titleSet SAVE 별도).
    applyColumnLayout: (sheetName, settings) => {
      set(state => {
        const shown = settings
          .filter(s => s.visible)
          .sort((a, b) => a.order - b.order)
          .map((s, i) => ({ ...s, order: i + 1 }));
        const hidden = settings
          .filter(s => !s.visible)
          .map(s => ({ ...s, order: Number.MAX_SAFE_INTEGER }));
        const layout = [...shown, ...hidden];
        state.userColumnLayout[sheetName] = layout;
        const cur = state.staticColumns[sheetName];
        if (!cur || cur.length === 0) return;
        state.staticColumns[sheetName] = applyLayoutToColumns(cur, layout);
      });
    },
    // 저장된 컬럼 개인화 복원 — ColumnLayoutModal 이 쓰는 공용 titleSet 조회 API 와 동일 계약.
    //   ⚠️ 화면별 `{menuId}/titleSet/SEARCH/call-proc` 대신 fetchTitleSet(공용 고정 엔드포인트)을
    //   쓴다 — SDM1010처럼 SCM_ADM_MNU_BTN_MPG_M 미등록 화면에서 전자는 403 난다(DMF0042 전례).
    fetchUserColumnLayout: async sheetName => {
      const rows = await fetchTitleSet({
        menuId: MENU_ID,
        sheetName,
        columnType: 'C',
        divisionId: get().searchParams.divisionId || PROJECT_DIVISION_ID,
      });
      if (!rows || rows.length === 0) return null;
      const isShown = (r: Record<string, string>) =>
        String(r.USER_FLAG ?? r.DEFAULT_FLAG ?? 'Y')
          .trim()
          .toUpperCase() === 'Y';
      const orderOf = (r: Record<string, string>) =>
        Number(r.USER_SORT_ORDER_NO ?? r.SORT_ORDER_NO ?? 0);
      const toSetting = (
        r: Record<string, string>,
        order: number,
        visible: boolean
      ): ColumnLayoutSetting => {
        const width = Number(r.USER_COLUMN_WIDTH ?? r.COLUMN_WIDTH ?? 0);
        return {
          colNm: String(r.COLUMN_NAME ?? ''),
          visible,
          width: Number.isFinite(width) && width > 0 ? width : DEFAULT_COL_WIDTH,
          cellColor: String(r.CELL_COLOR ?? ''),
          textColor: String(r.TEXT_COLOR ?? ''),
          order,
        };
      };
      const shown = rows
        .filter(isShown)
        .sort((a, b) => orderOf(a) - orderOf(b))
        .map((r, i) => toSetting(r, i + 1, true))
        .filter(s => s.colNm);
      // 비표시 컬럼도 함께 보관 — applyLayoutToColumns 는 '개인화에 없는 컬럼 = admin 기본값'
      //   이므로, 빠뜨리면 사용자가 끈 컬럼이 재조회마다 되살아난다.
      const hidden = rows
        .filter(r => !isShown(r))
        .map(r => toSetting(r, Number.MAX_SAFE_INTEGER, false))
        .filter(s => s.colNm);
      if (shown.length === 0) return null;
      const layout = [...shown, ...hidden];
      set(state => {
        state.userColumnLayout[sheetName] = layout;
        if (state.staticColumns[sheetName].length > 0) {
          state.staticColumns[sheetName] = applyLayoutToColumns(
            state.staticColumns[sheetName],
            layout
          );
        }
      });
      return layout;
    },
  }),
  'project-registration'
);
