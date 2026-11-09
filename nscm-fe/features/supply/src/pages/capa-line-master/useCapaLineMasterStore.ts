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
  // 활성(포커스) 그리드 — 공통 Insert/Delete/Save 가 이 그리드에만 작용(AS-IS fps/spreadNow, hook #97).
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
  // store 초기값은 빈 문자열이나, 실제 화면은 Form 이 콤보 로드 후 첫 항목을 자동선택한다
  //   (CapaLineMasterForm.tsx useEffect — AS-IS DropDownList 첫 행 자동선택 재현). 따라서
  //   사용자에게는 Division 이 미선택으로 보이지 않는다(L1 갭 해소, design 02 §4).
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
    //   와 동일(filters/applied/drill 비움) — 재조회는 명시 Search/드릴다운으로만.
    setDivision: divisionId =>
      set(state => {
        state.searchCondition = {
          ...initSearch, // Division 제외 전 조건 초기화(shopGroupId → 기본값). 기간/날짜 조건 없음.
          divisionId,
        };
        state.filters = {};
        state.applied = null;
        state.drill = {};
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
        // 상위 컨텍스트 리셋 — AS-IS FindData 의 InitSpread(1~5).
        state.drill = {};
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
      }),

    // Product Group 변경 — Division 과 달리 L4·L5 만 초기화하고 L1~L3 과 상위 드릴다운 컨텍스트를 유지한다.
    //   AS-IS rgrpSearchLevel_SelectedIndexChanged(cs:1845~1866) 는 FindData(4, division, L1, L2, L3) 를
    //   부르고 FindData 의 case 4(cs:713~717) 는 InitSpread(4); InitSpread(5) 만 수행한다 — L4 를 새 제품군으로
    //   즉시 재조회하고 L5 만 비운다. L1~L3 그리드와 _siteId/_companyId/_plantId 캐시는 그대로다.
    //   근거: GET SP 의 L1~L3 활성 쿼리는 p_shop_group_id 를 참조하지 않는다. P/A 분기와 E 분기가 같은
    //   SCP_MST_CAPA_LINE UNION SCP_MST_CAPA_ELTR_LINE 을 쓰고, ATTRIBUTE1=@p_shop_group_id 필터는
    //   L4·L5 에만 걸린다(L1~L3 위치의 등장은 전부 주석). 따라서 L1~L3 을 비우는 것은 근거 없는 과초기화다.
    //   TO-BE 파리티 결정(goal #5, 사용자 재확정 2026-11-06): Division 은 명시 Search 게이트지만 Product Group
    //   라디오(2차 조회조건)는 전사 표준(apply-division-reset=Division 단일콤보 전용, nscm-patterns §5-5)의
    //   대상이 아니라, AS-IS 처럼 L4 즉시 재조회로 복원한다. 재조회는 refetch 직접호출이 아니라 drillDown 과
    //   동일한 filters 참조 교체로 발사한다(nscm-patterns §5 #1). AS-IS 의 "_shopgroupId 갱신 전 FindData 호출"
    //   순서 결함(cs:1851 vs 1853~1864)은 재현하지 않는다 — 새 shopGroupId 로 params 를 만든다.
    resetForProductGroup: () =>
      set(state => {
        // L1~L3 그리드·드릴다운 컨텍스트와 그 미저장 편집은 유지한다(편집은 상시 가능, 수정 모드 없음).
        //   비우는 것은 L4·L5 뿐 — 그 시트의 편집 마킹은 화면 effect 가 tracker.clearChanges 로 걷는다.
        if (!state.applied) return;
        // 확정 조회조건의 제품군만 교체 — 이후 L4 재조회·드릴다운·신규행이 새 값을 쓴다.
        const shopGroupId = state.searchCondition.shopGroupId;
        state.applied = { ...state.applied, shopGroupId };
        // L4 드릴다운 산출물(FACTORY_*)은 L4 를 비우는 순간 무효다. L1~L3 산출물은 유지.
        const drill: DrillContext = { ...state.drill };
        delete drill.FACTORY_ID;
        delete drill.FACTORY_NAME;
        state.drill = drill;
        const filters: FiltersBySheet = { ...state.filters };
        clearBelow(filters, 3); // L4·L5 비움
        // AS-IS FindData(4) 파리티: L3 까지 드릴된 상태(상위 ID 확정)면 새 제품군으로 L4 를 즉시 재조회한다.
        //   L5 는 비운 채 드릴 대기. 미드릴(상위 컨텍스트 없음) 상태면 재조회 대상이 없어 그대로 빈 유지.
        if (drill.SITE_ID && drill.COMPANY_ID && drill.PLANT_ID) {
          filters[SHEET_BY_LEVEL[4]] = buildGetParams(4, state.applied.divisionId, shopGroupId, drill);
        }
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
