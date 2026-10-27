// SSP0015 ShipmentPSI — TobeGen 생성 골격 (As-is SSP0015_ShipmentPSI, Fact Pack Doc/asisfacts/screens/SSP0015)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './shipment-plan-mobility-it.constants';

interface SearchParamProps {
  planDate: string;
  sumYn: boolean;
  plantSiteIds: string[];
  periodFrom: string; // YYYYMMDD
  periodTo: string;
  itemIds: string[];
  bucketType: string;
  divisionIds: string[];
  myModel: boolean;
  partLeader: boolean;
  teamLeader: boolean;
  delegateeModel: boolean;
  resultType: string[];
  requestor: string;
  model2: string;
  periodFrom: string; // YYYYMMDD
  periodTo: string;
  periodFrom: string; // YYYYMMDD
  periodTo: string;
  lotId: string;
  divisionId: string; // As-is 에 Division 조회조건 없음 — 팝업 필드(ItemField/ProjectField) 의 division 필수 → MyDivision 첫 값으로 채움(Form useEffect)
}

// SP IN 파라미터(call-proc filters) — 멀티선택 = 콤마 delim('ALL' = 빈값), 팝업 텍스트 = raw(''), 체크 = 'Y'/'N' (AS-IS ControlValues 1:1 · dmf0045 선례)
//   SCM_ADM_PROC_M.COL_NM(camelCase) 과 키가 같아야 BE 가 positional 매핑한다 — 등록 SQL(<ID>_registration.sql BLOCK 2) 과 대사할 것
type ShipmentPlanMobilityItFilter = Record<keyof SearchParamProps, string>;
const j = (arr?: string[]): string => (!arr || arr.length === 0 ? 'ALL' : arr.join(','));
const raw = (arr?: string[]): string => (!arr || arr.length === 0 ? '' : arr.join(','));
const yn = (b?: boolean): string => (b ? 'Y' : 'N');
const toFilter = (p: SearchParamProps): ShipmentPlanMobilityItFilter => ({
  planDate: p.planDate,
  sumYn: yn(p.sumYn),
  plantSiteIds: j(p.plantSiteIds),
  periodFrom: p.periodFrom,
  periodTo: p.periodTo,
  itemIds: raw(p.itemIds),
  bucketType: p.bucketType,
  divisionIds: j(p.divisionIds),
  myModel: yn(p.myModel),
  partLeader: yn(p.partLeader),
  teamLeader: yn(p.teamLeader),
  delegateeModel: yn(p.delegateeModel),
  resultType: j(p.resultType),
  requestor: p.requestor,
  model2: p.model2,
  periodFrom: p.periodFrom,
  periodTo: p.periodTo,
  periodFrom: p.periodFrom,
  periodTo: p.periodTo,
  lotId: p.lotId,
  divisionId: p.divisionId,
});

interface ShipmentPlanMobilityItState {
  initialized: boolean;
  filters?: ShipmentPlanMobilityItFilter; // useTabProcQuery filters — ProcRequest 와 호환(string 값)
  searchParams: SearchParamProps;
  staticColumns: Partial<Record<SHEETS, RawFlexGridColumnConfig[]>>; // 시트별 메타 컬럼
  activeSheetDetail: SHEETS; // spdDetail: Hold stock Detail / Hold stock / MES Stock Detail / SCS Stock Detail / Shipment Confirm Detail / Shipment PSI(IT & Mobile) / Shipment PSI(Mobility & IT) / Shipment PSI(Packer) / Shipment Request Detail / Shipment Result / Stock Detail / Stock Location Detail / W/H stock / W/H stock Detail 전환
  isOpenSearchArea: boolean;
  openDiv*Modal: boolean; // As-is btnMeasure → MeasureSelectModal
  openShipmentPSICommentsModal: boolean; // As-is SSP0015_ShipmentPSICommentsPopup → ShipmentPSICommentsModal (화면 종속 모달 — As-is 팝업 클래스)
}

interface ShipmentPlanMobilityItAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  setActiveSheetDetail: (sheet: SHEETS) => void;
  setOpenSearchArea: (open?: boolean) => void;
  setOpenDiv*Modal: (value: boolean) => void;
  setOpenShipmentPSICommentsModal: (value: boolean) => void;
}

