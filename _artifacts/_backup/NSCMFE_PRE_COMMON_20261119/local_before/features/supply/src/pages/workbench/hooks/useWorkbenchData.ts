// SCP0125 데이터 조달 — `init`(9커서) 1회 + 5탭 lazy 조회 + lookup 4종을 한곳에 모은다.
//   페이지 본체 400라인 제한(hook #47/#51) 때문에 쿼리 배선을 여기로 뺐다.
//
// AS-IS 근거: cs:75(필드 초기자 = GET_SEARCH_INFO 1회) · cs:61~64(lookup) ·
//             cs:554~615(FindData_Main 5분기) · cs:2049(탭 전환 시 재평가)

import { useMemo } from 'react';

import type { ComboResponse } from '@foundation/models';
import { useTabLookupQueries, useTabProcQuery } from '@shared/hooks';

import { useWorkbenchStore } from '../useWorkbenchStore';
import type { DeriveSources } from '../utils/workbench.derive';
import { buildCellComboRows, toComboRows } from '../utils/workbench.gridCombos';
import type { CellComboRows } from '../utils/workbench.gridCombos';
import { DIVISION_CODE, GM_LOOKUP_TYPE, MENU_ID, RESPONSE_SET, SHEETS, TABS } from '../workbench.constants';
import type { RowsByTab, WorkbenchInitData } from '../workbench.types';

/** `init` 은 IN 파라미터가 0개다 — 모듈 상수로 고정해 참조가 매 렌더 바뀌지 않게 한다(§5-2). */
const INIT_FILTERS = {} as ProcRequest<MENU_ID, SHEETS.INIT>;

/**
 * 셀 콤보·파생이 쓰는 lookup. `SALES_TYPE_CODE`(=AS-IS `FcstType`)·`STOCK_TYPE` 는 두 축 모두에
 * 쓰인다 — 콤보 후보는 CODE=NAME 으로 재구성해 주입하고(`asDisplayKeyRows`), 파생은 여기서 받은
 * **원본**(CODE=SEGMENT1)으로 NAME→CODE 역변환한다. `YesOrNo` 만 메타 자동 콤보라 조회하지 않는다.
 */
const LOOKUP_TYPES = [GM_LOOKUP_TYPE, 'SALES_TYPE_CODE', 'STOCK_TYPE', 'INCOTERMS'];

/**
 * 조회 전 폴백 배열은 **탭마다 다른 객체**여야 하고 **모듈 스코프에 두면 안 된다**.
 *
 * 공용 `GridAction.addRow`(`packages/foundation/src/utils/gridAction.ts:821·831`)는
 * `collectionView.sourceCollection` 을 **직접 `splice`** 한다 — 즉 화면이 `itemsSource` 로 넘긴
 * 배열 자체를 변형한다(memory `datagrid-save-read-from-grid-source`). 앞단 가드
 * (`:815~818`)는 `length === 0` 이면 통과하므로 **조회 전 Insert 가 그대로 도달**한다.
 * 5탭이 같은 배열 1개를 폴백으로 공유하면 신규행 1건이 5탭 전부에 나타나고, 저장 시
 * `sourceCollection` 에 타 시트 행이 섞여 잘못된 SAVE SP 로 전송된다. 모듈 상수면 탭을 닫았다
 * 열어도 그 오염이 남는다.
 * → 화면 인스턴스마다 `useMemo` 로 탭별 빈 배열 5개를 만든다(참조 안정성은 그대로 유지 — §5-4).
 *
 * `resetKey`(division + Plan Date)가 바뀌면 배열을 **새로 만든다**. R05·R06 은 "Division·Plan Date
 * 변경 = 5탭 그리드 전부 비움"(AS-IS `ClearDataSource` cs:1997·2004)인데, `clearFilters()` 는
 * 스토어 filters 만 비우고 쿼리를 disable 할 뿐이라 **폴백 배열은 그대로 재사용된다** — 조회 전
 * Insert 로 들어간 신규행이 옛 `DIVISION_ID` 를 품은 채 살아남는다(`utils/workbench.insert.ts` 가
 * 삽입 시점 division 을 행에 박는다). 그러면 dirty 판정 때문에 탭 전환도 막히고, 그 상태로 저장하면
 * 새 division 화면에서 옛 division 행이 전송된다. 배열을 새로 만들면 그 경로가 끊긴다.
 */
const useEmptyRowsByTab = (resetKey: string): RowsByTab =>
  useMemo<RowsByTab>(
    () => ({
      [TABS.MKT_FCST]: [],
      [TABS.STOCK]: [],
      [TABS.STOCK_ELEC]: [],
      [TABS.ELEC_DEMAND]: [],
      [TABS.STOCK_2ND_OCV]: [],
    }),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [resetKey]
  );

