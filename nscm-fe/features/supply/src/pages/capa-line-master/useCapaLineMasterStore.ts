import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  DEFAULT_PRODUCT_GROUP,
  LEVELS,
  MENU_ID,
  PRODUCT_GROUP,
  SHEETS,
  SHEET_BY_LEVEL,
  type LevelNo,
  type ProductGroup,
} from './capa-line-master.constants';
import type { DrillContext, SearchCondition } from './capa-line-master.types';

type FiltersBySheet = Partial<Record<SHEETS, ProcRequest<MENU_ID, SHEETS.LEVEL1>>>;
type StaticColumnsBySheet = Record<SHEETS, RawFlexGridColumnConfig[]>;

// 확정 조회조건 — Search 로 실제 발사된 값. 신규행 DIVISION_ID/SHOP_GROUP_ID 는 입력중 searchCondition 이
//   아니라 이 값에서 온다(CommonCheckList Division § "Insert 시 확정 searchParams 기준 division").
interface AppliedCondition {
  divisionId: string;
  shopGroupId: ProductGroup;
}

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  applied: AppliedCondition | null;
  filters: FiltersBySheet;
  // 드릴다운으로 확정된 상위 컨텍스트(AS-IS _siteId/_companyId/... 캐시, cs:1757~1831).
  drill: DrillContext;
  // 편집모드 레벨 — 5그리드 중 동시 1개만(AS-IS IsEditModes dict + editCnt>1 되돌림, cs:490~502).
  editingLevel: LevelNo | null;
  // 활성(포커스) 그리드 — 공통 Insert/Delete/Edit/Save 가 이 그리드에만 작용(AS-IS fps/spreadNow, hook #97).
  activeLevel: LevelNo;
  openSearchArea: boolean;
  // ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch(시트별).
  //   미등록/실패 시 빈 배열 -> 그리드가 constants LEVEL_COLUMNS fallback.
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setSearchCondition: (patch: Partial<SearchCondition>) => void;
  setDivision: (divisionId: string) => void;
  setFilter: () => void;
  clearFilters: () => void;
  resetForProductGroup: () => void;
  clearBelowLevel: (level: LevelNo) => void;
  drillDown: (level: LevelNo, row: Record<string, unknown>) => void;
  setActiveLevel: (level: LevelNo) => void;
  toggleEditingLevel: (level: LevelNo) => void;
  clearEditingLevel: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: (divisionId?: string) => Promise<void>;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// F6(personalizeCondition) 저장 조회조건 복원 대상 키 — SearchCondition 필드와 1:1(둘 다 문자열, 배열 없음).
//   SEARCH_KEYS 밖 paramNm(구버전 잔재)은 버려 폼/store 오염을 막는다(SCP0005/SSP0014 동형).
const SEARCH_KEYS = new Set<string>(['divisionId', 'shopGroupId']);
// shopGroupId 는 라디오 파생 E/A/P 만 유효 — 구버전/수기 저장값이 라디오를 깨지 않게 수용 전 검증한다.
const PRODUCT_GROUP_VALUES = new Set<string>(Object.values(PRODUCT_GROUP));

const initSearch: SearchCondition = {
  // 기본선택 없음 — Division 은 콤보 첫 행이 아니라 사용자가 고르게 둔다(AS-IS 는 DropDownList 첫 행이
  //   자동 선택되지만 TO-BE 는 명시 Search 게이트라 미선택 상태로 시작, design 02 §4).
  divisionId: '',
  shopGroupId: DEFAULT_PRODUCT_GROUP,
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.LEVEL1]: [],
  [SHEETS.LEVEL2]: [],
  [SHEETS.LEVEL3]: [],
  [SHEETS.LEVEL4]: [],
  [SHEETS.LEVEL5]: [],
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  applied: null,
  filters: {},
  drill: {},
  editingLevel: null,
  activeLevel: 1,
  openSearchArea: true,
  staticColumns: emptyStaticColumns,
};

/**
 * GET SP 파라미터 (AS-IS FindData cs:729~737 — 이름·순서 그대로).
 * 1: p_menu_level / 2: p_division_id / 3: p_site_id / 4: p_company_id
 * 5: p_plant_id / 6: p_factory_id / 7: p_line_id(항상 공백) / 8: p_shop_group_id
 *
 * 레벨 n 조회는 상위 n-1 단계의 ID 만 싣는다(AS-IS 는 나머지를 null/"" 로 보낸다, cs:733~736).
 */
