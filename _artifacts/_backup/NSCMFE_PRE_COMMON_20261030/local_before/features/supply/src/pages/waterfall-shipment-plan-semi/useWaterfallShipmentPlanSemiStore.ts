import type { MeasureMeta } from 'features/master/src/components';

import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, BUCKET_TYPE, MENU_ID, SHEETS } from './waterfall-shipment-plan-semi.constants';
import type { SearchParams } from './waterfall-shipment-plan-semi.types';

interface Filters {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.SPREAD_TITLE]?: ProcRequest<MENU_ID, SHEETS.SPREAD_TITLE>;
}

interface WaterfallShipmentPlanSemiState {
  searchParams: SearchParams;
  filters: Filters;
  isOpenSearchArea: boolean;
  staticColumns: RawFlexGridColumnConfig[];
  staticMeasures: MeasureMeta[];
  // 조회 가능 Division 0건 시 조회조건 영역 전체 비활성(01_layout.md §2 트리거C, MSG00097).
  divisionAuthChecked: boolean;
  hasDivisionAuth: boolean;
  // F6(SubTitle searchParam) 개인화 저장분 복원 1회 가드(basic-check #3).
  conditionsRestored: boolean;
}

interface WaterfallShipmentPlanSemiAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParams>) => void;
  /** Division 변경(싱글 콤보) = Division·기간(start/end) 제외 검색조건 전부 초기화 + 그리드 초기화(TO-BE 공통 요건). */
  setDivision: (divisionId: string) => void;
  /** 조회 파라미터 조립 — Bucket/Sum 은 SP 미전달(순수 클라 트리거, §2.4/§3). */
  setFilters: (input: { userId: string }) => boolean;
  /** Division 전환 = 그리드 초기화(§5-5 표준 규약, 이 화면은 조회결과만 비운다 — 편집축 없음). */
  clearData: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: (sheetName: string) => Promise<void>;
  setDivisionAuth: (hasAuth: boolean) => void;
  /** F6 저장조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchParams 패치(진입 1회). */
  restoreSearchConditions: () => Promise<void>;
}

const initSearchParams: SearchParams = {
  divisionId: '',
  operationGroup: '',
  itemId: '',
  electrodeTypes: [],
  bucket: BUCKET_TYPE.DAILY, // AS-IS DefineProperty — cboBucketType.ControlValues = Daily 고정
  versionNos: [],
  startYyyymmdd: '',
  endYyyymmdd: '',
  isSumChecked: false, // AS-IS chkSum InitValue="N"
};

const initState: WaterfallShipmentPlanSemiState = {
  searchParams: initSearchParams,
  filters: {},
  isOpenSearchArea: true,
  staticColumns: [],
  staticMeasures: [],
  divisionAuthChecked: false,
  hasDivisionAuth: true,
  conditionsRestored: false, // F6 저장조건 복원 1회 가드
};

/** 다중선택 → SP 파라미터 — 02_search-combo.md §7#4 구분자 확인 필요(콤마로 잠정, AS-IS 확인 대기). */
const joinMulti = (arr: string[]): string => arr.join(',');

export const useWaterfallShipmentPlanSemiStore = createPersistedStoreWithTab<
  WaterfallShipmentPlanSemiState & WaterfallShipmentPlanSemiAction
