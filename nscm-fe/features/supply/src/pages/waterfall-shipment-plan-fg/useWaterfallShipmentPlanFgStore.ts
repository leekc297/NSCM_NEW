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
  CONDITION_NOT_SAVED,
  MENU_ID,
  SHEETS,
  SP_SHEET_NAME,
  VERSION_CODE_LENGTH,
} from './waterfall-shipment-plan-fg.constants';
import type { SearchParams } from './waterfall-shipment-plan-fg.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.TITLE]?: ProcRequest<MENU_ID, SHEETS.TITLE>;
  [SHEETS.TITLE_ISO]?: ProcRequest<MENU_ID, SHEETS.TITLE_ISO>;
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
  // F6(SubTitle searchParam) 저장조건 복원 1회 가드 — 같은 탭 재마운트(tabId effect 재발화) 시 중복 복원 방지.
  conditionsRestored: boolean;
}

interface Action {
  reset: () => void;
  setSearchParams: (p: Partial<SearchParams>) => void;
  // division 변경 = 검색조건(Division·기간 제외) 전부 초기화 + 그리드 clear (TO-BE 공통 요건, design 02 §3, Hook #5).
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
  // F6 저장조건(서버 개인화) 복원 — 진입 시 1회 GET → searchParams 패치(basic-check #3).
  restoreSearchConditions: () => Promise<void>;
}

type DayRange = { fromYyyymmdd: string; toYyyymmdd: string };

// AS-IS DateUtil.GetDayRange → 서버 SP SCM0001_GET_SCP_MONTH_PERIOD 이식(design 02 §C6/§3).
//   AS-IS 원본은 리포 GSCM/ 에 있어 실측(AGENT rule #5 / SCP0016.cs:214·609·1162 → DateUtil.cs:156):
//   SP Branch1(선택 Version 의 weekly plan 이 SCM_MST_PLAN 에 존재 — Version 필수라 상시 경로)은
//   bucket·division 무관하게 to = from + 363일. (AS-IS MSSQL 실측: PLAN_NAME 20260824 → 20270822, span 363.)
//   종전 근사(+12개월−1일 · MONTHLY 월초정렬)는 설계 C6 의 "SP 없음" 오기에 기반한 추정이라 제거한다.
const getDayRange = (
  division: string,
  bucket: BUCKET_TYPE,
  from: ReturnType<typeof dayjs>
): DayRange => {
  void division; // AS-IS SP 시그니처 파라미터 — Branch1 산식 미반영(SP 실측 확인)
  void bucket; // AS-IS Branch1 은 bucket 무관 (월초정렬 없음)
  return {
    fromYyyymmdd: from.format('YYYYMMDD'),
    toYyyymmdd: from.add(363, 'day').format('YYYYMMDD'),
  };
};

