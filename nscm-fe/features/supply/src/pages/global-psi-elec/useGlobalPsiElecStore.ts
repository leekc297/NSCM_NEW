import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  BUCKET_DEFAULT,
  MEASURE_SHEET_NAME,
  MENU_ID,
  PLAN_TYPE_DEFAULT,
  SHEETS,
} from './global-psi-elec.constants';
import type { SearchCondition } from './global-psi-elec.types';

// SCM_MST_SHEET_MEASURE 동적 fetch row — /admin/menu/{MENU_ID}/measure (camelCase, 자매 SCP0100 1:1).
//   주의: BE GridMeasure DTO 는 display/personalizable 를 boolean 으로 직렬화한다(string 'Y' 오선언 금지).
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
  //   design 03 §1 실측 14행(전열 INPUT_TP_CD='S' 잠금, PLANT_ID 숨김, VALUE2 고정열).
  staticColumns: RawFlexGridColumnConfig[];
  // SCM_MST_SHEET_MEASURE 동적 fetch(SHEET_NAME='Global PSI Elec' 10행, DB 실측). measure 개인화 팝업 원천.
  //   사용자 지시 2026-10-15: AS-IS/자매 SCP0100 처럼 measure 설정 팝업을 노출 — iter-1 G6 의 "measure UI 無"
  //   판정을 뒤집는다(DB MNU_BTN 에 MEASURE_SELECT 등록 필요, 05_register.sql). 자매 SCP0100 패턴 이식.
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
  // measure 메타 동적 fetch — 개인화 팝업 저장(titleSet 'M') 후 refetch 로 반영(자매 SCP0100 동형).
  fetchStaticMeasures: () => Promise<void>;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

// 개인화 조건 복원 역직렬화 키(SubTitle F6 저장은 배열=콤마join·불리언=String 평문화 — personalizeCondition).
//   company 는 다중선택이나 CSV 문자열 필드(SearchCondition.company: string)라 배열 역직렬화 불요 — 그대로 patch.
//   chkSum = 체크박스(String(bool) → ==='true'). 날짜 키(planStartYyyymmdd/from·toYyyymmdd)는 저장 측
//   EXCLUDED_DATE_PARAM(gridAction.ts) 으로 저장 자체가 제외 → 복원 응답에 없음(초기값 유지).
const RESTORE_BOOL_KEYS = new Set<string>(['chkSum']);