const buildGetParams = (
  level: LevelNo,
  divisionId: string,
  shopGroupId: ProductGroup,
  drill: DrillContext
): ProcRequest<MENU_ID, SHEETS.LEVEL1> => ({
  p_menu_level: level,
  p_division_id: divisionId,
  p_site_id: level >= 2 ? str(drill.SITE_ID) : '',
  p_company_id: level >= 3 ? str(drill.COMPANY_ID) : '',
  p_plant_id: level >= 4 ? str(drill.PLANT_ID) : '',
  p_factory_id: level >= 5 ? str(drill.FACTORY_ID) : '',
  p_line_id: '',
  p_shop_group_id: shopGroupId,
});

// 레벨 n 조회 시 n 초과 시트는 비운다 — AS-IS FindData 의 InitSpread(n..5) 재현(cs:689~721).
const clearBelow = (filters: FiltersBySheet, level: LevelNo): void => {
  for (const candidate of LEVELS) {
    if (candidate > level) delete filters[SHEET_BY_LEVEL[candidate]];
  }
};

export const useCapaLineMasterStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),

    setSearchCondition: patch =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...patch };
      }),

    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division 을 제외한 검색조건 전부 초기화 + 그리드 초기화
    //   (사용자 지시 2026-10-02 — TO-BE 공통 요건이 AS-IS 핸들러보다 우선, 정본 SCP0025 setDivision 패턴).
    //   이 화면의 비(非)Division 조회조건은 Product Group(shopGroupId) 하나이며 기간/날짜 조건은 없다
    //   → shopGroupId 를 initSearch 기본값(Electrode)으로 되돌린다. 편집중(dirty) 확인 가드(MSG00704)는
    //   Form 의 onChange 가 confirmIfDirtyKey 로 처리한다(commit 51d4e9fa 패턴). 그리드 초기화는 clearFilters
    //   와 동일(filters/applied/drill/editingLevel 비움) — 재조회는 명시 Search/드릴다운으로만.
    setDivision: divisionId =>
      set(state => {
        state.searchCondition = {
          ...initSearch, // Division 제외 전 조건 초기화(shopGroupId → 기본값). 기간/날짜 조건 없음.
          divisionId,
        };
        state.filters = {};
        state.applied = null;
        state.drill = {};
        state.editingLevel = null;
      }),

    // Search(F5) — Level1 부터 조회. AS-IS FindButton -> FindData(1, division, "") (cs:346~351).
    //   Division/Product Group 변경은 즉시조회하지 않는다(명시 Search 게이트, 사용자 확정 2026-09-23).
    setFilter: () =>
      set(state => {
        const condition = state.searchCondition;
        state.applied = {
          divisionId: condition.divisionId,
          shopGroupId: condition.shopGroupId,
        };
        // 상위 컨텍스트/편집모드 리셋 — AS-IS FindData 의 RefreshEditMode + InitSpread(1~5).
        state.drill = {};
        state.editingLevel = null;
        state.filters = {
          [SHEETS.LEVEL1]: buildGetParams(1, condition.divisionId, condition.shopGroupId, {}),
        };
      }),

    // Division 변경 / 탭 재진입 — 그리드 전부 비움(자동 재조회 없음, nscm-patterns §5-5/§5-7).
    //   AS-IS cboDivision_SelectedIndexChanged -> FindData(1,…) -> InitSpread(1~5) 전부 (design 01 §2 L4).
    clearFilters: () =>
      set(state => {
        state.filters = {};
        state.applied = null;
        state.drill = {};
        state.editingLevel = null;
      }),

    // Product Group 변경 — Division 과 달리 L4·L5 만 초기화하고 L1~L3 과 상위 드릴다운 컨텍스트를 유지한다.
    //   AS-IS rgrpSearchLevel_SelectedIndexChanged(cs:1845~1866) 는 FindData(4, division, L1, L2, L3) 를
    //   부르고 FindData 의 case 4(cs:713~717) 는 InitSpread(4); InitSpread(5) 만 수행한다 — L1~L3 그리드와
    //   _siteId/_companyId/_plantId 캐시는 그대로다(design 01 §2 L5 / 02 §3 "Level4·5 재초기화").
    //   근거: GET SP 의 L1~L3 활성 쿼리는 p_shop_group_id 를 참조하지 않는다. P/A 분기와 E 분기가 같은
    //   SCP_MST_CAPA_LINE UNION SCP_MST_CAPA_ELTR_LINE 을 쓰고, ATTRIBUTE1=@p_shop_group_id 필터는
    //   L4·L5 에만 걸린다(L1~L3 위치의 등장은 전부 주석). 따라서 L1~L3 을 비우는 것은 근거 없는 과초기화다.
    //   주의: AS-IS 는 FindData 를 _shopgroupId 갱신보다 먼저 불러 직전 제품군으로 조회하는 순서 결함이
    //   있다(cs:1851 vs 1853~1864). 이 화면은 명시 Search 게이트라 그 결함을 재현하지 않는다.
    resetForProductGroup: () =>
      set(state => {
        // 편집모드는 비우는 레벨(L4·L5)일 때만 끝낸다. L1~L3 편집은 이어져야 한다 —
        //   AS-IS RefreshEditMode(cs:1629~1636)는 IsEditModes dict 만 false 로 돌리고, 실제 편집·저장
        //   게이트인 IsLock(SaveData cs:784, SwitchLock cs:512~)은 건드리지 않는다. 그래서 AS-IS 는
        //   제품군을 바꿔도 L1~L3 의 미저장 편집을 계속 고치고 저장할 수 있다.
        //   TO-BE 의 editingLevel 은 그 IsLock 축에 대응하므로 1~3 이면 유지해야 파리티다. 여기서
        //   null 로 만들면 행의 CRUD_TYPE 마킹만 남고 Save(editingLevel!==level)·Edit 재진입(I/M 행 존재)이
        //   둘 다 무음 return 이라, 사용자가 빠져나갈 길 없이 편집분을 잃는다.
        //   주의: AS-IS 는 이 경로에서 두 시트가 동시에 unlocked 될 수 있으나 그건 사람설계서 업무규칙 5
        //   ("Edit 모드는 Level1~5 중 동시 처리 불가")에 반하는 결함이라 재현하지 않는다.
        if (state.editingLevel !== null && state.editingLevel >= 4) state.editingLevel = null;
        if (!state.applied) return;
        // 확정 조회조건의 제품군만 교체 — 이후 L4 드릴다운·신규행이 새 값을 쓴다.
        state.applied = { ...state.applied, shopGroupId: state.searchCondition.shopGroupId };
        // L4 드릴다운 산출물(FACTORY_*)은 L4 를 비우는 순간 무효다. L1~L3 산출물은 유지.
        const drill: DrillContext = { ...state.drill };
        delete drill.FACTORY_ID;
        delete drill.FACTORY_NAME;
        state.drill = drill;
        const filters: FiltersBySheet = { ...state.filters };
        clearBelow(filters, 3);
        state.filters = filters;
      }),

    // 드릴다운(L1~L4 셀 더블클릭) — 하위 레벨 재조회 + 상위 컨텍스트 저장 (cs:1743~1814).
    drillDown: (level, row) =>
      set(state => {
        const applied = state.applied;
        if (!applied) return;
        const nextLevel = (level + 1) as LevelNo;
        // AS-IS 는 divisionID 도 선택행에서 다시 읽는다(cs:1753) — 같은 조회 division 이지만 동일 재현.
        const divisionId = str(row.DIVISION_ID) || applied.divisionId;

        const drill: DrillContext = { ...state.drill };
        if (level >= 1) {
          drill.SITE_ID = str(row.SITE_ID);
          drill.SITE_NAME = str(row.SITE_NAME);
        }
        if (level >= 2) {
          drill.COMPANY_ID = str(row.COMPANY_ID);
          drill.COMPANY_NAME = str(row.COMPANY_NAME);
        }
        if (level >= 3) {
          drill.PLANT_ID = str(row.PLANT_ID);
          drill.PLANT_NAME = str(row.PLANT_NAME);
        }
        if (level >= 4) {
          drill.FACTORY_ID = str(row.FACTORY_ID);
          drill.FACTORY_NAME = str(row.FACTORY_NAME);
        }
        state.drill = drill;
        state.applied = { ...applied, divisionId };
        state.editingLevel = null; // FindData -> RefreshEditMode (cs:685)

        const filters: FiltersBySheet = { ...state.filters };
        clearBelow(filters, level);
        filters[SHEET_BY_LEVEL[nextLevel]] = buildGetParams(
          nextLevel,
          divisionId,
          applied.shopGroupId,
          drill
        );
        state.filters = filters;
      }),

    // 저장 성공 후 — AS-IS 는 활성 레벨만 재조회하는 게 아니라 FindData(activeLevel)(cs:935~954)을 부르고,
    //   FindData 의 InitSpread 분기(cs:689~721)가 activeLevel 부터 5까지를 전부 비운다. 하위를 남겨 두면
    //   방금 바뀐 부모 기준으로는 더 이상 맞지 않는 행이 화면에 남는다(특히 신규행 저장 직후).
    //   활성 레벨 자체의 재조회는 화면이 refetch 로 수행한다.
    clearBelowLevel: level =>
      set(state => {
        const filters: FiltersBySheet = { ...state.filters };
        clearBelow(filters, level);
        state.filters = filters;
      }),

    setActiveLevel: level =>
      set(state => {
        state.activeLevel = level;
      }),

    // Edit 토글 — 이미 다른 레벨이 편집중이면 무시(AS-IS editCnt>1 되돌림 후 return, cs:498~502).
    toggleEditingLevel: level =>
      set(state => {
        if (state.editingLevel === level) {
          state.editingLevel = null;
          return;
        }
        if (state.editingLevel !== null) return;
        state.editingLevel = level;
      }),

    clearEditingLevel: () =>
      set(state => {
        state.editingLevel = null;
      }),

    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),

    // admin SCM_MST_SHEET_COLUMNS 동적 fetch(5시트) — 미등록/실패 시 빈 배열 유지(console 금지 룰).
    //   divisionId 인자: division 변경 시 set() 커밋 뒤 새 division 을 넘겨 호출한다
    //   (producer 안에서 get() 하면 커밋 전 이전 값을 읽어 컬럼셋이 한 스텝 밀린다, nscm-patterns §5-5).
    fetchStaticColumns: async divisionId => {
      const division = divisionId ?? get().searchCondition.divisionId;
      await Promise.all(
        LEVELS.map(async level => {
          const sheet = SHEET_BY_LEVEL[level];
          try {
            const res = await apiClient.post<RawFlexGridColumnConfig[]>(
              `/admin/menu/${MENU_ID}/column`,
              { sheetNm: ADMIN_SHEET_NAME[sheet], divisionId: division }
            );
            const next = res.data.result ?? [];
            if (next.length === 0) return;
            set(state => {
              if (JSON.stringify(state.staticColumns[sheet]) !== JSON.stringify(next)) {
                state.staticColumns[sheet] = next;
              }
            });
          } catch {
            // 미등록/실패 = constants fallback
          }
        })
      );

      // F6 저장 조회조건 복원 — 탭 수명 내 1회(initialized 가드, SCP0005/SSP0014 동형). 이 화면은 기간/달력이
      //   없어 문자열 2필드(Division/Product Group)만 복원한다. createPersistedStoreWithTab 은 sessionStorage
      //   미영속이라 전체 새로고침 시 복원이 다시 돈다. F10(초기화)은 MotherStore 가 initialized 를 보존해 재복원 안 됨.
      //   복원은 searchCondition 만 세팅하고 조회는 하지 않는다 — 명시 Search 게이트 유지(goal.md 6 #5).
      if (!get().initialized) {
        try {
          const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
            `/admin/menu/${MENU_ID}/search-conditions`
          );
          const rows = res.data.result ?? [];
          if (rows.length > 0) {
            const patch: Partial<SearchCondition> = {};
            for (const { paramNm, paramCtn } of rows) {
              if (!SEARCH_KEYS.has(paramNm)) continue;
              if (paramNm === 'shopGroupId') {
                if (PRODUCT_GROUP_VALUES.has(paramCtn)) patch.shopGroupId = paramCtn as ProductGroup;
              } else {
                patch.divisionId = paramCtn ?? '';
              }
            }
            set(state => {
              state.searchCondition = { ...state.searchCondition, ...patch };
            });
          }
        } catch {
          // 저장조건 미존재/조회 실패 — 기본값 유지 (console 금지 룰)
        }
      }

      set(state => {
        state.initialized = true;
      });
    },
  }),
  'capa-line-master-store'
);
