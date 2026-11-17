import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  BTN_DAY_PERIOD,
  BUCKET_TYPE,
  MENU_ID,
  PERIOD_OFFSET_DAY,
  SHEETS,
} from './shipment-plan-fix.constants';
import type { SearchCondition } from './shipment-plan-fix.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  // 개인화 조회조건 복원 1회 가드 (SubTitle F6 저장분 mount 복원 — initialized 는 컬럼 fetch 전용이라 별도).
  conditionsRestored: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // admin SCM_MST_SHEET_COLUMNS('Shipment Plan Fix') 동적 fetch (ui-dynamic-property-management §2.3). 20행 등록 확인.
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
  fetchDayRange: (fromDate: string) => Promise<void>;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

// 개인화 조건 복원 역직렬화 키(SubTitle F6 저장은 배열=콤마join·불리언=String 평문화 — personalizeCondition).
const ARRAY_KEYS = new Set<string>(['electrodeTypes']);
const BOOL_KEYS = new Set<string>(['chkSum']);

const initSearch: SearchCondition = {
  // 기본 division = 빈값 → Form 이 콤보 로드 후 첫 옵션으로 세팅(AS-IS 파리티). AS-IS 는
  //   setListBox(dtDivision, cboDivision, false) 로 콤보 첫 행(ORDER BY ATTRIBUTE1)을 자동선택한다
  //   (cs:190, 세션 division 기본선택 로직 없음). 세션값을 기본으로 쓰면 콤보 첫 행과 달라 AS-IS 와 어긋난다.
  divisionId: '',
  operationGroupId: '',
  electrodeTypes: [],
  bucket: BUCKET_TYPE.DAILY,
  fromYyyymmdd: '',
  toYyyymmdd: '',
  chkSum: false,
  itemId: '',
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.MAIN]: [],
};

const initState: State = {
  initialized: false,
  conditionsRestored: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: emptyStaticColumns,
};

// 다중 선택 배열 → SP 파라미터 문자열. 빈 값은 '' 로 전송해 GET SP 무필터 분기를 태운다('ALL' 센티널 금지 —
//   자매 SCP0024 combo-optional-param-omit-safe-empty-null · scp0020-all-sentinel 실사고 동형).
const joinOrEmpty = (arr: string[]): string => arr.join(',');
const orEmpty = (v: string): string => (v && v.trim() ? v.trim() : '');
const str = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

export const useShipmentPlanFixStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division·기간(from/to)·날짜를 제외한 검색조건을 전부 초기화하고
    //   그리드도 초기화(filters clear)한다(사용자 지시 2026-10-02 — TO-BE 공통 요건이 AS-IS 핸들러보다 우선).
    //   기간(from/to)은 유지한다(mount 시 fetchDayRange 시드값). 편집중(dirty) 확인 가드(MSG00704)는 Form 의 onChange
    //   가 confirmIfDirtyKey 로 처리한다(commit 51d4e9fa 패턴) — 이 화면은 read-only 라 실제 dirty 는 없지만 공통 패턴을 따른다.
    setDivision: divisionId =>
      set(state => {
        const cur = get().searchCondition;
        state.searchCondition = {
          ...initSearch, // Division·기간 제외 전 조건 초기화(opGroup/electrode/bucket/sum/item)
          divisionId,
          fromYyyymmdd: cur.fromYyyymmdd,
          toYyyymmdd: cur.toYyyymmdd,
        };
        state.filters = {}; // 그리드 초기화 — 재조회(Search) 전까지 빈 상태
      }),
    // 메인 GET 파라미터 매핑 (PROC_M COL_NM 실측, ora.py 2026-09-24 — SP IN 순번 주석).
    //   mnuId(7)/sheetName(8)/sesUserId(9) 는 call-proc 엔벨로프·@LoginUser 로 BE 가 자동 주입 → FE 미전달(자매 SCP0024 동형).
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: orEmpty(c.divisionId), // 1 divisionId (단일)
            bizType: orEmpty(c.operationGroupId), // 2 bizType = Operation Group (단일)
            itemId: str(c.itemId), // 3 itemId (빈값=무필터, 콤마 다건)
            fromYyyymmdd: c.fromYyyymmdd.replace(/-/g, ''), // 4 fromYyyymmdd
            toYyyymmdd: c.toYyyymmdd.replace(/-/g, ''), // 5 toYyyymmdd
            electype: joinOrEmpty(c.electrodeTypes), // 6 electype (다중 콤마, 빈값=무필터)
            debugMode: 'F', // 10 debugMode
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
    // admin SCM_MST_SHEET_COLUMNS('Shipment Plan Fix') 동적 fetch — 미등록/실패 시 빈 배열(그리드 constants fallback).
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN,
        });
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
      set(state => {
        state.initialized = true;
      });
    },
    // 기간 기본값 — 공용 PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD 서버 산정(AS-IS GetDayRange(W52), cs:240).
    //   IN fromDate(""=오늘)/offsetDay(363=52*7-1)/timeZone(""=SP 기본), OUT o_rc1 1행 1열 "YYYYMMDD:YYYYMMDD"
    //   (SCM_SYS_CALENDAR_M 기준). dayjs 근사 금지 — 자매 SSP0200 fetchDayRange 1:1. SP/권한 미배포 시 조용히 무시
    //   (사용자가 직접 기간 지정, 근사 대체 안 함). 버튼맵 SCM_ADM_MNU_BTN_MPG_M(SCP0025,main,GET_SCP_DAY_PERIOD).
    fetchDayRange: async fromDate => {
      try {
        const res = await apiClient.post<Record<string, Record<string, string>[]>>(
          `/${MENU_ID}/${SHEETS.MAIN}/${BTN_DAY_PERIOD}/call-proc`,
          { fromDate, offsetDay: PERIOD_OFFSET_DAY, timeZone: '' }
        );
        if (res.status >= 400 || Number(res.data.code)) return;
        const first = res.data.result?.o_rc1?.[0];
        const raw = first ? String(Object.values(first)[0] ?? '') : '';
        const [from, to] = raw.split(':');
        if (!from || !to) return;
        set(state => {
          state.searchCondition = { ...get().searchCondition, fromYyyymmdd: from, toYyyymmdd: to };
        });
      } catch {
        // SP/권한 미배포 시 기간 기본값 없음 — 근사 대체하지 않는다(console 금지 룰).
      }
    },

    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 형제 화면 파리티.
    //   GET /admin/menu/{MENU_ID}/search-conditions → PRAM_NM/PRAM_CTN 역직렬화(배열 split·불리언 ==='true').
    //   저장분 없으면 기본값 유지.
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
        // 미저장/실패 = 기본값 유지 (console 금지)
      }
    },
  }),
  'shipment-plan-fix-store'
);
