import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  BUCKET_DEFAULT,
  MEASURE_SHEET_NAME,
  MENU_ID,
  SAVE_DATE_ALIAS,
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
  // 개인화 조회조건 복원 1회 가드 (SubTitle F6 저장분 mount 복원 — initialized 는 컬럼 fetch 전용이라 별도).
  conditionsRestored: boolean;
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
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

// 개인화 조건 복원 시 불리언 역직렬화 키(SubTitle F6 저장은 불리언=String 평문화 — personalizeCondition).
//   Site(fromSite/toSite)는 콤마 문자열 그대로 저장/복원이라 배열키 없음.
const BOOL_KEYS = new Set<string>(['chkAll', 'chkSum']);

// F6 저장 시 날짜키는 별칭(...Ymd)으로 평문화돼 저장된다(GlobalPsi savedParam, 공용 날짜 제외 정규식 회피).
//   복원 때 별칭 → 원래 SearchCondition 키로 역매핑. 그 외 키는 그대로.
const DATE_ALIAS_TO_FIELD: Record<string, string> = Object.fromEntries(
  Object.entries(SAVE_DATE_ALIAS).map(([field, alias]) => [alias, field])
);

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
  chkAll: true, // ALL 체크박스 숨김(GlobalPsiForm) — 조회 시 항상 p_chk_all='Y'(전체) 고정
  chkSum: false, // design 03 §2.2 SUM 컬럼 기본 미표시
  fromYyyymmdd: '',
  toYyyymmdd: '',
});

const makeInitState = (): State => ({
  initialized: false,
  conditionsRestored: false,
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
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division·기간(from/to)을 제외한 검색조건을 전부 초기값으로 되돌리고
    //   그리드도 초기화(filters clear)한다(apply-division-reset — TO-BE 공통 요건이 AS-IS 핸들러보다 우선, 정본 SCP0025).
    //   기간(fromYyyymmdd/toYyyymmdd)은 유지한다 — 이 화면 기간은 Plan Date cascade(selectPlanDate)가 재도출하므로
    //   하위 콤보(Site/PlanDate/Type/Seq/Item/NickName)·표시토글(bucket/chkSum)은 makeInitSearch 로 리셋된다.
    //   편집중(dirty) 확인 가드(MSG00704)는 Form 의 Division onChange 가 confirmIfDirtyKey 로 처리한다(commit 51d4e9fa 패턴) —
    //   이 화면은 read-only 라 실제 dirty 는 없지만 공통 패턴을 동일하게 둔다(SCP0025 선례).
    setDivision: divisionId =>
      set(state => {
        const cur = get().searchCondition;
        state.searchCondition = {
          ...makeInitSearch(), // Division·기간 제외 전 조건 초기화(Site/PlanDate/Type/Seq/Item/NickName/bucket/chkSum)
          divisionId,
          fromYyyymmdd: cur.fromYyyymmdd, // 기간 유지(Plan Date cascade 가 재도출)
          toYyyymmdd: cur.toYyyymmdd,
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
    //   필수: divisionId 는 항상 빈값으로 보낸다. 이 화면의 measure 16행은 전부 DIVISION_ID=NULL(전 division
    //   공통, DB 실측)이고 'Global PSI' 단일 시트다 — AS-IS SCP0031 도 measure 를 division 으로 나누지 않는다.
    //   그런데 공용 SP(PR_GET_SHEET_MEASURE_LIST) 개인화 분기의 division 필터에는 컬럼 SP 와 달리
    //   'OR M.DIVISION_ID IS NULL' 절이 없어, division 을 넘기면 NULL(공통) measure 가 전부 걸러져 빈 결과가 된다.
    //   SP 는 DMF0003/DMF0021 등 division 토큰을 쓰는 화면이 공유하므로 손대지 않고, division 구별이 없는
    //   이 화면만 빈값으로 조회해 'OR P_DIVISION_ID IS NULL' 경로로 16행 전체를 받는다(사용자 결정 2026-10-08).
    fetchStaticMeasures: async () => {
      try {
        const res = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: MEASURE_SHEET_NAME,
          divisionId: '',
        });
        set(state => {
          state.staticMeasures = res.data.result ?? [];
        });
      } catch {
        // 미등록/실패 시 빈 배열 (console 금지 룰)
      }
    },

    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 형제 화면 파리티.
    //   GET /admin/menu/{MENU_ID}/search-conditions → PRAM_NM/PRAM_CTN 역직렬화(불리언 ==='true', 나머지 그대로).
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
        const base = makeInitSearch();
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          // 날짜 별칭(...Ymd)은 원래 키로 역매핑 후 적용(그 외 키는 그대로).
          const key = DATE_ALIAS_TO_FIELD[paramNm] ?? paramNm;
          if (!(key in base)) continue;
          const val = paramCtn ?? '';
          patch[key] = BOOL_KEYS.has(key) ? val === 'true' : val;
        }
        set(state => {
          state.searchCondition = { ...state.searchCondition, ...patch } as SearchCondition;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지)
      }
    },
  }),
  'global-psi-store'
);
