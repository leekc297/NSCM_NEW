import type { MeasureMeta } from 'features/master/src/components';

import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { type ColumnLayoutRow } from '@shared/components';
import { createPersistedStoreWithTab } from '@shared/stores';

import {
  ADMIN_COLUMN_SHEET_NAME,
  ADMIN_MEASURE_SHEET_NAME,
  BUCKET_TYPE,
  MENU_ID,
  SHEETS,
  SP_SHEET_NAME,
  VERSION_CODE_LENGTH,
} from './waterfall-shipment-plan-fg.constants';
import type { SearchParams } from './waterfall-shipment-plan-fg.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.TITLE]?: ProcRequest<MENU_ID, SHEETS.TITLE>;
};

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  searchParams: SearchParams;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // admin SCM_MST_SHEET_COLUMNS('Waterfall Shipment Plan') 동적 fetch — SCP0016 28행 등록 확인됨(ora.py).
  staticColumns: StaticColumnsBySheet;
  // admin SCM_MST_SHEET_MEASURE('Shipment Plan FG') 동적 fetch — Measure 팝업 원천(design 03 §4.3, 8행).
  staticMeasures: MeasureMeta[];
  // Measure 팝업(MeasureSelectModal) OK 결과 — 표시 measure 코드(null = 전체). 행 필터 입력.
  visibleMeasures: string[] | null;
  // Column Set 팝업(ColumnLayoutModal) OK 결과 — 컬럼 표시/순서/폭/색(null = 미설정 = 메타 기본).
  columnSettings: ColumnLayoutRow[] | null;
  // 권한 Division 0건 게이트(design 01 D9, SetDivisionAuthCheck) — true 면 조회영역 disable + 조회 미발사.
  noDivisionAuth: boolean;
}

interface Action {
  reset: () => void;
  setSearchParams: (p: Partial<SearchParams>) => void;
  // division 변경 = 하위 cascade 초기화 + 그리드 clear (design 02 §3, Hook #5).
  setDivision: (divisionId: string) => void;
  // Version 변경 = Period(dCalendar) 재산정 (AS-IS ClbVersion_SelectedIndexChanged → GetDayRange, design 02 §3).
  setVersions: (versionNos: string[]) => void;
  // 조회 발사 — main + title(캘린더) payload 구성. userId = 세션 사용자.
  setFilters: (input: { userId: string }) => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: () => Promise<void>;
  applyVisibleMeasures: (codes: string[] | null) => void;
  applyColumnSettings: (rows: ColumnLayoutRow[] | null) => void;
  // 권한 Division 0건 여부 승계 — Form(콤보 실측) → page(조회 액션 차단).
  setNoDivisionAuth: (value: boolean) => void;
}

type DayRange = { fromYyyymmdd: string; toYyyymmdd: string };

// AS-IS DateUtil.GetDayRange(division, bucket, fromDate) 이식(design 02 §2 C6/§3). 공통 유틸 본문은 이 화면
//   소스 밖이고 AS-IS 원본(회사 소스) 접근이 차단돼 직접 실측 불가 — 확인된 사실만 반영한다:
//   (a) 기본 오프셋 12개월(자매 SCP0017 이 DateUtil.cs:156 실측). Check_PeriodDate 상한(from+1년+7일=371일) 이내.
//   (b) bucket 반영: MONTHLY 는 월 단위 계획이라 anchor 를 월초로 정렬(월중 시작 배제). DAILY/WEEKLY/WEEKLY_ISO
//       는 version 계획시작일(주 시작)을 그대로 anchor 로 쓴다.
//   division 은 AS-IS 시그니처 파라미터로 받되 기본 기간을 바꾼다는 근거가 없어 산식에 미반영한다 — 근거 없는
//   division 별 offset 임의 부여는 anti-simplification 위반이라 하지 않는다(정본 확인 후 반영, design 02 §7 확인필요).
const getDayRange = (
  division: string,
  bucket: BUCKET_TYPE,
  from: ReturnType<typeof dayjs>
): DayRange => {
  void division; // 시그니처 파라미터(확인필요) — 정본 산식 확정 후 반영
  const anchor = bucket === BUCKET_TYPE.MONTHLY ? from.startOf('month') : from;
  return {
    fromYyyymmdd: anchor.format('YYYYMMDD'),
    toYyyymmdd: anchor.add(12, 'month').subtract(1, 'day').format('YYYYMMDD'),
  };
};