// 버전 미선택(mount/reset) 기본 = AS-IS SP Branch2(GetWaterInit cs:214, strFromDate 공란):
//   from = 오늘, to = (오늘 + 12개월)을 그 주의 주초(일요일)로 라운딩.
//   AS-IS SP ELSE 분기 — SCM_SYS_CALENDAR_M MAX 를 `-DATEPART(DW)+1`(일요일 시작) 로 당긴다.
//   화면 실측(81 Division, Version 미선택): 오늘 2026-10-20 → 2026-10-20 ~ 2027-10-17.
const defaultPeriod = (): DayRange => {
  const from = dayjs();
  const maxEnd = from.add(12, 'month');
  const to = maxEnd.subtract(maxEnd.day(), 'day'); // dayjs day(): Sun=0 → 그 주 일요일로 당김
  return { fromYyyymmdd: from.format('YYYYMMDD'), toYyyymmdd: to.format('YYYYMMDD') };
};

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
  conditionsRestored: false, // F6 저장조건 복원 1회 가드
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
        // AS-IS cboBucketType_SelectedIndexChanged / dCalendar_ValueChanged → InitSpread_2 →
        //   siMain.InitSheet()(RowCount=0)로 Bucket·Period 변경 시 그리드를 비운다(재조회 전까지 빈 상태).
        //   TO-BE 도 등가로 bucket·period patch 면 filters 를 clear 한다(Version 은 setVersions 에서 처리).
        if ('bucket' in p || 'fromYyyymmdd' in p || 'toYyyymmdd' in p) {
          state.filters = {};
        }
      }),
    setDivision: divisionId =>
      set(state => {
        const cur = get().searchParams;
        state.searchParams = {
          // Division·기간 제외 전 조건 초기화(opGroup/version/electrode/bucket/item/project/sum)
          //   — TO-BE 공통 요건(싱글콤보 Division 변경 = 검색조건 초기화 + 그리드 초기화, 정본 SCP0025).
          ...initSearch,
          divisionId,
          fromYyyymmdd: cur.fromYyyymmdd, // 기간/날짜는 유지(version 재산정 전까지 현재 기간)
          toYyyymmdd: cur.toYyyymmdd,
        };
        state.filters = {}; // 그리드 데이터 clear (Hook #5) — 재조회(Search) 전까지 빈 상태
        // 컬럼/Measure 개인화는 division 별로 다를 수 있어 메타 기본으로 되돌린다.
        state.visibleMeasures = null;
        state.columnSettings = null;
      }),
    // Version 변경 → Period 재산정 (AS-IS ClbVersion_SelectedIndexChanged → GetDayRange(), design 02 §3).
    //   AS-IS 는 선택/해제 모두에서 GetDayRange() 를 재호출한다: 선택 시 strFromDate=계획시작일 → Branch1(+363),
    //   전체 해제(ALL) 시 strFromDate 공란 → Branch2(오늘 기본값)로 복귀. 선택했는데 코드가 무효면 기간 유지.
    //   PeriodField 수동 변경은 이후에도 그대로 override.
    setVersions: versionNos =>
      set(state => {
        const cur = get().searchParams;
        const next: SearchParams = { ...cur, versionNos };
        const period =
          versionNos.length === 0
            ? defaultPeriod() // 전체 해제 = AS-IS GetDayRange() 공란 → Branch2 오늘 기본값 복귀
            : periodFromVersion(versionNos[0], cur.divisionId, cur.bucket);
        if (period) {
          next.fromYyyymmdd = period.fromYyyymmdd;
          next.toYyyymmdd = period.toYyyymmdd;
        }
        state.searchParams = next;
        // AS-IS ClbVersion_SelectedIndexChanged → dCalendar.InitValue 재설정 → ValueChanged →
        //   cboBucketType_SelectedIndexChanged → InitSpread_2 → InitSheet()로 그리드를 비운다.
        //   TO-BE 도 Version 변경 시 등가로 filters 를 clear(재조회 전까지 빈 상태).
        state.filters = {};
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
            programId: MENU_ID, //  9 p_program_id
            sheetName: SP_SHEET_NAME, // 10 p_sheet_name ('Shipment Plan FG'; 11 p_user_id = 세션 자동)
            // 메인 SP 는 P_ISO 파라미터가 없다(DB 실측: P_SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL 12-IN).
            //   ISO 여부는 아래 TITLE_ISO 캘린더 SP 가 W_..._ISO 컬럼명을 내느냐로만 결정한다(AS-IS 등가).
          },
          // 캘린더 헤더 — bucket 에 맞는 시트만 Grid 가 enable 한다(아래 2개 중 하나만 실제 호출).
          [SHEETS.TITLE]: {
            startYyyymmdd: from, // 1 P_START_YYYYMMDD (공용 캘린더 SP 2-IN, NotISO)
            endYyyymmdd: to, // 2 P_END_YYYYMMDD
          },
          [SHEETS.TITLE_ISO]: {
            startYyyymmdd: from, // 1 P_START_YYYYMMDD (ISO 캘린더 SP 2-IN — P_USER_ID 없음, DB 실측)
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
        // divisionId 를 넘기지 않는다(빈값 → SP P_DIVISION_ID IS NULL 분기 → 전체 반환).
        //   SCM_MST_SHEET_MEASURE 의 measure 는 DIVISION_ID=NULL(전 사업부 공통)인데, SP
        //   PR_GET_SHEET_MEASURE_LIST 의 필터가 `P_DIVISION_ID IN (split(M.DIVISION_ID))` 라
        //   구체 division('40')을 넘기면 NULL 분할=공집합이 되어 공통 measure 가 전부 탈락한다
        //   (조회 후 저장→재조회 시 팝업 공란 버그). 컬럼 메타 fetch 와 동일하게 division 미전달로 통일.
        const res = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: ADMIN_MEASURE_SHEET_NAME,
          divisionId: '',
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
    // F6(SubTitle searchParam) 개인화 저장분 복원(진입 1회) — 자매 production-plan-waterfall(SCP0017) 파리티(basic-check #3).
    //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 를 searchParams 에 패치한다.
    //   저장측(gridAction.ts personalizeCondition)이 배열→콤마결합·불리언→'true'/'false'로 coerce 하고
    //   기간(from/to yyyymmdd)·빈값은 저장 제외하므로, 복원은 initSearch 의 필드 타입으로 역-coerce 한다
    //   (배열=split(',') / 불리언='true' 비교 / 그 외=문자열). 날짜는 응답에 없어 기본값 유지.
    //   주의: setDivision(cascade) 를 거치지 않고 직접 치환 — 저장된 하위조건(version/electrode/bucket 등)을 보존한다.
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
          // Version 은 ConditionNotUse(저장 제외) — 저장측(Page)에서 이미 뺐지만, 수정 전 저장된 낡은
          //   version 행이 서버에 남아 있을 수 있어 복원측에서도 건너뛴다(AS-IS 파리티, CONDITION_NOT_SAVED).
          if (CONDITION_NOT_SAVED.includes(paramNm)) continue;
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
  'waterfall-shipment-plan-fg-store'
);
