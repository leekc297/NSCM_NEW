import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  MEASURE_SHEET_NAME,
  MENU_ID,
  SHEETS,
} from './integration-psi.constants';
import type { SearchCondition } from './integration-psi.types';

// SCM_MST_SHEET_MEASURE 동적 fetch row — /admin/menu/{MENU_ID}/measure (camelCase, ForecastPrice 선례 1:1).
//   주의: BE GridMeasure DTO 는 DISPLAY_FLAG/USER_SELECTABLE_FLAG 를 boolean 으로 직렬화한다
//   (string 'Y'/'N' 로 오선언 시 === 'Y' 비교가 전부 false → Visible measure 0개 사고).
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
  // admin SCM_MST_SHEET_COLUMNS 동적 fetch (ui-dynamic-property-management §2.3). 'Integration PSI' 24행
  //   등록 확인됨(design 03 §0 실측) → 미등록/실패 시 빈 배열(메타 주도 — 하드코딩 fallback 없음).
  staticColumns: StaticColumnsBySheet;
  // SCM_MST_SHEET_MEASURE 동적 fetch (design 03 §1-M 7행). PIVOT measure 세로축. division=81 은 MKT_FCST 제외.
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

// 개인화 조건 복원 역직렬화 키(SubTitle F6 저장은 배열=콤마join·불리언=String 평문화 — personalizeCondition).
//   qtyYn = 체크박스(String(bool) → ==='true'). 그 외 조건(divisionId/nickName/cellItemId/itemId)은 문자열 → 그대로 patch.
//   날짜 키(planStartYyyymmdd/from·toYyyymm)는 저장 측 EXCLUDED_DATE_PARAM(gridAction.ts)으로 저장 자체가
//   제외 → 복원 응답에 없음(makeInitSearch 기본값 '' 유지). 배열(멀티셀렉트) 조건 없음 — divisionId 는 단일 콤보.
const RESTORE_BOOL_KEYS = new Set<string>(['qtyYn']);
// AS-IS ConditionNotUseList(design 02 §4.1 cs:InitControls) — cboPlanDate/cboPlanType 은 조회조건 저장/복원 제외.
//   planStartYyyymmdd(cboPlanDate)는 날짜 키라 저장 측에서 이미 제외되고, planType(cboPlanType)은 비날짜라
//   공용 저장 핸들러가 저장하므로 복원 측에서 명시 제외해 AS-IS 파리티를 맞춘다(cascade 하위 — 재진입 시 재도출).
const RESTORE_SKIP_KEYS = new Set<string>(['planType']);

// 주의: 상수가 아니라 함수다 — 탭 신규 진입마다 빈 검색조건을 새로 만든다.
//   F6 개인화 복원(restoreSearchConditions)이 divisionId 를 패치하면 그 값이 유지된다 — Form 의
//   "옵션에 없을 때만 첫 옵션" 교정 effect 와 충돌하지 않는다(저장해 둔 division 이 우선).
const makeInitSearch = (): SearchCondition => ({
  // division 초기값은 **비운다**. AS-IS 는 Form_Load 에서 `clsCtrl.setListBox(dtDivision, cboDivision,
  //   false, "CODE","NAME")`(cs:235) 로 DataSource 만 바인딩하고 명시 지정(cs:237 `ControlValues = "81"`)은
  //   주석 처리돼 있어 **조회된 division 목록의 첫 항목이 자동선택**된다. 세션 div(`session.div ?? '40'`)로
  //   초기화하면 그 값이 옵션에 존재하는 한 교정 effect 가 걸리지 않아 Div 가 40 에 고정된다(사용자 신고 2026-10-12).
  //   빈 값은 Form 의 "옵션에 없으면 첫 옵션" effect 가 첫 division 으로 채운다.
  //   메타 fetch 영향 없음 — 컬럼/measure 메타는 DIVISION_ID IS NULL 이고 SP 필터가
  //   `P_DIVISION_ID IS NULL OR C.DIVISION_ID IS NULL OR ...`(PKG_NSCM_UI_COM_MENU BODY L168/218/391) 다.
  divisionId: '',
  planStartYyyymmdd: '',
  planType: '',
  fromYyyymm: '',
  toYyyymm: '',
  qtyYn: false, // design 02 §4.2 미체크(N)
  nickName: '',
  cellItemId: '',
  itemId: '',
});

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.MAIN]: [],
};

const makeInitState = (): State => ({
  initialized: false,
  conditionsRestored: false,
  searchCondition: makeInitSearch(),
  filters: {},
  openSearchArea: true,
  staticColumns: emptyStaticColumns,
  staticMeasures: [],
});

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
const orEmpty = (v: string): string => (v && v.trim() ? v.trim() : '');

