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
  // F6(SubTitle searchParam) 저장조건 복원 1회 가드 — 같은 탭 재마운트(tabId effect 재발화) 시 중복 복원 방지.
  conditionsRestored: boolean;
}

interface Action {
  reset: () => void;
  setSearchParams: (p: Partial<SearchParams>) => void;
  // division 변경 = 하위 cascade 초기화 + 그리드 clear (design 02 §3, Hook #5).
  setDivision: (divisionId: string) => void;
  // Version 변경 = Period(dCalendar) 재산정 (AS-IS CboVersion_SelectedIndexChanged → GetDayRange, design 02 §3).
  //   AS-IS 는 version 뒤 8자의 연도로 그 해 0101:1231 을 만든다(DateUtil.cs:362, 로컬 산식 — 서버 SP 아님).
  setVersions: (versionNos: string[]) => void;
  // 전체기간(chkAll) 토글 = 그리드 재구성 + 데이터 clear (AS-IS ChkAll_CheckedChanged, design 03 §2.5).
  setChkAll: (checked: boolean) => void;
  // 조회 발사 — main(15 IN) + title(캘린더) payload 구성. userId = 세션 사용자.
  setFilters: (input: { userId: string }) => void;
  // 날짜 동적컬럼 헤더만 선조회 — 진입 시 Division/Bucket/기간이 준비되면 TITLE(캘린더) filters 만
  //   세팅해 날짜 헤더를 미리 그린다(MAIN 데이터는 Search 게이트 유지, 자동조회 금지와 무충돌).
  setTitleFilters: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: () => Promise<void>;
  applyVisibleMeasures: (codes: string[] | null) => void;
  applyColumnSettings: (rows: ColumnLayoutRow[] | null) => void;
  // 권한 Division 0건 여부 승계 — Form(콤보 실측) → page(조회 액션 차단, G6).
  setNoDivisionAuth: (value: boolean) => void;
  // F6 저장조건(서버 개인화) 복원 — 진입 시 1회 GET → searchParams 패치(basic-check #3).
  restoreSearchConditions: () => Promise<void>;
}

// AS-IS DateUtil.GetDayRange(yyyymmdd) 재현 (GSCM/01.Framework/.../DateUtil.cs:362~379).
//   "일자에 해당하는 연도의 1/1~12/31" — 연도(앞 4자)만으로 0101:1231 을 만드는 로컬 순수 산식이다
//   (서버 SP SCM0001_GET_SCP_MONTH_PERIOD 호출 오버로드는 SCP0017 에서 주석 처리되어 쓰이지 않는다, cs:2551/2552).
//   yyyymmdd 가 비면 올해 연도.
const dayRangeOfYear = (yyyymmdd: string): { fromYyyymmdd: string; toYyyymmdd: string } => {
  const yyyy = /^\d{4}/.test(yyyymmdd) ? yyyymmdd.slice(0, 4) : dayjs().format('YYYY');
  return { fromYyyymmdd: `${yyyy}0101`, toYyyymmdd: `${yyyy}1231` };
};

// 버전 미선택(mount/reset) 기본 = 올해 0101:1231 (AS-IS init cs:532 GetDayRange() — version 미체크 → 올해).
const defaultPeriod = (): { fromYyyymmdd: string; toYyyymmdd: string } => dayRangeOfYear('');

