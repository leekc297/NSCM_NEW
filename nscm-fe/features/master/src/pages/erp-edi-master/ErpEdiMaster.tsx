import { type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useMemo, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ErpEdiMasterForm } from './components/ErpEdiMasterForm';
import { ErpEdiMasterRepairGrid } from './components/ErpEdiMasterRepairGrid';
import { ErpEdiMasterSalesSiteGrid } from './components/ErpEdiMasterSalesSiteGrid';
import { ErpEdiMasterSspmGrid } from './components/ErpEdiMasterSspmGrid';
import { ErpEdiMasterSummaryGrid } from './components/ErpEdiMasterSummaryGrid';
import { MENU_ID, SHEETS, SHEET_INDEX } from './erp-edi-master.constants';
import { EMPTY_SALES_SITE_ROW, EMPTY_SSPM_ROW } from './erp-edi-master.empty-rows';
import styles from './ErpEdiMaster.module.scss';
import { useErpEdiMasterStore } from './useErpEdiMasterStore';

// AS-IS SaveSalesSite(.cs L1000~)/SaveSSPM(.cs L1240~) 컬럼 ↔ SAVE proc param(camelCase) 1:1.
//   SAVE SP 는 ^(=v_delimiter) 구분 다건(SCM_ARR_SPL_VAL 내부 split) — 행별 값들을 '^' join 해 1회 POST.
//   param 키 = PROC_M COL_NM(camelCase) / 값 = grid row 필드(대문자, GET 결과·EMPTY_*_ROW).
const SS_SAVE_MAP: Record<string, string> = {
  divisionId: 'DIVISION_ID',
  endCustomer: 'END_CUSTOMER',
  soldtoCustomer: 'SOLDTO_CUSTOMER',
  companyId: 'COMPANY_ID',
  scmSiteId: 'SSCM_SITE_ID',
  soldtoCode: 'REP_SOLDTO_CODE',
  shiptoCode: 'REP_SHIPTO_CODE',
  vmiYn: 'VMI_YN',
  validYn: 'SITE_VALID_YN',
  custValidYn: 'CUSTOMER_VALID_YN',
  repYn: 'REP_YN',
  country: 'COUNTRY',
  city: 'CITY',
  shipPlanAuto: 'SHIP_PLAN_AUTO',
  deptId: 'TEAM_ID',
};
const SSPM_SAVE_MAP: Record<string, string> = {
  divisionId: 'DIVISION_ID',
  projectCode: 'PROJECT_CODE',
  scmSiteId: 'SCM_SITE_ID',
  itemId: 'ITEM_ID',
  currency: 'CURRENCY',
  kwh: 'KWH',
  cellPerCar: 'CELL_PER_CAR',
  cellPerModule: 'CELL_PER_MODULE',
  liabilityPeriod: 'LIABILITY_PERIOD',
  validYn: 'VALID_YN',
  bpmsExist: 'BPMS_EXIST',
  salesCompany: 'SALES_COMPANY',
  salesPlant: 'SALES_PLANT',
  moduleVariant: 'MODULE_VARIANT',
  incoterms: 'EDI',
};
// salesSite 필수 입력 (AS-IS MSG00002, .cs L1069~1119)
const SS_MANDATORY: ReadonlyArray<{ field: string; label: string }> = [
  { field: 'SSCM_SITE_ID', label: 'Sales Site' },
  { field: 'REP_SOLDTO_CODE', label: 'Sold-To' },
  { field: 'REP_SHIPTO_CODE', label: 'Ship-To' },
  { field: 'SITE_VALID_YN', label: 'Site Valid' },
  { field: 'CUSTOMER_VALID_YN', label: 'Customer Valid' },
];

