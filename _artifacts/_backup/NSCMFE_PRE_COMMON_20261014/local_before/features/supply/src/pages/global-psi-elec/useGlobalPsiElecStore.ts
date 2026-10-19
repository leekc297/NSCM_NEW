import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, BUCKET_DEFAULT, MENU_ID, SHEETS } from './global-psi-elec.constants';
import type { SearchCondition } from './global-psi-elec.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // admin SCM_MST_SHEET_COLUMNS 동적 fetch(convert-core §2.4 하드코딩 금지). 미등록/실패 시 빈 배열.
  //   design 03 §1 실측 14행(전열 INPUT_TP_CD='S' 잠금, PLANT_ID 숨김, VALUE2 고정열).
  staticColumns: RawFlexGridColumnConfig[];
  // 주의: staticMeasures/fetchStaticMeasures 는 두지 않는다 — AS-IS SCP0095 는 measure 표시선택 UI 가 없고
  //   (SubTitle SEARCH 단일), 표시 measure 는 메인 SP 가 서버측에서 SCM_MST_SHEET_MEASURE.VALID_YN='Y' 로
  //   확정한다(AS-IS SP L129 실측). FE measure 메타 fetch 는 소비처 0 인 dead wiring 이라 제거(iter-1 gap-audit G6,
  //   convert-core §4.2 util 참조 0건 게이트). measure 개인화가 있는 자매 SCP0100(global-psi-report)과 다르다.
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

// 주의: 상수가 아니라 함수 — 모듈 최상위로 굳히면 청크 최초 로드 시점 session.div 로 얼어붙어
//   재로그인 시 앞 계정 division 이 고정된다(global-psi-report makeInitSearch 규약 동일).
const makeInitSearch = (): SearchCondition => ({
  divisionId: '', // Division 기본선택 없음(design 02 §4). Form 이 권한 목록 로드 후 첫 EE division 으로 교정.
  company: '',
  itemId: '',
  planStartYyyymmdd: '',
  fromYyyymmdd: '',
  toYyyymmdd: '',
  bucket: BUCKET_DEFAULT, // design 02 §4.2 cboBucketType.SelectedValue=Weekly
  chkSum: false, // AS-IS Visible=false 미노출(design 03 §2.2)
});

const makeInitState = (): State => ({
  initialized: false,
  searchCondition: makeInitSearch(),
  filters: {},
  openSearchArea: true,
  staticColumns: [],
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
    // division 변경 = 하위 cascade 초기화(design 02 §3) + 그리드 clear. PlanDate/Company/Item 리셋.
    //   Company 는 정적(division 무관)이나 선택값 초기화는 AS-IS SetChangedControl 재적재 등가.
    setDivision: divisionId =>
      set(state => {
        state.searchCondition = {
          ...get().searchCondition,
          divisionId,
          planStartYyyymmdd: '',
          fromYyyymmdd: '',
          toYyyymmdd: '',
          company: '',
          itemId: '',
        };
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
            planType: '', //  7 planType (AS-IS FE 미전달 기본 '', design 03 §4.1)
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
  }),
  'global-psi-elec-store'
);
