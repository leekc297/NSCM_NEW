import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import {
  DYNAMIC_SUB_COLUMNS,
  MENU_ID,
  PLAN_GROUP_SLOT_VALUE,
  SHEETS,
  UNUSED_SLOT_VALUES,
  type ActiveGrid,
} from './constraint-mgmt.constants';
import type { DynamicSubColumn, MasterRow, SearchParamProps } from './constraint-mgmt.types';
import { buildSearchParamsFromSaved } from './utils/constraintMgmt.utils';

interface ConstraintMgmtFilters {
  [SHEETS.LOOKUP_MASTER]?: ProcRequest<MENU_ID, SHEETS.LOOKUP_MASTER>;
  [SHEETS.LOOKUP_DETAIL]?: ProcRequest<MENU_ID, SHEETS.LOOKUP_DETAIL>;
}

interface ConstraintMgmtStaticColumns {
  [SHEETS.LOOKUP_MASTER]: RawFlexGridColumnConfig[];
  [SHEETS.LOOKUP_DETAIL]: RawFlexGridColumnConfig[];
}

interface ConstraintMgmtState {
  searchParams: SearchParamProps;
  filters: ConstraintMgmtFilters;
  staticColumns: ConstraintMgmtStaticColumns;
  isOpenSearchArea: boolean;
  activeGrid: ActiveGrid;
  /** 더블클릭으로 선택한 마스터 행의 LOOKUP_TYPE. Sub 조회 키이자 Sub 신규행 기본값이다. */
  mainLookupType: string;
  /** Sub 컬럼 라벨 치환값(동적 ②③). 키는 컬럼메타 colNm 이라 문자열 맵으로 둔다. */
  dynamicColumnLabels: Record<string, string>;
  /** Sub 컬럼 숨김(동적 ①). */
  hiddenSubColumns: Record<string, true>;
  /** 동적 라벨이 'PLAN_GROUP' 인 컬럼. F-01 권한 필터의 대상 컬럼이다. */
  planGroupColumn: DynamicSubColumn | '';
  /**
   * F-01 필터에 실제로 쓰는 Plan Group 체크값 — Sub 조회를 발사한 "그 시점"의 스냅샷이다.
   * 조회조건(searchParams.planGroupNames)을 그대로 보면 체크박스를 건드리는 것만으로 하단이
   * 재필터되어, splice 로 넣어 둔 미저장 신규행이 통째로 사라진다. AS-IS 도 FindData_Sub
   * 안에서 clbPlanGroup.CheckedItems 를 한 번 읽고 끝이다(cs:483~529).
   * 갱신 때마다 새 배열로 둔다 — 이 참조 교체가 곧 하단 pending 초기화 신호다.
   */
  appliedPlanGroupNames: string[];
}

interface ConstraintMgmtAction {
  /** BaseTabState 필수 계약 — 공용 Condition Reset 경로가 호출한다(SYS0010 선례와 동일 범위). */
  reset: () => void;
  setSearchParams: (next: Partial<SearchParamProps>) => void;
  restoreSearchParams: () => Promise<void>;
  setFilters: (adminYn: string) => void;
  setAppliedAdminYn: (adminYn: string) => void;
  setSubFilters: (lookupType: string) => void;
  clearFilters: () => void;
  clearDetail: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
  setActiveGrid: (grid: ActiveGrid) => void;
  applyDynamicSubColumns: (masterRow: MasterRow) => void;
}

// AS-IS 에 Reset 버튼 override 는 없다(5종 = Search/Insert/Delete/Edit/Save). 다만 reset action 은
// BaseTabState 필수 계약이라 생략할 수 없어(TS2344) 공용 Condition Reset 용으로 조회조건만 되돌린다.
const initSearchParams: SearchParamProps = {
  lookupType: '',
  planGroupNames: [],
  // AS-IS cs:154 — DataBind 직후의 index 0(ALL)을 즉시 'Y' 로 덮어쓴다.
  validYn: 'Y',
};

