import type { MeasureMeta } from 'features/master/src/components';

import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import type {
  SHEETS} from './capa-mobility-it.constants';
import {
  ADMIN_SHEET_NAME,
  DEFAULT_BUCKET,
  FIXED_DIVISION,
  MENU_ID
} from './capa-mobility-it.constants';
import type { CapaMobilityItSearchParams } from './capa-mobility-it.types';

interface State {
  searchParams: CapaMobilityItSearchParams;
  filters?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  openSearchArea: boolean;
  staticColumns: RawFlexGridColumnConfig[];
  // Measure 설정 팝업(MeasureSelectModal) 원천 — SCM_MST_SHEET_MEASURE. display 는 BE 가 사용자 저장분을 반영해 내린다.
  staticMeasures: MeasureMeta[];
  // 개인화 조회조건 복원 1회 가드 (SubTitle F6 저장분 mount 복원).
  conditionsRestored: boolean;
}

interface Action {
  reset: () => void;
  setSearchParams: (patch: Partial<CapaMobilityItSearchParams>) => void;
  setFilters: () => boolean;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => void;
  fetchStaticMeasures: () => Promise<void>;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchParams 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

const makeInitSearchParams = (): CapaMobilityItSearchParams => ({
  // Division 은 '40' 고정·비활성 (AS-IS cs L182~183). 사용자 변경 불가.
  divisionId: FIXED_DIVISION,
  plantIds: [],
  lineIds: [],
  // 초기 기간 — AS-IS GetDayRange(W52) 산출. TO-BE 는 오늘 기준 약 52주(당월 1일 ~ +52주) 기본값을
  //   두되, 정확한 초기 범위 SP(SCM0001_GET_SCP_DAY_PERIOD) 산출은 조회 전이라 근사한다(design 02 §2-5).
  startYyyymmdd: dayjs().startOf('month').format('YYYYMMDD'),
  endYyyymmdd: dayjs().startOf('month').add(52, 'week').subtract(1, 'day').format('YYYYMMDD'),
  itemId: '',
});

const makeInitState = (): State => ({
  searchParams: makeInitSearchParams(),
  openSearchArea: true,
  staticColumns: [],
  staticMeasures: [],
  conditionsRestored: false,
});

// 개인화 조건 복원 역직렬화 — SubTitle F6 저장은 배열=콤마join·평문 String(gridAction personalizeCondition).
//   plantIds/lineIds = 멀티셀렉트(콤마 결합 → split). divisionId/itemId = 문자열 그대로 patch.
//   날짜 키(startYyyymmdd/endYyyymmdd)는 EXCLUDED_DATE_PARAM 로 저장 자체가 제외 → 복원 대상 0건(기본값 유지).
const RESTORE_ARRAY_KEYS = new Set<string>(['plantIds', 'lineIds']);

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

export const useCapaMobilityItStore = createPersistedStoreWithTab<State & Action>(
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
        nickName: '', // Model/Nickname 통합(문서 SCP0098): 팝업 확정값은 itemId 로만 전송, nickName 은 무필터
        bucket: toBucketCode(DEFAULT_BUCKET),
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

    // divisionId 는 보내지 않는다 — SCP0098 measure 메타의 DIVISION_ID 가 NULL 이라 값을 보내면 0건이 된다
    //   (SSP0060 에서 같은 증상을 실측). 실패 시 빈 배열 유지.
    fetchStaticMeasures: async () => {
      try {
        const res = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: ADMIN_SHEET_NAME,
        });
        set(state => {
          state.staticMeasures = res.data.result ?? [];
        });
      } catch {
        // 미적재/실패 = 빈 배열 유지 (console 금지 룰)
      }
    },

    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 형제 scp-bom/shipment-plan-fix 파리티.
    //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 역직렬화(배열 split).
    //   저장분 없거나 조회 실패면 기본값 유지. 저장은 EXCLUDED_DATE_PARAM·빈값 필터 후 재삽입이라
    //   응답에 없는 키(날짜 등)는 initSearchParams 기본값 그대로 둔다(gridAction.ts personalizeCondition).
    //   store 는 새로고침 시 초기화(createPersistedStoreWithTab 미영속)라 이 복원이 유일한 조건 생존 경로.
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
        const init = makeInitSearchParams();
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in init)) continue; // CapaMobilityItSearchParams 필드만 allowlist
          const val = paramCtn ?? '';
          if (RESTORE_ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else patch[paramNm] = val;
        }
        set(state => {
          state.searchParams = { ...state.searchParams, ...patch } as CapaMobilityItSearchParams;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지 룰)
      }
    },
  }),
  'capa-mobility-it-store'
);
