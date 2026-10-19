import type { MeasureMeta } from 'features/master/src/components';

import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { type ColumnLayoutRow } from '@shared/components';
import { createPersistedStoreWithTab } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  BUCKET_TYPE,
  LINE_SENTINEL,
  MENU_ID,
  SHEETS,
  VERSION_CODE_LENGTH,
} from './production-plan-waterfall.constants';
import type { SearchParams } from './production-plan-waterfall.types';

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
  // admin SCM_MST_SHEET_COLUMNS('MODEL') 동적 fetch (ui-dynamic-property-management). SCP0017 25행 등록 확인됨.
  staticColumns: StaticColumnsBySheet;
  // admin SCM_MST_SHEET_MEASURE('MODEL') 동적 fetch — Measure(btnMeasure) 팝업 원천(design 03 §1.3, 6행).
  staticMeasures: MeasureMeta[];
  // Measure 팝업(MeasureSelectModal) OK 결과 — 표시 measure 코드(null = 전체). 행 필터 입력.
  visibleMeasures: string[] | null;
  // Column Set 팝업(ColumnLayoutModal) OK 결과 — 컬럼 표시/순서/폭/색(null = 미설정 = 메타 기본).
  columnSettings: ColumnLayoutRow[] | null;
  // 권한 Division 0건 게이트(design 01 L1, SetDivisionAuthCheck) — true 면 조회영역 disable + 조회 미발사(G6).
  noDivisionAuth: boolean;
}

interface Action {
  reset: () => void;
  setSearchParams: (p: Partial<SearchParams>) => void;
  // division 변경 = 하위 cascade 초기화 + 그리드 clear (design 02 §3, Hook #5).
  setDivision: (divisionId: string) => void;
  // Version 변경 = Period(dCalendar) 재산정 (AS-IS CboVersion_SelectedIndexChanged → GetDayRange, design 02 §3).
  setVersions: (versionNos: string[]) => void;
  // 전체기간(chkAll) 토글 = 그리드 재구성 + 데이터 clear (AS-IS ChkAll_CheckedChanged, design 03 §2.5).
  setChkAll: (checked: boolean) => void;
  // 조회 발사 — main(15 IN) + title(캘린더) payload 구성. userId = 세션 사용자.
  setFilters: (input: { userId: string }) => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: () => Promise<void>;
  applyVisibleMeasures: (codes: string[] | null) => void;
  applyColumnSettings: (rows: ColumnLayoutRow[] | null) => void;
  // 권한 Division 0건 여부 승계 — Form(콤보 실측) → page(조회 액션 차단, G6).
  setNoDivisionAuth: (value: boolean) => void;
}

// FROM 기준 + 12개월 범위 산정(공통) — AS-IS DateUtil.GetDayRange 기본 offset 재현(G2).
//   AS-IS DateUtil.GetDayRange(div, bucket, planStart, sOffsetMonth="12") = 서버 SP SCM0001_GET_SCP_MONTH_PERIOD
//   (GSCM/01.Framework/.../DateUtil.cs:156~185 실측 — 기본 오프셋 12개월). SP 미배포(ora.py all_objects 0)라
//   클라에서 offset 12개월로 근사한다(iter-2 의 +3개월 추측 제거). 정본(division/bucket 반영·경계 반올림)은
//   SCM0001_GET_SCP_MONTH_PERIOD 상당 SP 배선 후 확정(convert-sp 후속, 04 리포트 확인필요).
//   상한: Check_PeriodDate 는 from+1년+7일(371일) 미만을 요구 → 12개월(약 365일)은 상한 이내(G7 정합).
const rangeFrom = (from: ReturnType<typeof dayjs>): { fromYyyymmdd: string; toYyyymmdd: string } => ({
  fromYyyymmdd: from.format('YYYYMMDD'),
  toYyyymmdd: from.add(12, 'month').subtract(1, 'day').format('YYYYMMDD'),
});

// AS-IS GetDayRange(division, bucket, versionStart) 근사 (offset 12개월):
//   버전 미선택(mount/reset) 기본 = 당월 1일 anchor + 12개월. 실 산식 확정 시 교체(SP 배선 후).
const defaultPeriod = (): { fromYyyymmdd: string; toYyyymmdd: string } => rangeFrom(dayjs().startOf('month'));

// AS-IS CboVersion_SelectedIndexChanged → dCalendar.InitValue = GetDayRange(...,versionStart) (cs:1018-1020,
//   2176-2202). versionStart = 선택 version 코드 뒤 8자(PP_W_YYYYMMDD 의 계획시작일). FROM = versionStart,
//   TO = +12개월-1일(AS-IS offset 12개월, DateUtil.cs:156). anchor(versionStart) + offset 12 를 확정 반영해
//   dead cascade(G2)를 해소한다. 버전 코드가 무효면 null(기존 기간 유지).
const periodFromVersion = (
  versionNo: string | undefined
): { fromYyyymmdd: string; toYyyymmdd: string } | null => {
  const v = String(versionNo ?? '');
  if (v.length < VERSION_CODE_LENGTH) return null;
  const from = dayjs(v.slice(-8), 'YYYYMMDD');
  return from.isValid() ? rangeFrom(from) : null;
};

