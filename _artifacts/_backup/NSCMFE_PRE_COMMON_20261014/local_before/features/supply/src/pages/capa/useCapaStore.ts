import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import type { SHEETS} from './capa.constants';
import { ADMIN_SHEET_NAME, CHECK_DEFAULTS, MENU_ID, VERSION_CURRENT } from './capa.constants';
import type { CalendarRow, CapaSearchParams, CapaSummary } from './capa.types';

const EMPTY_SUMMARY: CapaSummary = { total: '', auto: '', small: '', elec: '', pic: '' };

/** 다중선택 → SP 파라미터: 빈 배열 = 'ALL'(GET_CAPA cs:850-854 서버 NULL 치환). */
const joinCsv = (arr: string[]): string => {
  const cleaned = arr.filter(v => v !== '' && v.toUpperCase() !== 'ALL');
  return cleaned.length === 0 ? 'ALL' : cleaned.join(',');
};

// 상수가 아니라 함수 — 탭 생성 시점 세션을 읽어 재로그인 시 이전 계정 division 이 얼어붙지 않게 한다.
const makeInitSearchParams = (): CapaSearchParams => ({
  divisionId: '',
  group: 'ALL',
  plantIds: [],
  factoryIds: [],
  lineIds: [],
  operationIds: [],
  versionId: VERSION_CURRENT,
  fromYyyymm: dayjs().format('YYYYMM'),
  toYyyymm: dayjs().format('YYYYMM'),
  modelId: '',
  materialId: '',
  bucketDay: false,
  ...CHECK_DEFAULTS,
  checkResult: true,
});

interface CapaState {
  searchParams: CapaSearchParams;
  filters?: ProcRequest<MENU_ID, SHEETS.CAPA>;
  calendarFilters?: ProcRequest<MENU_ID, SHEETS.CALENDAR>;
  isOpenSearchArea: boolean;
  staticColumns: RawFlexGridColumnConfig[];
  calendar: CalendarRow[];
  summary: CapaSummary;
  /** Version 콤보 lazy 옵션 — 'Current' 선두 + 최신 30건. */
  versionOptions: { code: string; name: string }[];
  /** 기간 피커 상한(당월+3년5개월) yyyymm. */
  periodMaxYyyymm: string;
}

interface CapaAction {
  /** 탭 종료 시 store 초기화(BaseTabState 계약 — resetAllStores 대상). */
  reset: () => void;
  setSearchParams: (patch: Partial<CapaSearchParams>) => void;
  /** Division 변경 = 하위 전부 ALL 리셋 + 그리드 비움. */
  changeDivision: (divisionId: string) => void;
  /** Version 변경 = 그리드·헤더요약 즉시 clear + isCurrentVersion 재산정(R14·02 §3 cs:2357-2362). */
  changeVersion: (versionId: string) => void;
  setFilters: () => boolean;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => void;
  setCalendar: (rows: CalendarRow[]) => void;
  setSummary: (summary: CapaSummary) => void;
  setVersionOptions: (rows: { code: string; name: string }[]) => void;
  setPeriodMaxYyyymm: (yyyymm: string) => void;
}

const makeInitState = (): CapaState => ({
  searchParams: makeInitSearchParams(),
  isOpenSearchArea: true,
  staticColumns: [],
  calendar: [],
  summary: EMPTY_SUMMARY,
  versionOptions: [{ code: VERSION_CURRENT, name: VERSION_CURRENT }],
  periodMaxYyyymm: dayjs().add(3, 'year').add(5, 'month').format('YYYYMM'),
});

