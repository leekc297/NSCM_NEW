import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import {
  BUCKET_TYPE,
  DIVISION_CODE,
  MENU_ID,
  SHEETS,
  SHEET_INDEX,
  type BucketType,
} from './sales-future-price.constants';

/**
 * 검색 조건 (14 필드) — As-Is `DMF0020_SalesFuturePrice.cs` §18.1 14 필드.
 * 사업부 분기 (40/81/82) 는 단일 필드 `divisionId` 로 유지하고, 분기는 컴포넌트/hook 에서 처리.
 */
interface SearchParamProps {
  divisionId: string;
  deptIds: string[];
  endCustomers: string[];
  scmSiteIds: string[];
  plantSiteIds: string[]; // ESS(81) 전용
  itemIds: string[];
  nickName: string;
  projectCodes: string[];
  periodFrom: string;
  periodTo: string;
  bizTypes: string[];
  owners: string[];
  bucketType: BucketType;
  searchOverRange: boolean;
  excludeNoPrice: boolean;
  versionId: string;
}

/** 동적 시간축 컬럼 정의 (`DMF0020_GET_SPREAD_TITLE_DATE` 응답 기반) */
interface DynamicColumn {
  binding: string; // W_20260511 또는 M_202605
  header: string; // MMDD 또는 MM
  basisYYYYMM: string; // Row 0 머지 키
  weekName: string; // Row 1
  visible: boolean; // bucketType 에 따라 토글
}

/**
 * Modal 열림 상태 — DMF0020 호출 POPUP 6종 (룰 25 §3 자체 modal 신규 생성 결정)
 * - openExchangeRate: DMF0020_SalesFuturePricePopUp (환율)
 * - openSalesPriceRange: DMF0020_SalesPriceRangePopUp (조회 범위)
 * - openPriceBatchInput: DMF0020_SaveSalesFuturePrice_Popup (Price 일괄입력)
 * - openSalesPriceTemplate: DMF0020_SalesPriceTemplatePopup
 * - openSalesPriceVersion: DMF0073_VersionBySalesPricePopup
 * - openColumnTitleSet: DM0002_TitleSetForm_Popup (컬럼 표시 설정)
 */
interface ModalState {
  openExchangeRate: boolean;
  openSalesPriceRange: boolean;
  openPriceBatchInput: boolean;
  openSalesPriceTemplate: boolean;
  openSalesPriceVersion: boolean;
  openColumnTitleSet: boolean;
}

interface SalesFuturePriceState {
  initialized: boolean;
  filters?: Record<string, unknown>;
  searchParams: SearchParamProps;
  staticColumns: RawFlexGridColumnConfig[];
  dynamicColumns: DynamicColumn[];
  selectedGroupKey?: string;
  /** TabWrapper 활성 인덱스 — Tab1 FlexGrid wide / Tab2 Wijmo PivotGrid (사용자 요구) */
  selectedTabIndex: SHEET_INDEX;
  isOpenSearchArea: boolean;
  modals: ModalState;
}

interface SalesFuturePriceAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  fetchDynamicColumns: () => Promise<void>;
  setSelectedGroupKey: (key?: string) => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSelectedTabIndex: (index: SHEET_INDEX) => void;
  // Division 변경 종속 필드 리셋 — AS-IS: DMF0020_SalesFuturePrice.cs:2491,2508,2519,2579
  onDivisionChanged: (divisionId: string) => void;
  // Modal 토글 (6종 — 자체 modal)
  setOpenExchangeRate: (value: boolean) => void;
  setOpenSalesPriceRange: (value: boolean) => void;
  setOpenPriceBatchInput: (value: boolean) => void;
  setOpenSalesPriceTemplate: (value: boolean) => void;
  setOpenSalesPriceVersion: (value: boolean) => void;
  setOpenColumnTitleSet: (value: boolean) => void;
}

const initSearchParams: SearchParamProps = {
  divisionId: '',
  deptIds: [],
  endCustomers: [],
  scmSiteIds: [],
  plantSiteIds: [],
  itemIds: [],
  nickName: '',
  projectCodes: [],
  periodFrom: '',
  periodTo: '',
  bizTypes: [],
  owners: [],
  bucketType: BUCKET_TYPE.WEEKLY,
  searchOverRange: false,
  excludeNoPrice: false,
  versionId: 'CURRENT',
};

const initModalState: ModalState = {
  openExchangeRate: false,
  openSalesPriceRange: false,
  openPriceBatchInput: false,
  openSalesPriceTemplate: false,
  openSalesPriceVersion: false,
  openColumnTitleSet: false,
};

const initSalesFuturePriceState: SalesFuturePriceState = {
  initialized: false,
  filters: undefined,
  searchParams: initSearchParams,
  staticColumns: [],
  dynamicColumns: [],
  selectedGroupKey: undefined,
  selectedTabIndex: SHEET_INDEX.MAIN_FLEX,
  isOpenSearchArea: true,
  modals: initModalState,
} as const;

