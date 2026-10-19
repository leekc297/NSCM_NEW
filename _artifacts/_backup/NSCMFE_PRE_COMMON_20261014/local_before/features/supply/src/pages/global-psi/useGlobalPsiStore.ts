import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  BUCKET_DEFAULT,
  MEASURE_SHEET_NAME,
  MENU_ID,
  SHEETS,
  SITE_SENTINEL,
} from './global-psi.constants';
import type { SearchCondition } from './global-psi.types';

// SCM_MST_SHEET_MEASURE 동적 fetch row — /admin/menu/{MENU_ID}/measure (camelCase, 자매 SCP0100 1:1).
//   주의: BE GridMeasure DTO 는 display/personalizable 를 boolean 으로 직렬화한다.
export interface MeasureMeta {
  colNm: string;
  colLblNm?: string;
  sClsLblNm?: string;
  display?: boolean;
  personalizable?: boolean;
  sortOrd?: number;
}

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // admin SCM_MST_SHEET_COLUMNS 동적 fetch(convert-core §2.4 하드코딩 금지). 미등록/실패 시 빈 배열.
  //   design 03 §1 실측 19행(가시15/hidden4). 전열 INPUT_TP_CD='S' 잠금(읽기전용). FIXED_FLAG='Y'=measure_label 1.
  staticColumns: RawFlexGridColumnConfig[];
  // SCM_MST_SHEET_MEASURE 동적 fetch(design 03 §1-C 'Global PSI' 16행). PIVOT measure 세로축.
  //   USER_SELECTABLE 8건은 Measure 설정 팝업(btnMeasure)으로 on/off. 자매 SCP0100 과 동일 개인화 경로.
  staticMeasures: MeasureMeta[];
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setDivision: (divisionId: string) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: () => Promise<void>;
}

// 주의: 상수가 아니라 함수 — 모듈 최상위로 굳히면 청크 최초 로드 시점 session.div 로 얼어붙어
//   재로그인 시 앞 계정 division 이 고정된다(global-psi-elec makeInitSearch 규약 동일).
const makeInitSearch = (): SearchCondition => ({
  divisionId: '', // Division 기본선택 없음 — Form 이 권한 목록 로드 후 첫 옵션(정렬 후 최소 CODE)으로 교정(design 02 §4.2)
  itemId: '',
  nickName: '',
  fromSite: '',
  toSite: '',
  planStartYyyymmdd: '',
  planType: '',
  planSeq: '',
  bucket: BUCKET_DEFAULT, // design 02 §4.2 cboBucketType 기본 DAILY
  chkAll: false, // design 02 §1 chkAll 기본 미체크(p_chk_all='N')
  chkSum: false, // design 03 §2.2 SUM 컬럼 기본 미표시
  fromYyyymmdd: '',
  toYyyymmdd: '',
});

const makeInitState = (): State => ({
  initialized: false,
  searchCondition: makeInitSearch(),
  filters: {},
  openSearchArea: true,
  staticColumns: [],
  staticMeasures: [],
});

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
const orEmpty = (v: string): string => (v && v.trim() ? v.trim() : '');
// Site 다중선택 — 미선택 센티넬('-')·'ALL' 은 빈값으로(SP 전체 우회, design 02 §4.2). 콤마 조인 유지.
const siteParam = (v: string): string => {
  const codes = str(v)
    .split(',')
    .map(c => c.trim())
    .filter(c => c && c !== SITE_SENTINEL && c.toUpperCase() !== 'ALL');
  return codes.join(',');
};

export const useGlobalPsiStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...makeInitState(),
    reset: () => set(makeInitState()),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // division 변경 = 하위 cascade 초기화(design 02 §3) + 그리드 clear. Site/PlanDate/Type/Seq/Item 리셋.
    //   트리거 상태 재현(CLAUDE.local §6) — division 변경 시 하위 전부 재도출.
    setDivision: divisionId =>
      set(state => {
        state.searchCondition = {
          ...get().searchCondition,
          divisionId,
          fromSite: '',
          toSite: '',
          planStartYyyymmdd: '',
          planType: '',
          planSeq: '',
          itemId: '',
          fromYyyymmdd: '',
          toYyyymmdd: '',
        };
        state.filters = {}; // division 변경 = Grid 초기화(design 02 §3, hook #5)
      }),
    // 메인 GET 16-param 매핑(design 02 §5.3 + SP arg 실측 camelCase). 각 줄 SP IN 순번 주석. 명시 매핑(spread 아님).
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          [SHEETS.MAIN]: {
            fromYyyymmdd: orEmpty(c.fromYyyymmdd), //  1 p_from_yyyymmdd
            toYyyymmdd: orEmpty(c.toYyyymmdd), //  2 p_to_yyyymmdd
            divisionId: orEmpty(c.divisionId), //  3 p_division_id
            itemId: str(c.itemId), //  4 p_item_id
            nickName: str(c.nickName), //  5 p_nick_name
            fromSite: siteParam(c.fromSite), //  6 p_from_site (ALL/'-'→'')
            toSite: siteParam(c.toSite), //  7 p_to_site (ALL/'-'→'')
            planStartYyyymmdd: orEmpty(c.planStartYyyymmdd), //  8 p_plan_start_yyyymmdd
            planType: orEmpty(c.planType), //  9 p_plan_type
            seq: orEmpty(c.planSeq), // 10 p_seq
            programId: MENU_ID, // 11 p_program_id = 'SCP0031'
            sheetName: ADMIN_SHEET_NAME[SHEETS.MAIN], // 12 p_sheet_name = 'Global PSI'
            userId: str(useSessionStore.getState().session.userId), // 13 p_user_id(BE @LoginUser 도 주입)
            bucket: orEmpty(c.bucket), // 14 p_bucket
            chkAll: c.chkAll ? 'Y' : 'N', // 15 p_chk_all
            debugMode: 'F', // 16 p_debug_mode
          },
        };
      });
    },
    // Division/PlanDate 변경 시 그리드 초기화 — filters 를 비우면 useTabProcQuery enabled=false 로 응답 소거.
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),
    // admin SCM_MST_SHEET_COLUMNS 동적 fetch — 미등록/실패 시 빈 배열(메타 주도, console 금지 룰).
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN], divisionId: get().searchCondition.divisionId }
        );
        // 주의: BE 가 200 으로 result:null 을 줄 수 있어 ?? [] 필수.
        const next = res.data.result ?? [];
        set(state => {
          // 참조 안정성 — 동일 내용이면 교체하지 않아 Wijmo 컬럼 재생성을 유발하지 않는다.
          if (JSON.stringify(state.staticColumns) !== JSON.stringify(next)) {
            state.staticColumns = next;
          }
          state.initialized = true;
        });
      } catch {
        set(state => {
          state.initialized = true;
        });
      }
    },
    // SCM_MST_SHEET_MEASURE('Global PSI') 동적 fetch — measure 16종(design 03 §1-C). 실패 시 빈 배열.
    fetchStaticMeasures: async () => {
      try {
        const res = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: MEASURE_SHEET_NAME,
          divisionId: get().searchCondition.divisionId,
        });
        set(state => {
          state.staticMeasures = res.data.result ?? [];
        });
      } catch {
        // 미등록/실패 시 빈 배열 (console 금지 룰)
      }
    },
  }),
  'global-psi-store'
);