// AS-IS CboVersion_SelectedIndexChanged → dCalendar.InitValue = GetDayRange(versionStart) (cs:1318-1321, 2527-2555).
//   versionStart = 선택 version 코드 뒤 8자(PP_W_YYYYMMDD 의 계획시작일)의 연도 → 그 해 0101:1231.
//   버전 코드가 무효면 null(기존 기간 유지).
const periodFromVersion = (
  versionNo: string | undefined
): { fromYyyymmdd: string; toYyyymmdd: string } | null => {
  const v = String(versionNo ?? '');
  if (v.length < VERSION_CODE_LENGTH) return null;
  const from = dayjs(v.slice(-8), 'YYYYMMDD');
  return from.isValid() ? dayRangeOfYear(from.format('YYYYMMDD')) : null;
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
  conditionsRestored: false, // F6 저장조건 복원 1회 가드
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
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division·기간(from/to)을 제외한 검색조건을 전부 초기화하고
    //   그리드도 초기화(filters clear)한다(SCP0025 선례, commit 51d4e9fa 패턴 — TO-BE 공통 요건이 AS-IS 핸들러보다 우선).
    //   유지: divisionId(새 값) + 기간(from/to). 초기화: operationGroup/plantSite/line/version/electrode/bucket/
    //   model/nickName/chkGap/chkAll/chkSum(= initSearch 기본값). 편집중 가드(MSG00704)는 Form onChange 의
    //   confirmIfDirtyKey 가 처리 — 이 화면은 read-only 라 실제 dirty 는 없지만 공통 패턴을 동일하게 둔다.
    setDivision: divisionId =>
      set(state => {
        const cur = get().searchParams;
        state.searchParams = {
          ...initSearch, // Division·기간 제외 전 조건 초기화
          divisionId,
          fromYyyymmdd: cur.fromYyyymmdd, // 기간 유지
          toYyyymmdd: cur.toYyyymmdd,
        };
        state.filters = {}; // 그리드 데이터 clear — 재조회(Search) 전까지 빈 상태 (Hook #5)
        // 컬럼/Measure 메타는 division 별로 다를 수 있어 개인화(Column Set/Measure)를 메타 기본으로 되돌린다.
        state.visibleMeasures = null;
        state.columnSettings = null;
      }),
    // Version 변경 → Period 재산정 (AS-IS CboVersion_SelectedIndexChanged → GetDayRange, G2).
    //   AS-IS 는 version 뒤 8자의 연도로 그 해 0101:1231 을 만드는 로컬 산식뿐이다(DateUtil.cs:362 — 서버 SP 아님).
    //   version 코드가 무효면 기간 유지. PeriodField 수동 변경은 이후에도 사용자 입력대로 둔다.
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
    // 날짜 헤더(TITLE) 선조회 — Division 이 실제 값(콤보 자동선택 후)일 때만 세팅한다. divisionId 가
    //   비면 의미 있는 캘린더가 나오지 않으므로 no-op. MAIN filters 는 건드리지 않아 데이터 자동조회가
    //   발생하지 않는다. Search 로 MAIN 이 이미 조회됐으면(= filters[MAIN] 존재) 그때의 TITLE 과 어긋나지
    //   않게 선조회를 넘긴다 — Search 시 setFilters 가 MAIN·TITLE 을 함께 재구성하기 때문. Search 전에는
    //   Division/Bucket/기간 변경에 따라 헤더를 현재 조건으로 갱신한다.
    setTitleFilters: () => {
      set(state => {
        const p = state.searchParams;
        if (!p.divisionId) return;
        if (state.filters[SHEETS.MAIN]) return;
        const next = {
          divisionId: orAll(p.divisionId),
          bucket: p.bucket,
          fromYyyymmdd: dash(p.fromYyyymmdd),
          toYyyymmdd: dash(p.toYyyymmdd),
        };
        // 동일 조건이면 재세팅하지 않는다(effect 재평가·StrictMode 이중호출 시 중복 TITLE 조회 방지).
        const cur = state.filters[SHEETS.TITLE];
        if (
          cur &&
          cur.divisionId === next.divisionId &&
          String(cur.bucket) === String(next.bucket) &&
          cur.fromYyyymmdd === next.fromYyyymmdd &&
          cur.toYyyymmdd === next.toYyyymmdd
        ) {
          return;
        }
        state.filters[SHEETS.TITLE] = next;
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
    // F6(SubTitle searchParam) 개인화 저장분 복원(진입 1회) — 자매 inventory-trend(SCP)·scp-bom 파리티(basic-check #3).
    //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 를 searchParams 에 패치한다.
    //   저장측(gridAction.ts personalizeCondition)이 배열→콤마결합·불리언→'true'/'false'로 coerce 하고
    //   기간(from/to yyyymmdd)·빈값은 저장 제외하므로, 복원은 initSearch 의 필드 타입으로 역-coerce 한다
    //   (배열=split(',') / 불리언='true' 비교 / 그 외=문자열). 날짜는 응답에 없어 기본값 유지.
    //   주의: setDivision(cascade) 를 거치지 않고 직접 치환 — 저장된 하위조건(plantSite/line/version 등)을 보존한다.
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
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initSearch)) continue; // SearchParams 필드만 allowlist
          const def = initSearch[paramNm as keyof SearchParams];
          const value = paramCtn ?? '';
          if (Array.isArray(def)) patch[paramNm] = value === '' ? [] : value.split(',');
          else if (typeof def === 'boolean') patch[paramNm] = value === 'true';
          else patch[paramNm] = value;
        }
        set(state => {
          state.searchParams = { ...state.searchParams, ...(patch as Partial<SearchParams>) };
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지 룰)
      }
    },
  }),
  'production-plan-waterfall-store'
);