export const useSalesFuturePriceStore = createPersistedStoreWithTab<
  SalesFuturePriceState & SalesFuturePriceAction
>(
  (set, get) => ({
    ...initSalesFuturePriceState,
    reset: () => set(initSalesFuturePriceState),
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
      });
    },
    setFilters: () => {
      set(state => {
        state.filters = { ...state.searchParams };
      });
    },
    fetchStaticColumns: async () => {
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        { sheetNm: SHEETS.MAIN }
      );
      set(state => {
        state.staticColumns = result.data.result;
      });
      if (get().initialized) return;
      const param = await apiClient.get<{ paramNm: keyof SearchParamProps; paramCtn: string }[]>(
        `/admin/menu/${MENU_ID}/search-conditions`
      );

      if (param.data.result?.length > 0) {
        const merged = { ...initSearchParams } as SearchParamProps;
        param.data.result.forEach(curr => {
          // 배열 필드는 ',' 로 split, boolean 은 'Y'/'N' 로
          const arrayFields: (keyof SearchParamProps)[] = [
            'deptIds',
            'endCustomers',
            'scmSiteIds',
            'plantSiteIds',
            'itemIds',
            'projectCodes',
            'bizTypes',
            'owners',
          ];
          if (arrayFields.includes(curr.paramNm)) {
            // @ts-expect-error — split 결과는 string[]
            merged[curr.paramNm] = curr.paramCtn ? curr.paramCtn.split(',') : [];
          } else if (curr.paramNm === 'searchOverRange' || curr.paramNm === 'excludeNoPrice') {
            merged[curr.paramNm] = curr.paramCtn === 'Y';
          } else {
            // @ts-expect-error — 단일 string 필드
            merged[curr.paramNm] = curr.paramCtn;
          }
        });

        set(state => {
          state.searchParams = merged;
        });
      }
      set(state => {
        state.initialized = true;
      });
    },
    fetchDynamicColumns: async () => {
      const { searchParams } = get();
      if (!searchParams.periodFrom || !searchParams.periodTo) return;
      const result = await apiClient.post<DynamicColumn[]>(
        `/${MENU_ID}/${SHEETS.MAIN}/SPREAD_TITLE_DATE/call-proc`,
        {
          periodFrom: searchParams.periodFrom,
          periodTo: searchParams.periodTo,
          bucketType: searchParams.bucketType,
        }
      );
      set(state => {
        // bucketType 에 따라 W_ 또는 M_ prefix 만 visible
        state.dynamicColumns = (result.data.result ?? []).map(c => ({
          ...c,
          visible:
            searchParams.bucketType === BUCKET_TYPE.WEEKLY
              ? c.binding.startsWith('W_')
              : c.binding.startsWith('M_'),
        }));
      });
    },
    setSelectedGroupKey: key => {
      set(state => {
        state.selectedGroupKey = key;
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    setSelectedTabIndex: index => {
      set(state => {
        state.selectedTabIndex = index;
      });
    },
    /**
     * Division 변경 시 종속 필드 리셋.
     * AS-IS: DMF0020_SalesFuturePrice.cs:2491,2508,2519,2579 (사업부 81/82 분기)
     * - Team / EndCustomer / SalesSite / BizType / PlantSite 모두 재조회 대상이므로 초기화
     * - PlantSite 는 사업부 81(ESS) 에서만 활성 — 다른 사업부에서는 빈 배열 유지
     */
    onDivisionChanged: divisionId => {
      set(state => {
        const prefix = divisionId.substring(0, 2);
        state.searchParams = {
          ...state.searchParams,
          divisionId,
          deptIds: [],
          endCustomers: [],
          scmSiteIds: [],
          plantSiteIds:
            prefix === DIVISION_CODE.ESS.substring(0, 2) ? state.searchParams.plantSiteIds : [],
          bizTypes: [],
        };
      });
    },
    setOpenExchangeRate: value => {
      set(state => {
        state.modals.openExchangeRate = value;
      });
    },
    setOpenSalesPriceRange: value => {
      set(state => {
        state.modals.openSalesPriceRange = value;
      });
    },
    setOpenPriceBatchInput: value => {
      set(state => {
        state.modals.openPriceBatchInput = value;
      });
    },
    setOpenSalesPriceTemplate: value => {
      set(state => {
        state.modals.openSalesPriceTemplate = value;
      });
    },
    setOpenSalesPriceVersion: value => {
      set(state => {
        state.modals.openSalesPriceVersion = value;
      });
    },
    setOpenColumnTitleSet: value => {
      set(state => {
        state.modals.openColumnTitleSet = value;
      });
    },
  }),
  'sales-future-price'
);
