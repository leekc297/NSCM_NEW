import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  DEFAULT_BUCKET_TYPE,
  MENU_ID,
  PERIOD_OFFSET_DAY,
  POPUP_SHEET_NAME,
  SHEETS,
} from './shipment-request-semi.constants';
import type { SearchCondition } from './shipment-request-semi.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.CALENDAR]?: ProcRequest<MENU_ID, SHEETS.CALENDAR>;
};

interface State {
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  /** 명시 조회 게이트 — MDI keep-alive 로 남은 filters 의 자동 발사를 막는다(nscm-patterns §5-7). */
  hasSearched: boolean;
  openSearchArea: boolean;
  /** admin SCM_MST_SHEET_COLUMNS 동적 fetch (SHEET_NAME='Shipment Request' 18행). 하드코딩 금지(hook #54/#66). */
  staticColumns: RawFlexGridColumnConfig[];
  /** PU04 BOD 팝업 컬럼 메타 (SHEET_NAME='bodPopup' 22행). 팝업도 admin 메타 단일 원천이다. */
  popupColumns: RawFlexGridColumnConfig[];
  /** Division 권한 콤보 도착 여부 — 미도착 상태의 조회를 막는다(권한 판정 전 발사 방지). */
  divisionAuthLoaded: boolean;
  /** 개인화 조회조건 복원 1회 가드 — SubTitle F6 저장분 mount 복원. reset()=initState 로 false 복귀 → F10 후 재복원 허용. */
  conditionsRestored: boolean;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  /** Division 변경 = 하위 초기화 의무(CS1) — From Site 선택 해제. */
  setDivision: (divisionId: string) => void;
  /** Operation Group 변경도 From Site 후보가 바뀌므로 같은 reset 을 적용한다(CA3/CS1). */
  setOperationGroup: (operationGroup: string) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setHasSearched: (v: boolean) => void;
  setOpenSearchArea: (open?: boolean) => void;
  setDivisionAuthLoaded: (v: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchPopupColumns: () => Promise<void>;
  /** 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회). */
  restoreSearchConditions: () => Promise<void>;
}

// 개인화 조건 복원 역직렬화 키 — SubTitle F6 저장은 배열=콤마join·null=''·그 외 String 평문화
//   (gridAction personalizeCondition). scmSiteIds=멀티셀렉트(콤마결합→split), showSum=불리언('true'/'false'→===).
//   그 외(divisionId/operationGroup/itemId/bucketType)는 평문이라 역직렬화 불요. 기간(fromYyyymmdd/toYyyymmdd)은
//   저장측 EXCLUDED_DATE_PARAM(`yyyymmdd$`)에 걸려 저장 자체가 제외 → 복원 대상 아님(AS-IS Period 서버산출·disabled 파리티).
const RESTORE_ARRAY_KEYS = new Set<string>(['scmSiteIds']);
const RESTORE_BOOL_KEYS = new Set<string>(['showSum']);

/**
 * 기간 기본값 — AS-IS SP02 `SCM0001_GET_SCP_DAY_PERIOD(p_from_date='', p_offset_day='55', p_timezone='AS054')`
 * 의 등가(오늘 ~ 오늘+55일). **달력 마스터(`SCM_SYS_CALENDAR_M`) 존재일로 clamp 하는 부분은 서버 몫**이며
 * `PKG_SSP0045` 미배포 상태라 지금은 반영되지 않는다(04 리포트 ERROR). SP 배선 시 이 값만 교체한다.
 * 주의: 날짜는 dayjs 로컬 — `toISOString()`(UTC) 금지(nscm-patterns §5-12).
 */
const makeInitPeriod = (): { fromYyyymmdd: string; toYyyymmdd: string } => ({
  fromYyyymmdd: dayjs().format('YYYYMMDD'),
  toYyyymmdd: dayjs().add(PERIOD_OFFSET_DAY, 'day').format('YYYYMMDD'),
});

// 주의: 상수가 아니라 함수다 — 모듈 최상위 상수로 굳히면 탭 생성 시점이 아니라 청크 로드 시점 날짜가 얼어붙는다.
const makeInitSearch = (): SearchCondition => ({
  // Division/Operation Group 은 콤보 도착 후 Form 이 첫 옵션을 선택한다(AS-IS DataSource 자동선택 등가).
  divisionId: '',
  operationGroup: '',
  itemId: '',
  scmSiteIds: [], // 빈 배열 = ALL → SP 에는 빈 문자열(P3)
  ...makeInitPeriod(),
  bucketType: DEFAULT_BUCKET_TYPE,
  showSum: false,
});

const makeInitState = (): State => ({
  searchCondition: makeInitSearch(),
  filters: {},
  hasSearched: false,
  openSearchArea: true,
  staticColumns: [],
  popupColumns: [],
  divisionAuthLoaded: false,
  conditionsRestored: false,
});

export const useShipmentRequestSemiStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...makeInitState(),
    reset: () => set(makeInitState()),

    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),

    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division·기간(from/to)을 제외한 검색조건을 전부
    //   초기화하고 그리드도 초기화(filters clear + hasSearched 해제)한다(사용자 지시 2026-10-02 — TO-BE
    //   공통 요건이 AS-IS CS1 "From Site 만 해제" 보다 우선, 정본 SCP0025 setDivision 1:1).
    //   유지: divisionId(새 값) + fromYyyymmdd/toYyyymmdd(mount 시드 기간). 초기화: operationGroup/itemId/
    //   scmSiteIds/bucketType/showSum → makeInitSearch 기본값(From Site 해제는 이 초기화에 포함).
    //   편집중(dirty) 확인 가드(MSG00704)는 Form 의 Division onChange 가 confirmIfDirtyKey 로 처리한다
    //   (commit 51d4e9fa 패턴). EditTracker(미저장 편집)·컬럼 메타 refetch 는 ref 접근이 필요해
    //   페이지의 division 감시 effect 가 담당한다(store 는 ref 를 못 잡는다).
    setDivision: divisionId =>
      set(state => {
        const cur = get().searchCondition;
        state.searchCondition = {
          ...makeInitSearch(), // Division·기간 제외 전 조건 초기화(opGroup/item/fromSite/bucket/sum)
          divisionId,
          fromYyyymmdd: cur.fromYyyymmdd,
          toYyyymmdd: cur.toYyyymmdd,
        };
        state.filters = {}; // 그리드 초기화 — 재조회(Search) 전까지 빈 상태
        state.hasSearched = false;
      }),

    setOperationGroup: operationGroup =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, operationGroup, scmSiteIds: [] };
      }),

    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        const sesUserId = useSessionStore.getState().session.userId ?? '';
        // GET SP 10 파라미터 (design 02 §1 / 03 §4.2).
        //   p_scm_site_id : 미선택/ALL → **빈 문자열**(P3). `'ALL'` 문자열을 보내면 String_Split 로 0건.
        //   p_program_id / p_sheet_name : SP 가 이 값으로 SCM_MST_SHEET_MEASURE 를 INNER JOIN 한다 — 틀리면 0행.
        //   Bucket/Sum 은 **전송하지 않는다**(그리드 가시성 전용, design 02 §6.4 V29).
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: c.divisionId,
            operationGroup: c.operationGroup,
            itemId: c.itemId.trim(),
            scmSiteId: c.scmSiteIds.filter(v => v !== 'ALL').join(','),
            fromYyyymmdd: c.fromYyyymmdd,
            toYyyymmdd: c.toYyyymmdd,
            programId: MENU_ID,
            sheetName: ADMIN_SHEET_NAME,
            userId: sesUserId,
            debugMode: 'F',
          },
          // 3단 헤더 메타 — 조회 기간이 곧 컬럼셋이다(기간이 바뀌면 컬럼이 통째로 재구성된다).
          [SHEETS.CALENDAR]: {
            startYyyymmdd: c.fromYyyymmdd,
            endYyyymmdd: c.toYyyymmdd,
          },
        };
      });
    },

    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),

    setHasSearched: v =>
      set(state => {
        state.hasSearched = v;
      }),

    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),

    setDivisionAuthLoaded: v =>
      set(state => {
        state.divisionAuthLoaded = v;
      }),

    // admin 컬럼 메타 — mount + 매 Search 마다 refetch(CLAUDE.md §2 체크3). 실패/미등록 시 빈 배열 유지.
    //   주의: `SCM_MST_SHEET_MEASURE` 는 fetch 하지 않는다. 이 화면에는 measure 선택 UI 가 없고
    //   (AS-IS 에도 없다) 그리드가 쓰는 `MEASURE_LABEL`/`MEASURE_COLOR` 는 GET SP 가 SHEET_MEASURE 를
    //   INNER JOIN 해 **행 값으로** 내려준다(design 03 §4.2). iter-1 은 fetch 만 하고 소비처가 0건이었다
    //   (react-gap-audit G-11) — 공용 `DataGrid` 에도 measure 를 받는 prop 이 없다.
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME, divisionId: get().searchCondition.divisionId }
        );
        const next = res.data.result ?? [];
        if (next.length === 0) return;
        set(state => {
          if (JSON.stringify(state.staticColumns) !== JSON.stringify(next)) {
            state.staticColumns = next;
          }
        });
      } catch {
        // 메타 미적재 시 빈 배열 유지 — 화면은 메타 주도(하드코딩 폴백 금지, hook #54)
      }
    },

    // PU04 팝업 컬럼 메타 — 팝업 그리드도 admin 메타 단일 원천이다
    //   (메모리 popup-grid-columns-admin-meta-not-hardcoded). 05_register.sql 8번 블록이 원천.
    fetchPopupColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: POPUP_SHEET_NAME, divisionId: get().searchCondition.divisionId }
        );
        const next = res.data.result ?? [];
        if (next.length === 0) return;
        set(state => {
          if (JSON.stringify(state.popupColumns) !== JSON.stringify(next)) {
            state.popupColumns = next;
          }
        });
      } catch {
        // 메타 미적재 시 빈 배열 유지 — 하드코딩 폴백 금지
      }
    },

    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 정본 1:1 = shipment-master-electrode(SSP0024).
    //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 역직렬화. searchCondition 만 patch 하므로
    //   filters 불변(진입 자동조회 게이트 무위반). setDivision(cascade 초기화)/setSearchCondition 경유 금지 —
    //   복원이 다른 액션 cascade 를 타지 않도록 직접 병합. Form 의 Division/Operation Group 자동선택 effect 는
    //   `!값` 가드라 복원이 비동기 후행이어도 최종 승리한다(값이 채워지면 자동선택 skip). 저장분 없거나 실패면 기본값 유지.
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
        const allow = makeInitSearch(); // SearchCondition 필드만 allowlist
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in allow)) continue;
          const val = paramCtn ?? '';
          if (RESTORE_ARRAY_KEYS.has(paramNm)) {
            patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          } else if (RESTORE_BOOL_KEYS.has(paramNm)) {
            patch[paramNm] = val === 'true';
          } else {
            patch[paramNm] = val;
          }
        }
        set(state => {
          state.searchCondition = { ...state.searchCondition, ...patch } as SearchCondition;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지 룰)
      }
    },
  }),
  'shipment-request-semi-store'
);
