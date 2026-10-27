import type { MeasureMeta } from 'features/master/src/components';

import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, BUCKET_TYPE, MENU_ID, SHEETS } from './production-plan-line.constants';
import type { MainRow, SearchCondition } from './production-plan-line.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.LOAD]?: ProcRequest<MENU_ID, SHEETS.LOAD>;
};

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  // F6 저장조건 복원 1회 가드(마운트 중복/재마운트 복원 방지 — fetchStaticColumns 의 initialized 와 별개).
  conditionsRestored: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // admin SCM_MST_SHEET_COLUMNS 동적 fetch (ui-dynamic-property-management §2.3). SCP0013 'Line' 27행 등록
  //   확인됨(ora.py 2026-09-16) → 미등록 시 빈 배열(그리드 constants fallback).
  staticColumns: StaticColumnsBySheet;
  // Measure 설정 팝업(btnMeasure) 동적 fetch — SCM_MST_SHEET_MEASURE(SHEET_NAME='LINE', 활성 6). AS-IS
  //   SCM0002_TitleSetForm_Popup(design 03 §6). forecast-price(DMF0082) MeasureSelectModal 과 동일 소스.
  staticMeasures: MeasureMeta[];
  // Fix/Unfix/New enable 엄밀판정용 최신 버전 CODE (design 01 R2 — planDate/planSeq 콤보 옵션 idx0).
  //   Form 이 콤보 옵션 로드 시 갱신 → 페이지 canFixUnfixNew 가 선택값과 대조(마지막 주차/SEQ 여부).
  latestPlanStart: string;
  latestPlanSeq: string;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setDivision: (divisionId: string) => void;
  setLatestVersion: (p: { latestPlanStart?: string; latestPlanSeq?: string }) => void;
  setFilter: () => void;
  clearFilters: () => void;
  // Load 팝업 — 부모 조회조건을 파라미터로 주입(design 01 P / BtnLoad_Click cs:944).
  setLoadFilter: () => void;
  clearLoadFilter: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  // Measure 설정 팝업용 measure 메타 fetch (SCM_MST_SHEET_MEASURE SHEET_NAME='LINE').
  fetchStaticMeasures: () => Promise<void>;
  // F6 로 저장한 조회조건을 마운트 시 불러와 searchCondition 에 적용(DMF0082 restoreSearchConditions 동등).
  restoreSearchConditions: () => Promise<void>;
}

// Period 기본값 — plan date 로드 전 임시 placeholder 다. 실제 Period 는 AS-IS GetDayRange(W52) 대로
//   ProductionPlanLineForm 이 "선택 Plan date" 기준으로 파생한다(from = plan date, to = from + 52*7-1).
//   AS-IS 는 CboPlanDate_SelectedIndexChanged(cs:3931) 에서 plan date 변경마다 GetDayRange 를 재산정하고,
//   SP p_offset_day = 주차*7-1("일요일 계산을 위한 하루를 뺀다", cs:4118)이라 끝날짜가 주의 마지막 날(일)에 떨어진다.
//   placeholder 는 당주 월요일 ~ +52주-1(동일 -1 적용). 모듈 로드 시 1회 평가(toISOString 금지).
const thisMonday = dayjs().add(1 - dayjs().day(), 'day');

const initSearch: SearchCondition = {
  // 기본 division = 세션 division(권한 division 첫 행 근사). Form 이 콤보 옵션과 대조해 교정.
  divisionId: useSessionStore.getState().session.div ?? '40',
  operationGroupId: '',
  plantSiteIds: [],
  lineIds: [],
  electrodeTypes: [],
  cellTypeGrs: [],
  extraSpecs: [],
  planStartYyyymmdds: [],
  planTypes: [],
  planSeqs: [],
  bucket: BUCKET_TYPE.WEEKLY, // design 01 A1 기본 WEEKLY
  fromYyyymmdd: thisMonday.format('YYYYMMDD'),
  toYyyymmdd: thisMonday.add(52 * 7 - 1, 'day').format('YYYYMMDD'),
  modelId: '',
  itemId: '',
  nickName: '',
  chkAll: false, // design 01 A1
  chkLineAssign: false,
  chkSum: false,
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.MAIN]: [],
};