const initConstraintMgmtState: ConstraintMgmtState = {
  searchParams: initSearchParams,
  filters: {},
  staticColumns: {
    [SHEETS.LOOKUP_MASTER]: [],
    [SHEETS.LOOKUP_DETAIL]: [],
  },
  isOpenSearchArea: true,
  // AS-IS 는 Fp_Resize 가 먼저 도는 Spread 로 fps 가 정해져 비결정적이다 — TO-BE 는 'main' 고정.
  activeGrid: 'main',
  mainLookupType: '',
  dynamicColumnLabels: {},
  hiddenSubColumns: {},
  planGroupColumn: '',
  appliedPlanGroupNames: [],
};

const isUnusedSlot = (value: string): boolean =>
  (UNUSED_SLOT_VALUES as readonly string[]).includes(value);

export const useConstraintMgmtStore = createPersistedStoreWithTab<
  ConstraintMgmtState & ConstraintMgmtAction
>(
  (set, get) => ({
    ...initConstraintMgmtState,
    reset: () =>
      set(state => {
        state.searchParams = { ...initSearchParams };
      }),
    setSearchParams: next => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...next };
      });
    },
    /**
     * F6 로 서버에 저장해 둔 조회조건을 진입 시 1회 되읽어 폼에 채운다. 스토어가 새로고침 때
     * 영속화하지 않으므로(createStore.ts §createPersistedStoreWithTab) 이 GET 복원이 없으면
     * F6 저장이 성공해도 새로고침 후 init 기본값만 뜬다. 저장분이 없으면 기본값을 그대로 둔다.
     * 자동조회는 하지 않는다 — filters 는 clearFilters 가 비운 채라 사용자가 Search 를 눌러야
     * 조회된다(AS-IS FindWhenOpen 미설정과 동일).
     */
    restoreSearchParams: async () => {
      const param = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
        `/admin/menu/${MENU_ID}/search-conditions`
      );
      if (!param.data.result?.length) return;
      set(state => {
        state.searchParams = buildSearchParamsFromSaved(param.data.result, initSearchParams);
      });
    },
    /**
     * 조회 발사 — payload 3키는 SCM_ADM_PROC_M.COL_NM 실측값 그대로 camelCase 다.
     * snake p_* 로 보내면 BE 가 값을 못 찾아 NULL 바인딩된다.
     * planGroup* 키는 보내지 않는다 — SP 파라미터 자체가 없다(FE 클라 필터 전용 축).
     */
    setFilters: adminYn => {
      const { lookupType, validYn } = get().searchParams;
      set(state => {
        state.filters[SHEETS.LOOKUP_MASTER] = {
          // IN 1 — 부분일치. trim 후 그대로. 'ALL' 치환 금지.
          lookupType: String(lookupType ?? '').trim(),
          // IN 2 — ALL 은 빈 문자열로. AS-IS CString.GetCheckedListValue 와 같은 정규화.
          validYn: validYn === 'ALL' ? '' : String(validYn ?? ''),
          // IN 3 — 관리자 판정. 값의 원천은 AdminYn_SCP0120 콤보(서버 SQL 이 세션으로 판정).
          adminYn: String(adminYn ?? ''),
        };
      });
    },
    /**
     * 관리자 판정만 갈아끼운다 — 조회조건은 직전 Search 로 적용된 스냅샷 그대로 둔다.
     * setFilters 를 재사용하면 lookupType/validYn 을 searchParams 에서 다시 읽어, 사용자가
     * Search 를 누르지 않은 폼 현재값으로 Main 결과셋이 갈린다(감사 G-20).
     * 적용된 조회가 없으면(=아직 Search 전) 아무것도 하지 않는다.
     */
    setAppliedAdminYn: adminYn => {
      set(state => {
        const applied = state.filters[SHEETS.LOOKUP_MASTER];
        if (!applied) return;
        applied.adminYn = String(adminYn ?? '');
      });
    },
    /**
     * Sub 조회 발사(마스터 더블클릭) — AS-IS FindData_Sub 진입과 같은 자리.
     * 이 시점에 Plan Group 체크값을 스냅샷한다. 같은 마스터 행을 다시 골라 queryKey 가
     * 그대로여도 배열 참조가 바뀌므로 하단 바인딩 소스가 새로 만들어지고, 미저장 pending 이
     * 함께 버려진다(AS-IS InitSpread(siSub) 와 동형).
     */
    setSubFilters: lookupType => {
      const picked = get().searchParams.planGroupNames;
      set(state => {
        state.filters[SHEETS.LOOKUP_DETAIL] = { lookupType };
        state.mainLookupType = lookupType;
        state.appliedPlanGroupNames = [...picked];
      });
    },
    /** keep-alive 잔여 filters 무효화 — 진입 자동조회 금지(AS-IS FindWhenOpen 미설정). */
    clearFilters: () => {
      set(state => {
        state.filters[SHEETS.LOOKUP_MASTER] = undefined;
        state.filters[SHEETS.LOOKUP_DETAIL] = undefined;
        state.mainLookupType = '';
        state.dynamicColumnLabels = {};
        state.hiddenSubColumns = {};
        state.planGroupColumn = '';
        state.appliedPlanGroupNames = [];
      });
    },
    /**
     * Search 시 하단 전체 초기화 — AS-IS FindData_Main 이 끝에서 InitSpread(siSub) 로 Sub 시트를
     * 재생성한다(cs:421). 데이터뿐 아니라 동적 라벨·숨김·필터 대상 컬럼까지 정적 상태로 되돌린다.
     */
    clearDetail: () => {
      set(state => {
        state.filters[SHEETS.LOOKUP_DETAIL] = undefined;
        state.mainLookupType = '';
        state.dynamicColumnLabels = {};
        state.hiddenSubColumns = {};
        state.planGroupColumn = '';
        state.appliedPlanGroupNames = [];
      });
    },
    fetchStaticColumns: async () => {
      const [masterRes, detailRes] = await Promise.all([
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.LOOKUP_MASTER,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.LOOKUP_DETAIL,
        }),
      ]);
      set(state => {
        state.staticColumns[SHEETS.LOOKUP_MASTER] = masterRes.data.result;
        state.staticColumns[SHEETS.LOOKUP_DETAIL] = detailRes.data.result;
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    setActiveGrid: grid => {
      set(state => {
        state.activeGrid = grid;
      });
    },
    /**
     * Sub 동적 3축 — AS-IS FindData_Sub cs:455~481.
     * 마스터 행의 SEGMENT1~10 / ATTRIBUTE1~15 "값"이 곧 디테일 컬럼의 이름이다.
     *   ① 값이 ''/'-'/'*' 면 그 컬럼을 숨긴다(미사용 슬롯).
     *   ② 아니면 라벨을 그 값으로 치환한다.
     *   ③ SEGMENT* 는 치환값 뒤에 '*' 를 붙인다(= 필수). ATTRIBUTE* 는 붙이지 않는다
     *      (AS-IS 판정식이 필드명 IndexOf('S')==0 이라 SEGMENT 계열만 걸린다).
     * 값이 'PLAN_GROUP' 인 슬롯은 숨김 여부와 무관하게 기록한다 — AS-IS 도 숨김 판정과
     * 별개 분기에서 search_ColName 을 잡는다(cs:476~479).
     */
    applyDynamicSubColumns: masterRow => {
      const labels: Record<string, string> = {};
      const hidden: Record<string, true> = {};
      let planGroupColumn: DynamicSubColumn | '' = '';

      DYNAMIC_SUB_COLUMNS.forEach(field => {
        const value = String(masterRow[field] ?? '').trim();
        if (isUnusedSlot(value)) hidden[field] = true;
        else labels[field] = field.startsWith('S') ? `${value}*` : value;
        if (value === PLAN_GROUP_SLOT_VALUE) planGroupColumn = field;
      });

      set(state => {
        state.dynamicColumnLabels = labels;
        state.hiddenSubColumns = hidden;
        state.planGroupColumn = planGroupColumn;
      });
    },
  }),
  'constraintMgmt'
);
