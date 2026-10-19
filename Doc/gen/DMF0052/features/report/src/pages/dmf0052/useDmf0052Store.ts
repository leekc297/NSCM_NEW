// DMF0052 EDISummary — TobeGen 생성 골격 (As-is DMF0052_EDISummary, Fact Pack Doc/asisfacts/screens/DMF0052)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './dmf0052.constants';

interface SearchParamProps {
  today: boolean;
  itemIds: string[];
  projectCodes: string[];
  periodFrom: string; // YYYYMMDD
  periodTo: string;
  senderCodes: string[];
  divisionId: string; // As-is 에 Division 조회조건 없음 — 팝업 필드(ItemField/ProjectField) 의 division 필수 → MyDivision 첫 값으로 채움(Form useEffect)
}

// SP IN 파라미터(call-proc filters) — 멀티선택 = 콤마 delim('ALL' = 빈값), 팝업 텍스트 = raw(''), 체크 = 'Y'/'N' (AS-IS ControlValues 1:1 · dmf0045 선례)
//   SCM_ADM_PROC_M.COL_NM(camelCase) 과 키가 같아야 BE 가 positional 매핑한다 — 등록 SQL(<ID>_registration.sql BLOCK 2) 과 대사할 것
type Dmf0052Filter = Record<keyof SearchParamProps, string>;
const j = (arr?: string[]): string => (!arr || arr.length === 0 ? 'ALL' : arr.join(','));
const raw = (arr?: string[]): string => (!arr || arr.length === 0 ? '' : arr.join(','));
const yn = (b?: boolean): string => (b ? 'Y' : 'N');
const toFilter = (p: SearchParamProps): Dmf0052Filter => ({
  today: yn(p.today),
  itemIds: raw(p.itemIds),
  projectCodes: raw(p.projectCodes),
  periodFrom: p.periodFrom,
  periodTo: p.periodTo,
  senderCodes: j(p.senderCodes),
  divisionId: p.divisionId,
});

interface Dmf0052State {
  initialized: boolean;
  filters?: Dmf0052Filter; // useTabProcQuery filters — ProcRequest 와 호환(string 값)
  searchParams: SearchParamProps;
  staticColumns: Partial<Record<SHEETS, RawFlexGridColumnConfig[]>>; // 시트별 메타 컬럼
  activeSheetData: SHEETS; // spdData: ERP Data / GSCM Data 전환
  isOpenSearchArea: boolean;
  openGSCMDataModal: boolean; // As-is DMF0052_GSCMDataPopup → GSCMDataModal (화면 종속 모달 — As-is 팝업 클래스)
}

interface Dmf0052Action {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  setActiveSheetData: (sheet: SHEETS) => void;
  setOpenSearchArea: (open?: boolean) => void;
  setOpenGSCMDataModal: (value: boolean) => void;
}

const initDmf0052Param: SearchParamProps = {
  today: false,
  itemIds: [],
  projectCodes: [],
  periodFrom: '',
  periodTo: '',
  senderCodes: [],
  divisionId: '',
};

const initDmf0052State: Dmf0052State = {
  initialized: false,
  filters: undefined,
  searchParams: initDmf0052Param,
  staticColumns: {},
  activeSheetData: SHEETS.ERP_DATA,
  isOpenSearchArea: true,
  openGSCMDataModal: false,
} as const;

export const useDmf0052Store = createPersistedStoreWithTab<Dmf0052State & Dmf0052Action>(
  (set, get) => ({
    ...initDmf0052State,
    reset: () => set(initDmf0052State),
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
      });
    },
    setFilters: () => {
      set(state => {
        state.filters = toFilter(get().searchParams);
      });
    },
    fetchStaticColumns: async () => {
      // 시트별 메타 컬럼(SCM_MST_SHEET_COLUMNS) 을 한 번에 — 시트명은 배포 케이싱 그대로
      const sheets = [SHEETS.SUMMARY, SHEETS.ERP_DATA, SHEETS.GSCM_DATA, SHEETS.SUMMARY_PJT, SHEETS.SUMMARY_STATUS, SHEETS.EDI_SUMMARY_GSCM_DATA_POPUP]; // 팝업 시트 포함(모달 staticColumns)
      const results = await Promise.all(sheets.map(sheetNm => apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, { sheetNm })));
      set(state => {
        sheets.forEach((sheetNm, i) => { state.staticColumns[sheetNm] = results[i].data.result; });
      });
      if (get().initialized) return;
      const param = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
        `/admin/menu/${MENU_ID}/search-conditions`
      );
      if (param.data.result?.length > 0) {
        // 저장된 조회조건(문자열) → 화면 타입으로 복원 (멀티/팝업: 콤마 분리, 체크: Y/N, 그 외 문자열)
        const saved = Object.fromEntries(param.data.result.map(r => [r.paramNm, r.paramCtn])) as Record<string, string | undefined>;
        const arr = (v?: string) => (v && v !== 'ALL' ? v.split(',').filter(Boolean) : []);
        const bool = (v?: string) => v === 'Y' || v === 'true';
        const str = (v: string | undefined, d: string) => v ?? d;
        const searchParams: SearchParamProps = {
          ...initDmf0052Param,
          today: bool(saved.today),
          itemIds: arr(saved.itemIds),
          projectCodes: arr(saved.projectCodes),
          periodFrom: str(saved.periodFrom, initDmf0052Param.periodFrom),
          periodTo: str(saved.periodTo, initDmf0052Param.periodTo),
          senderCodes: arr(saved.senderCodes),
          divisionId: str(saved.divisionId, ''),
        };
        set(state => {
          state.searchParams = searchParams;
        });
      }
      set(state => {
        state.initialized = true;
      });
    },
    setActiveSheetData: sheet => {
      set(state => {
        state.activeSheetData = sheet;
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    setOpenGSCMDataModal: value => {
      set(state => {
        state.openGSCMDataModal = value;
      });
    },
  }),
  'dmf0052'
);
