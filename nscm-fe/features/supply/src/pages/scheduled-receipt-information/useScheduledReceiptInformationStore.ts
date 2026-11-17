import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { COLUMN_SHEET_NAME, MENU_ID, SHEETS } from './scheduled-receipt-information.constants';
import type { SearchCondition } from './scheduled-receipt-information.types';
import { thisWeekMonday } from './utils/scheduledReceiptInformationDate';

type FiltersBySheet = {
  [key in SHEETS]?: ProcRequest<MENU_ID, key>;
};

interface ScheduledReceiptInformationState {
  initialized: boolean;
  // 개인화 조회조건 복원 1회 가드 (SubTitle F6 저장분 mount 복원 — initialized 는 컬럼 fetch 전용이라 별도).
  conditionsRestored: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchCondition;
  filters: FiltersBySheet;
  staticColumns: {
    [key in SHEETS]: RawFlexGridColumnConfig[];
  };
}

interface ScheduledReceiptInformationAction {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (searchParams: Partial<SearchCondition>) => void;
  setDivision: (divisionId: string) => void;
  resetTabScopedConditions: () => void;
  clearGrid: () => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchParams 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

const initSearchParams: SearchCondition = {
  divisionId: '',
  planGroupIds: 'ALL',
  siteIds: 'ALL',
  childMaterialIds: 'ALL',
  valid: 'All',
  fromDate: thisWeekMonday(),
  itemId: '',
};

const initState: ScheduledReceiptInformationState = {
  initialized: false,
  conditionsRestored: false,
  isOpenSearchArea: true,
  searchParams: initSearchParams,
  filters: {},
  staticColumns: {
    [SHEETS.VIRTUAL_BOM]: [],
    [SHEETS.SCHEDULED_RECEIPT]: [],
  },
};

export const useScheduledReceiptInformationStore = createPersistedStoreWithTab<
  ScheduledReceiptInformationState & ScheduledReceiptInformationAction
>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
      });
    },
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division·기간(fromDate)을 제외한 검색조건을 전부 초기화하고
    //   그리드도 초기화(filters clear)한다(TO-BE 공통 요건이 AS-IS cascade 핸들러보다 우선 — SCP0025 선례).
    //   유지: divisionId(새 값)·fromDate(날짜). 초기화: planGroupIds/siteIds/childMaterialIds/valid/itemId →
    //   initSearchParams 값. 편집중(dirty) 확인 가드(MSG00704)는 Form 의 onChange 가 confirmIfDirtyKey 로
    //   처리한다(commit 51d4e9fa 패턴). 그리드 초기화: filters={} 로 두 시트 조회키가 바뀌어 재조회(Search)
    //   전까지 빈 상태가 되고, 미저장 신규행·편집분도 재바인딩으로 함께 리셋된다(dirty 가드 통과 후이므로 안전).
    setDivision: divisionId => {
      set(state => {
        const cur = get().searchParams;
        state.searchParams = {
          ...initSearchParams,
          divisionId,
          fromDate: cur.fromDate,
        };
        state.filters = {};
      });
    },
    // AS-IS SpdMain_ActiveSheetChanged(.cs:1466-1507) 재현 — 탭 전환 시 Plan Group/Site/Child Material
    //   콤보를 새 탭 원천(Virtual Bom=Tables[0]/[7], Scheduled Receipt=Tables[8]/[7]/[5])으로 재바인딩
    //   하며 setListBox 가 선택을 ALL 로 초기화한다. TO-BE 는 조회조건이 공유 스토어라 탭을 바꿔도 값이
    //   남아, 새 탭 콤보에 없는 값이면 칸은 ALL 로 보이나 조회엔 이전 값이 실려 나가는 desync 가 생긴다
    //   (SCP0130-#4: Virtual Bom 에서 Plan Group 선택 후 Scheduled Receipt 로 전환 시 칸 ALL·요청 PG0005
    //   ·0행). 탭 전환 시 탭별 조회조건을 ALL 로 리셋해 AS-IS 재바인딩과 등가로 맞춘다. Division/Valid/
    //   FromDate/ItemId 는 공통(또는 탭 유지) 값이라 보존(AS-IS 도 Refresh 대상 아님).
    resetTabScopedConditions: () => {
      set(state => {
        state.searchParams = {
          ...get().searchParams,
          planGroupIds: 'ALL',
          siteIds: 'ALL',
          childMaterialIds: 'ALL',
        };
      });
    },
    // AS-IS CboPlanGroup_SelectedIndexChanged(.cs:1301) SpreadInfo.ClearDataSource(spdMain) 재현 —
    //   Plan Group 변경 시 조건(searchParams)은 그대로 두고 그리드만 비운다(filters={} → 두 시트 조회키가
    //   바뀌어 재조회(Search) 전까지 빈 상태). Division 변경(setDivision)이 조건까지 리셋하는 것과 구분된다.
    clearGrid: () => {
      set(state => {
        state.filters = {};
      });
    },
    // SP 파라미터(design 03 §4 spCalls#2, GET_VIRTUAL_BOM 7파라미터) — 조회조건은 두 시트가 공유하되,
    //   itemId(품목) 는 AS-IS FindData_Main(.cs:581,589)이 Virtual Bom 조회에만 싣고 Scheduled Receipt
    //   에는 ''로 비운다(Scheduled Receipt 는 Item ID 조회조건 자체가 숨김, SCP0130-08). 시트별 분리.
    setFilters: () => {
      set(state => {
        const { divisionId, planGroupIds, siteIds, childMaterialIds, valid, fromDate, itemId } =
          state.searchParams;
        const base = {
          divisionId,
          planGroupId: planGroupIds === 'ALL' ? '' : planGroupIds,
          siteId: siteIds === 'ALL' ? '' : siteIds,
          itemIdChild: childMaterialIds === 'ALL' ? '' : childMaterialIds,
          validYn: valid === 'All' ? '' : valid,
          fromDate,
        };
        state.filters = {
          [SHEETS.VIRTUAL_BOM]: { ...base, itemId },
          [SHEETS.SCHEDULED_RECEIPT]: { ...base, itemId: '' },
        };
      });
    },
    // 컬럼 메타는 admin(SCM_MST_SHEET_COLUMNS)에서 동적 fetch — 하드코딩 금지(CLAUDE.md §2).
    //   sheetNm 은 DB SHEET_NAME 원문(공백 포함, design 03 §1 DB 실측)을 그대로 쓴다.
    fetchStaticColumns: async () => {
      const fetchColumns = (sheet: SHEETS) =>
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: COLUMN_SHEET_NAME[sheet],
        });
      const [virtualBom, scheduledReceipt] = await Promise.all([
        fetchColumns(SHEETS.VIRTUAL_BOM),
        fetchColumns(SHEETS.SCHEDULED_RECEIPT),
      ]);
      set(state => {
        state.staticColumns = {
          [SHEETS.VIRTUAL_BOM]: virtualBom.data.result,
          [SHEETS.SCHEDULED_RECEIPT]: scheduledReceipt.data.result,
        };
        state.initialized = true;
      });
    },
    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 형제 scp-bom(SCP0053) 파리티.
    //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 를 searchParams 에 patch.
    //   SearchCondition 7필드가 전부 문자열(멀티셀렉트 planGroupIds/siteIds/childMaterialIds 도 콤마결합
    //   문자열이라 split 불요)이라 역직렬화 없이 평문 patch 한다. 저장측(gridAction.ts personalizeCondition)이
    //   값을 String coerce + 빈값/날짜키(EXCLUDED_DATE_PARAM) 제외 후 저장하므로, 응답에 없는 키는
    //   initSearchParams 기본값 그대로 둔다. divisionId/itemId 는 기본값이 빈 문자열이라 저장 자체가 안 돼
    //   미저장 상태면 기본값 유지. cascade(setDivision)·필터(setFilters) 경유 금지 — 직접 병합한다.
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
        const patch: Partial<SearchCondition> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initSearchParams)) continue; // SearchCondition 필드만 allowlist
          // 기간(fromDate)은 복원하지 않는다 — AS-IS BaseForm.SavePanelCondition 이 날짜/기간 컨트롤을
          //   Condition 저장에서 제외(.cs:2105-2126 주석)하는 것과 등가(공통요건 R11). 저장측(Form 이
          //   SubTitle 에 넘기는 searchParam)에서 이미 빼지만, 기존에 저장돼 있던 레거시 fromDate 행도
          //   무시해 "다시 열면 기본값(이번주 월요일)" 을 보장한다(#7).
          if (paramNm === 'fromDate') continue;
          patch[paramNm as keyof SearchCondition] = paramCtn ?? '';
        }
        set(state => {
          state.searchParams = { ...state.searchParams, ...patch };
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지 룰)
      }
    },
  }),
  'scheduled-receipt-information'
);