const initState: State = {
  initialized: false,
  conditionsRestored: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: emptyStaticColumns,
  staticMeasures: [],
  latestPlanStart: '',
  latestPlanSeq: '',
};

// 다중 선택 배열 → SP 파라미터. 빈 배열(전체선택)은 '' — Oracle 바인드에서 NULL 취급되어 SP 옵션필터
//   'P_X IS NULL OR col IN (STRING_SPLIT(P_X,','))' 가 꺼진다(전체 반환). AS-IS 등가:
//   GetCheckedListValue(dt, ControlValues, isReturnEmptyString=true)(CString.cs:559-561)가 'ALL'/빈값→''.
//   주의: 'ALL' 리터럴을 보내면 PKG_SCP0013 에 'ALL' 특례가 없어(all_source 실측 0건) col IN ('ALL')=0건,
//   기본조회(plant/line 미선택)가 빈 그리드가 된다(design 02 §7 확인6 / 04_impl-gap-audit iter-6 H1).
const joinOrNull = (arr: string[]): string => (arr.length === 0 ? '' : arr.join(','));
// 필수 단일값(division/operationGroup) — 조회 필수 가드로 항상 실제 값. AS-IS GetCheckedListValue 2-arg 등가.
const orEmpty = (v: string): string => (v && v.trim() ? v.trim() : '');
const str = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// F6(Condition) 저장조건 복원용 — SubTitle 에 searchParam=sc(searchCondition) 를 그대로 넘기므로 저장분의
//   키가 searchCondition 필드명과 같다. personalizeCondition 이 전부 문자열로 coerce(배열=콤마조인·불리언=
//   문자열)하므로 복원 때 필드 타입대로 역coerce 한다.
const ARRAY_COND_KEYS = new Set<string>([
  'plantSiteIds',
  'lineIds',
  'electrodeTypes',
  'cellTypeGrs',
  'extraSpecs',
  'planStartYyyymmdds',
  'planTypes',
  'planSeqs',
]);
const BOOL_COND_KEYS = new Set<string>(['chkAll', 'chkLineAssign', 'chkSum']);

