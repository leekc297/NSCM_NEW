import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './shipment-master-electrode.constants';
import type { SearchCondition } from './shipment-master-electrode.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // 개인화 조회조건 복원 1회 가드 (SubTitle F6 저장분 mount 복원). reset()=initState 로 false 복귀 → F10 후 재복원 허용.
  conditionsRestored: boolean;
  // ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch. 미등록/실패 시 빈 배열
  //   -> 그리드가 constants MAIN_COLUMNS fallback. 실측: SSP0024 컬럼메타 25행 배포됨(goal.md ②, design 03 §0).
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setDivision: (divisionId: string) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

// 개인화 조건 복원 역직렬화 키(SubTitle F6 저장은 배열=콤마join·null=''·그 외 String 평문화 —
//   gridAction.ts personalizeCondition). scmSiteIds = 멀티셀렉트(콤마 결합 → split). 그 외
//   (divisionId/materialId/nickName/modelId)는 평문 문자열이라 역직렬화 불요. 날짜·불리언 조회조건 없음.
const RESTORE_ARRAY_KEYS = new Set<string>(['scmSiteIds']);

const initSearch: SearchCondition = {
  // 기본 사업부 = 세션 division. AS-IS 는 MyDivision 콤보 기본선택(명시 SelectedIndex 없음, design 02 §4).
  divisionId: useSessionStore.getState().session.div ?? '',
  scmSiteIds: [],
  materialId: '',
  nickName: '',
  modelId: '',
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.MAIN]: [],
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: emptyStaticColumns,
  conditionsRestored: false,
};

// 다건 텍스트(개행/콤마) -> 콤마 join. GET SP P_MATERIAL_ID/P_MODEL_ID 콤마 IN (design 02 §4).
const multi = (v: string): string =>
  v
    ? v
        .split(/[\n,]/)
        .map(s => s.trim())
        .filter(Boolean)
        .join(',')
    : '';

const joinOrEmpty = (arr: string[]): string => (arr.length === 0 ? '' : arr.join(','));
const trimOrEmpty = (v: string): string => (v && v.trim() ? v.trim() : '');

export const useShipmentMasterElectrodeStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division 을 제외한 검색조건을 전부 초기화하고 그리드도
    //   초기화(filters clear)한다(사용자 지시 2026-10-02 — TO-BE 공통 요건이 AS-IS 핸들러보다 우선, 정본 SCP0025
    //   setDivision). 이 화면은 기간/날짜 조회조건이 없어 유지 대상은 Division(새 값)뿐이고 나머지
    //   (PlantSite/Material/NickName/Model)는 initSearch 값으로 되돌린다. 편집중(dirty) 확인 가드(MSG00704)와
    //   그리드 미저장 편집·신규행 되돌리기는 Form onChange 의 confirmIfDirtyKey + 공용 DataGrid 자동 reset 이
    //   담당한다(commit 51d4e9fa 패턴).
    setDivision: divisionId =>
      set(state => {
        state.searchCondition = { ...initSearch, divisionId };
        state.filters = {}; // 그리드 초기화 — 재조회(Search) 전까지 빈 상태
      }),
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        // GET SP P_SSP0024_GET_SHIP_MASTER 파라미터 (design 02 §4 / 03 §4.2):
        //   p_division_id(단일) / p_plant_site_id(콤마 다건) / p_material_id(콤마 다건) /
        //   p_nick_name(단일) / p_model_id(콤마 다건).
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: c.divisionId,
            plantSiteId: joinOrEmpty(c.scmSiteIds),
            materialId: multi(c.materialId),
            nickName: trimOrEmpty(c.nickName),
            modelId: multi(c.modelId),
          },
        };
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),

    // admin SCM_MST_SHEET_COLUMNS 동적 fetch — 미등록/실패 시 빈 배열 유지(그리드 constants fallback, console 금지).
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN }
        );
        const next = res.data.result ?? [];
        if (next.length > 0) {
          set(state => {
            if (JSON.stringify(state.staticColumns[SHEETS.MAIN]) !== JSON.stringify(next)) {
              state.staticColumns[SHEETS.MAIN] = next;
            }
          });
        }
      } catch {
        // 미등록/실패 = constants fallback
      }
      set(state => {
        state.initialized = true;
      });
    },

    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 정본 1:1 = inventory-raw(SSP0017)/scp-bom(SCP0053).
    //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 역직렬화(scmSiteIds 만 split, 그 외 평문).
    //   저장분 없거나 조회 실패면 기본값 유지. searchCondition 만 patch 하므로 filters 불변(진입 자동조회 게이트 무위반).
    //   setDivision(cascade 초기화)/setSearchCondition 경유 금지 — 복원이 다른 액션 cascade 를 타지 않도록 직접 병합.
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
          if (!(paramNm in initSearch)) continue; // SearchCondition 필드만 allowlist
          const val = paramCtn ?? '';
          if (RESTORE_ARRAY_KEYS.has(paramNm)) {
            patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          } else {
            patch[paramNm] = val;
          }
        }
        set(state => {
          state.searchCondition = { ...state.searchCondition, ...patch } as SearchCondition;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지 룰)
      }
    },
  }),
  'shipment-master-electrode-store'
);