export interface WorkbenchData {
  init: WorkbenchInitData;
  /** GM 사업부 여부 — lookup 조회 결과로 판정(FE 화이트리스트 금지, hook #113). */
  isGmDivision: boolean;
  /** STOCK 계열 SP 분기 여부(`81_UC`) — 대응 메타가 없어 상수 비교다(constants DIVISION_CODE 주석). */
  isUcDivision: boolean;
  rowsByTab: RowsByTab;
  isFetching: boolean;
  comboRowsByTab: Record<TABS, CellComboRows>;
  deriveSources: DeriveSources;
}

export const useWorkbenchData = (tabId: string): WorkbenchData => {
  const searchParams = useWorkbenchStore(state => state.searchParams);
  const filters = useWorkbenchStore(state => state.filters);

  const [gmRows, fcstTypeRows, stockTypeRows, incotermsRows] = useTabLookupQueries({
    filters: LOOKUP_TYPES,
  });

  const divisionId = searchParams.divisionId;
  /**
   * GM 사업부 판정 — 응답 키는 `CODE` 가 아니라 **lookup 마스터 헤더값**이다.
   * TO-BE `PKG_NSCM_UI_COM_LOOKUP.PR_GET_LOOKUP_INFO_LIST` 는 `SCM_ADM_LOOKUP_MASTER.SEGMENT1~5`
   * 에 적힌 헤더명으로 PIVOT 하므로 `OPMZ_DIVISION_GM` 의 응답 컬럼은 `{LOOKUP_TYPE, DIVISION_ID}` 다
   * (SEGMENT1='DIVISION_ID', SEGMENT2~5='-' 실측). AS-IS 는 `SEGMENT1 AS CODE` 로 받았기 때문에
   * `row.CODE` 로 옮기면 판정이 **영구 false** 가 되어 일단위 위젯·조회기준일·신규행 CUTOFF 가
   * 동시에 틀어진다(iter-2 감사 GAP-15). 다른 lookup type 재사용 시의 이식성을 위해 `CODE` 도 남긴다.
   */
  const isGmDivision = useMemo(
    () => (gmRows ?? []).some(row => (row.CODE ?? row.DIVISION_ID) === divisionId),
    [gmRows, divisionId]
  );
  const isUcDivision = divisionId === DIVISION_CODE.UC;

  // ── init(GET_SEARCH_INFO) — 화면당 1회. Division 변경 시 재호출하지 않는다(W23).
  const { data: initData } = useTabProcQuery<MENU_ID, SHEETS.INIT>({
    menuId: MENU_ID,
    sheetName: SHEETS.INIT,
    tabId,
    filters: INIT_FILTERS,
    enabled: true,
  });

  // ── 5탭 lazy 조회. 그 탭 filters 가 없으면 미발사 = 빈 그리드 유지(hook #81 / V27).
  //   STOCK 계열만 division 으로 sheetName 이 갈린다(goal.md §4.4 C2) — `divisionId` 를 filters 로만
  //   넘기고 sheetName 을 고정하면 81_UC 의 2열(`LINE_ID`·`BEFORE_DEGAS`)이 통째로 빠진다.
  const stockSheet = isUcDivision ? SHEETS.STOCK_UC : SHEETS.STOCK;
  const stockElecSheet = isUcDivision ? SHEETS.STOCK_ELEC_UC : SHEETS.STOCK_ELEC;

  const mktFcst = useTabProcQuery<MENU_ID, SHEETS.MKT_FCST>({
    menuId: MENU_ID,
    sheetName: SHEETS.MKT_FCST,
    tabId,
    filters: filters[SHEETS.MKT_FCST],
    enabled: !!filters[SHEETS.MKT_FCST],
  });
  const stock = useTabProcQuery<MENU_ID, SHEETS.STOCK | SHEETS.STOCK_UC>({
    menuId: MENU_ID,
    sheetName: stockSheet,
    tabId,
    filters: filters[stockSheet],
    enabled: !!filters[stockSheet],
  });
  const stockElec = useTabProcQuery<MENU_ID, SHEETS.STOCK_ELEC | SHEETS.STOCK_ELEC_UC>({
    menuId: MENU_ID,
    sheetName: stockElecSheet,
    tabId,
    filters: filters[stockElecSheet],
    enabled: !!filters[stockElecSheet],
  });
  const elecDemand = useTabProcQuery<MENU_ID, SHEETS.ELEC_DEMAND>({
    menuId: MENU_ID,
    sheetName: SHEETS.ELEC_DEMAND,
    tabId,
    filters: filters[SHEETS.ELEC_DEMAND],
    enabled: !!filters[SHEETS.ELEC_DEMAND],
  });
  const secondOcv = useTabProcQuery<MENU_ID, SHEETS.STOCK_2ND_OCV>({
    menuId: MENU_ID,
    sheetName: SHEETS.STOCK_2ND_OCV,
    tabId,
    filters: filters[SHEETS.STOCK_2ND_OCV],
    enabled: !!filters[SHEETS.STOCK_2ND_OCV],
  });

  // itemsSource 참조 안정화 — 매 렌더 새 `?? []` 를 넘기면 CollectionView 가 재구축된다(§5-4).
  //   폴백은 탭별 독립 배열이다(위 `useEmptyRowsByTab` 주석 — 공유하면 조회 전 Insert 가 5탭을 오염시킨다).
  //   R05·R06 축 — 이 둘 중 하나라도 바뀌면 폴백 배열을 새로 만들어 조회 전 신규행을 버린다.
  const emptyRowsByTab = useEmptyRowsByTab(
    `${searchParams.divisionId}|${searchParams.planStartYyyymmdd}|${searchParams.planDateDaily}`
  );
  const rowsByTab = useMemo<RowsByTab>(
    () => ({
      [TABS.MKT_FCST]: mktFcst.data?.[RESPONSE_SET] ?? emptyRowsByTab[TABS.MKT_FCST],
      [TABS.STOCK]: stock.data?.[RESPONSE_SET] ?? emptyRowsByTab[TABS.STOCK],
      [TABS.STOCK_ELEC]: stockElec.data?.[RESPONSE_SET] ?? emptyRowsByTab[TABS.STOCK_ELEC],
      [TABS.ELEC_DEMAND]: elecDemand.data?.[RESPONSE_SET] ?? emptyRowsByTab[TABS.ELEC_DEMAND],
      [TABS.STOCK_2ND_OCV]: secondOcv.data?.[RESPONSE_SET] ?? emptyRowsByTab[TABS.STOCK_2ND_OCV],
    }),
    [mktFcst.data, stock.data, stockElec.data, elecDemand.data, secondOcv.data, emptyRowsByTab]
  );

  const init = useMemo<WorkbenchInitData>(
    () => ({
      versionAll: (initData?.o_rc1 ?? []) as ComboResponse[],
      salesSiteAll: (initData?.o_rc2 ?? []) as ComboResponse[],
      plantSiteAll: (initData?.o_rc3 ?? []) as ComboResponse[],
      scmSiteAll: (initData?.o_rc4 ?? []) as ComboResponse[],
      itemAll: initData?.o_rc5 ?? [],
      projectAll: initData?.o_rc6 ?? [],
      projectCode40All: (initData?.o_rc7 ?? []) as ComboResponse[],
      locationAll: (initData?.o_rc8 ?? []) as ComboResponse[],
      lineAll: (initData?.o_rc9 ?? []) as ComboResponse[],
    }),
    [initData]
  );

  const fcstTypeCombo = useMemo(() => toComboRows(fcstTypeRows), [fcstTypeRows]);
  const stockTypeCombo = useMemo(() => toComboRows(stockTypeRows), [stockTypeRows]);
  const incotermsCombo = useMemo(() => toComboRows(incotermsRows), [incotermsRows]);

  const comboRowsByTab = useMemo<Record<TABS, CellComboRows>>(() => {
    const built = buildCellComboRows(init, divisionId, {
      fcstType: fcstTypeCombo,
      stockType: stockTypeCombo,
      incoterms: incotermsCombo,
    });
    return {
      [TABS.MKT_FCST]: built.mktFcst,
      [TABS.STOCK]: built.stock,
      [TABS.STOCK_ELEC]: built.stockElec,
      [TABS.ELEC_DEMAND]: built.elecDemand,
      [TABS.STOCK_2ND_OCV]: built.stock2ndOcv,
    };
  }, [init, divisionId, fcstTypeCombo, stockTypeCombo, incotermsCombo]);

  const deriveSources = useMemo<DeriveSources>(
    () => ({
      fcstTypeRows: fcstTypeCombo,
      stockTypeRows: stockTypeCombo,
      lineAll: init.lineAll,
      plantSiteAll: init.plantSiteAll,
    }),
    [fcstTypeCombo, stockTypeCombo, init.lineAll, init.plantSiteAll]
  );

  return {
    init,
    isGmDivision,
    isUcDivision,
    rowsByTab,
    isFetching:
      mktFcst.isFetching ||
      stock.isFetching ||
      stockElec.isFetching ||
      elecDemand.isFetching ||
      secondOcv.isFetching,
    comboRowsByTab,
    deriveSources,
  };
};
