import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import type { SHEETS } from './master-validation.constants';
import { MASTER_ADMIN_SHEET_NAME, MENU_ID } from './master-validation.constants';
import type { SearchParamProps } from './master-validation.types';

// detail(결과) 그리드 컬럼 메타 캐시 — 검증유형별 sheetNm 로 admin fetch(design 03 §5 #03).
type ColumnCache = Partial<Record<SHEETS, RawFlexGridColumnConfig[]>>;

interface MasterValidationState {
  searchParams: SearchParamProps;
  // 마스터 "Validation Info" 컬럼 메타(admin fetch — 하드코딩 금지, CLAUDE.md §2 체크3/4).
  //   QUERY/OPEN 액션셀 포함. mount 시 1회 fetch. detail 은 staticColumns 캐시에 sheetNm 별로 담는다.
  masterColumns: RawFlexGridColumnConfig[];
  staticColumns: ColumnCache;
  // 마스터 행 선택 시 CONSTRAINTS01 'Const:PlanGroup' 이면 PlanGroup 조건 잠금(design 01 §2-C R18).
  planGroupLocked: boolean;
  openSearchArea: boolean;
  // 개인화 조회조건 복원 1회 가드 (SubTitle F6 저장분 mount 복원 — 저장만 있고 복원 누락 방지, basic-check #3).
  conditionsRestored: boolean;
}

interface MasterValidationAction {
  setSearchParams: (params: Partial<SearchParamProps>) => void;
  // Division 변경 = PlanGroup 초기화 + 조회 리셋(그리드 초기화 의무, nscm-patterns §5-5).
  setDivision: (divisionId: string) => void;
  setPlanGroupLocked: (locked: boolean) => void;
  fetchMasterColumns: () => Promise<void>;
  fetchDetailColumns: (sheet: SHEETS, adminSheetName: string) => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchParams 패치(1회).
  restoreSearchConditions: () => Promise<void>;
  reset: () => void;
}

// 개인화 조건 복원 역직렬화 키(SubTitle F6 저장은 배열=콤마join 평문화 — personalizeCondition).
//   SCP0039 조회조건 3필드 중 멀티셀렉트는 planGroupIds 1건(나머지 divisionId/itemId 는 문자열 그대로).
const RESTORE_ARRAY_KEYS = new Set<string>(['planGroupIds']);

// planGroupIds: [] = 전체(ALL) — SP payload p_plan_group_id='' 로 매핑(design 02 §4).
const initSearchParams: SearchParamProps = {
  divisionId: useSessionStore.getState().session.div ?? '',
  planGroupIds: [],
  itemId: '',
};

const initState: MasterValidationState = {
  searchParams: initSearchParams,
  masterColumns: [],
  staticColumns: {},
  planGroupLocked: false,
  openSearchArea: true,
  conditionsRestored: false,
} as const;

const fetchColumns = async (sheetNm: string): Promise<RawFlexGridColumnConfig[]> => {
  const res = await apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
    sheetNm,
  });
  return res.data.result ?? [];
};

export const useMasterValidationStore = createPersistedStoreWithTab<
  MasterValidationState & MasterValidationAction
>((set, get) => ({
  ...initState,
  setSearchParams: params =>
    set(state => {
      state.searchParams = { ...get().searchParams, ...params };
    }),
  // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division 을 제외한 검색조건을 전부 초기화한다(PlanGroup 전체(ALL=[]) +
  //   Model/Item). 이 화면엔 기간/날짜 조회조건이 없어 유지 대상은 Division(새 값)뿐이다. 그리드 초기화(COUNT/detail/
  //   activeSheet)는 MasterValidation 의 clearResults useEffect(searchParams.divisionId watch)가 수행한다.
  //   편집중(dirty) 가드(MSG00704)는 Form 의 Division onChange 가 confirmIfDirtyKey 로 처리(commit 51d4e9fa 패턴) —
  //   이 화면은 read-only 라 실제 dirty 는 없지만 공통 패턴을 동일하게 둔다(SCP0025 선례).
  setDivision: divisionId =>
    set(state => {
      state.searchParams = { ...initSearchParams, divisionId };
    }),
  setPlanGroupLocked: locked =>
    set(state => {
      state.planGroupLocked = locked;
    }),
  fetchMasterColumns: async () => {
    // 마스터 "Validation Info" 메타 fetch(mount 1회). 이미 있으면 재조회 생략(정적 메타).
    if (get().masterColumns.length) return;
    const cols = await fetchColumns(MASTER_ADMIN_SHEET_NAME);
    set(state => {
      state.masterColumns = cols;
    });
  },
  fetchDetailColumns: async (sheet, adminSheetName) => {
    // 이미 캐시된 시트는 재조회 생략(정적 메타).
    if (get().staticColumns[sheet]?.length) return;
    const cols = await fetchColumns(adminSheetName);
    set(state => {
      state.staticColumns[sheet] = cols;
    });
  },
  setOpenSearchArea: open =>
    set(state => {
      state.openSearchArea = open ?? !state.openSearchArea;
    }),
  // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 형제 shipment-plan-fix 파리티.
  //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 역직렬화(planGroupIds 배열 split,
  //   divisionId/itemId 문자열 그대로). 저장분 없으면 기본값 유지. setDivision/setSearchParams 경유 금지
  //   (cascade·초기화 side-effect 회피) — searchParams 직접 병합.
  restoreSearchConditions: async () => {
    if (get().conditionsRestored) return;
    set(state => {
      state.conditionsRestored = true;
    });
    try {
      const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
        `/admin/menu/${MENU_ID}/search-conditions`
      );
      const rows = res.data.result ?? [];
      if (rows.length === 0) return;
      const patch: Record<string, unknown> = {};
      for (const { paramNm, paramCtn } of rows) {
        if (!(paramNm in initSearchParams)) continue;
        const val = paramCtn ?? '';
        if (RESTORE_ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
        else patch[paramNm] = val;
      }
      set(state => {
        state.searchParams = { ...state.searchParams, ...(patch as Partial<SearchParamProps>) };
      });
    } catch {
      // 미저장/실패 = 기본값 유지 (console 금지)
    }
  },
  reset: () => set(initState),
}), 'master-validation');