const initSearch: SearchParams = {
  divisionId: '',
  operationGroupId: '',
  plantSiteIds: [],
  lineIds: [],
  versionNos: [],
  electrodeTypes: [],
  bucket: BUCKET_TYPE.DAILY, // design 02 §4.3 기본 DAILY
  ...defaultPeriod(),
  modelId: '',
  nickName: '',
  chkGap: false,
  chkAll: false,
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

export const useProductionPlanWaterfallStore = createPersistedStoreWithTab<State & Action>(
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
          plantSiteIds: [],
          lineIds: [],
          versionNos: [],
          electrodeTypes: [], // EE 아니면 어차피 disable+clear
        };
        state.filters = {}; // 그리드 데이터 clear (Hook #5)
        // 컬럼/Measure 메타는 division 별로 다를 수 있어 개인화(Column Set/Measure)를 메타 기본으로 되돌린다.
        state.visibleMeasures = null;
        state.columnSettings = null;
      }),
    // Version 변경 → Period 재산정 (AS-IS CboVersion_SelectedIndexChanged, G2). 버전 코드 뒤 8자 = 계획시작일.
    //   코드가 무효면 기간 유지(추측 금지). PeriodField 수동 변경은 이후에도 그대로 override 된다.
    setVersions: versionNos =>
      set(state => {
        const next: SearchParams = { ...get().searchParams, versionNos };
        const period = periodFromVersion(versionNos[0]);
        if (period) {
          next.fromYyyymmdd = period.fromYyyymmdd;
          next.toYyyymmdd = period.toYyyymmdd;
        }
        state.searchParams = next;
      }),
    // 전체기간(chkAll) 토글 = AS-IS ChkAll_CheckedChanged: InitSpread_2 그리드 재구성 + SpreadInfo.ClearDataSource.
    //   재구성은 조회 시 title/컬럼 파이프라인이 재수행하므로, 확정 효과인 데이터 clear(재조회 요구)를 재현한다.
    setChkAll: checked =>
      set(state => {
        state.searchParams = { ...get().searchParams, chkAll: checked };
        state.filters = {}; // ClearDataSource — 그리드 비움(재조회 필요)
      }),
    // 메인 GET 15-param 매핑 (design 03 §4.1 — SP IN 순번 주석) + title(캘린더) payload.
    setFilters: ({ userId }) => {
      set(state => {
        const p = state.searchParams;
        const from = dash(p.fromYyyymmdd);
        const to = dash(p.toYyyymmdd);
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: orAll(p.divisionId), //  1 p_division_id (단일)
            operationGroup: orAll(p.operationGroupId), //  2 p_operation_group (단일)
            scmSiteId: joinOrAll(p.plantSiteIds), //  3 p_scm_site_id (다중)
            itemId: p.modelId.trim(), //  4 p_item_id (Model 팝업 결과)
            fromYyyymmdd: from, //  5 p_from_yyyymmdd
            toYyyymmdd: to, //  6 p_to_yyyymmdd
            versionNo: p.versionNos.join(','), //  7 p_version_no (Gap 시 2건)
            electrodeType: joinOrAll(p.electrodeTypes), //  8 p_electrode_type (ALL→NULL)
            nickName: p.nickName.trim(), //  9 p_nick_name
            gap: p.chkGap ? 'Y' : 'N', // 10 p_gap
            lineId: joinOrAll(p.lineIds.filter(v => v !== LINE_SENTINEL)), // 11 p_line_id ('-'→제외)
            programId: MENU_ID, // 12 p_program_id
            sheetName: 'MODEL', // 13 p_sheet_name (14 p_user_id = 세션 자동)
            debugMode: 'F', // 15 debug_mode
          },
          [SHEETS.TITLE]: {
            divisionId: orAll(p.divisionId),
            bucket: p.bucket,
            fromYyyymmdd: from,
            toYyyymmdd: to,
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
    // admin SCM_MST_SHEET_COLUMNS('MODEL') 동적 fetch — 미등록/실패 시 빈 배열(그리드 메타 fallback).
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN }
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
    // admin SCM_MST_SHEET_MEASURE('MODEL') 동적 fetch — Measure 팝업 원천(design 03 §1.3). 미등록/실패 시 빈 배열.
    fetchStaticMeasures: async () => {
      try {
        const res = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN,
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
    // ColumnLayoutModal OK — 컬럼 표시/순서/폭/색. 팝업 재진입 복원값(서버 titleSet 저장 후 재fetch 로 그리드 반영).
    applyColumnSettings: rows =>
      set(state => {
        state.columnSettings = rows;
      }),
    setNoDivisionAuth: value =>
      set(state => {
        state.noDivisionAuth = value;
      }),
  }),
  'production-plan-waterfall-store'
);
