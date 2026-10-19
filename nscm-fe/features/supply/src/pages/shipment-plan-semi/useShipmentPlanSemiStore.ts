import type { MeasureMeta } from 'features/master/src/components';

import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  BUCKET_TYPE,
  MEASURE_SHEET_NAME,
  MENU_ID,
  SHEETS,
} from './shipment-plan-semi.constants';
import type { SearchCondition } from './shipment-plan-semi.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.CALENDAR]?: ProcRequest<MENU_ID, SHEETS.CALENDAR>;
};

interface State {
  initialized: boolean;
  // 개인화 조회조건 복원 1회 가드 — SubTitle F6 저장분 GET → searchCondition 패치(중복 복원 방지).
  conditionsRestored: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  staticColumns: RawFlexGridColumnConfig[];
  // Measure 세트는 OperationGroup 값(A=CELL, 그외=ELECTRODE)에 따라 분기(design 03 §0.1) — sheetNm 별 캐시.
  staticMeasures: Record<'CELL' | 'ELECTRODE', MeasureMeta[]>;
  // 조회 실행 시점의 스냅샷 — 편집잠금(BOD 판정)은 "마지막 조회" 기준을 유지(design 03 §3.1).
  appliedDivisionId: string;
  appliedPlanStartYyyymmdd: string;
  appliedToYyyymmdd: string;
  // 저장 payload(design 03 §4.4)의 p_plan_type/p_seq — 행(row) 에는 이 값이 없다(MAIN_COLUMNS
  //   27건 어디에도 plan_type/seq 컬럼이 없음, 한 화면 조회결과는 항상 단일 Plan 이므로 조회조건
  //   스냅샷에서만 구할 수 있다). appliedDivisionId 와 동일하게 setFilter() 시점에 고정.
  appliedPlanType: string;
  appliedPlanSeq: string;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setDivision: (divisionId: string) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: (group: 'CELL' | 'ELECTRODE') => Promise<void>;
  // 개인화 조회조건 복원 — GET /admin/menu/SCP0010/search-conditions → searchCondition 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

const initSearch: SearchCondition = {
  divisionId: '',
  operationGroupId: '',
  fromSiteIds: [],
  toSiteIds: [],
  electrodeTypeIds: [],
  planStartYyyymmdd: '',
  planType: '',
  planSeq: '',
  fromYyyymmdd: '',
  toYyyymmdd: '',
  itemId: '',
  bucketType: BUCKET_TYPE.DAILY, // AS-IS 기본값 Daily(cs L277 cboBucketType.ControlValues = BucketType.Daily)
  chkSum: false,
};

// 개인화 조건 복원 역직렬화 키 — SubTitle F6 저장은 배열=콤마join·불리언=String 평문화(personalizeCondition).
//   plan date(planStartYyyymmdd)는 conditionIncludeKeys opt-in 으로 저장/복원된다(사용자 요청 2026-10-13) —
//   restore 가 이 값을 채우면 Form 자동선택(최신 date)이 덮지 않아 저장값대로 복원되고, planType/planSeq
//   (날짜형 아님 → 이미 저장됨)와 함께 3단이 일관된다. 기간(from/to Yyyymmdd)은 여전히 저장 제외 —
//   plan date 변경 시 Form effect 가 W52 로 재계산하므로 복원 불요.
const ARRAY_KEYS = new Set<string>(['fromSiteIds', 'toSiteIds', 'electrodeTypeIds']);
const BOOL_KEYS = new Set<string>(['chkSum']);

const initState: State = {
  initialized: false,
  conditionsRestored: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: [],
  staticMeasures: { CELL: [], ELECTRODE: [] },
  appliedDivisionId: '',
  appliedPlanStartYyyymmdd: '',
  appliedToYyyymmdd: '',
  appliedPlanType: '',
  appliedPlanSeq: '',
};

const joinOrAll = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join(','));
const orAll = (v: string): string => (v && v.trim() ? v.trim() : 'ALL');

