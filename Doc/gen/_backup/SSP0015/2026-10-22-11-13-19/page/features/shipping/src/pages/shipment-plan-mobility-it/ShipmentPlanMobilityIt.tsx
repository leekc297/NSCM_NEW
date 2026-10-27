import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import {
  MaterialByDivisionModal,
  MeasureSelectModal,
  ModelByDivisionPopup,
} from 'features/master/src/components';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcMeasureSelect } from '@foundation/assets';
import { CELL_CONTROL_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { HotkeyConfig, PageProps, RawFlexGridColumnConfig } from '@foundation/models';
import { useMutation, useQuery } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import { GridAction, GridUtils } from '@foundation/utils';
import { MainTitle, saveTitleSet, SsoUserModal, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useProcMutation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ShipmentChangeRequestDraftingModal } from './components/ShipmentChangeRequestDraftingModal';
import {
  ShipmentOrderDetailModal,
  type OrderDetailContext,
} from './components/ShipmentOrderDetailModal';
import { ShipmentPsiDetailBar } from './components/ShipmentPsiDetailBar';
import { ShipmentPsiDetailGrid } from './components/ShipmentPsiDetailGrid';
import { ShipmentPsiForm } from './components/ShipmentPsiForm';
import { ShipmentPsiMainGrid } from './components/ShipmentPsiMainGrid';
import {
  ShipmentPsiMemoModal,
  type MemoContext,
  type MemoSaveInput,
} from './components/ShipmentPsiMemoModal';
import {
  ADMIN_SHEET_NAME,
  COMMENTS_BTN,
  FIXED_DIVISION,
  LBL,
  MAX_PERIOD_LABEL_DAYS,
  MENU_ID,
  MSG,
  RESULT_TYPE_BY_SHEET,
  SHEETS,
  TITLESET_MEASURE_TYPE,
  USER_CHECK_BTN,
} from './shipment-plan-mobility-it.constants';
import type { MainRow } from './shipment-plan-mobility-it.types';
import styles from './ShipmentPlanMobilityIt.module.scss';
import { useShipmentPlanMobilityItStore } from './useShipmentPlanMobilityItStore';
import { figureDrilldownOf, measureDrilldownOf } from './utils/shipment-plan-mobility-it.detailSheets';
import {
  collectConfirmSaveRows,
  collectHoldSaveRows,
  collectMainSaveRows,
  toValidYmd,
  type ConfirmSaveFolded,
  type HoldSaveFolded,
  type MainSaveFolded,
} from './utils/shipment-plan-mobility-it.save';
import { applyMainSums } from './utils/shipment-plan-mobility-it.sum';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// AS-IS GSCM.SSP.Plan.UIL SSP0015_ShipmentPSI (Shipment Plan(Mobility & IT)) — 신규 전환(2026-09-27).
//   설계: .atlas/gscm-design/SSP0015/design/00~03. 매핑: __asis-mapping__.md.
//   툴바: Find/Insert/Delete/Save=실동작, EditButton 모드토글 미이식(편집 기본 ON, convert-core §2.4).
//   미이관/후속(04_react-gap.md): TransMode/ShipToCode 셀콤보 lazy 재조회, ERP 인터페이스 연쇄(convert-sp),
//   PlanDateShip Packer 분기, Comments/OrderDetail 팝업, PACKER_PAST 조회.
export const ShipmentPlanMobilityIt = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const session = useSessionStore(s => s.session);

  // ── refs ──
  const mainGridRef = useRef<FlexGridType>();
  const mainGridFilterRef = useRef<FlexGridFilter>();
  const mainEditTrackerRef = useRef<EditTracker>();
  const confirmGridRef = useRef<FlexGridType>();
  const confirmGridFilterRef = useRef<FlexGridFilter>();
  const confirmEditTrackerRef = useRef<EditTracker>();
  const whStockGridRef = useRef<FlexGridType>();
  const whStockGridFilterRef = useRef<FlexGridFilter>();
  const holdStockGridRef = useRef<FlexGridType>();
  const holdStockGridFilterRef = useRef<FlexGridFilter>();
  const holdStockEditTrackerRef = useRef<EditTracker>();
  const mesStockGridRef = useRef<FlexGridType>();
  const mesStockGridFilterRef = useRef<FlexGridFilter>();
  const mesStockEditTrackerRef = useRef<EditTracker>();
  const scsStockGridRef = useRef<FlexGridType>();
  const scsStockGridFilterRef = useRef<FlexGridFilter>();
  const stockLocGridRef = useRef<FlexGridType>();
  const stockLocGridFilterRef = useRef<FlexGridFilter>();
  const resultGridRef = useRef<FlexGridType>();
  const resultGridFilterRef = useRef<FlexGridFilter>();

  // ── store ──
  const sc = useShipmentPlanMobilityItStore(s => s.searchCondition);
  const set = useShipmentPlanMobilityItStore(s => s.setSearchCondition);
  const filters = useShipmentPlanMobilityItStore(s => s.filters);
  const mainSheet = useShipmentPlanMobilityItStore(s => s.mainSheet);
  const setMainSheet = useShipmentPlanMobilityItStore(s => s.setMainSheet);
  const setMainFilters = useShipmentPlanMobilityItStore(s => s.setMainFilters);
  const setDetailFilter = useShipmentPlanMobilityItStore(s => s.setDetailFilter);
  const clearFilters = useShipmentPlanMobilityItStore(s => s.clearFilters);
  const restoreSearchConditions = useShipmentPlanMobilityItStore(s => s.restoreSearchConditions);
  const openSearchArea = useShipmentPlanMobilityItStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentPlanMobilityItStore(s => s.setOpenSearchArea);
  const activeGrid = useShipmentPlanMobilityItStore(s => s.activeGrid);
  const activeDetailSheet = useShipmentPlanMobilityItStore(s => s.activeDetailSheet);
  const setActiveDetailSheet = useShipmentPlanMobilityItStore(s => s.setActiveDetailSheet);
  const staticColumns = useShipmentPlanMobilityItStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentPlanMobilityItStore(s => s.fetchStaticColumns);
  const staticMeasures = useShipmentPlanMobilityItStore(s => s.staticMeasures);
  const visibleMeasures = useShipmentPlanMobilityItStore(s => s.visibleMeasures);
  const fetchStaticMeasures = useShipmentPlanMobilityItStore(s => s.fetchStaticMeasures);
  const applyVisibleMeasures = useShipmentPlanMobilityItStore(s => s.applyVisibleMeasures);
  const initialized = useShipmentPlanMobilityItStore(s => s.initialized);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const latestPlanDate = useShipmentPlanMobilityItStore(s => s.latestPlanDate);

  // R7a(편집 진입 가드, I06) — AS-IS EditButton(cs L1737) GetSSPUserCheck()==false → MSG00251 차단.
  //   USER_CHECK(=SSP0002_GET_USER_INFO_LIST) 호출: o_rc1 0행 or 403(비SSP 권한) 이면 SSP 등록 사용자 아님.
  //   체크 전(undefined)엔 낙관적 허용(sspUserCheck!==false), 완료 후 비SSP면 편집 비활성(canEdit=false)+1회 알럿.
  const { data: sspUserCheck } = useQuery({
    queryKey: [tabId, 'sspUserCheck', session.userId],
    queryFn: async () => {
      try {
        const res = await apiClient.post(`/${MENU_ID}/${SHEETS.MAIN}/${USER_CHECK_BTN}/call-proc`, {
          userId: session.userId ?? '',
          language: session.langCd ?? '',
          ssoUserYn: 'N',
        });
        if (res.status >= 400 || Number(res.data?.code)) return false; // 403 = USER_CHECK 권한 없음 = 비SSP
        const rows = (res.data?.result as { o_rc1?: unknown[] })?.o_rc1 ?? [];
        return rows.length > 0;
      } catch {
        return false;
      }
    },
    enabled: !!session.userId,
    staleTime: Infinity,
  });
  const isSspUser = sspUserCheck !== false;
  const sspAlertShownRef = useRef(false);
  useEffect(() => {
    if (sspUserCheck === false && !sspAlertShownRef.current) {
      sspAlertShownRef.current = true;
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_AUTHORITY, '__You are not a registered SSP Planner. [User ID : {0}]').replace(
          '{0}',
          session.userId ?? ''
        ),
      });
    }
  }, [sspUserCheck, t, session.userId]);

  // 편집 기본 ON — canEdit = hasButton('EDIT') (AS-IS EditButton 토글 미이식, convert-core §2.4) + R7a(SSP 사용자).
  const canEdit = hasButton('EDIT') && isSspUser;
  // R7b(이전 Plan 편집차단, MSG00170) — AS-IS oldPlanDate!=newPlanDate 는 spdMain 편집 가드다. 선택 Plan
  //   Date 가 최신(콤보 [0])이 아니면 편집 차단(알럿 없이 — 사용자 지시 2026-09-30). master(PSI)뿐 아니라
  //   아래 Detail 탭 그리드도 동일 적용(사용자 지시 2026-10-01). latestPlanDate 미확정('')·planDate
  //   미선택이면 통과(로드 전 불필요 차단 방지).
  const isLatestPlan = !latestPlanDate || !sc.planDate || sc.planDate === latestPlanDate;
  const canEditPlan = canEdit && isLatestPlan;

  // Packer 과거 조회 분기 — AS-IS SSP0015.cs: 최신 Plan 은 GET_SHIPMENT_PSI_PACKER(L2354),
  //   비최신(과거) Plan 은 GET_SHIPMENT_PSI_PACKER_PAST(L2235). 조회한 filter 의 planStart 를 기준으로 판정
  //   (sc 는 조회 후 바뀔 수 있어 커밋된 filter 기준). btn 매핑: (SSP0015, main, GET_SHIPMENT_PSI_PACKER_PAST).
  const packerSearchedPlan = (filters[SHEETS.MAIN_PACKER] as Record<string, string> | undefined)
    ?.planStartYyyymmdd;
  const isPackerPast =
    mainSheet === 'packer' && !!latestPlanDate && !!packerSearchedPlan && packerSearchedPlan !== latestPlanDate;

  // ── 모달 open state ──
  const [openItemMain, setOpenItemMain] = useState(false);
  const [openItemDetail, setOpenItemDetail] = useState(false);
  const [openMeasure, setOpenMeasure] = useState(false);
  const [openRequestor, setOpenRequestor] = useState(false);
  // CHANGE_REQ_NO 셀 클릭 → 변경요청 상세(Drafting) 팝업 (I13). 비공백이면 모달 오픈.
  const [reqDraftingNo, setReqDraftingNo] = useState('');
  // ERP_SO_NO 더블클릭 → OrderDetail(SSP0300) 팝업 컨텍스트
  const [orderDetailCtx, setOrderDetailCtx] = useState<OrderDetailContext | null>(null);

  // ── 조회 (React Query) ──
  const { data: mainData, refetch: refetchMain } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const { data: packerData, refetch: refetchPacker } = useTabProcQuery<MENU_ID, SHEETS.MAIN_PACKER>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN_PACKER,
    tabId,
    filters: filters[SHEETS.MAIN_PACKER],
    enabled: !!filters[SHEETS.MAIN_PACKER] && !isPackerPast,
  });
  // Packer 과거 조회 — GET_SHIPMENT_PSI_PACKER_PAST (btn 매핑 shtNm='main'). filter 는 Packer 와 동일.
  //   비최신 Plan 일 때만 활성. useTabProcQuery 는 typed 라 커스텀 btnCd/시트 조합엔 apiClient 직결 사용.
  const { data: packerPastData, refetch: refetchPackerPast } = useQuery({
    queryKey: [tabId, 'packerPast', filters[SHEETS.MAIN_PACKER]],
    queryFn: async () => {
      const r = await apiClient.post(
        `/${MENU_ID}/${SHEETS.MAIN}/GET_SHIPMENT_PSI_PACKER_PAST/call-proc`,
        filters[SHEETS.MAIN_PACKER]
      );
      return (r.data?.result as { o_rc1?: MainRow[] }) ?? { o_rc1: [] };
    },
    enabled: !!filters[SHEETS.MAIN_PACKER] && isPackerPast,
  });
  const { data: calendarData } = useTabProcQuery<MENU_ID, SHEETS.CALENDAR>({
    menuId: MENU_ID,
    sheetName: SHEETS.CALENDAR,
    tabId,
    filters: filters[SHEETS.CALENDAR],
    enabled: !!filters[SHEETS.CALENDAR],
  });
  // Confirm Detail 은 상단 탭에 따라 데이터 SP 가 다르다(AS-IS FindData_Detail vs FindData_Detail_Packer):
  //   Mobility&IT → GET_SHIPMENT_CONFIRM_DETAIL, Packer → GET_SHIPMENT_CONFIRM_DETAIL_PACKER.
  //   시트(72열)는 공유 superset, IN 파라미터 17개 동일 — 라우팅만 분기한다.
  const { data: confirmData } = useTabProcQuery<MENU_ID, SHEETS.CONFIRM_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.CONFIRM_DETAIL,
    tabId,
    filters: filters[SHEETS.CONFIRM_DETAIL],
    enabled: !!filters[SHEETS.CONFIRM_DETAIL] && mainSheet !== 'packer',
  });
  // Packer Confirm Detail — GET_SHIPMENT_CONFIRM_DETAIL_PACKER (btn 매핑 shtNm='main'). filter 는 동일.
  const { data: confirmPackerData } = useQuery({
    queryKey: [tabId, 'confirmPacker', filters[SHEETS.CONFIRM_DETAIL]],
    queryFn: async () => {
      const r = await apiClient.post(
        `/${MENU_ID}/${SHEETS.MAIN}/GET_SHIPMENT_CONFIRM_DETAIL_PACKER/call-proc`,
        filters[SHEETS.CONFIRM_DETAIL]
      );
      return (r.data?.result as { o_rc1?: WijmoRowItem[] }) ?? { o_rc1: [] };
    },
    enabled: !!filters[SHEETS.CONFIRM_DETAIL] && mainSheet === 'packer',
  });
  const { data: whStockData } = useTabProcQuery<MENU_ID, SHEETS.WH_STOCK>({
    menuId: MENU_ID,
    sheetName: SHEETS.WH_STOCK,
    tabId,
    filters: filters[SHEETS.WH_STOCK],
    enabled: !!filters[SHEETS.WH_STOCK],
  });
  const { data: holdStockData, refetch: refetchHoldStock } = useTabProcQuery<MENU_ID, SHEETS.HOLD_STOCK>({
    menuId: MENU_ID,
    sheetName: SHEETS.HOLD_STOCK,
    tabId,
    filters: filters[SHEETS.HOLD_STOCK],
    enabled: !!filters[SHEETS.HOLD_STOCK],
  });
  const { data: mesStockData } = useTabProcQuery<MENU_ID, SHEETS.MES_STOCK>({
    menuId: MENU_ID,
    sheetName: SHEETS.MES_STOCK,
    tabId,
    filters: filters[SHEETS.MES_STOCK],
    enabled: !!filters[SHEETS.MES_STOCK],
  });
  const { data: scsStockData } = useTabProcQuery<MENU_ID, SHEETS.SCS_STOCK>({
    menuId: MENU_ID,
    sheetName: SHEETS.SCS_STOCK,
    tabId,
    filters: filters[SHEETS.SCS_STOCK],
    enabled: !!filters[SHEETS.SCS_STOCK],
  });
  const { data: stockLocData } = useTabProcQuery<MENU_ID, SHEETS.STOCK_LOCATION_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.STOCK_LOCATION_DETAIL,
    tabId,
    filters: filters[SHEETS.STOCK_LOCATION_DETAIL],
    enabled: !!filters[SHEETS.STOCK_LOCATION_DETAIL],
  });
  const { data: resultData } = useTabProcQuery<MENU_ID, SHEETS.SHIPMENT_RESULT>({
    menuId: MENU_ID,
    sheetName: SHEETS.SHIPMENT_RESULT,
    tabId,
    filters: filters[SHEETS.SHIPMENT_RESULT],
    enabled: !!filters[SHEETS.SHIPMENT_RESULT],
  });
  // WH In Plan Detail — 전용 SP 없음, AS-IS 는 GET_SHIPMENT_PSI_COMMENTS 재사용(SSP0015.cs L4695, main btnCd).
  //   useTabProcQuery 는 typed sheet SP 전용이라 custom btnCd 는 apiClient 직결(memo 조회와 동일 경로).
  const { data: whInPlanData } = useQuery({
    queryKey: [tabId, 'whInPlanDetail', filters[SHEETS.WH_IN_PLAN_DETAIL]],
    queryFn: async () => {
      const res = await apiClient.post(
        `/${MENU_ID}/${SHEETS.MAIN}/${COMMENTS_BTN.GET}/call-proc`,
        filters[SHEETS.WH_IN_PLAN_DETAIL]
      );
      return (res.data?.result as { o_rc1?: WijmoRowItem[] }) ?? {};
    },
    enabled: !!filters[SHEETS.WH_IN_PLAN_DETAIL],
  });

  const calendarRows = useMemo(() => calendarData?.o_rc1 ?? [], [calendarData]);
  // 기간 컬럼 순서(SP 컬럼 순서) — 주/월 합계 계산 기준
  const periodBindings = useMemo(
    () =>
      calendarRows
        .map(r => ({ b: str(r.COLUMN_NAME), s: str(r.SORT_ORDER_NO) }))
        .filter(x => /^[DWMB]_/.test(x.b))
        .sort((a, b) => a.s.localeCompare(b.s))
        .map(x => x.b),
    [calendarRows]
  );
  // Main 시트만 화면에서 주/월 합계를 계산한다(AS-IS FindData_Main 의 CalculateSum). Packer 는 SP 값 그대로.
  const mainRows = useMemo<MainRow[]>(
    () =>
      mainSheet === 'packer'
        ? ((isPackerPast ? (packerPastData?.o_rc1 ?? []) : (packerData?.o_rc1 ?? [])) as MainRow[])
        : applyMainSums((mainData?.o_rc1 ?? []), periodBindings),
    [mainSheet, isPackerPast, mainData, packerData, packerPastData, periodBindings]
  );
  // 합계 미적용 원본(pull 버전) 보존
  // const mainRows = useMemo<MainRow[]>(
  //   () =>
  //     (mainSheet === 'packer'
  //       ? isPackerPast
  //         ? (packerPastData?.o_rc1 ?? [])
  //         : (packerData?.o_rc1 ?? [])
  //       : (mainData?.o_rc1 ?? [])) as MainRow[],
  //   [mainSheet, isPackerPast, mainData, packerData, packerPastData]
  // );

  const rowsBySheet = useMemo(
    () => ({
      [SHEETS.CONFIRM_DETAIL]:
        mainSheet === 'packer'
          ? (confirmPackerData?.o_rc1 ?? [])
          : ((confirmData?.o_rc1 ?? []) as WijmoRowItem[]),
      [SHEETS.WH_STOCK]: (whStockData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.HOLD_STOCK]: (holdStockData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.MES_STOCK]: (mesStockData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.SCS_STOCK]: (scsStockData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.STOCK_LOCATION_DETAIL]: (stockLocData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.SHIPMENT_RESULT]: (resultData?.o_rc1 ?? []) as WijmoRowItem[],
      // 서브 detail — 부모 SP 2번째 커서(O_RC2). 전용 GET SP 없음(AS-IS도 동일, .cs L3820).
      [SHEETS.WH_STOCK_DETAIL]:
        (whStockData as unknown as { o_rc2?: WijmoRowItem[] })?.o_rc2 ?? [],
      [SHEETS.HOLD_STOCK_DETAIL]:
        (holdStockData as unknown as { o_rc2?: WijmoRowItem[] })?.o_rc2 ?? [],
      // WH In Plan Detail — GET_SHIPMENT_PSI_COMMENTS o_rc1 (AS-IS FindData_WHinPlanDetail_btnSearch 재사용).
      [SHEETS.WH_IN_PLAN_DETAIL]: (whInPlanData?.o_rc1 ?? []),
    }),
    [
      mainSheet,
      confirmData,
      confirmPackerData,
      whStockData,
      holdStockData,
      mesStockData,
      scsStockData,
      stockLocData,
      resultData,
      whInPlanData,
    ]
  );

  // Confirm Detail 일부 컬럼은 상단 탭에 따라 가시성이 다르다(admin VISIBLE_FLAG 는 시트 단위라 탭별 표현 불가 →
  //   탭 의존 가시성만 코드 override). Packer 에서 숨김:
  //   - ERP_SO_NO(SO No): AS-IS SetSoNoColumnVisible(SSP0015.cs L9707) — Packer→숨김 / Mobility&IT→표시.
  //   - TRANSPORT_MODE(Trans Mode): Packer 에서는 미사용(사용자 지시 2026-10-02) — Mobility&IT 는 유지.
  // const detailStaticColumns = useMemo(() => {
  //   if (mainSheet !== 'packer') return staticColumns;
  //   const cd = staticColumns[SHEETS.CONFIRM_DETAIL];
  //   if (!cd) return staticColumns;
  //   const packerHidden = new Set(['ERP_SO_NO', 'TRANSPORT_MODE']);
  //   return {
  //     ...staticColumns,
  //     [SHEETS.CONFIRM_DETAIL]: cd.map(c =>
  //       packerHidden.has(c.colNm) ? { ...c, visible: false, display: false } : c
  //     ),
  //   };
  // }, [staticColumns, mainSheet]);
  // 수량 입력칸은 정수만 받는다(소수 0자리). Hold stock Amend Qty 는 AS-IS SetReNumerCellType 소수 0자리.
  const detailStaticColumns = useMemo(() => {
    const cd = staticColumns[SHEETS.CONFIRM_DETAIL];
    const hs = staticColumns[SHEETS.HOLD_STOCK];
    const packerHidden =
      mainSheet === 'packer' ? new Set(['ERP_SO_NO', 'TRANSPORT_MODE']) : new Set<string>();
    const asInteger = (c: RawFlexGridColumnConfig): RawFlexGridColumnConfig => ({
      ...c,
      cellCtrlObjTpCd: CELL_CONTROL_TYPE.NUMBER,
      scale: 0,
    });
    return {
      ...staticColumns,
      ...(cd && {
        [SHEETS.CONFIRM_DETAIL]: cd.map(c => {
          if (packerHidden.has(c.colNm)) return { ...c, visible: false, display: false };
          return c.colNm === 'SHIPMENT_CONFIRM_QTY' ? asInteger(c) : c;
        }),
      }),
      ...(hs && {
        [SHEETS.HOLD_STOCK]: hs.map(c => (c.colNm === 'HOLD_QTY' ? asInteger(c) : c)),
      }),
    };
  }, [staticColumns, mainSheet]);

  // ── master(PSI) 저장 mutation — call-proc 이 '^'-폴딩 단일 객체를 받는 특수 형태라 useProcMutation
  //   (배열 {data:[]}) 규약과 달라 useMutation 으로 직접 배선한다. mutationKey 를 [tabId,...] 로 두어
  //   MDIContainer 의 useIsBusy([activeTabId]) 공통 로딩 스피너가 저장 중에도 뜨게 한다(raw apiClient.post
  //   는 react-query 밖이라 스피너 미표시였음 — 사용자 지시 2026-09-30). ──
  const { mutate: mutateMainSave, isPending: mainSaving } = useMutation({
    mutationKey: [tabId, SHEETS.MAIN, 'SAVE'],
    mutationFn: async (payload: MainSaveFolded) => {
      const res = await apiClient.post(`/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`, payload);
      if (res.status >= 400 || Number(res.data?.code)) {
        throw new Error(t(MSG.SAVE_FAILED, '__Save failed.'));
      }
      return res.data;
    },
    onSuccess: () => {
      mainEditTrackerRef.current?.clearChanges();
      setToast({ type: 'success', message: t(MSG.SAVED, '__Saved successfully.') });
      if (mainSheet === 'packer') void (isPackerPast ? refetchPackerPast() : refetchPacker());
      else void refetchMain();
    },
    onError: (error: Error) => {
      void setAlert({ type: 'alert', content: error.message || t(MSG.SAVE_FAILED, '__Save failed.') });
    },
  });

  // ── 저장 mutation (Confirm Detail — SAVE_SHIPMENT_REQUEST_CONFIRM_40) ──
  //   proc 가 '^'-폴딩 단일 객체를 받는 특수형태(파라미터 전건 VARCHAR → BE 미폴딩)라 useProcMutation
  //   (배열 {data:[]}) 규약과 달라 useMutation 으로 직접 배선한다(master 저장과 동일 — 배열 전송은 미저장 사고).
  const { mutateAsync: mutateConfirmAsync } = useMutation({
    mutationKey: [tabId, SHEETS.CONFIRM_DETAIL, 'SAVE'],
    mutationFn: async (payload: ConfirmSaveFolded) => {
      // 상단 탭에 따라 저장 SP 분기 — Mobility&IT: confirmDetail/SAVE(_40), Packer: main/SAVE_..._CONFIRM_PACKER.
      //   (AS-IS SaveData_Detail_Packer). 폴딩 payload 는 공유(packer 는 shiptoCode 추가 — collectConfirmSaveRows).
      const endpoint =
        mainSheet === 'packer'
          ? `/${MENU_ID}/${SHEETS.MAIN}/SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER/call-proc`
          : `/${MENU_ID}/${SHEETS.CONFIRM_DETAIL}/SAVE/call-proc`;
      const res = await apiClient.post(endpoint, payload);
      if (res.status >= 400 || Number(res.data?.code)) {
        throw new Error(t(MSG.SAVE_FAILED, '__Save failed.'));
      }
      // 프로시저 업무결과 검사 — HTTP 200·code:0 이어도 SP 가 예외를 내부 캐치해 커밋 없이
      //   o_rc1 RESULT_CODE!='S'(F/X) + ERR_MESSAGE 로 돌려줄 수 있다(미저장인데 성공으로 오인 방지).
      //   예: ORA-01400 PLAN_START_YYYYMMDD NULL → RESULT_CODE='F'. 이때 throw → onError 알럿, 성공 토스트 미표시.
      const rc = (
        res.data?.result as {
          o_rc1?: { RESULT_CODE?: unknown; ERR_MESSAGE?: unknown }[];
          o_rc2?: { ERR_MESSAGE?: unknown }[];
        }
      )?.o_rc1?.[0];
      const resultCode = str(rc?.RESULT_CODE);
      if (resultCode && resultCode !== 'S') {
        const errMsg =
          str(rc?.ERR_MESSAGE) ||
          str(
            (res.data?.result as { o_rc2?: { ERR_MESSAGE?: unknown }[] })?.o_rc2?.[0]?.ERR_MESSAGE
          );
        throw new Error(errMsg || t(MSG.SAVE_FAILED, '__Save failed.'));
      }
      return res.data;
    },
    onSuccess: () => {
      confirmEditTrackerRef.current?.clearChanges();
      setToast({ type: 'success', message: t(MSG.SAVED, '__Saved successfully.') });
      setDetailFilter(SHEETS.CONFIRM_DETAIL, 'N');
    },
    onError: (error: Error) => {
      void setAlert({ type: 'alert', content: error.message || t(MSG.SAVE_FAILED, '__Save failed.') });
    },
  });
  // Hold stock 저장 (SAVE_BLOCK_STOCK_DATA — SP 배포 확인, 03 §4 / iter-1 I03) ──
  // const { mutate: mutateHold } = useProcMutation<MENU_ID, SHEETS.HOLD_STOCK>({
  //   menuId: MENU_ID,
  //   sheetName: SHEETS.HOLD_STOCK,
  //   tabId,
  //   onSuccess: () => {
  //     holdStockEditTrackerRef.current?.clearChanges();
  //     setToast({ type: 'success', message: t(MSG.SAVED, '__Saved successfully.') });
  //     setDetailFilter(SHEETS.HOLD_STOCK, 'N');
  //   },
  // });
  // proc 가 '^'-폴딩 단일 객체를 받는다. 행 배열로 보내면 0건 처리 후 성공만 반환해 저장되지 않는다.
  const { mutate: mutateHold, isPending: holdSaving } = useMutation({
    mutationKey: [tabId, SHEETS.HOLD_STOCK, 'SAVE'],
    mutationFn: async (payload: HoldSaveFolded) => {
      const res = await apiClient.post(`/${MENU_ID}/${SHEETS.HOLD_STOCK}/SAVE/call-proc`, payload);
      if (res.status >= 400 || Number(res.data?.code)) {
        throw new Error(t(MSG.SAVE_FAILED, '__Save failed.'));
      }
      // HTTP 200 이어도 proc 가 RESULT_CODE='F' 로 실패를 돌려줄 수 있다.
      const result = res.data?.result as {
        o_rc1?: { RESULT_CODE?: unknown }[];
        o_rc2?: { ERR_MESSAGE?: unknown }[];
      };
      const resultCode = str(result?.o_rc1?.[0]?.RESULT_CODE);
      if (resultCode && resultCode !== 'S') {
        throw new Error(str(result?.o_rc2?.[0]?.ERR_MESSAGE) || t(MSG.SAVE_FAILED, '__Save failed.'));
      }
      return res.data;
    },
    onSuccess: () => {
      holdStockEditTrackerRef.current?.clearChanges();
      setToast({ type: 'success', message: t(MSG.SAVED, '__Saved successfully.') });
      // 조회조건이 그대로면 필터를 다시 넣어도 재조회되지 않아 직접 다시 읽는다.
      if (filters[SHEETS.HOLD_STOCK]) void refetchHoldStock();
      else setDetailFilter(SHEETS.HOLD_STOCK, 'N');
    },
    onError: (error: Error) => {
      void setAlert({ type: 'alert', content: error.message || t(MSG.SAVE_FAILED, '__Save failed.') });
    },
  });
  // MES Stock 저장 (SAVE_MES_STOCK — SP 배포 확인, 03 §4 / iter-1 I03) ──
  const { mutate: mutateMes } = useProcMutation<MENU_ID, SHEETS.MES_STOCK>({
    menuId: MENU_ID,
    sheetName: SHEETS.MES_STOCK,
    tabId,
    onSuccess: () => {
      mesStockEditTrackerRef.current?.clearChanges();
      setToast({ type: 'success', message: t(MSG.SAVED, '__Saved successfully.') });
      setDetailFilter(SHEETS.MES_STOCK, 'N');
    },
  });

  // ── mount — 개인화 조회조건 복원(SubTitle F6 저장분, 1회). GET /admin/menu/SSP0015/search-conditions
  //   → searchCondition 패치. 형제 화면 파리티(종전 미배선 → 저장만 되고 복원 안 되던 것 해소). ──
  useEffect(() => {
    void restoreSearchConditions();
  }, [restoreSearchConditions]);

  // ── mount — keep-alive 잔여 filters 무효화 + 컬럼/Measure 메타 1회 fetch ──
  useEffect(() => {
    clearFilters();
    // Result Type 기본 = 시트별 상위 2개(AS-IS). persist 로 비어 있으면 채운다(기존 세션 대비).
    if (sc.resultTypes.length === 0) {
      set({
        resultTypes: [
          ...(mainSheet === 'packer' ? RESULT_TYPE_BY_SHEET.PACKER : RESULT_TYPE_BY_SHEET.MAIN),
        ].slice(0, 2),
      });
    }
    if (!initialized) {
      void fetchStaticMeasures(SHEETS.MAIN);
      void fetchStaticMeasures(SHEETS.MAIN_PACKER);
    }
    // 컬럼 헤더 — master + 전 detail 탭. detail 탭은 항상 보이므로 조회 전에도 헤더가 뜨게 mount 에서 로드
    //   (기존 lazy: handleDetailSearch 시에만 받아 조회 전 헤더 공백이던 것 개선). 데이터는 각 GET SP /
    //   부모 o_rc2(WH stock/Hold stock Detail) / WH_IN 드릴다운(WH In Plan Detail).
    void fetchStaticColumns([
      SHEETS.MAIN,
      SHEETS.MAIN_PACKER,
      SHEETS.CONFIRM_DETAIL,
      SHEETS.WH_STOCK,
      SHEETS.WH_STOCK_DETAIL,
      SHEETS.HOLD_STOCK,
      SHEETS.HOLD_STOCK_DETAIL,
      SHEETS.MES_STOCK,
      SHEETS.WH_IN_PLAN_DETAIL,
      SHEETS.SCS_STOCK,
      SHEETS.STOCK_LOCATION_DETAIL,
      SHEETS.SHIPMENT_RESULT,
    ]);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // ── Find (F5 — 활성시트 분기, 01 R4) ──
  const runMainSearch = () => {
    setMainFilters();
    void fetchStaticColumns([mainSheet === 'packer' ? SHEETS.MAIN_PACKER : SHEETS.MAIN]);
  };

  // 기간 검증 — AS-IS DateUtil.Check_PeriodDate (SSP0015.cs: 메인 drpPeriod L2188/2307/2426,
  //   detail drpPeriod2 L3307/3570/4544). 공백 → MSG00665 / from>to → MSG00108 / 최대범위 초과 → MSG01187.
  //   최대범위: From Date + 1캘린더연 + 7일(윤년 2/29 포함 구간이면 실경계 372~373일 — 고정 371 가산보다
  //   관대, AS-IS DateUtil.cs:122~140 동일). 메시지 인자 {0} 만 AS-IS 문구대로 371 유지. true=통과.
  const validatePeriodRange = (from: string, to: string): boolean => {
    if (!from || !to) {
      void setAlert({ type: 'alert', content: t(MSG.PERIOD_EMPTY, '__Please enter the search period.') });
      return false;
    }
    if (from > to) {
      void setAlert({ type: 'alert', content: t(MSG.PERIOD_ORDER, '__Invalid period (start > end).') });
      return false;
    }
    const toDayYmd = (ymd: string) =>
      dayjs(`${ymd.slice(0, 4)}-${ymd.slice(4, 6)}-${ymd.slice(6, 8)}`);
    const limit = toDayYmd(from).add(1, 'year').add(7, 'day').format('YYYYMMDD');
    if (to >= limit) {
      void setAlert({
        type: 'alert',
        content: t(MSG.PERIOD_MAX, '__Maximum Period is From Date + {0}.').replace(
          '{0}',
          String(MAX_PERIOD_LABEL_DAYS)
        ),
      });
      return false;
    }
    return true;
  };

  const handleSearch = () => {
    // 필수 (Plan Date* / Period*)
    if (!sc.planDate || !sc.periodFrom) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_FIELDS, '__Please enter the required fields.'),
      });
      return;
    }
    // 기간 검증(drpPeriod)
    if (!validatePeriodRange(sc.periodFrom, sc.periodTo)) return;
    const hasUnsaved =
      mainEditTrackerRef.current?.hasChanges() === true ||
      confirmEditTrackerRef.current?.hasChanges() === true ||
      holdStockEditTrackerRef.current?.hasChanges() === true ||
      mesStockEditTrackerRef.current?.hasChanges() === true;
    if (hasUnsaved) {
      void setAlert({
        type: 'confirm',
        content: t(MSG.NO_MODIFICATION, '__There are unsaved changes. Search again?'),
        onConfirm: runMainSearch,
      });
      return;
    }
    runMainSearch();
  };

  // ── Detail Search (2차 btnSearch — 활성 sheet 재조회) ──
  const handleDetailSearch = () => {
    // 기간 검증(drpPeriod2) — AS-IS Check_PeriodDate(drpPeriod2) (SSP0015.cs L3307/3570/4544).
    if (!validatePeriodRange(sc.period2From, sc.period2To)) return;
    // W/H stock Detail / Hold stock Detail 는 전용 SP 가 없고 부모(WH_STOCK/HOLD_STOCK) SP 의 O_RC2 가 소스다
    //   (P_SSP0015_GET_WH_STOCK·GET_BLOCK_STOCK 둘 다 O_RC1=본체/O_RC2=detail, DB 실측). 따라서 detail 탭
    //   Search 는 부모 시트 filter 를 켜야 쿼리가 돌아 o_rc2 가 채워진다(그전엔 filters[detail] 만 세팅돼 미조회).
    const querySheet =
      activeDetailSheet === SHEETS.WH_STOCK_DETAIL
        ? SHEETS.WH_STOCK
        : activeDetailSheet === SHEETS.HOLD_STOCK_DETAIL
          ? SHEETS.HOLD_STOCK
          : activeDetailSheet;
    setDetailFilter(querySheet, 'N');
    void fetchStaticColumns([activeDetailSheet]);
  };

  // ── master 기간셀 더블클릭 드릴다운 (design 03 §3.F) ──
  const handleMainDrilldown = (row: MainRow) => {
    const sheet = measureDrilldownOf(str(row.MEASURE));
    if (!sheet) return;
    const overrides = { itemId: str(row.ITEM_ID), fromSite: str(row.FROM_SITE) };
    setActiveDetailSheet(sheet);
    setDetailFilter(sheet, 'Y', overrides);
    void fetchStaticColumns([sheet]);
  };

  // ── BOH 'FIGURE' 열 더블클릭 드릴 (AS-IS SpdMain_CellDoubleClick L8109-8173) ──
  //   TYPE=Hold 행(MES_FCS_RELEASE)→Hold stock, WH_STOCK/BALANCE→Stock Detail. 행 PLAN_TYPE/SEQ 를
  //   overrides 로 전달(AS-IS FindData_block_stock sPlanType/sSeq 파리티).
  const handleFigureDrilldown = (row: MainRow) => {
    const sheet = figureDrilldownOf(str(row.MEASURE));
    if (!sheet) return;
    const overrides = {
      itemId: str(row.ITEM_ID),
      fromSite: str(row.FROM_SITE),
      planType: str(row.PLAN_TYPE),
      seq: str(row.SEQ),
    };
    setActiveDetailSheet(sheet);
    setDetailFilter(sheet, 'Y', overrides);
    void fetchStaticColumns([sheet]);
  };

  // ── Save (F7 — 활성 그리드/시트 분기, 01 R8 / 03 §4) ──
  const handleSave = async () => {
    // R7b — 비최신(이전) Plan 이면 저장 차단 + MSG01185 (AS-IS EditButton MSG00170 cs L1767). canEdit=false(R7a/권한)
    //   인 경우는 이미 읽기전용 + MSG01261 안내라 여기선 old-plan 만 명시 안내한다(셀 편집은 읽기전용으로 조용히 차단).
    if (canEdit && !isLatestPlan) {
      void setAlert({ type: 'alert', content: t(MSG.OLD_PLAN_EDIT_BLOCK, '__A previous Plan cannot be edited.') });
      return;
    }
    if (activeGrid === 'main') {
      if (!canEditPlan) return; // 이전 Plan(비최신)·EDIT 권한 없음 → master 저장 차단(R7b)
      const rows = (mainGridRef.current?.collectionView?.sourceCollection ??
        []) as Record<string, unknown>[];
      const dayCols = calendarRows
        .map(r => str(r.COLUMN_NAME))
        .filter(b => b.startsWith('D_'))
        .sort();
      const tracker = mainEditTrackerRef.current;
      const { payload, negatives } = collectMainSaveRows(
        rows,
        dayCols,
        row => tracker?.getOriginalValues().get(row as WijmoRowItem),
        {
          divisionId: FIXED_DIVISION,
          planStartYyyymmdd: sc.planDate,
          userId: session.userId ?? '',
        }
      );
      if (negatives.length > 0) {
        void setAlert({
          type: 'alert',
          content: t(MSG.NEGATIVE_QTY, '__Quantity must be 0 or greater.'),
        });
        return;
      }
      if (!payload) {
        setToast({
          type: 'error',
          message: t(MSG.NO_MODIFICATION, '__No modifications have been made.'),
        });
        return;
      }
      if (mainSaving) return; // 중복 제출 방지(mutation 진행 중)
      mutateMainSave(payload); // 성공/실패·재조회·공통 로딩은 mutation 이 담당
      return;
    }

    // Detail 저장 — 이전 Plan(비최신)·EDIT 권한 없음이면 차단(R7b 확장, master 와 동일 — 사용자 지시 2026-10-01)
    if (!canEditPlan) return;

    // Detail 저장 — 활성 sheet 분기
    if (activeDetailSheet === SHEETS.CONFIRM_DETAIL) {
      const rows = (confirmGridRef.current?.collectionView?.sourceCollection ??
        []) as Record<string, unknown>[];
      const dirty = rows.filter(r => str(r.EDIT_MAIN) === 'Y' || str(r.CRUD_TYPE));
      if (dirty.length === 0) {
        setToast({
          type: 'error',
          message: t(MSG.NO_MODIFICATION, '__No modifications have been made.'),
        });
        return;
      }
      // 행별 필수 검증 (design 03 §0-1/§4 — 라벨 `*` 컬럼 빈값 차단. INPUT_TP_CD 전건 'S'라
      //   useSaveWithValidation 메타 판정 불가 → 라벨 `*`(Shipment Qty*/Shipment Date*/Trans Mode*)
      //   기준 명시 차단으로 재현. iter-1 I01 — SCP0020 필수검증 누락 실사고 계열).
      for (const row of dirty) {
        if (str(row.CRUD_TYPE) === 'D') continue; // 삭제행은 필수검증 제외
        // Shipment Qty* — 빈값/비숫자 차단 (라벨 * 필수)
        const qtyRaw = row.SHIPMENT_CONFIRM_QTY;
        if (qtyRaw === '' || qtyRaw === null || qtyRaw === undefined || Number.isNaN(Number(qtyRaw))) {
          void setAlert({
            type: 'alert',
            content: t(MSG.REQUIRED_VALUE, '__{0} value is required.\', 0: \'Shipment Qty'),
          });
          return;
        }
        // Shipment Date* — 빈값 차단 (라벨 * 필수)
        if (str(row.SHIPMENT_DATE).trim() === '') {
          void setAlert({
            type: 'alert',
            content: t(MSG.REQUIRED_VALUE, '__{0} value is required.\', 0: \'Shipment Date'),
          });
          return;
        }
        // Shipment Date 형식 검증 (AS-IS GetERPInterface L6498 DateTime.TryParse → MSG00049 / TO-BE MSG01081).
        //   유효하지 않은 날짜면 차단. 빈값은 위에서 이미 처리.
        if (!dayjs(str(row.SHIPMENT_DATE)).isValid()) {
          void setAlert({
            type: 'alert',
            content: t(MSG.INVALID_DATE_FORMAT, '__This is not a valid date format.'),
          });
          return;
        }
        if (str(row.TRANSPORT_MODE).trim() === '') {
          void setAlert({
            type: 'alert',
            content: t(MSG.REQUIRED_VALUE, '__{0} value is required.\', 0: \'Trans Mode'),
          });
          return;
        }
        // Change Reason 미입력 → AS-IS([C20200630-000480], Validation_Check L6277~6289)는 블로킹 얼럿을
        //   주석처리하고 'T07'(외부 요인) 기본값으로 자동 설정한 뒤 진행한다. 얼럿 미이식(그대로 저장).
        const reason = str(row.CHANGE_REASON_CODE).trim();
        if (reason === '' || reason === '-') {
          row.CHANGE_REASON_CODE = 'T07';
        }
      }
      // AS-IS SaveData_Detail_Packer(SSP0015.cs L5403~)는 저장 전 확인창이 없다 — 검증 통과 즉시 저장.
      //   전환 초기의 MSG01201 confirm 은 AS-IS MSG00324(저장결과 'X' BOD/Trans/Incoterms 무효 사후 안내,
      //   L5592)를 확인창으로 오인한 것이라 제거(AS-IS 소스에 MSG01201·confirm 자체가 없음, 2026-10-01 실측).
      //   proc 는 컬럼별 '^'-폴딩 단일 객체를 받는다(배열 전송은 전건 null → 미저장, 2026-10-01 실측).
      const confirmPayload = collectConfirmSaveRows(dirty, session.userId ?? '');
      if (!confirmPayload) {
        setToast({ type: 'error', message: t(MSG.NO_MODIFICATION, '__No modifications have been made.') });
        return;
      }
      // AS-IS GetERPInterface 첫 게이트 — GetShipmentStatusChk(SSP0015.cs L6541). 변경행의 기존 CONFIRM_ID
      //   (신규 'I'/'-' 제외)와 DIVISION 을 '^'-폴딩해 GET_SHIPMENT_STATUS 호출(SP 양 파라미터 FN_STRING_SPLIT '^',
      //   1회 배치). 3 커서 중 하나라도 있으면 저장 차단(AS-IS 002xx → TO-BE 012xx 역매핑, SCM_ADM_MSG_M 실측):
      //   o_rc1=다른 사용자 변경요청(MSG01258)·o_rc2=삭제 Qty:0(MSG01259)·o_rc3=ERP DO 생성 ERP_STATUS='C'(MSG01202).
      const statusRows = dirty.filter(r => {
        const id = str(r.CONFIRM_ID).trim();
        return id !== '' && id !== '-';
      });
      if (statusRows.length > 0) {
        const statusConfirmIds = Array.from(new Set(statusRows.map(r => str(r.CONFIRM_ID).trim())));
        const statusDivisions = Array.from(
          new Set(statusRows.map(r => str(r.DIVISION_ID).trim()).filter(Boolean))
        );
        const idList = (cur?: { CONFIRM_ID?: unknown }[]) =>
          Array.from(new Set((cur ?? []).map(c => str(c.CONFIRM_ID).trim()).filter(Boolean))).join(', ');
        try {
          const st = await apiClient.post(
            `/${MENU_ID}/${SHEETS.MAIN}/GET_SHIPMENT_STATUS/call-proc`,
            { divisionId: statusDivisions.join('^'), confirmId: statusConfirmIds.join('^') }
          );
          // 비정상 응답(403 권한·5xx 등)은 업무차단이 아니라 시스템 오류 — 저장실패로 구분.
          if (st.status >= 400 || Number(st.data?.code)) {
            void setAlert({ type: 'alert', content: t(MSG.SAVE_FAILED, '__Save failed.') });
            return;
          }
          const sr = st.data?.result as
            | {
                o_rc1?: { CONFIRM_ID?: unknown }[];
                o_rc2?: { CONFIRM_ID?: unknown }[];
                o_rc3?: { CONFIRM_ID?: unknown }[];
              }
            | undefined;
          if (sr?.o_rc1?.length) {
            void setAlert({
              type: 'alert',
              content: t(
                MSG.STATUS_OTHER_USER_REQUEST,
                '__A Confirm ID for which another user requested a shipment plan change exists.'
              ).replace('{0}', idList(sr.o_rc1)),
            });
            return;
          }
          if (sr?.o_rc2?.length) {
            void setAlert({
              type: 'alert',
              content: t(
                MSG.STATUS_DELETED_QTY0,
                '__A deleted (Qty:0) Confirm ID exists. Please re-search for the latest information and try again.'
              ).replace('{0}', idList(sr.o_rc2)),
            });
            return;
          }
          if (sr?.o_rc3?.length) {
            void setAlert({
              type: 'alert',
              content: t(
                MSG.STATUS_ERP_DO_CREATED,
                '__In ERP, a DO has been created and the change cannot be requested.'
              ).replace('{0}', idList(sr.o_rc3)),
            });
            return;
          }
        } catch {
          void setAlert({ type: 'alert', content: t(MSG.SAVE_FAILED, '__Save failed.') });
          return;
        }
      }
      // AS-IS GetERPInterface(SSP0015.cs L6478~6495) ERP SO No 건수 체크 — 변경행에 ERP_SO_NO 가 있으면
      //   DB 건수(GET_ERP_SO_NO_CNT) 와 화면에 조회된 동일 SO 행수가 같아야 한다(같은 SO 는 전건이 한 화면에
      //   조회돼야 SO 단위 일괄변경 가능). 다르면 MSG00247 로 차단. (ERP outbound 호출은 제외 — I02.)
      const confirmRows = (confirmGridRef.current?.collectionView?.sourceCollection ??
        []) as Record<string, unknown>[];
      const dirtyErpSoNos = Array.from(
        new Set(dirty.map(r => str(r.ERP_SO_NO).trim()).filter(Boolean))
      );
      for (const soNo of dirtyErpSoNos) {
        const divisionId = str(dirty.find(r => str(r.ERP_SO_NO).trim() === soNo)?.DIVISION_ID);
        let dbCnt = -1;
        try {
          const r = await apiClient.post(
            `/${MENU_ID}/${SHEETS.MAIN}/GET_ERP_SO_NO_CNT/call-proc`,
            { divisionId, erpSoNo: soNo }
          );
          if (r.status >= 400 || Number(r.data?.code)) {
            void setAlert({ type: 'alert', content: t(MSG.SAVE_FAILED, '__Save failed.') });
            return;
          }
          dbCnt = Number(
            (r.data?.result as { o_rc1?: { CNT?: unknown }[] })?.o_rc1?.[0]?.CNT ?? -1
          );
        } catch {
          void setAlert({ type: 'alert', content: t(MSG.SAVE_FAILED, '__Save failed.') });
          return;
        }
        const sheetCnt = confirmRows.filter(r => str(r.ERP_SO_NO).trim() === soNo).length;
        if (dbCnt !== sheetCnt) {
          void setAlert({ type: 'alert', content: t(MSG.SO_NO_COUNT_MISMATCH, '__Another item created with the same SO number exists.') });
          return;
        }
      }
      // AS-IS GetERPInterface(SSP0015.cs L6509~) 저장 전 Confirm 변경시각 체크 — 변경행의 기존 CONFIRM_ID
      //   (신규 'I'/'-' 제외)를 '^'-폴딩해 SCM_SSP_CHECK_CONFIRM_CHANGETIME 호출. 'S' 만 통과, 그 외(X: 최근
      //   2분 이내 변경 / F: 에러)는 MSG01395 로 저장 차단(AS-IS isResult!='S' → MSG00404 동치). 양 탭 공통.
      const confirmIds = Array.from(
        new Set(dirty.map(r => str(r.CONFIRM_ID).trim()).filter(id => id !== '' && id !== '-'))
      );
      if (confirmIds.length > 0) {
        let changeTimeCode = '';
        try {
          const chk = await apiClient.post(
            `/${MENU_ID}/${SHEETS.MAIN}/CHECK_CONFIRM_CHANGETIME/call-proc`,
            { confirmId: confirmIds.join('^') }
          );
          // 비정상 응답(403 권한·5xx 등)은 lock 이 아니라 시스템 오류 — MSG01395 오인 방지(저장실패로 구분).
          if (chk.status >= 400 || Number(chk.data?.code)) {
            void setAlert({ type: 'alert', content: t(MSG.SAVE_FAILED, '__Save failed.') });
            return;
          }
          changeTimeCode = str(
            (chk.data?.result as { o_rc1?: { RESULT_CODE?: unknown }[] })?.o_rc1?.[0]?.RESULT_CODE
          );
        } catch {
          void setAlert({ type: 'alert', content: t(MSG.SAVE_FAILED, '__Save failed.') });
          return;
        }
        if (changeTimeCode !== 'S') {
          void setAlert({
            type: 'alert',
            content: t(MSG.CONFIRM_CHANGETIME_LOCK, '__Due to ERP I/F, changes can be made after 2 minutes of previous work.'),
          });
          return;
        }
      }
      // 저장 → (성공 시) ERP I/F 호출. AS-IS GetERPInterface→SoNo/NonSoNo→GetErpIFCheck 흐름의 TO-BE 배선.
      //   저장 proc O_RC1 이 성공 시 RESULT_CODE='S' + CHANGE_REQ_NO 반환(PKG_SSP0015 L7350) → 그 번호로 IF 호출.
      //   현재는 mock(/call-test) — 실서비스(UIC0001.asmx) 완성 시 '/call' 로 교체(코드 동일).
      let saveData: unknown;
      try {
        saveData = await mutateConfirmAsync(confirmPayload); // 실패 시 throw → onError alert
      } catch {
        return;
      }
      const o1 = (
        saveData as { result?: { o_rc1?: { RESULT_CODE?: unknown; CHANGE_REQ_NO?: unknown }[] } }
      )?.result?.o_rc1?.[0];
      if (str(o1?.RESULT_CODE) === 'X') return; // 저장 결과 'X'(업무 실패)면 IF 생략.
      // CHANGE_REQ_NO — 저장 proc 가 반환하면 사용. 현 success 경로는 RESULT_CODE/RESULT_CNT 만 반환하므로
      //   실서비스 연계 전까지는 변경행 CONFIRM_ID 로 대체(mock 은 번호값 무시). 실서비스 시 proc 가
      //   CHANGE_REQ_NO 를 반환하도록 BE 보강 필요(I02).
      const changeReqNo = str(o1?.CHANGE_REQ_NO) || confirmIds[0] || str(dirty[0]?.CONFIRM_ID);
      if (!changeReqNo) return;
      try {
        // TODO: 실서비스 완성 시 '/common/web-service/erpIf/call' 로 교체
        const erp = await apiClient.post('/common/web-service/erpIf/call-test', {
          CHANGE_REQ_NO: changeReqNo,
          CHANGE_TYPE: 'C',
          SHIPMENT_STATUS: '',
        });
        // BE 가 XML 을 파싱해 { E_TYPE, E_MESSAGE } Map 으로 돌려준다(result).
        //   AS-IS GetErpIFCheck: 성공(S)은 별도 메시지 없이 진행(저장완료 토스트로 충분) — 에러만 알린다.
        //   E/F/C_E → AS-IS MSG00197/204/306(ReErrorMsg 포함). 현재는 전달된 E_MESSAGE 를 노출(코드 매핑은 후속).
        const erpResult = erp.data?.result as { E_TYPE?: unknown; E_MESSAGE?: unknown } | null;
        const eType = str(erpResult?.E_TYPE);
        const eMsg = str(erpResult?.E_MESSAGE);
        if (eType && eType !== 'S') {
          void setAlert({ type: 'alert', content: eMsg || t(MSG.SAVE_FAILED, '__ERP interface failed.') });
        }
      } catch {
        // IF 호출 실패 — 저장은 이미 완료됨. 안내만(후속 재전송/배치 처리는 I02 오케스트레이션 범위).
        void setAlert({ type: 'alert', content: t(MSG.SAVE_FAILED, '__ERP interface call failed.') });
      }
      return;
    }

    // Hold stock 저장 (SAVE_BLOCK_STOCK_DATA — iter-1 I03) ──
    if (activeDetailSheet === SHEETS.HOLD_STOCK) {
      const rows = (holdStockGridRef.current?.collectionView?.sourceCollection ??
        []) as Record<string, unknown>[];
      const dirty = rows.filter(r => str(r.CRUD_TYPE));
      if (dirty.length === 0) {
        setToast({
          type: 'error',
          message: t(MSG.NO_MODIFICATION, '__No modifications have been made.'),
        });
        return;
      }
      // 날짜 형식과 시작/종료 순서 검증 (AS-IS Convert.ToDateTime, checkValidN MSG00219).
      for (const row of dirty) {
        const holdYmd = toValidYmd(row.HOLD_YYYYMMDD);
        const releaseYmd = toValidYmd(row.RELEASE_YYYYMMDD);
        if (!holdYmd || !releaseYmd) {
          void setAlert({
            type: 'alert',
            content: t(MSG.INVALID_DATE_FORMAT, '__This is not a valid date format.'),
          });
          return;
        }
        if (holdYmd > releaseYmd) {
          void setAlert({
            type: 'alert',
            content: t(MSG.PERIOD_ORDER, '__Invalid period (start > end).'),
          });
          return;
        }
      }
      // plan 3종은 master 활성행 값. 활성행이 없으면 조회조건 Plan Date 와 화면 고정값(SP/1)을 쓴다.
      const mg = mainGridRef.current;
      const activeMain = mg
        ? (GridUtils.getRow(mg, mg.selection?.row ?? -1) as MainRow | undefined)
        : undefined;
      const holdPayload = collectHoldSaveRows(dirty, {
        planStartYyyymmdd: str(activeMain?.PLAN_START_YYYYMMDD) || sc.planDate,
        planType: str(activeMain?.PLAN_TYPE) || 'SP',
        seq: str(activeMain?.SEQ) || '1',
        userId: session.userId ?? '',
      });
      if (!holdPayload) return;
      if (holdSaving) return; // 중복 제출 방지
      mutateHold(holdPayload);
      // mutateHold(dirty as unknown as HoldStockRow[]);
      return;
    }

    // MES Stock 저장 (SAVE_MES_STOCK — iter-1 I03) ──
    if (activeDetailSheet === SHEETS.MES_STOCK) {
      const rows = (mesStockGridRef.current?.collectionView?.sourceCollection ??
        []) as Record<string, unknown>[];
      const dirty = rows.filter(r => str(r.EDIT_MAIN) === 'Y' || str(r.CRUD_TYPE));
      if (dirty.length === 0) {
        setToast({
          type: 'error',
          message: t(MSG.NO_MODIFICATION, '__No modifications have been made.'),
        });
        return;
      }
      mutateMes(dirty as unknown as ResponseData<MENU_ID, SHEETS.MES_STOCK, 'o_rc1'>[]);
      return;
    }
    // 그 외 읽기전용 시트 — 저장 대상 아님(조용히 무시).
  };

  // ── Insert (F8 — Hold stock 신규행. 03 §3.A L7645 — 값 원본 = master 활성행) ──
  //   AS-IS: spdDetail + shtBolckStock + 신규행일 때만 동작. 그 외 무동작(가드).
  const handleInsert = () => {
    if (!canEditPlan) return; // 이전 Plan(비최신)·EDIT 권한 없음 → Detail 편집 차단(R7b 확장)
    // Confirm Detail - 선택한 확정(Status C) 행을 복사한 분할 행 추가 (AS-IS InsertRow L7651~7801).
    //   수량은 0, Remarks 와 ERP Status 는 빈 값, 나머지는 원본 행 그대로다.
    if (activeDetailSheet === SHEETS.CONFIRM_DETAIL) {
      const cg = confirmGridRef.current;
      if (!cg || cg.rows.length === 0) return;
      const src = GridUtils.getRow(cg, cg.selection?.row ?? -1) as WijmoRowItem | undefined;
      if (!src || str(src.SHIPMENT_STATUS) !== 'C') return;
      GridAction.addRow(
        cg,
        {
          ...src,
          CRUD_TYPE: 'I',
          SHIPMENT_CONFIRM_QTY: 0,
          REMARKS: '',
          ERP_STATUS: '',
        } as WijmoRowItem,
        'above',
        true
      );
      return;
    }
    // if (activeDetailSheet !== SHEETS.HOLD_STOCK) return; // AS-IS Insert 가드(Hold stock 한정, 01 R5)
    if (activeDetailSheet !== SHEETS.HOLD_STOCK) return;
    // 신규행 값 원본 = siMain 활성행 (Detail 자신 아님 — design 03 §3.A L7645). 활성행 없으면 조용히 중단
    //   (복사원본 없이 빈 행 생성 금지, convert-core §2.4 — 미조회 상태 삽입 결함).
    const g = mainGridRef.current;
    const mainRow = g ? (GridUtils.getRow(g, g.selection?.row ?? -1) as MainRow | undefined) : undefined;
    if (!mainRow) return;
    const target = holdStockGridRef.current;
    if (!target) return;
    // 식별열은 master 활성행 복사, HOLD_YYYYMMDD=cboPlanDate.Text(오늘 Plan). 편집열은 초기값.
    GridAction.addRow(
      target,
      {
        CRUD_TYPE: 'I',
        DIVISION_ID: str(mainRow.DIVISION_ID),
        FROM_SITE: str(mainRow.FROM_SITE),
        FROM_SITE_NM: str(mainRow.FROM_SITE_NM),
        ITEM_ID: str(mainRow.ITEM_ID),
        NICK_NAME: str(mainRow.NICK_NAME),
        // HOLD_YYYYMMDD: sc.planDate,
        // 조회된 행과 같은 YYYY-MM-DD 표기로 넣는다.
        HOLD_YYYYMMDD: `${sc.planDate.slice(0, 4)}-${sc.planDate.slice(4, 6)}-${sc.planDate.slice(6, 8)}`,
        RELEASE_YYYYMMDD: '',
        HOLD_QTY: 0,
        REMARKS: '',
      } as WijmoRowItem,
      'above',
      true
    );
  };

  // ── Delete (F9 — AS-IS: spdDetail + shtBolckStock + 신규행('I')일 때만. 그 외 무동작, 01 R6) ──
  const handleDelete = () => {
    if (!canEditPlan) return; // 이전 Plan(비최신)·EDIT 권한 없음 → Detail 편집 차단(R7b 확장)
    if (activeDetailSheet !== SHEETS.HOLD_STOCK) return; // 가드 — 그 외 무동작
    // deleteOnlyNew=true → 미저장 신규행('I')만 제거(기존행은 삭제 안 함 = AS-IS action=='I' 가드).
    const target = holdStockGridRef.current;
    if (!target) return;
    GridAction.removeRow(target, true);
  };

  // ── Measure (R2/R3 — master 활성일 때만 팝업. detail 이면 조용히 no-op) ──
  const handleMeasure = () => {
    if (activeGrid === 'detail') return;
    // 열 때 활성시트 measure 메타 최신화(initialized 가드로 mount 시 못 받은 경우 대비)
    void fetchStaticMeasures(mainSheet === 'packer' ? SHEETS.MAIN_PACKER : SHEETS.MAIN);
    setOpenMeasure(true);
  };

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') ? handleSave : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    manual: false,
    upload: false,
  };

  const customButtons = [
    {
      label: t(LBL.MEASURE, '_Measure'),
      title: t(LBL.MEASURE, '_Measure'),
      action: handleMeasure,
      iconComponent: <IcMeasureSelect />,
      buttonLabel: '',
    },
  ];

  const activeMainSheet = mainSheet === 'packer' ? SHEETS.MAIN_PACKER : SHEETS.MAIN;

  // ── Memo(우클릭 코멘트, 엑셀 메모형) — WH_IN 행 D_ 셀 ──
  //   조회 시 GET_SHIPMENT_PSI_COMMENTS 로 코멘트 로드 → (division,site,item,yyyymmdd) 매칭 맵 →
  //   그리드 인디케이터/툴팁 + 모달 프리필. 저장은 SAVE_SHIPMENT_PSI_COMMENTS(13 IN 단일 객체).
  const commentsFilters = useMemo(() => {
    const f = filters[activeMainSheet] as Record<string, string> | undefined;
    if (!f) return undefined;
    return {
      divisionId: f.divisionId ?? '',
      planStartYyyymmdd: f.planStartYyyymmdd ?? '',
      fromSite: f.fromSite ?? '',
      itemId: f.itemId ?? '',
      fromYyyymmdd: f.fromYyyymmdd ?? '',
      toYyyymmdd: f.toYyyymmdd ?? '',
    };
  }, [filters, activeMainSheet]);

  const { data: commentsData, refetch: refetchComments } = useQuery({
    queryKey: [tabId, 'psiComments', commentsFilters],
    queryFn: async () => {
      const res = await apiClient.post(
        `/${MENU_ID}/${SHEETS.MAIN}/${COMMENTS_BTN.GET}/call-proc`,
        commentsFilters
      );
      return (res.data?.result as { o_rc1?: Record<string, unknown>[] })?.o_rc1 ?? [];
    },
    enabled: !!commentsFilters,
  });

  const memoKey = (divisionId: string, fromSite: string, itemId: string, ymd: string): string =>
    `${divisionId}|${fromSite}|${itemId}|${ymd}`;

  const commentMap = useMemo(() => {
    const m = new Map<string, Record<string, unknown>>();
    (commentsData ?? []).forEach(r => {
      const key = memoKey(
        str(r.DIVISION_ID),
        str(r.SITE),
        str(r.ITEM_ID),
        str(r.YYYYMMDD).replace(/-/g, '')
      );
      m.set(key, r);
    });
    return m;
  }, [commentsData]);

  // Production(PROD_PLAN) 노트 — 표시전용 파란 마커/툴팁 (AS-IS SetProdNote_Display, 등록 없음).
  //   데이터 원천 = master SP(GET_SHIPMENT_PSI)의 3번째 커서 o_rc3(=AS-IS dtPROD_Note, PRODUCT_QTY).
  //   WH_IN 코멘트(별도 GET_SHIPMENT_PSI_COMMENTS)와 달리 별도 조회 없이 master 응답에 함께 온다.
  const prodNotes = useMemo<Record<string, unknown>[]>(() => {
    const d =
      mainSheet === 'packer' ? (isPackerPast ? packerPastData : packerData) : mainData;
    return (d as unknown as { o_rc3?: Record<string, unknown>[] })?.o_rc3 ?? [];
  }, [mainSheet, isPackerPast, mainData, packerData, packerPastData]);
  const prodNoteMap = useMemo(() => {
    const m = new Map<string, string>();
    prodNotes.forEach(n => {
      const key = memoKey(
        str(n.DIVISION_ID) || FIXED_DIVISION,
        str(n.SITE),
        str(n.ITEM_ID),
        str(n.YYYYMMDD).replace(/-/g, '')
      );
      m.set(key, str(n.PRODUCT_QTY));
    });
    return m;
  }, [prodNotes]);
  const prodNoteOf = useCallback(
    (row: MainRow, binding: string): string | undefined => {
      const q = prodNoteMap.get(
        memoKey(str(row.DIVISION_ID) || FIXED_DIVISION, str(row.FROM_SITE), str(row.ITEM_ID), binding.slice(2))
      );
      return q ? q : undefined;
    },
    [prodNoteMap]
  );

  // 그리드 메모 인디케이터/툴팁 — 코멘트 텍스트가 있을 때만.
  const memoOf = useCallback(
    (row: MainRow, binding: string): string | undefined => {
      const c = commentMap.get(
        memoKey(
          str(row.DIVISION_ID) || FIXED_DIVISION,
          str(row.FROM_SITE),
          str(row.ITEM_ID),
          binding.slice(2)
        )
      );
      const cm = c ? str(c.COMMENTS) : '';
      return cm || undefined;
    },
    [commentMap]
  );

  const [memoCtx, setMemoCtx] = useState<MemoContext | null>(null);

  const handleMemo = useCallback(
    (cell: { row: MainRow; binding: string; whInQty: string; prodQty: string }) => {
      const { row, binding, whInQty, prodQty } = cell;
      const yyyymmdd = binding.slice(2);
      const divisionId = str(row.DIVISION_ID) || FIXED_DIVISION;
      const fromSite = str(row.FROM_SITE);
      const itemId = str(row.ITEM_ID);
      const c = commentMap.get(memoKey(divisionId, fromSite, itemId, yyyymmdd));
      setMemoCtx({
        divisionId,
        planDate: sc.planDate,
        fromSite,
        fromSiteNm: str(row.FROM_SITE_NM),
        itemId,
        nickName: str(row.NICK_NAME),
        yyyymmdd,
        measure: 'WH_IN',
        planType: str(row.PLAN_TYPE) || 'SP',
        seq: str(row.SEQ) || '1',
        whInQty,
        prodQty,
        beforeQty: c ? str(c.BEFORE_QTY) : '0',
        gapQty: c ? str(c.GAP) : '0',
        currentQty: c ? str(c.QTY) : whInQty,
        comments: c ? str(c.COMMENTS) : '',
      });
    },
    [commentMap, sc.planDate]
  );

  // Memo 저장 — SAVE_SHIPMENT_PSI_COMMENTS(13 IN 단일 객체, '^' 폴딩 없음). 성공 시 코멘트·master 재조회.
  const { mutate: mutateMemo } = useMutation({
    mutationKey: [tabId, SHEETS.MAIN, COMMENTS_BTN.SAVE],
    mutationFn: async (payload: Record<string, string>) => {
      const res = await apiClient.post(
        `/${MENU_ID}/${SHEETS.MAIN}/${COMMENTS_BTN.SAVE}/call-proc`,
        payload
      );
      if (res.status >= 400 || Number(res.data?.code)) {
        throw new Error(t(MSG.SAVE_FAILED, '__Save failed.'));
      }
      return res.data;
    },
    onSuccess: () => {
      setToast({ type: 'success', message: t(MSG.SAVED, '__Saved successfully.') });
      void refetchComments();
      if (mainSheet === 'packer') void (isPackerPast ? refetchPackerPast() : refetchPacker());
      else void refetchMain();
    },
    onError: (error: Error) => {
      void setAlert({ type: 'alert', content: error.message || t(MSG.SAVE_FAILED, '__Save failed.') });
    },
  });

  const handleMemoSave = (input: MemoSaveInput) => {
    if (!memoCtx) return;
    mutateMemo({
      changeFlag: input.changed ? 'Y' : 'N',
      divisionId: memoCtx.divisionId,
      fromSite: memoCtx.fromSite,
      itemId: memoCtx.itemId,
      planStartYyyymmdd: memoCtx.planDate,
      yyyymmdd: memoCtx.yyyymmdd,
      planType: memoCtx.planType,
      seq: memoCtx.seq,
      measure: memoCtx.measure,
      qty: input.changeQty,
      prodQty: memoCtx.prodQty || '0',
      comments: input.comments,
      userId: session.userId ?? '',
    });
    setMemoCtx(null);
  };

  // 상단 master 그리드 — AS-IS spdMain 2 시트 탭(Mobility & IT / Packer) 재현. 단일 그리드 +
  //   mainSheet 데이터 스왑 유지(탭 전환 = setMainSheet, Plant Site/PlanDate/ResultType 조회축 초기화는 store).
  const mainGridEl = (
    <ShipmentPsiMainGrid
      rows={mainRows}
      calendar={calendarRows}
      gridRef={mainGridRef}
      gridFilterRef={mainGridFilterRef}
      editTrackerRef={mainEditTrackerRef}
      adminColumns={staticColumns[activeMainSheet]}
      bucketType={sc.bucketType}
      chkSum={sc.chkSum}
      editable={canEditPlan}
      planDate={sc.planDate}
      onDrilldown={handleMainDrilldown}
      onFigureDrilldown={handleFigureDrilldown}
      prodNoteOf={prodNoteOf}
      memoOf={memoOf}
      onMemo={handleMemo}
    />
  );

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <ShipmentPsiForm onSearch={handleSearch} onItemSearch={() => setOpenItemMain(true)} />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={mainGridRef}
        gridFilter={mainGridFilterRef}
        dataCount={mainRows.length}
        excelFileName='ShipmentPlanMobilityIt'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />

      {/* splitContainer1 — Master(상) / Detail(하) 수직 분할 (01 §1). 경계를 드래그해 상하 크기 조절 */}
      <div className={styles.gridArea}>
        <PanelGroup className={styles.panelGroup} orientation='vertical'>
          <Panel defaultSize='55%' minSize='15%'>
            {/* spdMain — 2 시트 탭(Mobility & IT / Packer). AS-IS FpSpread ActiveSheet 등가(01 §1 / R4) */}
            <div className={styles.mainGrid}>
              {/* 탭은 헤더(시트 전환)만 담당 — 그리드는 탭 밖 단일 인스턴스로 렌더해 전환 시 remount/ref 충돌 방지.
                  (기존: {mainGridEl} 을 두 TabItem 에 중복 → 조회 후 탭 전환 시 그리드 remount 크래시.)
                  헤더 래퍼를 헤더 높이로 고정해 TabWrapper 빈 content 영역이 공간을 먹지 않게 한다. */}
              <div className={styles.mainTabs}>
                <TabWrapper
                  activeTabIndex={mainSheet === 'packer' ? 1 : 0}
                  setActiveTabIndex={index => setMainSheet(index === 1 ? 'packer' : 'main')}
                >
                  <TabItem key='main' label={ADMIN_SHEET_NAME[SHEETS.MAIN] ?? ''} />
                  <TabItem key='packer' label={ADMIN_SHEET_NAME[SHEETS.MAIN_PACKER] ?? ''} />
                </TabWrapper>
              </div>
              <div className={styles.mainGridBody}>{mainGridEl}</div>
            </div>
          </Panel>

          <PanelSeparator className={styles.splitBar} />

          <Panel defaultSize='45%' minSize='15%'>
            <div className={styles.detailArea}>
              <ShipmentPsiDetailBar
                onDetailSearch={handleDetailSearch}
                onModelSearch={() => setOpenItemDetail(true)}
                onRequestorSearch={() => setOpenRequestor(true)}
              />
              <ShipmentPsiDetailGrid
                rowsBySheet={rowsBySheet}
                gridRefs={{
                  [SHEETS.CONFIRM_DETAIL]: confirmGridRef,
                  [SHEETS.WH_STOCK]: whStockGridRef,
                  [SHEETS.HOLD_STOCK]: holdStockGridRef,
                  [SHEETS.MES_STOCK]: mesStockGridRef,
                  [SHEETS.SCS_STOCK]: scsStockGridRef,
                  [SHEETS.STOCK_LOCATION_DETAIL]: stockLocGridRef,
                  [SHEETS.SHIPMENT_RESULT]: resultGridRef,
                }}
                gridFilterRefs={{
                  [SHEETS.CONFIRM_DETAIL]: confirmGridFilterRef,
                  [SHEETS.WH_STOCK]: whStockGridFilterRef,
                  [SHEETS.HOLD_STOCK]: holdStockGridFilterRef,
                  [SHEETS.MES_STOCK]: mesStockGridFilterRef,
                  [SHEETS.SCS_STOCK]: scsStockGridFilterRef,
                  [SHEETS.STOCK_LOCATION_DETAIL]: stockLocGridFilterRef,
                  [SHEETS.SHIPMENT_RESULT]: resultGridFilterRef,
                }}
                editTrackerRefs={{
                  [SHEETS.CONFIRM_DETAIL]: confirmEditTrackerRef,
                  [SHEETS.HOLD_STOCK]: holdStockEditTrackerRef,
                  [SHEETS.MES_STOCK]: mesStockEditTrackerRef,
                }}
                staticColumns={detailStaticColumns}
                editable={canEditPlan}
                onConfirmDetail={setReqDraftingNo}
                onOrderDetail={setOrderDetailCtx}
              />
            </div>
          </Panel>
        </PanelGroup>
      </div>

      {/* 1차 Model/Nickname 팝업 (btnItemId) — 공용 MaterialByDivisionModal(COM0013)로 교체(사용자 지시 2026-10-13).
          AS-IS SCM0002_ItembyDivisionPopup 과 조회 SP 가 달라지는 의도적 변경(자매 SSP 화면과 동일). */}
      <MaterialByDivisionModal
        open={openItemMain}
        modalClose={() => setOpenItemMain(false)}
        setSelectedValue={itemId => set({ itemId: str(itemId) })}
        preSearchParams={{
          divisionId: FIXED_DIVISION,
          scpModuleType: MENU_ID,
          operationGroup: '',
          itemId: sc.itemId,
        }}
      />
      {/* 종전 1차 Item 팝업(ModelByDivisionPopup)
      <ModelByDivisionPopup
        open={openItemMain}
        onClose={() => setOpenItemMain(false)}
        onSelect={selected => set({ itemId: str(selected.itemId) })}
        params={{ divisionId: FIXED_DIVISION, itemId: sc.itemId }}
      />
      */}

      {/* 2차 Model 팝업 (btnItemID2 — ModelByDivisionPopup) */}
      <ModelByDivisionPopup
        open={openItemDetail}
        onClose={() => setOpenItemDetail(false)}
        onSelect={selected => set({ model: str(selected.itemId) })}
        params={{ divisionId: FIXED_DIVISION, itemId: sc.model }}
      />

      {/* Measure 선택 (R3 — btnMeasure) — MeasureSelectModal + titleSet 'M' 저장 → 활성시트 재조회 */}
      <MeasureSelectModal
        open={openMeasure}
        modalClose={() => setOpenMeasure(false)}
        measures={staticMeasures[activeMainSheet] ?? []}
        visibleMeasures={visibleMeasures[activeMainSheet] ?? null}
        onApply={codes => {
          setOpenMeasure(false);
          applyVisibleMeasures(activeMainSheet, codes);
          const all = (staticMeasures[activeMainSheet] ?? []).map(m => m.colNm);
          const selected = codes ?? all;
          void saveTitleSet({
            menuId: MENU_ID,
            sheetName: ADMIN_SHEET_NAME[activeMainSheet] ?? '',
            columnType: TITLESET_MEASURE_TYPE,
            rows: selected.map((name, i) => ({ name, sortOrderNo: i + 1 })),
          }).then(ok => {
            if (!ok) {
              void setAlert({
                type: 'alert',
                content: t(MSG.SAVE_FAILED, '__Save failed.'),
              });
              return;
            }
            void fetchStaticMeasures(activeMainSheet);
            if (mainSheet === 'packer' && filters[SHEETS.MAIN_PACKER]) void (isPackerPast ? refetchPackerPast() : refetchPacker());
            else if (filters[SHEETS.MAIN]) void refetchMain();
          });
        }}
      />

      {/* Requestor 검색 (btnRequestor) — 공용 SsoUserModal (AS-IS SSP0002_UserInfoPopup).
          선택 → requestorId(UserID) + requestorName(언어별 KO/EN 표시명) 세팅. */}
      <SsoUserModal
        open={openRequestor}
        modalClose={() => setOpenRequestor(false)}
        initialUser={sc.requestorId}
        setSelectedValue={(userId, userNm, userEngNm) => {
          set({
            requestorId: userId,
            requestorName: (session.langCd === 'KO' ? userNm : userEngNm) || userId,
          });
          setOpenRequestor(false);
        }}
        ssoUserYn='N'
      />

      {/* Memo(우클릭 코멘트) — WH_IN 행 D_ 셀. AS-IS SSP0015_ShipmentPSICommentsPopup 이식 */}
      <ShipmentPsiMemoModal
        open={!!memoCtx}
        data={memoCtx}
        onClose={() => setMemoCtx(null)}
        onSave={handleMemoSave}
      />
      <ShipmentOrderDetailModal
        open={!!orderDetailCtx}
        data={orderDetailCtx}
        onClose={() => setOrderDetailCtx(null)}
      />

      {/* CHANGE_REQ_NO 셀 클릭 → 변경요청 상세(Drafting) 팝업 (I13, AS-IS SCM0002_ShipmentPlanRequestPopup) */}
      <ShipmentChangeRequestDraftingModal
        open={!!reqDraftingNo}
        changeReqNo={reqDraftingNo}
        onClose={() => setReqDraftingNo('')}
      />
    </>
  );
};
