import type { MeasureMeta } from 'features/master/src/components';

import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  BUCKET_TYPE,
  MEASURE_SHEET_NAME,
  MENU_ID,
  PRESET_W52,
  SHEETS,
} from './production-plan.constants';
import type { SearchCondition } from './production-plan.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.LINE]?: ProcRequest<MENU_ID, SHEETS.LINE>;
  [SHEETS.EDIT_INFO]?: ProcRequest<MENU_ID, SHEETS.EDIT_INFO>;
};

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
  [SHEETS.LINE]: RawFlexGridColumnConfig[];
};

type StaticMeasuresBySheet = {
  [SHEETS.MAIN]: MeasureMeta[];
  [SHEETS.LINE]: MeasureMeta[];
};

interface State {
  searchCondition: SearchCondition;
  // F6 저장 조회조건 복원 가드 — 탭 수명 내 1회만 서버 저장조건을 불러와 적용(자매 demand-manager 동일).
  initialized: boolean;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  staticColumns: StaticColumnsBySheet;
  staticMeasures: StaticMeasuresBySheet; // Measure 설정 팝업용 — MODEL/LINE 각 시트(포커스된 그리드 기준, AS-IS btnMeasure fps).
  // Plan 콤보 최신 버전 CODE(옵션 idx0) — Form 이 승격. (SCP0011 은 Fix 없음, 자동선택 가드 참고용)
  latestPlanDate: string;
}

interface Action {
  reset: () => void;
  restoreSearchConditions: () => Promise<void>; // F6 저장 조회조건을 마운트 시 1회 복원
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setDivision: (divisionId: string) => void;
  setFilter: () => void; // 모델 그리드 조회(Find)
  setLineFilter: (masterRow: Record<string, unknown>) => void; // master 더블클릭 → line drill
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: (sheet: SHEETS.MAIN | SHEETS.LINE) => Promise<void>;
  fetchStaticMeasures: (sheet: SHEETS.MAIN | SHEETS.LINE) => Promise<void>;
  setLatestPlanDate: (v: string) => void;
}

// Period 기본 placeholder — 선택 Plan date 로드 전까지. 모듈 로드 1회 평가.
const thisMonday = dayjs().add(1 - dayjs().day(), 'day');

const initSearch: SearchCondition = {
  divisionId: useSessionStore.getState().session.div ?? '',
  operationGroupId: '',
  plantSiteIds: [],
  electrodeTypes: [],
  planStartYyyymmdds: [],
  planTypes: [],
  planSeqs: [],
  bucket: BUCKET_TYPE.WEEKLY,
  fromYyyymmdd: thisMonday.format('YYYYMMDD'),
  toYyyymmdd: thisMonday.add(PRESET_W52 * 7 - 1, 'day').format('YYYYMMDD'),
  itemId: '',
  nickName: '',
  chkSum: false,
  // chkAll(전체보기)은 항상 ALL 로 조회한다(사용자 지시 2026-10-07 — 체크박스 UI 제거, 그리드 chkAll=true 고정).
  chkAll: true,
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.MAIN]: [],
  [SHEETS.LINE]: [],
};

const emptyStaticMeasures: StaticMeasuresBySheet = {
  [SHEETS.MAIN]: [],
  [SHEETS.LINE]: [],
};

const initState: State = {
  searchCondition: initSearch,
  initialized: false,
  filters: {},
  openSearchArea: true,
  staticColumns: emptyStaticColumns,
  staticMeasures: emptyStaticMeasures,
  latestPlanDate: '',
};

// F6 저장 조회조건 복원 시 값 역직렬화 기준 — 배열 키(콤마 분해)·불리언 키('true' 판정). 나머지는 문자열.
//   날짜(from/to)는 저장 자체가 안 됨(gridAction EXCLUDED_DATE_PARAM) → 복원 대상 아님, Period effect 가 재계산.
const ARRAY_KEYS = new Set<string>([
  'plantSiteIds',
  'electrodeTypes',
  'planStartYyyymmdds',
  'planTypes',
  'planSeqs',
]);
const BOOL_KEYS = new Set<string>(['chkSum', 'chkAll']);

// 다중 선택 배열 → SP 파라미터. 빈 배열(전체)은 ''(Oracle NULL 취급 → 옵션필터 off, 자매 SCP0013 규약).
const joinOrNull = (arr: string[]): string => (arr.length === 0 ? '' : arr.join(','));
const orEmpty = (v: string): string => (v && v.trim() ? v.trim() : '');
const str = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

