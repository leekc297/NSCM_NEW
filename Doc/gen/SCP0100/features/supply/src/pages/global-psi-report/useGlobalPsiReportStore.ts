// SCP0100 Global_PSI_Report — TobeGen 생성 골격 (As-is SCP0100_Global_PSI_Report, Fact Pack Doc/asisfacts/screens/SCP0100)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './global-psi-report.constants';

interface SearchParamProps {
  searchLevel: string;
  cellQty: boolean;
  planDate: string;
  bucketType: string;
  periodFrom: string; // YYYYMMDD
  periodTo: string;
  graphType: string;
  itemIds: string[];
  display: string;
  projectCodes: string[];
  fromSiteIds: string[];
  toSiteIds: string[];
  cellGroup: string;
  planType: string;
  searchLevel: string;
  as: boolean;
  unitQty: string;
  divisionIds: string[];
  divisionId: string; // As-is 에 Division 조회조건 없음 — 팝업 필드(ItemField/ProjectField) 의 division 필수 → MyDivision 첫 값으로 채움(Form useEffect)
}

// SP IN 파라미터(call-proc filters) — 멀티선택 = 콤마 delim('ALL' = 빈값), 팝업 텍스트 = raw(''), 체크 = 'Y'/'N' (AS-IS ControlValues 1:1 · dmf0045 선례)
//   SCM_ADM_PROC_M.COL_NM(camelCase) 과 키가 같아야 BE 가 positional 매핑한다 — 등록 SQL(<ID>_registration.sql BLOCK 2) 과 대사할 것
type GlobalPsiReportFilter = Record<keyof SearchParamProps, string>;
const j = (arr?: string[]): string => (!arr || arr.length === 0 ? 'ALL' : arr.join(','));
const raw = (arr?: string[]): string => (!arr || arr.length === 0 ? '' : arr.join(','));
const yn = (b?: boolean): string => (b ? 'Y' : 'N');
const toFilter = (p: SearchParamProps): GlobalPsiReportFilter => ({
  searchLevel: p.searchLevel,
  cellQty: yn(p.cellQty),
  planDate: p.planDate,
  bucketType: p.bucketType,
  periodFrom: p.periodFrom,
  periodTo: p.periodTo,
  graphType: p.graphType,
  itemIds: raw(p.itemIds),
  display: p.display,
  projectCodes: raw(p.projectCodes),
  fromSiteIds: j(p.fromSiteIds),
  toSiteIds: j(p.toSiteIds),
  cellGroup: p.cellGroup,
  planType: p.planType,
  searchLevel: p.searchLevel,
  as: yn(p.as),
  unitQty: p.unitQty,
  divisionIds: j(p.divisionIds),
  divisionId: p.divisionId,
});

interface GlobalPsiReportState {
  initialized: boolean;
  filters?: GlobalPsiReportFilter; // useTabProcQuery filters — ProcRequest 와 호환(string 값)
  searchParams: SearchParamProps;
  staticColumns: Partial<Record<SHEETS, RawFlexGridColumnConfig[]>>; // 시트별 메타 컬럼
  isOpenSearchArea: boolean;
  openMeasureModal: boolean; // As-is btnMeasure → MeasureSelectModal
  openColumnModal: boolean; // As-is btnColumn → ColumnLayoutModal
}

interface GlobalPsiReportAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
  setOpenMeasureModal: (value: boolean) => void;
  setOpenColumnModal: (value: boolean) => void;
}

const initGlobalPsiReportParam: SearchParamProps = {
  searchLevel: '',
  cellQty: false,
  planDate: '',
  bucketType: '',
  periodFrom: '',
  periodTo: '',
  graphType: '',
  itemIds: [],
  display: '',
  projectCodes: [],
  fromSiteIds: [],
  toSiteIds: [],
  cellGroup: '',
  planType: '',
  searchLevel: '',
  as: false,
  unitQty: '',
  divisionIds: [],
  divisionId: '',
};

const initGlobalPsiReportState: GlobalPsiReportState = {
  initialized: false,
  filters: undefined,
  searchParams: initGlobalPsiReportParam,
  staticColumns: {},
  isOpenSearchArea: true,
  openMeasureModal: false,
  openColumnModal: false,
} as const;

export const useGlobalPsiReportStore = createPersistedStoreWithTab<GlobalPsiReportState & GlobalPsiReportAction>(
  (set, get) => ({
    ...initGlobalPsiReportState,
    reset: () => set(initGlobalPsiReportState),
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
      const sheets = [SHEETS.REPORT, SHEETS.SEARCH_LEVEL, SHEETS.SEARCH_LEVEL_DETAIL]; // 팝업 시트 포함(모달 staticColumns)
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
          ...initGlobalPsiReportParam,
          searchLevel: str(saved.searchLevel, initGlobalPsiReportParam.searchLevel),
          cellQty: bool(saved.cellQty),
          planDate: str(saved.planDate, initGlobalPsiReportParam.planDate),
          bucketType: str(saved.bucketType, initGlobalPsiReportParam.bucketType),
          periodFrom: str(saved.periodFrom, initGlobalPsiReportParam.periodFrom),
          periodTo: str(saved.periodTo, initGlobalPsiReportParam.periodTo),
          graphType: str(saved.graphType, initGlobalPsiReportParam.graphType),
          itemIds: arr(saved.itemIds),
          display: str(saved.display, initGlobalPsiReportParam.display),
          projectCodes: arr(saved.projectCodes),
          fromSiteIds: arr(saved.fromSiteIds),
          toSiteIds: arr(saved.toSiteIds),
          cellGroup: str(saved.cellGroup, initGlobalPsiReportParam.cellGroup),
          planType: str(saved.planType, initGlobalPsiReportParam.planType),
          searchLevel: str(saved.searchLevel, initGlobalPsiReportParam.searchLevel),
          as: bool(saved.as),
          unitQty: str(saved.unitQty, initGlobalPsiReportParam.unitQty),
          divisionIds: arr(saved.divisionIds),
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
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    setOpenMeasureModal: value => {
      set(state => {
        state.openMeasureModal = value;
      });
    },
    setOpenColumnModal: value => {
      set(state => {
        state.openColumnModal = value;
      });
    },
  }),
  'global-psi-report'
);