export const useIntegrationPsiStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...makeInitState(),
    reset: () => set(makeInitState()),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division 을 제외한 검색조건을 전부 초기 상수값으로 되돌리고
    //   그리드도 초기화(filters clear)한다(SCP0025 setDivision 1:1, 사용자 지시 2026-10-02 — TO-BE 공통 요건 우선).
    //   이 화면은 기간(from/to)·PlanDate 가 Division→PlanDate→Month cascade 의 하위라 기간도 함께 '' 로 리셋된다
    //   (design 02 §3·§5.2 — 기간이 Division 종속이므로 "기간 유지" 예외 대상이 아니다). makeInitSearch 로 교체하면
    //   cascade 하위(PlanDate/PlanType/기간) + 팝업/텍스트(nickName/cellItemId/itemId) + qtyYn 이 전부 초기화된다.
    //   편집중(dirty) 확인 가드(MSG00704)는 Form 의 onChange 가 confirmIfDirtyKey 로 처리한다(commit 51d4e9fa 패턴).
    setDivision: divisionId =>
      set(state => {
        state.searchCondition = {
          ...makeInitSearch(), // Division 제외 전 조건 초기화(planDate/planType/기간/nick/cellItem/item/qty)
          divisionId,
        };
        state.filters = {}; // 그리드 데이터 clear (design 02 §5.2 division 변경 = Grid 초기화)
      }),
    // 메인 GET 10-param 매핑 (design 02 §4.4 — SP IN 순번 주석). p_plan_type/p_seq "" 고정.
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: orEmpty(c.divisionId), //  1 p_division_id
            planStartYyyymmdd: orEmpty(c.planStartYyyymmdd), //  2 p_plan_start_yyyymmdd
            planType: '', //  3 p_plan_type ("" 고정 — design 02 §4.4 cs:878)
            seq: '', //  4 p_seq ("" 고정 — cs:879)
            fromYyyymm: orEmpty(c.fromYyyymm), //  5 p_from_yyyymm
            toYyyymm: orEmpty(c.toYyyymm), //  6 p_to_yyyymm
            // 7 p_nick_name — **공백 고정**. Model/Nickname 입력칸 통합(사용자 지시 2026-10-12)으로 값은
            //   itemId 한 축으로만 보낸다. SP 가 nick 과 item 을 **AND** 로 걸기 때문이다
            //   (PKG_SCP0111 BODY L317~319 nick / L324~326 item) — 같은 문자열을 양쪽에 넣으면
            //   "코드도 같고 닉네임도 같은 행"을 요구해 0건이 된다. store 의 nickName 은 F6 복원 등으로
            //   잔여값이 남을 수 있어 참조하지 않고 '' 를 못박는다.
            nickName: '',
            cellItemId: str(c.cellItemId), //  8 p_cellitem_id
            itemId: str(c.itemId), //  9 p_item_id (= Model/Nickname 입력칸)
            qtyYn: c.qtyYn ? 'Y' : 'N', // 10 p_qty_yn (음수 아이템만 조회)
          },
        };
      });
    },
    // Division 전환 시 그리드 초기화 — filters 를 비우면 useTabProcQuery enabled=false 로 이전 응답이 즉시 사라진다.
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),
    // admin SCM_MST_SHEET_COLUMNS('Integration PSI') 동적 fetch — 미등록/실패 시 빈 배열(메타 주도, console 금지 룰).
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN, divisionId: get().searchCondition.divisionId }
        );
        // 주의: BE 가 200 으로 result:null 을 줄 수 있어 `?? []` 필수(ForecastPrice division 81 실측).
        const next = res.data.result ?? [];
        set(state => {
          if (JSON.stringify(state.staticColumns[SHEETS.MAIN]) !== JSON.stringify(next)) {
            state.staticColumns[SHEETS.MAIN] = next;
          }
        });
      } catch {
        // 미등록/실패 = 빈 배열 유지 (console 금지 룰)
      }
      set(state => {
        state.initialized = true;
      });
    },
    // SCM_MST_SHEET_MEASURE('Integration PSI') 동적 fetch — measure 7종(design 03 §1-M). 실패 시 빈 배열.
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
        // SCM_MST_SHEET_MEASURE 미등록/실패 시 빈 배열 (console 금지 룰)
      }
    },
    // 개인화 조회조건 복원(mount 1회) — SubTitle F6 저장분을 GET 으로 받아 searchCondition 에 역직렬화 패치.
    //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn(불리언 ==='true', 그 외 문자열).
    //   저장분 없거나 조회 실패면 기본값 유지. 저장은 EXCLUDED_DATE_PARAM·빈값 필터 후 재삽입이라
    //   (gridAction.ts personalizeCondition) 응답에 없는 키는 makeInitSearch 기본값 그대로 둔다.
    //   새로고침 = 새 store 라 conditionsRestored=false 로 재복원(global-psi-elec/scp-bom 파리티).
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
          if (RESTORE_SKIP_KEYS.has(paramNm)) continue; // AS-IS ConditionNotUseList 제외(planType)
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
  'integration-psi-store'
);