>(
  (set, get) => ({
    ...initState,
    reset: () =>
      set(state => {
        state.searchParams = initSearchParams;
        state.filters = {};
        state.isOpenSearchArea = true;
      }),
    setSearchParams: searchParams =>
      set(state => {
        state.searchParams = { ...state.searchParams, ...searchParams };
      }),
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division·기간(start/end) 을 제외한 검색조건을 전부 초기화하고
    //   그리드도 초기화(filters clear)한다(TO-BE 공통 요건이 AS-IS 핸들러보다 우선, SCP0025 선례).
    //   기간(start/end)은 유지한다. 초기화 대상: operationGroup/itemId/electrodeTypes/bucket/versionNos/isSumChecked.
    //   편집중(dirty) 확인 가드(MSG00704)는 Form 의 onChange 가 confirmIfDirtyKey 로 처리한다(commit 51d4e9fa 패턴)
    //   — 이 화면은 read-only 라 실제 dirty 는 없지만 공통 패턴을 동일하게 둔다.
    setDivision: divisionId =>
      set(state => {
        const cur = state.searchParams;
        state.searchParams = {
          ...initSearchParams, // Division·기간 제외 전 조건 초기화(opGroup/item/electrode/bucket/version/sum)
          divisionId,
          startYyyymmdd: cur.startYyyymmdd,
          endYyyymmdd: cur.endYyyymmdd,
        };
        state.filters = {}; // 그리드 초기화 — 재조회(Search) 전까지 빈 상태
      }),
    setFilters: ({ userId }) => {
      let changed = false;
      set(state => {
        const p = state.searchParams;
        // p_sheet_name 파생값 — OperationGroup=='A' ? 'CELL' : 'ELECTRODE' (02_search-combo.md §5 말미,
        //   03_grid-columns.md §4.2 — 고정값 전달 금지).
        const sheetName = p.operationGroup === 'A' ? 'CELL' : 'ELECTRODE';
        const newFilters: Filters = {
          [SHEETS.MAIN]: {
            fromYyyymmdd: p.startYyyymmdd,
            toYyyymmdd: p.endYyyymmdd,
            divisionId: p.divisionId,
            operationGroup: p.operationGroup,
            itemId: p.itemId.trim(),
            versionNo: joinMulti(p.versionNos),
            electype: joinMulti(p.electrodeTypes),
            programId: MENU_ID,
            sheetName,
            userId,
          },
          [SHEETS.SPREAD_TITLE]: {
            startYyyymmdd: p.startYyyymmdd,
            endYyyymmdd: p.endYyyymmdd,
            userId,
          },
        };
        if (JSON.stringify(newFilters) !== JSON.stringify(state.filters)) {
          state.filters = newFilters;
          changed = true;
        }
      });
      return changed;
    },
    clearData: () =>
      set(state => {
        state.filters = {};
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      }),
    // 03_grid-columns.md §5#1 — SCM_MST_SHEET_COLUMNS(PROGRAM_ID='SCP0018') 24행, 하드코딩 금지.
    fetchStaticColumns: async () => {
      try {
        const result = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME }
        );
        set(state => {
          state.staticColumns = result.data.result ?? [];
        });
      } catch {
        /* 메타 미적재 시 빈 배열 유지 — 화면은 fallback 없이 메타 주도 */
      }
    },
    // SCM_MST_SHEET_MEASURE — p_sheet_name(CELL/ELECTRODE) 파생값별 다른 측도 셋(03_grid-columns.md §4.3).
    fetchStaticMeasures: async sheetName => {
      try {
        const result = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: sheetName,
        });
        set(state => {
          state.staticMeasures = result.data.result ?? [];
        });
      } catch {
        /* 미적재 시 빈 배열 유지 — 모달 fallback */
      }
    },
    setDivisionAuth: hasAuth =>
      set(state => {
        state.divisionAuthChecked = true;
        state.hasDivisionAuth = hasAuth;
      }),
    // F6(SubTitle searchParam) 개인화 저장분 복원(진입 1회) — 자매 waterfall-shipment-plan-fg(SCP0016) 파리티(basic-check #3).
    //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 를 searchParams 에 패치한다.
    //   저장측(gridAction.ts personalizeCondition)이 배열→콤마결합·불리언→'true'/'false'로 coerce 하고
    //   기간(start/endYyyymmdd)·빈값은 저장 제외하므로, 복원은 initSearchParams 의 필드 타입으로 역-coerce 한다
    //   (배열=split(',') / 불리언='true' 비교 / 그 외=문자열). 날짜는 응답에 없어 기본값 유지.
    //   주의: setDivision(cascade) 를 거치지 않고 직접 치환 — 저장된 하위조건(version/electrode/bucket 등)을 보존한다.
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
          if (!(paramNm in initSearchParams)) continue; // SearchParams 필드만 allowlist
          const def = initSearchParams[paramNm as keyof SearchParams];
          const value = paramCtn ?? '';
          if (Array.isArray(def)) patch[paramNm] = value === '' ? [] : value.split(',');
          else if (typeof def === 'boolean') patch[paramNm] = value === 'true';
          else patch[paramNm] = value;
        }
        set(state => {
          state.searchParams = { ...state.searchParams, ...(patch as Partial<SearchParams>) };
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지 룰)
      }
    },
  }),
  'waterfall-shipment-plan-semi'
);