export const useProductionPlanStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    // F6(Condition) 저장 조회조건 복원 — 마운트 시 1회. 저장(GridAction.personalizeCondition)이 모든 값을
    //   문자열로 coerce 하므로(배열=콤마 join / 불리언='true'/'false'), 여기서 역직렬화해 되돌린다. 저장조건
    //   미존재/조회 실패는 기본값 유지. division 은 setDivision(하위 cascade reset) 이 아니라 merge 로 넣어
    //   저장된 하위값(opGroup/planDate/type/seq)이 보존되게 한다. from/to 는 저장 대상이 아님(Period effect 재계산).
    restoreSearchConditions: async () => {
      if (get().initialized) return;
      set(state => {
        state.initialized = true; // 먼저 세운다 — 마운트 중복/재마운트 재복원 방지.
      });
      try {
        const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const rows = res.data.result ?? [];
        if (rows.length === 0) return;
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          // 현재 SearchCondition 에 없는 키(구버전 잔재)는 버린다 — setFilter 가 조회조건을 SP payload 로
          //   옮겨 담으므로 모르는 필드가 섞이면 새어 나간다.
          if (!(paramNm in initSearch)) continue;
          const val = paramCtn ?? '';
          if (ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else if (BOOL_KEYS.has(paramNm)) patch[paramNm] = val === 'true';
          else patch[paramNm] = val;
        }
        set(state => {
          state.searchCondition = { ...state.searchCondition, ...(patch as Partial<SearchCondition>) };
        });
      } catch {
        // 저장조건 미존재/조회 실패 → 기본값 유지 (console 금지 룰)
      }
    },
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // Division 변경 = Division·기간/날짜(from/to)만 유지하고 나머지 검색조건 전부 초기화 + 그리드 clear
    //   (TO-BE 공통 요건 apply-division-reset, 정본 SCP0025). OperationGroup/PlantSite/Electrode/Plan*·
    //   Bucket/SUM/Item/Nickname 을 initSearch 기준으로 되돌린다. 미저장 편집 dirty 가드는 Form onChange
    //   (confirmIfDirtyKey) 가 선행하므로 여기 도달 시 리셋은 안전. filters={} 로 그리드도 재조회 전까지 빈 상태.
    setDivision: divisionId =>
      set(state => {
        const c = get().searchCondition;
        state.searchCondition = {
          ...initSearch,
          divisionId,
          fromYyyymmdd: c.fromYyyymmdd, // 기간/날짜는 유지(초기화 제외)
          toYyyymmdd: c.toYyyymmdd,
        };
        state.filters = {};
      }),
    // 모델 그리드 조회 — MODEL GET + EDIT_INFO(행별 편집판정). design 02 §5.2 / 03 §4.2.
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        const common = {
          divisionId: orEmpty(c.divisionId),
          operationGroup: orEmpty(c.operationGroupId),
          scmSiteId: joinOrNull(c.plantSiteIds),
          electrodeType: joinOrNull(c.electrodeTypes),
          planStartYyyymmdd: joinOrNull(c.planStartYyyymmdds),
          planType: joinOrNull(c.planTypes),
          seq: joinOrNull(c.planSeqs),
          fromYyyymmdd: c.fromYyyymmdd.replace(/-/g, ''),
          toYyyymmdd: c.toYyyymmdd.replace(/-/g, ''),
          itemId: str(c.itemId),
          nickName: str(c.nickName),
          bucket: c.bucket,
          // 전체보기(All Days) 고정 — AS-IS chkAll 체크와 동일하게 SP V_BUCKET='DAILY' 강제(일자까지 조회).
          //   체크박스 UI 는 제거(2026-10-07). Bucket 콤보는 그리드 표시 가시성만 제어(AS-IS 동일 구조).
          //   LINE GET SP 는 chkAll/bucket 파라미터가 없고 항상 D_/W_/M_ 전부 반환하므로 setLineFilter 는 불요.
          chkAll: 'Y',
          programId: MENU_ID,
          debugMode: 'F',
        };
        // EDIT_INFO(편집컨텍스트)는 검색 시점에 조회하지 않는다 — AS-IS Get_IsEditInfo 는 모델행 더블클릭 시
        //   그 행의 plan version + ORIGIN_DIVISION_ID 로 호출한다(SCP0011.cs L1694~1722 / L3060). 검색 시점엔
        //   ORIGIN_DIVISION_ID 가 없어 proc 이 0행을 돌려 편집이 전면 잠긴다(DB 실측 2026-10-08). setLineFilter 에서 조회.
        state.filters = {
          [SHEETS.MAIN]: { ...common, sheetName: ADMIN_SHEET_NAME[SHEETS.MAIN] },
        };
      });
    },
    // master(MODEL) 더블클릭 → line drill. 선택 모델행의 식별값 + plan 컨텍스트로 LINE GET. design 03 §4.2.
    setLineFilter: masterRow =>
      set(state => {
        const c = state.searchCondition;
        // AS-IS FindData_Line(e.Row)/Get_IsEditInfo(e.Row) 패리티 — 더블클릭 모델행의 site·origin 을 쓴다.
        const operationGroup = str(masterRow.OPERATION_GROUP) || orEmpty(c.operationGroupId);
        const scmSiteId = str(masterRow.SCM_SITE_ID);
        const originDivisionId = str(masterRow.ORIGIN_DIVISION_ID);
        const planStartYyyymmdd = joinOrNull(c.planStartYyyymmdds);
        const planType = joinOrNull(c.planTypes);
        const seq = joinOrNull(c.planSeqs);
        state.filters = {
          ...state.filters,
          [SHEETS.LINE]: {
            divisionId: orEmpty(c.divisionId),
            operationGroup,
            scmSiteId,
            operationId: str(masterRow.OPERATION_ID),
            modelId: str(masterRow.MODEL_ID),
            itemId: str(masterRow.ITEM_ID),
            // electrodeType: str(masterRow.ELECTRODE_TYPE),
            // 임시 우회: MODEL SP 는 빈 Electrode 를 '/' 로, LINE SP 는 '-' 로 바꿔 비교해 0행이 된다.
            //   '/' 는 빈 값(조건 없음)으로 넘긴다. PKG_SCP0011 LINE SP 수정 후 제거한다.
            electrodeType: str(masterRow.ELECTRODE_TYPE) === '/' ? '' : str(masterRow.ELECTRODE_TYPE),
            originDivisionId,
            planStartYyyymmdd,
            planType,
            seq,
            fromYyyymmdd: c.fromYyyymmdd.replace(/-/g, ''),
            toYyyymmdd: c.toYyyymmdd.replace(/-/g, ''),
            bucket: c.bucket,
            programId: MENU_ID,
            sheetName: ADMIN_SHEET_NAME[SHEETS.LINE],
            debugMode: 'F',
          },
          // EDIT_INFO(GET_PLAN_EDIT_INFO) — 더블클릭 모델행의 site + ORIGIN_DIVISION_ID + 선택 plan version 으로
          //   편집컨텍스트(EDIT_START_DATE/IS_EDITABLE) 조회(AS-IS Get_IsEditInfo(e.Row)). P_ORIGIN_DIVISION_ID 가
          //   비면 proc 이 0행→편집 전면 잠금(DB 실측 2026-10-08)이라 행 origin 을 반드시 싣는다.
          [SHEETS.EDIT_INFO]: {
            divisionId: orEmpty(c.divisionId),
            operationGroup,
            scmSiteId,
            planStartYyyymmdd,
            planType,
            seq,
            originDivisionId,
            programId: MENU_ID,
            debugMode: 'F',
          },
        };
      }),
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),
    // admin SCM_MST_SHEET_COLUMNS 동적 fetch — Model/Line 시트별. 미등록/실패 시 빈 배열(constants fallback).
    fetchStaticColumns: async sheet => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[sheet], divisionId: get().searchCondition.divisionId }
        );
        const next = res.data.result ?? [];
        if (next.length > 0) {
          set(state => {
            if (JSON.stringify(state.staticColumns[sheet]) !== JSON.stringify(next)) {
              state.staticColumns[sheet] = next;
            }
          });
        }
      } catch {
        // 미등록/실패 = constants fallback (console 금지 룰)
      }
    },
    // Measure 설정 팝업용 measure 메타 fetch — SCM_MST_SHEET_MEASURE(SHEET_NAME 대문자 'MODEL'/'LINE').
    //   포커스된 그리드 기준으로 팝업을 열기 위해 시트별로 받는다(AS-IS btnMeasure_Click fps 분기).
    //   divisionId 는 빈값으로 보낸다(= Oracle NULL). PR_GET_SHEET_MEASURE_LIST 의 개인화(SHEET_PRSL_YN='Y')
    //   분기는 division 필터 `P_DIVISION_ID IN split(M.DIVISION_ID)` 를 걸지만, SCP0011 measure 는 DIVISION_ID
    //   가 전부 NULL(전 division 공통)이라 실제 division 을 보내면 전건이 걸러져 목록이 빈다(ora.py 실측 2026-10-12).
    //   빈값→`P_DIVISION_ID IS NULL` 로 필터 우회 = 기존 전 division 동일 노출 동작 보존 + 개인화 display 반영.
    fetchStaticMeasures: async sheet => {
      try {
        const res = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: MEASURE_SHEET_NAME[sheet],
          divisionId: '',
        });
        set(state => {
          state.staticMeasures[sheet] = res.data.result ?? [];
        });
      } catch {
        // 미등록/실패 = 빈 배열 (console 금지 룰)
      }
    },
    setLatestPlanDate: v =>
      set(state => {
        state.latestPlanDate = v;
      }),
  }),
  'production-plan-store'
);