export const useProductionPlanLineStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // Form 이 콤보 옵션 idx0(최신 버전)을 밀어넣는다 — 페이지 canFixUnfixNew 엄밀판정 입력(design 01 R2).
    setLatestVersion: p =>
      set(state => {
        if (p.latestPlanStart !== undefined) state.latestPlanStart = p.latestPlanStart;
        if (p.latestPlanSeq !== undefined) state.latestPlanSeq = p.latestPlanSeq;
      }),
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division·기간(from/to)·날짜를 제외한 검색조건을 전부 초기화하고
    //   그리드도 초기화(filters clear)한다(apply-division-reset §2, 사용자 지시 2026-10-02 — TO-BE 공통 요건이
    //   AS-IS cascade-only 핸들러보다 우선, SCP0025 setDivision 정본 1:1). 종전엔 cascade 필드(opGroup/site/line/
    //   버전콤보)만 리셋하고 Model/Nickname(modelId/itemId/nickName)·Electrode·Bucket·SUM 은 유지돼, div 를 바꿔도
    //   Model/Nickname 등이 초기화되지 않는 결함이 있었다(사용자 신고 2026-10-12). initSearch 전개로 이들도 초기화한다.
    //   유지: Division(새 값) + 기간(from/to) — 기간은 Form 의 planDate 파생 effect 가 새 division 최신 plan-date 로
    //   곧 재산정하므로 전개 후에도 깨지지 않는다. 편집중(dirty) 가드(MSG00704)는 Form handleDivisionChange 가 담당.
    setDivision: divisionId =>
      set(state => {
        const cur = get().searchCondition;
        state.searchCondition = {
          ...initSearch, // Division·기간 제외 전 조건 초기화(opGroup/site/line/버전/electrode/bucket/sum/model/nick)
          divisionId,
          fromYyyymmdd: cur.fromYyyymmdd,
          toYyyymmdd: cur.toYyyymmdd,
        };
        state.filters = {}; // 그리드 데이터 clear (design 01 D2) — 재조회(Search) 전까지 빈 상태
      }),
    // 메인 GET 22-param 매핑 (design 02 §5.2 — SP IN 순번 주석). p_division_id/p_operation_group 단일값.
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: orEmpty(c.divisionId), //  1 p_division_id (단일 필수)
            operationGroup: orEmpty(c.operationGroupId), //  2 p_operation_group (단일 필수)
            scmSiteId: joinOrNull(c.plantSiteIds), //  3 p_scm_site_id (다중, 전체선택 ''→NULL)
            lineId: joinOrNull(c.lineIds.filter(v => v !== '-')), //  4 p_line_id ('-'→제외, 전체선택 '')
            modelId: str(c.modelId), //  5 p_model_id
            itemId: str(c.itemId), //  6 p_item_id
            fromYyyymmdd: c.fromYyyymmdd.replace(/-/g, ''), //  7 p_from_yyyymmdd
            toYyyymmdd: c.toYyyymmdd.replace(/-/g, ''), //  8 p_to_yyyymmdd
            planStartYyyymmdd: joinOrNull(c.planStartYyyymmdds), //  9 p_plan_start_yyyymmdd (단일 필수)
            planType: joinOrNull(c.planTypes), // 10 p_plan_type (단일 필수)
            seq: joinOrNull(c.planSeqs), // 11 p_seq (단일 필수)
            electrodeType: joinOrNull(c.electrodeTypes), // 12 p_electrode_type (전체선택 ''→NULL, AS-IS cs:2037 ALL→DBNull 등가)
            nickName: str(c.nickName), // 13 p_nick_name
            cellTypeGr: joinOrNull(c.cellTypeGrs), // 14 p_cell_type_gr (다중, 전체선택 '')
            bucket: c.bucket, // 15 p_bucket
            lineAssign: c.chkLineAssign ? 'Y' : 'N', // 16 p_line_assign
            // 17 p_chk_all — 전체보기(All Days) 고정 'Y'. AS-IS chkAll 체크와 동일하게 SP V_BUCKET='DAILY'
            //   강제(일자까지 조회). ALL 체크박스 UI 는 제거됨(2026-10-01). 자매 SCP0011 과 동일 처리 — store
            //   chkAll 은 false 유지(bucket=Daily 강제 효과 미발동 → Bucket 콤보 Weekly/활성 유지), payload·grid 만 고정.
            chkAll: 'Y',
            extraSpec: joinOrNull(c.extraSpecs), // 18 p_extra_spec (다중, 전체선택 '')
            programId: MENU_ID, // 19 p_program_id
            sheetName: 'LINE', // 20 p_sheet_name
            debugMode: 'F', // 22 debug_mode (21 p_user_id = 세션 자동)
          },
        };
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    // Load 팝업 조회 — 부모 조회조건 주입(design 01 P3 / 02 §4.6 BtnLoad_Click cs:928). 팝업은 완전 읽기전용.
    //   파라미터 정제(L7r 보완, design 02 §4.6): (a) from<planStart 면 planStart 로 보정(AS-IS cs:928)
    //   (b) line '-' sentinel 제외 (c) lineId 전달(LOAD SP P_LINE_ID pos4 — ora.py 2026-09-27 실측).
    setLoadFilter: () =>
      set(state => {
        const c = state.searchCondition;
        const planStart = c.planStartYyyymmdds[0] ?? '';
        const from = c.fromYyyymmdd.replace(/-/g, '');
        const fromClamped = planStart && from && from < planStart ? planStart : from;
        state.filters = {
          ...state.filters,
          [SHEETS.LOAD]: {
            divisionId: orEmpty(c.divisionId),
            operationGroup: orEmpty(c.operationGroupId),
            scmSiteId: joinOrNull(c.plantSiteIds), // 전체선택 ''→NULL(필터 off)
            lineId: joinOrNull(c.lineIds.filter(v => v !== '-')), // '-' sentinel 제외 + 전체선택 ''
            planStartYyyymmdd: joinOrNull(c.planStartYyyymmdds),
            planType: joinOrNull(c.planTypes),
            seq: joinOrNull(c.planSeqs),
            fromYyyymmdd: fromClamped, // from<planStart 보정
            toYyyymmdd: c.toYyyymmdd.replace(/-/g, ''),
            programId: MENU_ID,
            debugMode: 'F',
          },
        };
      }),
    clearLoadFilter: () =>
      set(state => {
        delete state.filters[SHEETS.LOAD];
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),
    // admin SCM_MST_SHEET_COLUMNS('Line') 동적 fetch — 미등록/실패 시 빈 배열(그리드 constants fallback).
    //   divisionId 를 함께 보내 서버(PR_GET_SHEET_COLUMN_LIST)가 DIVISION_ID(콤마 목록) 필터로 현재
    //   division 에 맞는 컬럼만 반환하게 한다(division 별 가시성 데이터화 — FE 하드코딩 제거).
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          {
            sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN,
            divisionId: get().searchCondition.divisionId,
          }
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
        // 미등록/실패 = constants fallback (console 금지 룰)
      }
      set(state => {
        state.initialized = true;
      });
    },
    // Measure 설정 팝업용 measure 메타 fetch — SCM_MST_SHEET_MEASURE(SHEET_NAME='LINE'). forecast-price
    //   fetchStaticMeasures 패턴 동일(/admin/menu/{MENU_ID}/measure). 실패 시 빈 배열(팝업 fallback).
    fetchStaticMeasures: async () => {
      try {
        const res = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: 'LINE',
          divisionId: get().searchCondition.divisionId,
        });
        const next = res.data.result ?? [];
        set(state => {
          state.staticMeasures = next;
        });
      } catch {
        // 미등록/실패 = 빈 배열 (console 금지 룰)
      }
    },
    // F6(Condition) 저장조건 복원 — 마운트 1회. DMF0082 등 다른 화면엔 있는데 SCP0013 엔 없어 저장만 되고
    //   복원이 안 됐다(grid 빈 채로 열림). GET 으로 불러와 searchCondition 에 역coerce 병합한다.
    //   복원이 divisionId 를 바꾸면 division-키 effect(컬럼/메저 재fetch)가 알아서 따라오고, Form 의 기본값
    //   effect 는 모두 "미선택/옵션에 없을 때만" 세팅이라 복원한 유효값을 덮지 않는다.
    restoreSearchConditions: async () => {
      if (get().conditionsRestored) return;
      set(state => {
        state.conditionsRestored = true; // 먼저 세워 재마운트 중복 복원(사용자 편집 덮어쓰기) 방지.
      });
      try {
        const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const rows = res.data.result ?? [];
        if (rows.length === 0) return;
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initSearch)) continue; // 현재 조회조건에 없는 구버전 키 무시
          const val = paramCtn ?? '';
          if (ARRAY_COND_KEYS.has(paramNm))
            patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else if (BOOL_COND_KEYS.has(paramNm)) patch[paramNm] = val === 'true';
          else patch[paramNm] = val;
        }
        set(state => {
          state.searchCondition = {
            ...get().searchCondition,
            ...(patch as Partial<SearchCondition>),
          };
        });
      } catch {
        // 저장조건 미존재/조회 실패 = 기본값 유지 (console 금지 룰)
      }
    },
  }),
  'production-plan-line-store'
);

// 그리드가 소비할 편집 판정 컨텍스트 파생 — 조회결과에서 최종 PlanType/FN 존재 계산(design 01 F2).
export const deriveEditContext = (rows: MainRow[]): { lastPlanType: string; hasFn: boolean } => {
  let lastPlanType = '';
  let hasFn = false;
  for (const r of rows) {
    const pt = str((r as Record<string, unknown>).PLAN_TYPE);
    if (pt) lastPlanType = pt;
    if (pt === 'FN') hasFn = true;
  }
  return { lastPlanType, hasFn };
};