export const useCapaStore = createPersistedStoreWithTab<CapaState & CapaAction>((set, get) => ({
  ...makeInitState(),
  reset: () => set(makeInitState()),
  setSearchParams: patch =>
    set(state => {
      state.searchParams = { ...get().searchParams, ...patch };
    }),
  // Division 변경 시 하위 다중선택 전부 ALL 리셋 + group 초기화 + Version 'Current' 복귀(02 §3·§5).
  //   그리드 비움은 clearFilters 로(division-변경 effect 에서 호출). 컬럼 메타는 재조회.
  changeDivision: divisionId =>
    set(state => {
      state.searchParams = {
        ...get().searchParams,
        divisionId,
        group: 'ALL',
        plantIds: [],
        factoryIds: [],
        lineIds: [],
        operationIds: [],
        versionId: VERSION_CURRENT,
      };
      state.versionOptions = [{ code: VERSION_CURRENT, name: VERSION_CURRENT }];
    }),
  // Version 변경 시 그리드 DataSource + 헤더 요약 5필드 즉시 clear(AS-IS cs:2357-2362). filters 무효화로
  //   useTabProcQuery enabled=false → rows 비움. 재조회는 사용자 SEARCH 로만. isCurrentVersion 은 versionId 파생.
  changeVersion: versionId =>
    set(state => {
      state.searchParams = { ...get().searchParams, versionId };
      state.filters = undefined;
      state.calendarFilters = undefined;
      state.calendar = [];
      state.summary = EMPTY_SUMMARY;
    }),
  setFilters: () => {
    const sp = get().searchParams;
    const userAuth = useSessionStore.getState().session.groupId ?? '';
    // GET_CAPA 23 IN(procedures.d.ts SCP0049.capa.request — userId 는 BE 자동 주입). 02 §5.186.
    //   Model/Nickname 통합 텍스트 → modelId. nickName 조건은 TO-BE 삭제(02 §1 #11) → 'ALL'.
    const newFilters: ProcRequest<MENU_ID, SHEETS.CAPA> = {
      todayYyyymmdd: dayjs().format('YYYYMMDD'),
      fromYyyymm: sp.fromYyyymm,
      toYyyymm: sp.toYyyymm,
      divisionId: sp.divisionId,
      group: sp.group || 'ALL',
      plantId: joinCsv(sp.plantIds),
      factoryId: joinCsv(sp.factoryIds),
      versionId: sp.versionId,
      lineId: joinCsv(sp.lineIds),
      operationId: joinCsv(sp.operationIds),
      modelId: sp.modelId.trim() === '' ? 'ALL' : sp.modelId.trim(),
      itemId: sp.materialId.trim() === '' ? 'ALL' : sp.materialId.trim(),
      nickName: 'ALL',
      bucket: sp.bucketDay ? 'D,M' : 'M',
      checkLoss: sp.checkLoss ? 'Y' : 'N',
      checkLine: sp.checkLine ? 'Y' : 'N',
      checkTact: sp.checkTact ? 'Y' : 'N',
      checkYield: sp.checkYield ? 'Y' : 'N',
      checkEmpty: sp.checkEmpty ? 'Y' : 'N',
      userAuth,
      searchType: 'CAPA',
      debugMode: 'F',
    };
    const newCalendarFilters: ProcRequest<MENU_ID, SHEETS.CALENDAR> = {
      todayYyyymmdd: dayjs().format('YYYYMMDD'),
      fromYyyymm: sp.fromYyyymm,
      toYyyymm: sp.toYyyymm,
      bucket: sp.bucketDay ? 'D,M' : 'M',
    };
    const isSame =
      JSON.stringify(get().filters) === JSON.stringify(newFilters) &&
      JSON.stringify(get().calendarFilters) === JSON.stringify(newCalendarFilters);
    set(state => {
      state.filters = newFilters;
      state.calendarFilters = newCalendarFilters;
    });
    return isSame;
  },
  // Division 전환 시 그리드 초기화 — filters 무효화로 useTabProcQuery enabled=false → rows 즉시 비움.
  clearFilters: () =>
    set(state => {
      state.filters = undefined;
      state.calendarFilters = undefined;
      state.calendar = [];
      state.summary = EMPTY_SUMMARY;
    }),
  setOpenSearchArea: open =>
    set(state => {
      state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
    }),
  fetchStaticColumns: () => {
    void (async () => {
      try {
        const result = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME, divisionId: get().searchParams.divisionId }
        );
        set(state => {
          state.staticColumns = result.data.result ?? [];
        });
      } catch {
        // 메타 미적재 시 빈 배열 유지 — 화면은 메타 주도(fallback 없음).
      }
    })();
  },
  setCalendar: rows =>
    set(state => {
      state.calendar = rows;
    }),
  setSummary: summary =>
    set(state => {
      state.summary = summary;
    }),
  setVersionOptions: rows =>
    set(state => {
      // 'Current' 선두 고정 + 최신 30건(02 §4). 중복 'Current' 제거.
      state.versionOptions = [
        { code: VERSION_CURRENT, name: VERSION_CURRENT },
        ...rows.filter(r => r.code !== VERSION_CURRENT),
      ];
    }),
  setPeriodMaxYyyymm: yyyymm =>
    set(state => {
      state.periodMaxYyyymm = yyyymm;
    }),
}), 'capa');