// 주의: 상수가 아니라 함수 — 모듈 최상위로 굳히면 청크 최초 로드 시점 session.div 로 얼어붙어
//   재로그인 시 앞 계정 division 이 고정된다(global-psi-report makeInitSearch 규약 동일).
const makeInitSearch = (): SearchCondition => ({
  divisionId: '', // Division 기본선택 없음. Form 이 권한 목록 로드 후 첫 EE division 자동선택(firstDivision effect).
  company: '',
  itemId: '',
  planStartYyyymmdd: '', // Form 이 목록 로드 후 첫 Plan-date 자동선택(firstPlanDate effect) + Period 파생.
  planType: PLAN_TYPE_DEFAULT, // Report Type* 기본 'FN'(AS-IS). p_plan_type 로 실림(SP 필터, 빈값이면 결과 0).
  fromYyyymmdd: '',
  toYyyymmdd: '',
  bucket: BUCKET_DEFAULT, // design 02 §4.2 cboBucketType.SelectedValue=Weekly
  chkSum: false, // AS-IS Visible=false 미노출(design 03 §2.2)
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

export const useGlobalPsiElecStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...makeInitState(),
    reset: () => set(makeInitState()),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division 을 제외한 검색조건을 전부 초기 상수값으로 되돌리고
    //   그리드도 초기화(filters clear)한다(commit 51d4e9fa 패턴, SCP0025 선례 — TO-BE 공통 요건이 AS-IS 보다 우선).
    //   Bucket/SUM(chkSum)도 초기값으로 되돌린다(skill §2: OperationGroup/Electrode/Bucket/SUM/Item 전부 초기화).
    //   이 화면의 기간/날짜 필드(planStartYyyymmdd·from/to)는 SCP0025 의 독립 기간과 달리 Division→Plan-date
    //   cascade 로 파생되므로(DATE_WEEKLY @divisionId 재조회) 유지가 아니라 초기화한다 — 이전 값이 새 division 에서 무효.
    //   편집중(dirty) MSG00704 가드는 Form onChange 의 confirmIfDirtyKey 가 처리한다(read-only 라 실제 dirty 는 없음).
    setDivision: divisionId =>
      set(state => {
        state.searchCondition = { ...makeInitSearch(), divisionId };
        state.filters = {}; // division 변경 = Grid 초기화(design 02 §3, hook #5)
      }),
    // 메인 GET 11-param 매핑(design 02 §5 + PROC_M 실측 camelCase). 각 줄 SP IN 순번 주석.
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: orEmpty(c.divisionId), //  1 divisionId
            company: str(c.company), //  2 company (값=COMPANY_NAME)
            itemId: str(c.itemId), //  3 itemId
            yyyymmdd: orEmpty(c.planStartYyyymmdd), //  4 yyyymmdd (Plan-date)
            fromYyyymmdd: orEmpty(c.fromYyyymmdd), //  5 fromYyyymmdd (Period)
            toYyyymmdd: orEmpty(c.toYyyymmdd), //  6 toYyyymmdd (Period)
            planType: orEmpty(c.planType), //  7 planType (Report Type* — SP 가 A.PLAN_TYPE=UPPER(P_PLAN_TYPE) 필터)
            programId: MENU_ID, //  8 programId = 'SCP0095'
            sheetName: ADMIN_SHEET_NAME[SHEETS.MAIN], //  9 sheetName = 'Global PSI Elec'
            userId: str(useSessionStore.getState().session.userId), // 10 userId(BE @LoginUser 도 주입)
            debugMode: 'F', // 11 debugMode
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
        // 주의: BE 가 200 으로 result:null 을 줄 수 있어 ?? [] 필수(global-psi-report division 실측).
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
    // measure 메타 동적 fetch — SCM_MST_SHEET_MEASURE(SHEET_NAME='Global PSI Elec'). 미등록/실패 시 빈 배열.
    //   저장(titleSet 'M') 후 재조회로 개인화 표시/순서 반영(자매 SCP0100 fetchStaticMeasures 동형).
    fetchStaticMeasures: async () => {
      try {
        const res = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: MEASURE_SHEET_NAME,
          // divisionId: get().searchCondition.divisionId,
          // measure 시트는 Division 무관 1벌. Division 을 실으면 저장 후 재조회가 0건이라 빈값 고정(2026-10-21)
          divisionId: '',
        });
        set(state => {
          state.staticMeasures = res.data.result ?? [];
        });
      } catch {
        // SCM_MST_SHEET_MEASURE 미등록/실패 시 빈 배열 (console 금지 룰)
      }
    },
    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 정본 scp-bom(SCP0053)·shipment-plan-fix 파리티.
    //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 역직렬화(불리언 ==='true', 그 외 문자열).
    //   저장분 없거나 조회 실패면 기본값 유지. 저장은 EXCLUDED_DATE_PARAM·빈값 필터 후 재삽입이라
    //   (gridAction.ts personalizeCondition) 응답에 없는 키는 initSearch 기본값 그대로 둔다.
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
        const init = makeInitSearch();
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in init)) continue; // SearchCondition 필드만 allowlist
          const val = paramCtn ?? '';
          if (RESTORE_BOOL_KEYS.has(paramNm)) patch[paramNm] = val === 'true';
          else patch[paramNm] = val;
        }
        set(state => {
          state.searchCondition = { ...state.searchCondition, ...patch } as SearchCondition;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지 룰)
      }
    },
  }),
  'global-psi-elec-store'
);
