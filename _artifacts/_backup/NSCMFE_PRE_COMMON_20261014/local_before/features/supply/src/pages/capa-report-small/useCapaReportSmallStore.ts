import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import type {
  SHEETS} from './capa-report-small.constants';
import {
  ADMIN_SHEET_NAME,
  DEFAULT_BUCKET,
  FIXED_DIVISION,
  MENU_ID
} from './capa-report-small.constants';
import type { CapaReportSmallSearchParams } from './capa-report-small.types';

/** SCM_MST_SHEET_MEASURE 동적 fetch row — /admin/menu/{MENU_ID}/measure (camelCase). */
export interface MeasureMeta {
  colNm: string;
  colLblNm?: string;
  sClsLblNm?: string;
  display?: boolean;
  personalizable?: boolean;
  sortOrd?: number;
}

interface State {
  searchParams: CapaReportSmallSearchParams;
  filters?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  openSearchArea: boolean;
  /** chkDetail 로컬 UI 상태 — Daily bucket 에서 D_↔M_ 가시성 토글(design 01 §2 B). store 는 서버데이터 없음. */
  isDetail: boolean;
  staticColumns: RawFlexGridColumnConfig[];
  staticMeasures: MeasureMeta[];
}

interface Action {
  reset: () => void;
  setSearchParams: (patch: Partial<CapaReportSmallSearchParams>) => void;
  setFilters: () => boolean;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setIsDetail: (on: boolean) => void;
  fetchStaticColumns: () => void;
  fetchStaticMeasures: () => void;
}

const makeInitSearchParams = (): CapaReportSmallSearchParams => ({
  // Division 은 '40' 고정·비활성 (AS-IS cs L182~183). 사용자 변경 불가.
  divisionId: FIXED_DIVISION,
  plantIds: [],
  lineIds: [],
  bucketType: DEFAULT_BUCKET,
  // 초기 기간 — AS-IS GetDayRange(W52) 산출. TO-BE 는 오늘 기준 약 52주(당월 1일 ~ +52주) 기본값을
  //   두되, 정확한 초기 범위 SP(SCM0001_GET_SCP_DAY_PERIOD) 산출은 조회 전이라 근사한다(design 02 §2-5).
  startYyyymmdd: dayjs().startOf('month').format('YYYYMMDD'),
  endYyyymmdd: dayjs().startOf('month').add(52, 'week').subtract(1, 'day').format('YYYYMMDD'),
  itemId: '',
  nickName: '',
});

const makeInitState = (): State => ({
  searchParams: makeInitSearchParams(),
  openSearchArea: true,
  isDetail: false,
  staticColumns: [],
  staticMeasures: [],
});

/** 다중선택 → SP CSV. 'ALL' sentinel/빈 배열 = '' (전체, INSTR CSV 필터 무효화). */
const joinCsv = (arr: string[]): string => {
  const picked = arr.filter(v => v && v !== 'ALL');
  return picked.join(',');
};

/** Line 다중 → p_line_id. '-'(미선택 UNION 행)은 빈값으로 치환(AS-IS FindData_Main L657~660). */
const joinLineCsv = (arr: string[]): string => {
  const picked = arr.filter(v => v && v !== 'ALL' && v !== '-');
  return picked.join(',');
};

/** DAILY/WEEKLY/MONTHLY → SP @p_bucket (D/W/M). (design 03 §4.1) */
const toBucketCode = (bucket: string): string => (bucket || DEFAULT_BUCKET).charAt(0).toUpperCase();

export const useCapaReportSmallStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...makeInitState(),
    reset: () => set(makeInitState()),

    setSearchParams: patch =>
      set(state => {
        state.searchParams = { ...get().searchParams, ...patch };
      }),

    /**
     * Search — searchParams → main filters(camelCase, procedures.d.ts SCP0098.main.request).
     *   division 고정 '40'. Line/Operation/Model 은 AS-IS 동일하게 모두 선택 Line CSV 로 전달(design 02 §2).
     *   반환 true = 이전과 동일(참조교체 없음) → 화면이 refetch() 로 강제.
     */
    setFilters: () => {
      const sp = { ...makeInitSearchParams(), ...get().searchParams };
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      const lineCsv = joinLineCsv(sp.lineIds);
      const next: ProcRequest<MENU_ID, SHEETS.MAIN> = {
        todayYyyymmdd: dayjs().format('YYYYMMDD'),
        fromYyyymmdd: sp.startYyyymmdd,
        toYyyymmdd: sp.endYyyymmdd,
        divisionId: FIXED_DIVISION,
        plantId: joinCsv(sp.plantIds),
        lineId: lineCsv,
        operationId: lineCsv, // AS-IS: p_operation_id = 선택 Line (동일 전달)
        modelId: lineCsv, // AS-IS: p_model_id = 선택 Line (동일 전달)
        itemId: sp.itemId,
        nickName: sp.nickName,
        bucket: toBucketCode(sp.bucketType),
        userId: sesUserId,
        debugMode: 'F',
      };
      const isSame = JSON.stringify(get().filters) === JSON.stringify(next);
      set(state => {
        state.filters = next;
      });
      return isSame;
    },

    clearFilters: () =>
      set(state => {
        state.filters = undefined;
      }),

    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),

    setIsDetail: on =>
      set(state => {
        state.isDetail = on;
      }),

    fetchStaticColumns: () => {
      void (async () => {
        try {
          const result = await apiClient.post<RawFlexGridColumnConfig[]>(
            `/admin/menu/${MENU_ID}/column`,
            { sheetNm: ADMIN_SHEET_NAME, divisionId: FIXED_DIVISION }
          );
          set(state => {
            // `?? []` — BE 가 200 + result:null 을 주는 경우 방어(ForecastPrice 선례).
            state.staticColumns = result.data.result ?? [];
          });
        } catch {
          /* 메타 미적재 시 빈 배열 유지 — 컬럼 0개가 곧 메타 누락 신호(fallback 하드코딩 금지) */
        }
      })();
    },

    fetchStaticMeasures: () => {
      void (async () => {
        try {
          const result = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
            sheetNm: ADMIN_SHEET_NAME,
            divisionId: FIXED_DIVISION,
          });
          set(state => {
            state.staticMeasures = result.data.result ?? [];
          });
        } catch {
          /* SHEET_MEASURE 미적재 시 빈 배열 유지 */
        }
      })();
    },
  }),
  'capa-report-small-store'
);
