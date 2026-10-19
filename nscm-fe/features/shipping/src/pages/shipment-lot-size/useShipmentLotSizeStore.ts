import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './shipment-lot-size.constants';
import type { SearchCondition } from './shipment-lot-size.types';

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
  // ui-dynamic-property-management — admin SCM_MST_SHEET_COLUMNS 동적 fetch(미등록 시 빈 배열 → constants
  //   fallback). design 03 §0: PROGRAM_ID='SCP0028', SHEET_NAME='Shipment Lot Size' 18행 등록 실측(2026-09-26).
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
}

const initSearch: SearchCondition = {
  divisionId: '', // 첫 권한 사업부로 초기화(Form mount, design 02 §4 line 98)
  operationGroup: 'ALL', // ALL + Pack/Cell/Electrode, 기본 ALL (design 02 §4)
  fromSite: 'ALL', // 다중 ALL (권한 내 전체)
  toSite: 'ALL', // 다중 ALL
  transMode: 'ALL', // 다중 ALL(전체 체크)
  itemId: '', // Model — Item 팝업으로만 채움
  valid: 'ALL', // ALL/Y/N, 기본 ALL (design 02 §4)
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
};

// 'ALL' sentinel / 공백 -> 빈값 치환 (design 02 §2·§5 — GET SP 파라미터 'ALL'->''/null).
const orEmpty = (v: string): string => {
  const t = (v ?? '').trim();
  return !t || t.toUpperCase() === 'ALL' ? '' : t;
};

export const useShipmentLotSizeStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        const next = { ...get().searchCondition, ...p };
        // 이슈3(사용자 지시 2026-10-02): Division 이 아닌 조회조건 변경으로는 그리드(filters)를 비우지
        //   않는다 — 조회 후 조건만 바꿔도 조회 데이터가 사라지지 않게 유지한다. 재조회는 Search 버튼으로만.
        // Division 변경 경로는 setDivision(아래)이 담당한다 — 사용자 onChange 는 Form 이 setDivision 으로
        //   보내고, 여기 분기는 '첫 권한 사업부 자동 채움'(Form effect, divisionId='' → 첫 옵션) 같은
        //   프로그램적 경로만 탄다. 그 시점은 mount 직후(clearFilters 완료)라 그리드 초기화가 불필요하다.
        //   하위 콤보 재조회는 Form 의 useTabComboQueries divisionId 키가 담당.
        if (p.divisionId !== undefined && p.divisionId !== get().searchCondition.divisionId) {
          next.operationGroup = initSearch.operationGroup;
          next.fromSite = initSearch.fromSite;
          next.toSite = initSearch.toSite;
          next.transMode = initSearch.transMode;
          next.itemId = initSearch.itemId;
          next.valid = initSearch.valid;
        }
        state.searchCondition = next;
      }),
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division 을 제외한 검색조건 전부 초기화 + 그리드 초기화
    //   (filters clear → useTabProcQuery enabled=false 로 빈 그리드, 재조회는 명시 Search).
    //   이 화면 SearchCondition 에는 기간/날짜 필드가 없어 '유지' 대상은 divisionId 뿐이다
    //   (정본 SCP0025 useShipmentPlanFixStore.setDivision 은 from/toYyyymmdd 를 유지한다).
    //   편집중(dirty) 확인 가드(MSG00704)는 Form 의 Division onChange 가 confirmIfDirtyKey 로 처리한다
    //   (commit 51d4e9fa 패턴) — 취소 시 controlled 콤보가 이전 Division 으로 복귀한다.
    //   주의: 이슈3(2026-10-02 '조회 데이터 유지')은 Division 이 아닌 조회조건 변경에만 적용된다.
    //   Division 은 그리드 전건의 사업부 축이라 바뀌면 남은 데이터가 조건과 불일치한다(TO-BE 공통 요건 우선).
    setDivision: divisionId =>
      set(state => {
        state.searchCondition = { ...initSearch, divisionId };
        state.filters = {}; // 그리드 초기화 — 재조회(Search) 전까지 빈 상태
      }),
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        // GET SP PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE 파라미터 매핑(PROC_M COL_NM 실측, IN 순서):
        //   divisionId, operationGroup, fromSite, toSite, transMode, itemId, valid.
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: orEmpty(c.divisionId),
            operationGroup: orEmpty(c.operationGroup),
            fromSite: orEmpty(c.fromSite),
            toSite: orEmpty(c.toSite),
            transMode: orEmpty(c.transMode),
            itemId: (c.itemId ?? '').trim(),
            valid: orEmpty(c.valid), // ALL->'' (BE 가 NULL 치환, design 02 §5)
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

    // admin SCM_MST_SHEET_COLUMNS 동적 fetch — 미등록/실패 시 빈 배열 유지(그리드 constants fallback).
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] }
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
        // 미등록/실패 = constants fallback (console 금지 룰)
      }
      // 이슈2: 저장된 조회조건 복원(최초 1회). 저장(F6 personalizeCondition)은 되나 복원 경로가 없어
      //   재진입 시 사라지던 것 보완(SCP0001 usePlantSiteStore 동형). 직접 set 이라 division cascade
      //   미발동(복원값 그대로 반영). divisionId 는 Form 의 '첫 권한 사업부' 초기화(!divisionId 조건)보다
      //   우선한다. 실패 시 무시(명시 Search 전까지 조회도 안 나감).
      if (!get().initialized) {
        try {
          const res = await apiClient.get<{ paramNm: keyof SearchCondition; paramCtn: string }[]>(
            `/admin/menu/${MENU_ID}/search-conditions`
          );
          const list = res.data.result ?? [];
          if (list.length > 0) {
            const restored = list.reduce(
              (acc, cur) => ({ ...acc, [cur.paramNm]: cur.paramCtn }),
              {} as Partial<SearchCondition>
            );
            set(state => {
              state.searchCondition = { ...get().searchCondition, ...restored };
            });
          }
        } catch {
          // 복원 실패 무시
        }
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'shipment-lot-size-store'
);