const initShipmentPlanMobilityItParam: SearchParamProps = {
  planDate: '',
  sumYn: false,
  plantSiteIds: [],
  periodFrom: '',
  periodTo: '',
  itemIds: [],
  bucketType: '',
  divisionIds: [],
  myModel: false,
  partLeader: false,
  teamLeader: false,
  delegateeModel: false,
  resultType: [],
  requestor: '',
  model2: '',
  periodFrom: '',
  periodTo: '',
  periodFrom: '',
  periodTo: '',
  lotId: '',
  divisionId: '',
};

const initShipmentPlanMobilityItState: ShipmentPlanMobilityItState = {
  initialized: false,
  filters: undefined,
  searchParams: initShipmentPlanMobilityItParam,
  staticColumns: {},
  activeSheetDetail: SHEETS.HOLD_STOCK_DETAIL,
  isOpenSearchArea: true,
  openDiv*Modal: false,
  openShipmentPSICommentsModal: false,
} as const;

export const useShipmentPlanMobilityItStore = createPersistedStoreWithTab<ShipmentPlanMobilityItState & ShipmentPlanMobilityItAction>(
  (set, get) => ({
    ...initShipmentPlanMobilityItState,
    reset: () => set(initShipmentPlanMobilityItState),
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
      const sheets = [SHEETS.HOLD_STOCK, SHEETS.HOLD_STOCK_DETAIL, SHEETS.MES_STOCK_DETAIL, SHEETS.SCS_STOCK_DETAIL, SHEETS.SHIPMENT_CONFIRM_DETAIL, SHEETS.SHIPMENT_PSI_IT_MOBILE, SHEETS.SHIPMENT_PSI_MOBILITY_IT, SHEETS.SHIPMENT_PSI_PACKER, SHEETS.SHIPMENT_REQUEST_DETAIL, SHEETS.SHIPMENT_RESULT, SHEETS.STOCK_DETAIL, SHEETS.STOCK_LOCATION_DETAIL, SHEETS.W_H_STOCK, SHEETS.W_H_STOCK_DETAIL, SHEETS.WH_IN_PLAN_DETAIL]; // 팝업 시트 포함(모달 staticColumns)
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
          ...initShipmentPlanMobilityItParam,
          planDate: str(saved.planDate, initShipmentPlanMobilityItParam.planDate),
          sumYn: bool(saved.sumYn),
          plantSiteIds: arr(saved.plantSiteIds),
          periodFrom: str(saved.periodFrom, initShipmentPlanMobilityItParam.periodFrom),
          periodTo: str(saved.periodTo, initShipmentPlanMobilityItParam.periodTo),
          itemIds: arr(saved.itemIds),
          bucketType: str(saved.bucketType, initShipmentPlanMobilityItParam.bucketType),
          divisionIds: arr(saved.divisionIds),
          myModel: bool(saved.myModel),
          partLeader: bool(saved.partLeader),
          teamLeader: bool(saved.teamLeader),
          delegateeModel: bool(saved.delegateeModel),
          resultType: arr(saved.resultType),
          requestor: str(saved.requestor, initShipmentPlanMobilityItParam.requestor),
          model2: str(saved.model2, initShipmentPlanMobilityItParam.model2),
          periodFrom: str(saved.periodFrom, initShipmentPlanMobilityItParam.periodFrom),
          periodTo: str(saved.periodTo, initShipmentPlanMobilityItParam.periodTo),
          periodFrom: str(saved.periodFrom, initShipmentPlanMobilityItParam.periodFrom),
          periodTo: str(saved.periodTo, initShipmentPlanMobilityItParam.periodTo),
          lotId: str(saved.lotId, initShipmentPlanMobilityItParam.lotId),
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
    setActiveSheetDetail: sheet => {
      set(state => {
        state.activeSheetDetail = sheet;
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    setOpenDiv*Modal: value => {
      set(state => {
        state.openDiv*Modal = value;
      });
    },
    setOpenShipmentPSICommentsModal: value => {
      set(state => {
        state.openShipmentPSICommentsModal = value;
      });
    },
  }),
  'shipment-plan-mobility-it'
);
