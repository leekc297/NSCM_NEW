import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { FIXED_SEARCH, MENU_ID } from './shipment-allo-report.constants';
import type { SearchCondition } from './shipment-allo-report.types';

// admin SCM_MST_SHEET_COLUMNS 실측 SHEET_NAME(design 03 §0 — Main/Gap 탭 공유 1종).
const ADMIN_SHEET_NAME = 'Shipment(Allo) Report';

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  // 조회 실행 시점 스냅샷 — useTabProcQuery filters(Main/Gap 각각 기준일만 다름, design 02 §3).
  mainFilter?: ProcRequest<MENU_ID, 'main'>;
  gapFilter?: ProcRequest<MENU_ID, 'main'>;
  // 편집모드 — 조회 직후 항상 false(전체 잠금, design 01 §2 #17). EditButton 클릭으로만 true.
  editable: boolean;
  staticColumns: RawFlexGridColumnConfig[];
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setOpenSearchArea: (open?: boolean) => void;
  runSearch: (userId: string) => void;
  clearFilters: () => void;
  setEditable: (v: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  restoreSearchCondition: () => Promise<void>;
}

const makeInitSearch = (): SearchCondition => ({
  divisionId: FIXED_SEARCH.DIVISION_ID,
  operationGroup: FIXED_SEARCH.OPERATION_GROUP,
  bucketType: FIXED_SEARCH.BUCKET_TYPE,
  cellTypeGr: FIXED_SEARCH.CELL_TYPE_GR,
  // 멀티셀렉트(allOption) 초기값은 리터럴 'ALL' 이 정석 — CustomDropdown 은 전체/빈선택을 onChange 로
  //   'ALL' sentinel 로 내보내므로(CustomDropdown.tsx:558-593), init 을 ''로 두면 pristine Search 는 ''를,
  //   사용자가 한 번 건드린 뒤 "전체"는 'ALL'를 보내 동일 의미에 전송값이 ''↔'ALL'로 엇갈린다. 'ALL'로 통일.
  //   (GET SP PKG_SCP0055 는 V_FROMSITE/V_TEAM_ID 를 TRIM IS NULL / UPPER='ALL' 둘 다 무필터로 받음 — 실측.)
  team: 'ALL',
  fromSite: 'ALL',
  fcstYn: false,
  planDate: '',
  gapDate: '',
  fromYyyymm: '',
  toYyyymm: '',
  itemId: '',
  nickName: '',
});

const makeInitState = (): State => ({
  initialized: false,
  searchCondition: makeInitSearch(),
  openSearchArea: true,
  editable: false,
  staticColumns: [],
});

// F6(조회조건 저장, SubTitle searchParam={sc})로 서버에 저장한 조회조건을 init 기준으로 복원한다.
//   store(createPersistedStoreWithTab)는 새로고침 때 조회조건을 영속화하지 않으므로, 이 GET 복원이
//   없으면 F6 저장이 성공해도 재진입/새로고침 후 init 기본값만 뜬다(warehouse-capacity 선례와 동형).
//   저장 SP(P_SCM0000_SAVE_SRCH_COND)가 값을 String 으로만 보관하므로(GridAction.personalizeCondition)
//   fcstYn 은 'true'/'false' 문자열을 boolean 으로 되돌린다. Period(fromYyyymm/toYyyymm)는 저장 단계의
//   EXCLUDED_DATE_PARAM 로 애초에 빠져 복원 대상이 아니다(init '' 유지). Division/OperationGroup/
//   Bucket/CellTypeGr 는 OnShown 고정값이라 복원하지 않고 init(FIXED_SEARCH)을 권위값으로 둔다.
const RESTORE_STRING_KEYS = ['team', 'fromSite', 'planDate', 'gapDate', 'itemId', 'nickName'] as const;
const buildSearchConditionFromSaved = (
  saved: readonly { paramNm: string; paramCtn: string }[],
  init: SearchCondition
): SearchCondition => {
  const map = new Map(saved.map(row => [row.paramNm, row.paramCtn]));
  const next: SearchCondition = { ...init };
  RESTORE_STRING_KEYS.forEach(key => {
    const value = map.get(key);
    if (value !== undefined) next[key] = value;
  });
  const fcstYn = map.get('fcstYn');
  if (fcstYn !== undefined) next.fcstYn = fcstYn === 'true';
  return next;
};

const toMmddFirstDay = (yyyymm: string): string => (yyyymm ? `${yyyymm}01` : '');
const toMmddLastDay = (yyyymm: string): string => {
  if (!yyyymm || yyyymm.length !== 6) return '';
  const y = Number(yyyymm.slice(0, 4));
  const m = Number(yyyymm.slice(4, 6));
  const lastDay = new Date(Date.UTC(y, m, 0)).getUTCDate();
  return `${yyyymm}${String(lastDay).padStart(2, '0')}`;
};

export const useShipmentAlloReportStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...makeInitState(),
    reset: () => set(makeInitState()),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),
    // 조회(Search) 실행 — Main/Gap 각각 기준일(PlanDate/GapDate)만 다른 동일 파라미터 세트(design 02 §3).
    // 조회 성공 시 그리드 전체 재잠금(design 01 §2 #17) — editable 을 여기서 false 로 리셋한다.
    runSearch: userId => {
      const c = get().searchCondition;
      const base = {
        divisionId: c.divisionId,
        bizType: c.operationGroup,
        cellTypeGr: c.cellTypeGr,
        fromYyyymmdd: toMmddFirstDay(c.fromYyyymm),
        toYyyymmdd: toMmddLastDay(c.toYyyymm),
        fromsite: c.fromSite,
        teamId: c.team,
        itemId: c.itemId,
        nickname: c.nickName,
        programId: MENU_ID,
        sheetName: ADMIN_SHEET_NAME,
        userId,
        fcstYn: c.fcstYn ? 'Y' : 'N',
        debugMode: 'N',
      };
      set(state => {
        state.mainFilter = { ...base, planStartYyyymmdd: c.planDate };
        state.gapFilter = { ...base, planStartYyyymmdd: c.gapDate };
        state.editable = false;
      });
    },
    clearFilters: () =>
      set(state => {
        state.mainFilter = undefined;
        state.gapFilter = undefined;
      }),
    // F6 로 저장한 조회조건을 진입 시 1회 되읽어 폼에 복원한다. 복원은 searchCondition 만 채우고
    //   mainFilter/gapFilter 는 비운 채라 자동조회 없이 Search 대기 상태가 된다(AS-IS FindWhenOpen
    //   미설정 파리티). 저장분이 없으면 init 기본값을 그대로 둔다.
    restoreSearchCondition: async () => {
      const param = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
        `/admin/menu/${MENU_ID}/search-conditions`
      );
      if (!param.data.result?.length) return;
      set(state => {
        state.searchCondition = buildSearchConditionFromSaved(param.data.result, makeInitSearch());
      });
    },
    // EditButton — fps(조회 결과) 존재 시에만 토글하는 가드는 화면(Page)이 담당(design 01 §2 #14).
    setEditable: v =>
      set(state => {
        state.editable = v;
      }),
    // admin SCM_MST_SHEET_COLUMNS 동적 fetch(6칼럼, design 03 §1.1) — 미등록/실패 시 빈 배열.
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: ADMIN_SHEET_NAME,
          divisionId: get().searchCondition.divisionId,
        });
        set(state => {
          state.staticColumns = res.data.result ?? [];
          state.initialized = true;
        });
      } catch {
        // 미등록/실패 = 빈 배열(console 금지 룰)
      }
    },
  }),
  'shipment-allo-report-store'
);