// AS-IS DMF0008_ErpEdiMaster — 3단 구조:
//   [검색] Division (Form) + Last Update Start/End (AS-IS .cs L2918 DMF0000_GET_UPDATE_HISTORY)
//   [1단] Summary    : DMF0008_GET_EDI_MST_SUMMARY (sheet 'summary')
//   [2단] Repair     : DMF0008_GET_EDI_MST_REPAIR  (sheet 'repair')
//   [3단 2 tab] Sub  : Sales Site / SSPM
//
// 룰 v2 _tobe/01_file_structure.md §1.5 + hook components-folder-pattern.md (2026-06-09):
//   진입 페이지 = composition + layout 만. 4 grid + Form 은 components/ sub-component.
// 룰 #24 menu-button-dynamic-fetch + #62 ui-dynamic-property-management (2026-06-15):
//   useTabBtnPermissions + hasButton(BTN_CD) — admin USE_YN='N' 자동 반영.
const ErpEdiMaster = ({ tabId, title }: PageProps<MENU_ID>) => {
  // V08/V09 fix (2026-06-20): useState(*GridRef) 안티패턴 제거.
  // SubTitle 의 grid/gridFilter 는 activeTab 기반 삼항으로 직접 전달 (Lookup.tsx L208 표준).
  const summaryGridRef = useRef<FlexGridType<ResponseData<MENU_ID, SHEETS.SUMMARY>>>();
  const repairGridRef = useRef<FlexGridType<ResponseData<MENU_ID, SHEETS.REPAIR>>>();
  const salesSiteGridRef =
    useRef<FlexGridType<ResponseData<MENU_ID, SHEETS.SALES_SITE, 'o_rc1'>>>();
  const sspmGridRef = useRef<FlexGridType<ResponseData<MENU_ID, SHEETS.SSPM>>>();
  const summaryFilterRef = useRef<FlexGridFilter>();
  const repairFilterRef = useRef<FlexGridFilter>();
  const salesSiteFilterRef = useRef<FlexGridFilter>();
  const sspmFilterRef = useRef<FlexGridFilter>();

  // DMF0004 표준 store hooks
  const filters = useErpEdiMasterStore(s => s.filters);
  const initialized = useErpEdiMasterStore(s => s.initialized);
  const searchParams = useErpEdiMasterStore(s => s.searchParams);
  const setSearchParams = useErpEdiMasterStore(s => s.setSearchParams);
  const setSummaryFilters = useErpEdiMasterStore(s => s.setSummaryFilters);
  const setUpdateHistoryFilter = useErpEdiMasterStore(s => s.setUpdateHistoryFilter);
  const setRepairFilter = useErpEdiMasterStore(s => s.setRepairFilter);
  const setSalesSiteOnly = useErpEdiMasterStore(s => s.setSalesSiteOnly);
  const setSspmOnly = useErpEdiMasterStore(s => s.setSspmOnly);
  const clearSubFilters = useErpEdiMasterStore(s => s.clearSubFilters);
  const setSalesSiteFilters = useErpEdiMasterStore(s => s.setSalesSiteFilters);
  const setSspmFilters = useErpEdiMasterStore(s => s.setSspmFilters);
  const repairContext = useErpEdiMasterStore(s => s.repairContext);
  const setRepairContext = useErpEdiMasterStore(s => s.setRepairContext);
  const openSearchArea = useErpEdiMasterStore(s => s.openSearchArea);
  const setOpenSearchArea = useErpEdiMasterStore(s => s.setOpenSearchArea);
  const fetchStaticColumns = useErpEdiMasterStore(s => s.fetchStaticColumns);
  const setUpdateHistory = useErpEdiMasterStore(s => s.setUpdateHistory);

  const { t } = useTranslation();

  const setAlert = useMessageStore(s => s.setAlert);
  const setToast = useMessageStore(s => s.setToast);

  // V07 fix (2026-06-20): 동적 권한 hook 도입 (Hook #24/#62).
  // admin USE_YN='N' 시 자동 false. BE 메타 (SCM_ADM_USER_GR_MNU_BTN_MPG_M) 등록 필요.
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const [activeTab, setActiveTab] = useState<SHEET_INDEX>(SHEET_INDEX.SALES_SITE);
  // #3 (2026-06-28): Sort/Filter 는 마지막 클릭(포커스)한 그리드에 적용 — 4 그리드 중 선택.
  //   각 섹션 onClickCapture 로 갱신. 기본 = Summary(최상단).
  const [focusedSheet, setFocusedSheet] = useState<SHEETS>(SHEETS.SUMMARY);

  const [ssRefreshNonce, setSsRefreshNonce] = useState(0);
  const [sspmRefreshNonce, setSspmRefreshNonce] = useState(0);

  const { data: summaryData, refetch: refetchSummary } = useTabProcQuery<MENU_ID, SHEETS.SUMMARY>({
    menuId: MENU_ID,
    sheetName: SHEETS.SUMMARY,
    tabId,
    filters: filters[SHEETS.SUMMARY],
    enabled: !!filters[SHEETS.SUMMARY],
  });

  const { data: repairData, refetch: refetchRepair } = useTabProcQuery<MENU_ID, SHEETS.REPAIR>({
    menuId: MENU_ID,
    sheetName: SHEETS.REPAIR,
    tabId,
    filters: filters[SHEETS.REPAIR],
    enabled: !!filters[SHEETS.REPAIR],
  });

  const { data: salesSiteData, refetch: refetchSalesSite } = useTabProcQuery<
    MENU_ID,
    SHEETS.SALES_SITE
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.SALES_SITE,
    tabId,
    filters: filters[SHEETS.SALES_SITE],
    enabled: !!filters[SHEETS.SALES_SITE],
  });

  const { data: sspmData, refetch: refetchSspm } = useTabProcQuery<MENU_ID, SHEETS.SSPM>({
    menuId: MENU_ID,
    sheetName: SHEETS.SSPM,
    tabId,
    filters: filters[SHEETS.SSPM],
    enabled: !!filters[SHEETS.SSPM],
  });

  // F02 (2026-06-20): AS-IS .cs L2918 DMF0000_GET_UPDATE_HISTORY 호출.
  // setSummaryFilters 가 filters[UPDATE_HISTORY] 도 함께 set (Store) → 자동 fetch.
  const { data: updateHistoryData, refetch: refetchHistory } = useTabProcQuery<
    MENU_ID,
    SHEETS.UPDATE_HISTORY
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.UPDATE_HISTORY,
    tabId,
    filters: filters[SHEETS.UPDATE_HISTORY],
    enabled: !!filters[SHEETS.UPDATE_HISTORY],
  });

  useEffect(() => {
    const row = updateHistoryData?.o_rc1?.[0];
    if (row) {
      setUpdateHistory({
        SDATE: String(row.SDATE ?? ''),
        EDATE: String(row.EDATE ?? ''),
        UPDATED_BY: String(row.UPDATED_BY ?? ''),
      });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [updateHistoryData]);

  // 진입 시 fetchStaticColumns 1회 (메모리 feedback_fetchstaticcolumns_no_initialized_guard)
  useEffect(() => {
    void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // 첫 진입 시 Summary/Repair 자동 조회 막음 (2026-07-02 사용자 요구) — Update History(Form 상단
  //   Last Update)만 조회. Summary/Repair 는 사용자가 Search/조회를 눌러 setSummaryFilters() 호출 시 조회.
  useEffect(() => {
    if (initialized && !filters[SHEETS.UPDATE_HISTORY]) setUpdateHistoryFilter();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [initialized]);

  // #5 (2026-06-28): 하단 탭 전환 시 현재 Repair context 로 미조회된 탭 자동 조회 (hook #81 tab-driven-lazy-fetch).
  //   filter 내용 동일 시 react-query 가 캐시(같은 key) → 중복 fetch 없음. handleRepairDoubleClick 후 탭 전환에도 적용.
  useEffect(() => {
    if (!repairContext) return;
    if (activeTab === SHEET_INDEX.SALES_SITE) {
      setSalesSiteFilters({
        divisionId: repairContext.division,
        soldTo: repairContext.erpSoldTo,
        shipTo: repairContext.erpShipTo,
        scmSiteId: repairContext.gscmSalesSiteId,
      });
    } else {
      setSspmFilters({
        divisionId: repairContext.division,
        itemId: repairContext.erpItemId,
        scmSiteId: repairContext.gscmSalesSiteId,
      });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [activeTab, repairContext]);

  // AS-IS btnStatusUpdate_Click (.cs L2565~2626): PR_DM_DNM_EDI_CALLOFF_STATUS(인자 0개) 실행 →
  //   FindData_Main(Summary/Repair 재조회) + GetUpdateHistory(Update Start/End 최신).
  //   ⚠ 버튼 매핑 SHT_NM='main' (SCM_ADM_MNU_BTN_MPG_M) → 라우트 'main' 사용(이전 'summary'=ORA-01403).
  //   refetch() 직접 호출 — setSummaryFilters 는 filter 내용 동일(캐시) → 최신 미반영이므로.
  const handleStatusUpdate = async () => {
    try {
      void setToast({ type: 'default', message: t('LBL00665', 'Loading...'), duration: 3000 });
      await apiClient.post(`/${MENU_ID}/main/STATUS_UPDATE/call-proc`, {});
      void setToast({ type: 'success', message: 'Status Update 완료. 재조회합니다.' });
      await Promise.all([refetchSummary?.(), refetchRepair?.(), refetchHistory?.()]);
    } catch (e) {
      const msg = e instanceof Error ? e.message : 'Status Update 실패';
      void setAlert({ type: 'alert', content: msg });
    }
  };

  // SummaryGrid onDblClick: (sFlag, division, senderName)
  //   Repair 재조회 시 이전 Repair 선택 기반의 하단 SalesSite/SSPM 은 stale → 함께 클리어 (2026-07-02).
  const handleSummaryDoubleClick = (sFlag: string, _division: string, senderName: string) => {
    setSearchParams({ senderName, flag: sFlag });
    setRepairFilter();
    setRepairContext(undefined);
    // 하단 두 그리드 filter 제거 → salesSiteRows/sspmRows useMemo 가 [] 반환 → itemsSource 변경으로
    //   Wijmo 가 컬렉션 재생성(빈 그리드). 재조회도 막힘(enabled=false).
    clearSubFilters();
  };

  // RepairGrid onDblClick — AS-IS .cs L1973 단일 sheet 분기 (성능 — 2 SP → 1 SP).
  // targetSheet 에 따라 해당 sub tab 으로 전환 + 단일 filter set.
  const handleRepairDoubleClick = (
    targetSheet: 'SALES_SITE' | 'SSPM',
    row: ResponseData<MENU_ID, SHEETS.REPAIR>
  ) => {
    setSearchParams({
      selectedSoldTo: String(row.ERP_SOLDTO ?? ''),
      selectedShipTo: String(row.ERP_SHIPTO ?? ''),
      selectedItemId: String(row.ERP_ITEM_ID ?? ''),
      selectedScmSiteId: String(row.GSCM_SALES_SITE_ID ?? ''),
    });
    if (targetSheet === 'SALES_SITE') {
      setSalesSiteOnly();
      setActiveTab(SHEET_INDEX.SALES_SITE);
    } else {
      setSspmOnly();
      setActiveTab(SHEET_INDEX.SSPM);
    }
    const ctx = {
      division: row.DIVISION_ID,
      senderName: row.EDI_SENDER_NAME,
      flag: filters[SHEETS.REPAIR]?.flag ?? '',
      erpSoldTo: row.ERP_SOLDTO,
      erpShipTo: row.ERP_SHIPTO,
      erpItemId: row.ERP_ITEM_ID,
      gscmSalesSiteId: row.GSCM_SALES_SITE_ID,
      activeSs: row.ACTIVE_SS,
      gscmSspm: row.GSCM_SSPM,
    };
    setRepairContext(ctx);
  };

  const handleInsert = () => {
    if (!repairContext) return;
    if (useSessionStore.getState().session?.groupId === 'SCP Planner') {
      void setAlert({
        type: 'alert',
        content: t('MSG00096', '사용 권한이 없습니다.'),
      });
      return;
    }

    if (activeTab === SHEET_INDEX.SALES_SITE) {
      if (!salesSiteGridRef.current) return;
      // 저장 시 scmSiteId(=SSCM_SITE_ID) 가 키이므로 repair context 의 site 로 prefill (나머지는 popup/입력).
      GridAction.addRow(salesSiteGridRef.current, {
        ...EMPTY_SALES_SITE_ROW,
        DIVISION_ID: repairContext.division,
        REP_SOLDTO_CODE: repairContext.erpSoldTo,
        REP_SHIPTO_CODE: repairContext.erpShipTo,
      });
    } else {
      if (!sspmGridRef.current) return;
      GridAction.addRow(sspmGridRef.current, {
        ...EMPTY_SSPM_ROW,
        DIVISION_ID: repairContext.division,
        SCM_SITE_ID: repairContext.gscmSalesSiteId,
        SOLDTO_CODE: repairContext.erpSoldTo,
        SHIPTO_CODE: repairContext.erpShipTo,
        ITEM_ID: repairContext.erpItemId,
      });
    }
  };

  // Delete (F9, Figma 디자인 — AS-IS DeleteButton 빈 함수) — 활성 sub 그리드에서 신규 추가행만 제거(FE only).
  //   사용자 결정 2026-06-28: 기존 저장행은 미삭제(delete SP 없음). GridAction.removeRow(grid, true)=deleteOnlyNew.
  const handleDelete = () => {
    const grid =
      activeTab === SHEET_INDEX.SALES_SITE ? salesSiteGridRef.current : sspmGridRef.current;
    if (!grid) return;
    const ok = GridAction.removeRow(grid as never, true);
    if (!ok) {
      void setAlert({ type: 'alert', content: t('MSG00113', '_삭제할 신규 행을 선택하세요.') });
    }
  };

  // V11 fix (2026-06-20): typo dead code `?? salesSiteData?.o_rc1` 제거 → 도메인 표준 `?? []`.
  // (no-use-before-define: handleSave 보다 먼저 선언)
  const summaryRows = !filters[SHEETS.SUMMARY] ? [] : (summaryData?.o_rc1 ?? []);
  const repairRows = !filters[SHEETS.REPAIR] ? [] : (repairData?.o_rc1 ?? []);
  // #1 (2026-06-28): salesSite GET OUT 커서명 = O_RESULT_CURSOR (DMF0008_GET_SALES_SITE) — `.o_rc1` 아님.
  //   sspm 은 o_rc1(OPEN O_RC1 FOR SELECT). casing 무관 fallback.
  // ⚠️ TEMP MASK (2026-07-02, 저장테스트용): salesSite/sspm 조회행 EDIT_FLAG 를 'Y' 로 강제.
  //   SP(DMF0008_GET_SALES_SITE) 리터럴 버그로 EDIT_FLAG 가 항상 'N' → 편집/insert 차단됨.
  //   근본 해결(SP fix) 전까지 임시로 마스크. ⛔ 저장테스트 후 제거 예정 (grep: "TEMP MASK").
  // ⚠️ useMemo 필수 (2026-07-02): itemsSource 참조가 매 렌더마다 바뀌면 Wijmo 가 CollectionView 를
  //   재생성 → GridAction.addRow 로 추가한 신규 행이 다른 그리드 클릭(리렌더) 시 소멸. 데이터 원천이
  //   실제로 바뀔 때만(salesSiteData/sspmData) 새 배열 생성하도록 memoize.
  // filter 가 없으면(초기/clearSubFilters 후) 빈 배열 확정 — react-query 캐시 잔존 데이터 재주입 방지.
  const salesSiteRows = useMemo(
    () =>
      !filters[SHEETS.SALES_SITE]
        ? []
        : (
            ((salesSiteData as Record<string, unknown>)?.O_RESULT_CURSOR as
              | ResponseData<MENU_ID, SHEETS.SALES_SITE, 'o_rc1'>[]
              | undefined) ??
            ((salesSiteData as Record<string, unknown>)?.o_result_cursor as
              | ResponseData<MENU_ID, SHEETS.SALES_SITE, 'o_rc1'>[]
              | undefined) ??
            []
          ).map(r => ({ ...r, EDIT_FLAG: 'Y' })),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [salesSiteData, filters[SHEETS.SALES_SITE], ssRefreshNonce]
  );
  const sspmRows = useMemo(
    () =>
      !filters[SHEETS.SSPM] ? [] : (sspmData?.o_rc1 ?? []).map(r => ({ ...r, EDIT_FLAG: 'Y' })),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [sspmData, filters[SHEETS.SSPM], sspmRefreshNonce]
  );

  // AS-IS SaveSalesSite/SaveSSPM — 변경행(CRUD_TYPE)만 ^-delim 누적 → 1회 POST(개별 param SP 가 내부 split).
  //   결과: salesSite=p_message_cursor[0].RESULT_MSG(에러 시 한글 메시지) / sspm=O_RESULT_CURSOR[0].RESULT_CODE('1'=성공).
  //   (두 결과커서 컬럼명이 CODE 가 아니므로 전역 interceptor 미간섭 → 여기서 직접 판별.)
  const handleSave = async () => {
    const isSS = activeTab === SHEET_INDEX.SALES_SITE;
    const src = (isSS ? salesSiteRows : sspmRows) as unknown as Record<string, string>[];
    const rows = src.filter(r => r.CRUD_TYPE);
    if (rows.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00113', '_저장할 데이터를 선택하세요.') });
      return;
    }
    // 필수 검증 (salesSite — AS-IS MSG00002)
    if (isSS) {
      for (const r of rows) {
        const miss = SS_MANDATORY.find(m => !String(r[m.field] ?? '').trim());
        if (miss) {
          void setAlert({
            type: 'alert',
            content: t('MSG00002', `_[${miss.label}] 은(는) 필수 입력사항입니다.`, {
              0: miss.label,
            }),
          });
          return;
        }
      }
    }
    const map = isSS ? SS_SAVE_MAP : SSPM_SAVE_MAP;
    const acc: Record<string, string[]> = {};
    for (const k of Object.keys(map)) acc[k] = [];
    for (const r of rows) {
      for (const [param, field] of Object.entries(map)) acc[param].push(String(r[field] ?? ''));
    }
    const payload: Record<string, string> = {};
    for (const [k, arr] of Object.entries(acc)) payload[k] = arr.join('^');
    if (isSS) payload['deptId'] = '-';

    try {
      void setToast({ type: 'default', message: t('LBL00665', 'Loading...'), duration: 3000 });
      const route = isSS ? SHEETS.SALES_SITE : SHEETS.SSPM;
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${route}/SAVE/call-proc`,
        payload
      );
      if (res.status >= 400 || Number(res.data?.code)) {
        const reason =
          (res.data as { message?: string })?.message?.trim() ||
          t('MSG00618', '_저장 중 오류가 발생했습니다.');
        void setAlert({ type: 'alert', content: reason });
        return; // 편집/신규행 유지 — 사용자가 수정 후 재저장
      }
      const result = (res.data?.result ?? {}) as Record<string, Record<string, string>[]>;
      if (isSS) {
        const m = String(result.p_message_cursor?.[0]?.RESULT_MSG ?? '').trim();
        if (m && m.toUpperCase() !== 'SUCCESS') {
          void setAlert({ type: 'alert', content: m });
          return;
        }
      } else {
        const rc = result.O_RESULT_CURSOR ?? result.o_result_cursor;
        const code = String(rc?.[0]?.RESULT_CODE ?? '');
        if (code && code !== '1') {
          const em =
            String(rc?.[0]?.RESULT_MSG ?? rc?.[0]?.ERR_EVENT ?? '').trim() ||
            t('MSG00618', '_저장 중 오류가 발생했습니다.');
          void setAlert({ type: 'alert', content: em });
          return;
        }
      }
      void setToast({ type: 'success', message: t('MSG00606', '_데이터가 저장되었습니다.') });
      if (isSS) {
        await refetchSalesSite?.();
        setSsRefreshNonce(n => n + 1);
      } else {
        await refetchSspm?.();
        setSspmRefreshNonce(n => n + 1);
      }
    } catch (e) {
      const msg = e instanceof Error ? e.message : t('MSG00618', '_저장 중 오류가 발생했습니다.');
      void setAlert({ type: 'alert', content: msg });
    }
  };

  // V07 fix (2026-06-20): hasButton 권한 분기.
  // BTN_CD 표준: SEARCH / SAVE / INSERT / STATUS_UPDATE (DMF0008 메타 SCM_ADM_USER_GR_MNU_BTN_MPG_M).
  // 2026-06-20 사용자 요구: Condition / ResetCondition 기본 활성 (SubTitle DefaultButtonActions).
  // → 명시 미정의 = 자동 활성 (F6 / F10).
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? setSummaryFilters : false,
    save: false, //hasButton('SAVE') ? handleSave : false,
    insert: false, //hasButton('INSERT') ? handleInsert : false,
    delete: hasButton('DELETE') ? handleDelete : false, // Delete(F9) — Figma 디자인 + 권한 메타(DELETE) 등록
    manual: false,
    upload: false,
  };

  // V07: customButtons 도 권한 분기 (STATUS_UPDATE BTN_CD).
  const customButtons = hasButton('STATUS_UPDATE')
    ? [
        {
          label: 'Status Update',
          action: () => void handleStatusUpdate(),
        },
      ]
    : [];

  // #3: SubTitle 의 Sort/Filter 대상 = focusedSheet(마지막 클릭 그리드)의 grid/filter ref (4-way).
  const focusedGridRef =
    focusedSheet === SHEETS.SUMMARY
      ? summaryGridRef
      : focusedSheet === SHEETS.REPAIR
        ? repairGridRef
        : focusedSheet === SHEETS.SALES_SITE
          ? salesSiteGridRef
          : sspmGridRef;
  const focusedGridFilterRef =
    focusedSheet === SHEETS.SUMMARY
      ? summaryFilterRef
      : focusedSheet === SHEETS.REPAIR
        ? repairFilterRef
        : focusedSheet === SHEETS.SALES_SITE
          ? salesSiteFilterRef
          : sspmFilterRef;

  return (
    <div className={styles.container}>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <ErpEdiMasterForm />

      <SubTitle
        menuId={MENU_ID}
        grid={focusedGridRef as never}
        gridFilter={focusedGridFilterRef}
        dataCount={repairRows.length}
        excelFileName='ErpEdiMaster'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
        customButtons={customButtons}
      />

      {/* ⭐ Figma Top (527h) — Summary(좌 400) | Repair(우 1202) 2-컬럼 (2026-06-28) */}
      <div className={styles.topRow}>
        <div className={styles.summaryCol} onClickCapture={() => setFocusedSheet(SHEETS.SUMMARY)}>
          <div className={styles.sectionTitle}>Summary</div>
          <ErpEdiMasterSummaryGrid
            gridRef={summaryGridRef}
            gridFilterRef={summaryFilterRef}
            data={summaryRows}
            onDblClick={handleSummaryDoubleClick}
          />
        </div>

        <div className={styles.repairCol} onClickCapture={() => setFocusedSheet(SHEETS.REPAIR)}>
          <div className={styles.sectionTitle}>List of SCM Master Data Requiring Maintenance</div>
          <ErpEdiMasterRepairGrid
            gridRef={repairGridRef}
            gridFilterRef={repairFilterRef}
            data={repairRows}
            onDblClick={handleRepairDoubleClick}
          />
        </div>
      </div>

      {/* Figma 하단 Module (180h): Sales Site / SSPM 탭 */}
      <div
        className={styles.subSection}
        onClickCapture={() =>
          setFocusedSheet(activeTab === SHEET_INDEX.SALES_SITE ? SHEETS.SALES_SITE : SHEETS.SSPM)
        }
      >
        <TabWrapper
          persist
          activeTabIndex={activeTab}
          setActiveTabIndex={setActiveTab as (idx: number) => void}
        >
          <TabItem label='Sales Site'>
            <ErpEdiMasterSalesSiteGrid
              gridRef={salesSiteGridRef}
              gridFilterRef={salesSiteFilterRef}
              data={salesSiteRows}
            />
          </TabItem>
          <TabItem label='SSPM'>
            <ErpEdiMasterSspmGrid
              gridRef={sspmGridRef}
              gridFilterRef={sspmFilterRef}
              data={sspmRows}
            />
          </TabItem>
        </TabWrapper>
      </div>
    </div>
  );
};
export default ErpEdiMaster;
