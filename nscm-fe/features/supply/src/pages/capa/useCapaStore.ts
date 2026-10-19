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

// F6 개인화 조회조건 복원 역직렬화 키 — SubTitle personalizeCondition 저장은 값을 평문화한다
//   (배열=콤마 join / 불리언=String(true/false) / 그 외 String). 복원 시 유형별 역변환에 쓴다.
//   날짜(fromYyyymm/toYyyymm)는 저장 제외(gridAction EXCLUDED_DATE_PARAM `yyyymm$`)라 복원 응답에 없다.
const RESTORE_ARRAY_KEYS = new Set<string>(['plantIds', 'factoryIds', 'lineIds', 'operationIds']);
const RESTORE_BOOL_KEYS = new Set<string>([
  'bucketDay',
  'checkLoss',
  'checkLine',
  'checkTact',
  'checkYield',
  'checkResult',
  'checkEmpty',
]);

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
  /** F6 개인화 조회조건 복원 1회 가드(탭 수명 내 1회 — 새로고침 시 새 store 라 재복원). */
  conditionsRestored: boolean;
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
  /** F6 저장 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchParams 패치(1회). */
  restoreSearchParams: () => Promise<void>;
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
  conditionsRestored: false,
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
  // F6 개인화 조회조건 복원(SubTitle personalizeCondition 저장분 되불러오기 — 탭 수명 내 1회).
  //   저장분 없으면 기본값 유지. 날짜는 저장 제외라 복원 대상 아님(기간은 mount GET_DAY_RANGE 시드 유지).
  //   형제 supply/shipment-plan-fix restoreSearchConditions 와 1:1. division 이 복원되면 division-변경
  //   effect(Capa.tsx)가 그리드 clear + 컬럼/Version 재조회를 담당한다(searchParams 은 유지 — merge).
  restoreSearchParams: async () => {
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
        if (!(paramNm in init)) continue;
        const val = paramCtn ?? '';
        if (RESTORE_ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
        else if (RESTORE_BOOL_KEYS.has(paramNm)) patch[paramNm] = val === 'true';
        else patch[paramNm] = val;
      }
      set(state => {
        state.searchParams = { ...state.searchParams, ...(patch as Partial<CapaSearchParams>) };
      });
    } catch {
      // 미저장/조회 실패 = 기본값 유지(console 금지 룰).
    }
  },
  // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division·기간(fromYyyymm/toYyyymm)을 제외한 검색조건을
  //   전부 초기화하고 그리드(요약·캘린더 포함)도 비운다(사용자 지시 2026-10-02 — TO-BE 공통 요건이 AS-IS
  //   핸들러보다 우선). 하위 cascade(group/plant/factory/line/operation)·version·model/material·bucket·
  //   체크박스 전부 init 복귀, 기간만 유지(mount GET_DAY_RANGE 시드값 보존). 컬럼 메타 재조회·editTracker
  //   리셋은 division-변경 effect(Capa.tsx)가 담당. 편집중(dirty) 가드(MSG00704)는 Form onChange 가
  //   confirmIfDirtyKey 로 처리한다(commit 51d4e9fa 패턴).
  changeDivision: divisionId =>
    set(state => {
      const cur = get().searchParams;
      state.searchParams = {
        ...makeInitSearchParams(),
        divisionId,
        fromYyyymm: cur.fromYyyymm,
        toYyyymm: cur.toYyyymm,
      };
      state.versionOptions = [{ code: VERSION_CURRENT, name: VERSION_CURRENT }];
      state.filters = undefined;
      state.calendarFilters = undefined;
      state.calendar = [];
      state.summary = EMPTY_SUMMARY;
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