// 버전 미선택(mount/reset) 기본 = 당월 1일 anchor. division 미정('')·bucket 기본 DAILY 로 getDayRange.
const defaultPeriod = (): DayRange => getDayRange('', BUCKET_TYPE.DAILY, dayjs().startOf('month'));

// AS-IS ClbVersion_SelectedIndexChanged → dCalendar.InitValue = GetDayRange(division, bucket, versionStart).
//   versionStart = 선택 version 코드 뒤 8자(SP_W_YYYYMMDD 의 계획시작일). 코드가 무효면 null(기존 기간 유지).
const periodFromVersion = (
  versionNo: string | undefined,
  division: string,
  bucket: BUCKET_TYPE
): DayRange | null => {
  const v = String(versionNo ?? '');
  if (v.length < VERSION_CODE_LENGTH) return null;
  const from = dayjs(v.slice(-8), 'YYYYMMDD');
  return from.isValid() ? getDayRange(division, bucket, from) : null;
};

const initSearch: SearchParams = {
  divisionId: '',
  operationGroupId: '',
  versionNos: [],
  electrodeTypes: [],
  bucket: BUCKET_TYPE.DAILY, // design 02 §4.3 기본 DAILY
  ...defaultPeriod(),
  itemId: '',
  projectCode: '',
  chkSum: false,
};

const emptyStaticColumns: StaticColumnsBySheet = { [SHEETS.MAIN]: [] };

const initState: State = {
  initialized: false,
  searchParams: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: emptyStaticColumns,
  staticMeasures: [],
  visibleMeasures: null,
  columnSettings: null,
  noDivisionAuth: false, // 콤보 미조회 상태 기본 허용(divisions undefined 동안 조회 미차단)
};

// 다중 선택 배열 → SP 파라미터 문자열. 빈 배열 = 'ALL' sentinel.
const joinOrAll = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join(','));
const orAll = (v: string): string => (v && v.trim() ? v.trim() : 'ALL');
const dash = (s: string): string => s.replace(/-/g, '');

export const useWaterfallShipmentPlanFgStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () =>
      set(state => {
        state.searchParams = { ...initSearch, ...defaultPeriod() };
        state.filters = {};
        state.openSearchArea = true;
        state.visibleMeasures = null;
        state.columnSettings = null;
      }),
    setSearchParams: p =>
      set(state => {
        state.searchParams = { ...get().searchParams, ...p };
      }),
    setDivision: divisionId =>
      set(state => {
        state.searchParams = {
          ...get().searchParams,
          divisionId,
          operationGroupId: '',
          versionNos: [],
          electrodeTypes: [], // EE 아니면 어차피 disable+clear
        };
        state.filters = {}; // 그리드 데이터 clear (Hook #5)
        // 컬럼/Measure 개인화는 division 별로 다를 수 있어 메타 기본으로 되돌린다.
        state.visibleMeasures = null;
        state.columnSettings = null;
      }),
    // Version 변경 → Period 재산정 (AS-IS ClbVersion_SelectedIndexChanged, design 02 §3). 코드 뒤 8자 = 계획시작일.
    //   코드가 무효면 기간 유지(추측 금지). PeriodField 수동 변경은 이후에도 그대로 override.
    setVersions: versionNos =>
      set(state => {
        const cur = get().searchParams;
        const next: SearchParams = { ...cur, versionNos };
        const period = periodFromVersion(versionNos[0], cur.divisionId, cur.bucket);
        if (period) {
          next.fromYyyymmdd = period.fromYyyymmdd;
          next.toYyyymmdd = period.toYyyymmdd;
        }
        state.searchParams = next;
      }),
    // 메인 GET 파라미터 매핑 (design 02 §5 / 03 §4.2 — SP IN 순번 주석) + title(캘린더 start/end) payload.
    setFilters: ({ userId }) => {
      set(state => {
        const p = state.searchParams;
        const from = dash(p.fromYyyymmdd);
        const to = dash(p.toYyyymmdd);
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: orAll(p.divisionId), //  1 p_division_id (단일)
            fromYyyymmdd: from, //  2 p_from_yyyymmdd
            toYyyymmdd: to, //  3 p_to_yyyymmdd
            bizType: orAll(p.operationGroupId), //  4 p_biz_type (단일)
            projectCode: p.projectCode.trim(), //  5 p_project_code (Project 팝업 결과)
            itemId: p.itemId.trim(), //  6 p_item_id (Model 팝업 결과)
            versionNo: p.versionNos.join(','), //  7 p_version_no (다중, IN-list)
            electype: joinOrAll(p.electrodeTypes), //  8 p_electype (다중, ALL→NULL)
            iso: p.bucket === BUCKET_TYPE.WEEKLY_ISO ? 'T' : 'F', //  9 p_iso
            programId: MENU_ID, // 10 p_program_id
            sheetName: SP_SHEET_NAME, // 11 p_sheet_name ('Shipment Plan FG'; 12 p_user_id = 세션 자동)
          },
          [SHEETS.TITLE]: {
            startYyyymmdd: from, // 1 P_START_YYYYMMDD (공용 캘린더 SP 2-IN)
            endYyyymmdd: to, // 2 P_END_YYYYMMDD
          },
        };
        void userId; // 세션 user_id 는 BE @LoginUser 자동 주입 — payload 미전달
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),
    // admin SCM_MST_SHEET_COLUMNS('Waterfall Shipment Plan') 동적 fetch — 미등록/실패 시 빈 배열(그리드 메타 fallback).
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_COLUMN_SHEET_NAME }
        );
        const next = res.data.result ?? [];
        if (next.length > 0) {
          set(state => {
            if (JSON.stringify(state.staticColumns[SHEETS.MAIN]) !== JSON.stringify(next)) {
              state.staticColumns[SHEETS.MAIN] = next;
            }
          });
        }
      } catch {
        // 미등록/실패 = 빈 배열 fallback (console 금지 룰)
      }
      set(state => {
        state.initialized = true;
      });
    },
    // admin SCM_MST_SHEET_MEASURE('Shipment Plan FG') 동적 fetch — Measure 팝업 원천(design 03 §4.3). 미등록 시 빈 배열.
    fetchStaticMeasures: async () => {
      try {
        const res = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: ADMIN_MEASURE_SHEET_NAME,
          divisionId: get().searchParams.divisionId,
        });
        const next = res.data.result ?? [];
        set(state => {
          state.staticMeasures = next;
        });
      } catch {
        // 미등록/실패 = 빈 배열 fallback (console 금지 룰)
      }
    },
    // MeasureSelectModal OK — 표시 measure 코드(null = 전체). 그리드 행 필터 입력(page visibleData).
    applyVisibleMeasures: codes =>
      set(state => {
        state.visibleMeasures = codes;
      }),
    // ColumnLayoutModal OK — 컬럼 표시/순서/폭/색. 팝업 재진입 복원값(서버 titleSet 저장 후 재fetch 로 반영).
    applyColumnSettings: rows =>
      set(state => {
        state.columnSettings = rows;
      }),
    setNoDivisionAuth: value =>
      set(state => {
        state.noDivisionAuth = value;
      }),
  }),
  'waterfall-shipment-plan-fg-store'
);