export const useShipmentPlanSemiStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    // F10(검색조건 초기화)은 저장된 조회조건만 되돌리고, 조회되어 있던 그리드는 유지한다(사용자 요청
    //   2026-10-13). 그리드는 filters(조회 payload → useTabProcQuery) 와 applied* 스냅샷(날짜 헤더)에서
    //   나오므로 이 둘을 보존하고 나머지(searchCondition·openSearchArea 등)만 initState 로 되돌린다.
    //   그리드 초기화는 Division 변경(setDivision)이 담당한다 — F10 소관이 아니다. 전역
    //   PRESERVED_ON_CONDITION_RESET 에 filters 를 넣는 전역화는 불가(리포트형 화면은 Division cascade 가
    //   없어 F10 이 그리드를 영영 안 비우게 됨) — 화면별 reset 보존이 정답(f10-reset 메모리).
    reset: () =>
      set(state => {
        const {
          filters,
          appliedDivisionId,
          appliedPlanStartYyyymmdd,
          appliedToYyyymmdd,
          appliedPlanType,
          appliedPlanSeq,
        } = get();
        Object.assign(state, initState, {
          filters,
          appliedDivisionId,
          appliedPlanStartYyyymmdd,
          appliedToYyyymmdd,
          appliedPlanType,
          appliedPlanSeq,
        });
      }),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division·기간(from/to)을 제외한 검색조건을 전부 초기화하고
    //   그리드도 초기화(filters clear)한다 — TO-BE 공통 요건이 AS-IS 하위콤보 cascade 초기화(design 02 §6)보다
    //   넓다(opGroup/site/electrode/plan*·item/bucket/sum 까지 초기 상수값으로). 기간(from/to)은 유지한다.
    //   편집중(dirty) 확인 가드(MSG00704)는 Form 의 onChange 가 confirmIfDirtyKey 로 처리한다(commit 51d4e9fa
    //   패턴) — 편집가능 그리드라 DataGrid 가 dirty 판정·되돌리기를 자동 등록하므로 여기선 trigger(filters)만 비운다.
    setDivision: divisionId =>
      set(state => {
        const cur = get().searchCondition;
        state.searchCondition = {
          ...initSearch, // Division·기간 제외 전 조건 초기화
          divisionId,
          fromYyyymmdd: cur.fromYyyymmdd,
          toYyyymmdd: cur.toYyyymmdd,
        };
        state.filters = {}; // 그리드 초기화 — 재조회(Search) 전까지 빈 상태
      }),
    // 조회조건 -> GET SP 파라미터(15개, design 02 §2.9 P_SCP0010_GET_SHIP_PLAN_SEMI 순번 근거 주석).
    setFilter: () => {
      const c = get().searchCondition;
      // p_sheet_name — cboOperGroup=='A'(Cell) 면 CELL, 그 외(P/E) 면 ELECTRODE(design 02 §2.9,
      //   design 03 §0.1 — Pack 선택 시에도 ELECTRODE 로 가는 것이 AS-IS 그대로, 사용자 확인 필요 항목).
      const sheetName = c.operationGroupId === 'A' ? 'CELL' : 'ELECTRODE';
      set(state => {
        state.filters = {
          ...state.filters,
          [SHEETS.MAIN]: {
            fromYyyymmdd: c.fromYyyymmdd, // P_FROM_YYYYMMDD
            toYyyymmdd: c.toYyyymmdd, // P_TO_YYYYMMDD
            divisionId: orAll(c.divisionId), // P_DIVISION_ID
            operationGroup: orAll(c.operationGroupId), // P_OPERATION_GROUP
            itemId: orAll(c.itemId), // P_ITEM_ID
            electype: joinOrAll(c.electrodeTypeIds), // P_ELECTYPE
            planStartYyyymmdd: c.planStartYyyymmdd, // P_PLAN_START_YYYYMMDD
            planType: c.planType, // P_PLAN_TYPE
            seq: c.planSeq, // P_SEQ
            fromsite: joinOrAll(c.fromSiteIds), // P_FROMSITE
            tosite: joinOrAll(c.toSiteIds), // P_TOSITE
            programId: MENU_ID, // P_PROGRAM_ID
            // P_SHEET_NAME — Measure 레지스트리(SCM_MST_SHEET_MEASURE) 필터용 CELL/ELECTRODE.
            //   admin 컬럼메타 SHEET_NAME('Shipment Plan SEMI')이 아니다(PKG_SCP0010 PACKAGE BODY
            //   L2122,2172-2196 실측 — 컬럼메타 값을 넣으면 GT_SCP0010_MEASURE 가 항상 0행이 돼
            //   메인 그리드(O_RC1)가 항상 0행으로 나온다, iter-1 gap-audit SCP0010-G-01).
            sheetName,
            sesUserId: useSessionStore.getState().session.userId ?? '', // P_USER_ID(SCM_ADM_PROC_M COL_NM=sesUserId)
            debugMode: 'F', // P_DEBUG_MODE
          },
        };
        state.filters[SHEETS.CALENDAR] = {
          // SCM_ADM_PROC_M(PROC_NM=PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN) 등록 COL_NM은
          //   startYyyymmdd/endYyyymmdd — fromYyyymmdd/toYyyymmdd 로 보내면 name-lookup 바인딩이
          //   NULL 처리되어 헤더(D_/W_/M_) 0열이 된다(iter-1 gap-audit SCP0010-G-02).
          startYyyymmdd: c.fromYyyymmdd,
          endYyyymmdd: c.toYyyymmdd,
        };
        state.appliedDivisionId = c.divisionId;
        state.appliedPlanStartYyyymmdd = c.planStartYyyymmdd;
        state.appliedToYyyymmdd = c.toYyyymmdd;
        state.appliedPlanType = c.planType;
        state.appliedPlanSeq = c.planSeq;
      });
      // Measure 레지스트리는 sheetName(CELL/ELECTRODE) 이 조회조건 값에 종속되므로 조회 시점에 fetch.
      void get().fetchStaticMeasures(sheetName);
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN,
        });
        const next = res.data.result ?? [];
        if (next.length > 0) {
          set(state => {
            if (JSON.stringify(state.staticColumns) !== JSON.stringify(next)) {
              state.staticColumns = next;
            }
          });
        }
      } catch {
        // 미등록/실패 = constants fallback(console 금지 룰)
      }
      set(state => {
        state.initialized = true;
      });
    },
    fetchStaticMeasures: async group => {
      try {
        const res = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: MEASURE_SHEET_NAME[group],
        });
        const next = res.data.result ?? [];
        set(state => {
          state.staticMeasures = { ...state.staticMeasures, [group]: next };
        });
      } catch {
        // 미등록/실패 = 빈 배열 유지(그리드는 MEASURE 코드 원본 순서로 표시)
      }
    },
    // 개인화 조회조건 복원 — SubTitle F6(personalizeCondition) 저장분을 GET 해 searchCondition 에 1회 패치.
    //   저장은 배열=콤마join·불리언=String 평문화라 역직렬화한다. 날짜 키는 저장 제외라 복원 대상 아님
    //   (planDate/Period 는 Form 자동선택이 채운다). 저장분 없으면 기본값 유지. 자매 SCP0009 와 동일 패턴.
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
          if (!(paramNm in initSearch)) continue;
          const val = paramCtn ?? '';
          if (ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else if (BOOL_KEYS.has(paramNm)) patch[paramNm] = val === 'true';
          else patch[paramNm] = val;
        }
        set(state => {
          state.searchCondition = { ...state.searchCondition, ...patch } as SearchCondition;
        });
      } catch {
        // 미저장/실패 = 기본값 유지(console 금지)
      }
    },
  }),
  'shipment-plan-semi-store'
);
