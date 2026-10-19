import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import {
  ItemByDivisionModal,
  MaterialByDivisionModal,
  ProjectByDivisionModal,
} from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQuery } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import { GridAction, GridUtils } from '@foundation/utils';
import { MainTitle, saveTitleSet, SubTitle } from '@shared/components';
import { useProcMutation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { MeasureSelectModal } from './components/modals/MeasureSelectModal';
import { OrderDetailModal, type OrderDetailContext } from './components/modals/OrderDetailModal';
import { RequestorModal } from './components/modals/RequestorModal';
import { ShipmentPlanAutoEssDetailBar } from './components/ShipmentPlanAutoEssDetailBar';
import { ShipmentPlanAutoEssDetailGrid } from './components/ShipmentPlanAutoEssDetailGrid';
import { ShipmentPlanAutoEssForm } from './components/ShipmentPlanAutoEssForm';
import { ShipmentPlanAutoEssMainGrid } from './components/ShipmentPlanAutoEssMainGrid';
import {
  ADMIN_SHEET_NAME,
  LBL,
  MENU_ID,
  MSG,
  PLAN_DETAIL_INSERT_COPY_COLUMNS,
  SHEETS,
  TITLESET_MEASURE_TYPE,
  USER_CHECK_BTN,
} from './shipment-plan-auto-ess.constants';
import type { MainRow, PlanDetailRow } from './shipment-plan-auto-ess.types';
import styles from './ShipmentPlanAutoEss.module.scss';
import { useShipmentPlanAutoEssStore } from './useShipmentPlanAutoEssStore';
import { BOH_DRILLDOWN, measureDrilldownOf } from './utils/shipment-plan-auto-ess.detailSheets';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// AS-IS GSCM.SSP.Plan.UIL SSP0021_ShipmentPlan (Shipment Plan) — 신규 전환(2026-09-27).
//   설계: .atlas/gscm-design/SSP0021/design/00~03. 매핑: __asis-mapping__.md. 자매 SSP0060 패턴 준용.
//   툴바: Find/Save/Insert=실동작, Delete=NO-OP `() => undefined`(design 01 §2 — 노출 유지, false·키생략 금지),
//   Edit=미이식(convert-core §2.4 — 편집 기본 ON, canEdit=hasButton('EDIT')).
//   저장 = Detail Confirm 만(design 01 §2 SaveData_Detail / 03 §4.1) — Main SHIP_PLAN 편집은 Simulation 입력.
//   주의: Drafting 3경로 ERP IF 체인·Hold stock 편집은 SP 미배포 — 04_react-gap.md "확인 필요/SP 후속" 참조.
export const ShipmentPlanAutoEss = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  // ── refs (Main + Detail 7-sheet) ──
  const mainGridRef = useRef<FlexGridType>();
  const mainGridFilterRef = useRef<FlexGridFilter>();
  const mainEditTrackerRef = useRef<EditTracker>();
  const planDetailGridRef = useRef<FlexGridType>();
  const planDetailGridFilterRef = useRef<FlexGridFilter>();
  const planDetailEditTrackerRef = useRef<EditTracker>();
  const stockDetailGridRef = useRef<FlexGridType>();
  const stockDetailGridFilterRef = useRef<FlexGridFilter>();
  const owmsDetailGridRef = useRef<FlexGridType>();
  const owmsDetailGridFilterRef = useRef<FlexGridFilter>();
  const holdStockGridRef = useRef<FlexGridType>();
  const holdStockGridFilterRef = useRef<FlexGridFilter>();
  const mesStockGridRef = useRef<FlexGridType>();
  const mesStockGridFilterRef = useRef<FlexGridFilter>();
  const mesStockDetailGridRef = useRef<FlexGridType>();
  const mesStockDetailGridFilterRef = useRef<FlexGridFilter>();
  const shipmentResultGridRef = useRef<FlexGridType>();
  const shipmentResultGridFilterRef = useRef<FlexGridFilter>();

  // ── store ──
  const sc = useShipmentPlanAutoEssStore(s => s.searchCondition);
  const set = useShipmentPlanAutoEssStore(s => s.setSearchCondition);
  const filters = useShipmentPlanAutoEssStore(s => s.filters);
  const setMainFilters = useShipmentPlanAutoEssStore(s => s.setMainFilters);
  const setDetailFilter = useShipmentPlanAutoEssStore(s => s.setDetailFilter);
  const clearFilters = useShipmentPlanAutoEssStore(s => s.clearFilters);
  const restoreSearchConditions = useShipmentPlanAutoEssStore(s => s.restoreSearchConditions);
  const openSearchArea = useShipmentPlanAutoEssStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentPlanAutoEssStore(s => s.setOpenSearchArea);
  const realFlag = useShipmentPlanAutoEssStore(s => s.realFlag);
  const activeGrid = useShipmentPlanAutoEssStore(s => s.activeGrid);
  const activeDetailSheet = useShipmentPlanAutoEssStore(s => s.activeDetailSheet);
  const setActiveDetailSheet = useShipmentPlanAutoEssStore(s => s.setActiveDetailSheet);
  const staticColumns = useShipmentPlanAutoEssStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentPlanAutoEssStore(s => s.fetchStaticColumns);
  const staticMeasures = useShipmentPlanAutoEssStore(s => s.staticMeasures);
  const fetchStaticMeasures = useShipmentPlanAutoEssStore(s => s.fetchStaticMeasures);
  const visibleMeasures = useShipmentPlanAutoEssStore(s => s.visibleMeasures);
  const applyVisibleMeasures = useShipmentPlanAutoEssStore(s => s.applyVisibleMeasures);
  const initialized = useShipmentPlanAutoEssStore(s => s.initialized);

  const session = useSessionStore(st => st.session);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // R7a(Edit 진입 가드① — 자매 SSP0060 에서 이식) — AS-IS EditButton 첫 가드:
  //   `bool isOK = GetSSPUserCheck(); if (isOK == false) { GMessageBox("MSG00251", UserId); return; }`
  //   (SSP0021_ShipmentPlan.cs L2358~2368). GetSSPUserCheck(cs L5836~5858)은
  //   `SSP.SSP0002_GET_USER_INFO_LIST` 를 Search=UserId / Language / SSOUserYN='N' 로 호출해
  //   **0행이면 false**(= GSCM 미등록 사용자)다. 자매 SSP0060(cs L8011~8033)과 의미 동일하다.
  //   TO-BE 등가 = USER_CHECK call-proc(PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST).
  //   판정 전(undefined)에는 낙관적 허용 — 로드 중 불필요한 편집 차단을 만들지 않는다.
  //   비SSP 확정(false) 시에만 편집 차단 + 1회 알럿(AS-IS 는 Edit 클릭 시점 알럿이나, 편집 기본 ON
  //   전환(convert-core §2.4)에서는 클릭 시점이 없어 판정 완료 시점 1회로 옮긴다).
  const { data: sspUserCheck } = useQuery({
    queryKey: [tabId, 'sspUserCheck', session.userId],
    queryFn: async () => {
      try {
        const res = await apiClient.post(`/${MENU_ID}/${SHEETS.MAIN}/${USER_CHECK_BTN}/call-proc`, {
          userId: session.userId ?? '',
          language: session.langCd ?? '',
          ssoUserYn: 'N',
        });
        // 403 = USER_CHECK 버튼권한 없음 = 비SSP 사용자(@AuthCheck 차단)
        if (res.status >= 400 || Number(res.data?.code)) return false;
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
        content: t(
          MSG.NO_AUTHORITY,
          '__This user does not have permission to the SSP Planner.\n\rUser ID : {0}'
        ).replace('{0}', session.userId ?? ''),
      });
    }
  }, [sspUserCheck, t, session.userId, setAlert]);

  // 편집 가능 = 권한(canEdit = hasButton('EDIT'), 마운트 1회) · 최신 Plan(realFlag).
  //   AS-IS EditButton/SwitchLock '수정 모드' 토글은 이식하지 않는다(convert-core §2.4). 편집 기본 ON.
  //   R7a(isSspUser)는 권한 축이라 canEdit 에 합산한다 — AS-IS 가드① 과 동일하게 비SSP 는 전면 읽기전용.
  const canEdit = hasButton('EDIT') && isSspUser;
  // Main(PSI) 그리드는 **읽기전용**이다 — AS-IS 가 하드 차단한다(사용자 확인 2026-10-12).
  //   `SSP0021_ShipmentPlan.cs` EditButton() L2370~2375:
  //       if (fps.Name == "spdMain") {
  //           // jilee 231004
  //           MessageHelper.GMessageBox("MSG00109", null);   // "읽기 전용입니다."
  //           return;                                        // ← 무조건 return
  //           CanModelChange = false;                        // 이하 전부 도달 불가(死코드)
  //           if (bEdit_Auth == true) { ... LockRange(..., false) ... }
  //       }
  //   2023-10-04(jilee)에 들어간 무조건 return 이라 그 아래 `bEdit_Auth` 분기와 unlock 로직은
  //   전부 死코드다. 즉 **어떤 권한/그룹이어도 Main 은 편집 불가**이고, 이 화면은 조회성 화면이다.
  //   (design 03 §1.2 의 "Main SHIP_PLAN 편집 유일"·"편집 → Simulation → Detail Confirm 저장"은
  //    2023-10 차단 이전 기준의 낡은 기술이다.)
  //   Detail 은 그대로 둔다 — 같은 EditButton 의 else 분기(cs L2459~)가 spdDetail 에 대해
  //   `SwitchLock()` + LockColumn/LockRange 로 정상 편집을 연다. 차단은 spdMain 한정이다.
  const mainEditable = false;
  const detailEditable = canEdit && realFlag;

  // ── 모달 open state (페이지 소유) ──
  const [openItemMain, setOpenItemMain] = useState(false); // 1차 Model(btnItemId)
  const [openItemDetailBar, setOpenItemDetailBar] = useState(false); // 2차 Model(btnItemID2)
  const [openRequestor, setOpenRequestor] = useState(false);
  const [openMeasure, setOpenMeasure] = useState(false); // TitleSetForm(Measure — btnMeasure)
  const [cellPopupRow, setCellPopupRow] = useState<WijmoRowItem | null>(null);
  const [cellPopupKind, setCellPopupKind] = useState<'item' | 'project' | null>(null);
  // ERP Order Detail 팝업(SSP0300) — Shipment Plan Detail 의 ERP_SO_NO 더블클릭 컨텍스트.
  const [orderDetail, setOrderDetail] = useState<OrderDetailContext | null>(null);

  // ── 조회 (React Query — SSOT) ──
  const { data: mainData, refetch: refetchMain } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const { data: calendarData } = useTabProcQuery<MENU_ID, SHEETS.CALENDAR>({
    menuId: MENU_ID,
    sheetName: SHEETS.CALENDAR,
    tabId,
    filters: filters[SHEETS.CALENDAR],
    enabled: !!filters[SHEETS.CALENDAR],
  });
  const { data: planDetailData } = useTabProcQuery<MENU_ID, SHEETS.PLAN_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.PLAN_DETAIL,
    tabId,
    filters: filters[SHEETS.PLAN_DETAIL],
    enabled: !!filters[SHEETS.PLAN_DETAIL],
  });
  const { data: stockDetailData } = useTabProcQuery<MENU_ID, SHEETS.STOCK_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.STOCK_DETAIL,
    tabId,
    filters: filters[SHEETS.STOCK_DETAIL],
    enabled: !!filters[SHEETS.STOCK_DETAIL],
  });
  const { data: owmsDetailData } = useTabProcQuery<MENU_ID, SHEETS.OWMS_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.OWMS_DETAIL,
    tabId,
    filters: filters[SHEETS.OWMS_DETAIL],
    enabled: !!filters[SHEETS.OWMS_DETAIL],
  });
  const { data: holdStockData } = useTabProcQuery<MENU_ID, SHEETS.HOLD_STOCK>({
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
  const { data: mesStockDetailData } = useTabProcQuery<MENU_ID, SHEETS.MES_STOCK_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.MES_STOCK_DETAIL,
    tabId,
    filters: filters[SHEETS.MES_STOCK_DETAIL],
    enabled: !!filters[SHEETS.MES_STOCK_DETAIL],
  });
  const { data: shipmentResultData } = useTabProcQuery<MENU_ID, SHEETS.SHIPMENT_RESULT>({
    menuId: MENU_ID,
    sheetName: SHEETS.SHIPMENT_RESULT,
    tabId,
    filters: filters[SHEETS.SHIPMENT_RESULT],
    enabled: !!filters[SHEETS.SHIPMENT_RESULT],
  });

  const mainRows = useMemo<MainRow[]>(() => mainData?.o_rc1 ?? [], [mainData]);
  const calendarRows = useMemo(() => calendarData?.o_rc1 ?? [], [calendarData]);

  const rowsBySheet = useMemo(
    () => ({
      [SHEETS.PLAN_DETAIL]: (planDetailData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.STOCK_DETAIL]: (stockDetailData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.OWMS_DETAIL]: (owmsDetailData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.HOLD_STOCK]: (holdStockData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.MES_STOCK]: (mesStockData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.MES_STOCK_DETAIL]: (mesStockDetailData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.SHIPMENT_RESULT]: (shipmentResultData?.o_rc1 ?? []) as WijmoRowItem[],
    }),
    [
      planDetailData,
      stockDetailData,
      owmsDetailData,
      holdStockData,
      mesStockData,
      mesStockDetailData,
      shipmentResultData,
    ]
  );

  // ── 저장 — Detail Confirm 만(design 01 §2 SaveData_Detail / 03 §4.3) ──
  const { mutate: mutateConfirm } = useProcMutation<MENU_ID, SHEETS.PLAN_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.PLAN_DETAIL,
    tabId,
    onSuccess: () => {
      planDetailEditTrackerRef.current?.clearChanges();
      // 편집 기본 ON(convert-core §2.4) — 저장 후 조회모드 복귀 없음.
      setToast({ type: 'success', message: t(MSG.SAVED, '__Saved successfully.') });
      setDetailFilter(SHEETS.PLAN_DETAIL, 'N');
    },
  });

  // ── mount — SubTitle F6 저장 조회조건 복원(1회, conditionsRestored 가드) ──
  useEffect(() => {
    void restoreSearchConditions();
  }, [restoreSearchConditions]);

  // ── mount — keep-alive 잔여 filters 무효화 + 컬럼 메타 1회 fetch (np §5-7) ──
  useEffect(() => {
    clearFilters();
    if (!initialized) {
      void fetchStaticColumns([SHEETS.MAIN, SHEETS.PLAN_DETAIL]);
      void fetchStaticMeasures();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // ── Division/Company 변경 = 편집 상태 초기화 (np §5-5). filters 초기화는 store 가 수행 ──
  useEffect(() => {
    mainEditTrackerRef.current?.clearChanges();
    planDetailEditTrackerRef.current?.clearChanges();
  }, [sc.divisionId, sc.companyId]);

  // ── Find (F5 — FindData_Main) ──
  const runMainSearch = () => {
    setMainFilters();
    void fetchStaticColumns([SHEETS.MAIN]);
    void fetchStaticMeasures();
  };

  const handleSearch = () => {
    // 필수 4종 (design 02 §4.1 — Division*/Company*/Period*/Plan Date*)
    if (!sc.divisionId || !sc.companyId || !sc.planDate || !sc.periodFrom) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_FIELDS, '__Please enter the required fields.'),
      });
      return;
    }
    // 미저장 변경이 있으면 재조회 전 확인(MSG00703)
    const hasUnsaved =
      mainEditTrackerRef.current?.hasChanges() === true ||
      planDetailEditTrackerRef.current?.hasChanges() === true;
    if (hasUnsaved) {
      void setAlert({
        type: 'confirm',
        content: t(MSG.CONFIRM_RESEARCH_UNSAVED, {
          defaultValue: '_There are unsaved changes. Do you want to search again?',
        }),
        onConfirm: runMainSearch,
      });
      return;
    }
    runMainSearch();
  };

  // ── Detail Search (2차 btnSearch — 활성 sheet 재조회, hook #81 lazy) ──
  const handleDetailSearch = () => {
    setDetailFilter(activeDetailSheet, 'N');
    void fetchStaticColumns([activeDetailSheet]);
  };

  // ── Main 드릴다운 (design 03 §3.7 — BOH_TYPE / MEASURE 분기) ──
  const handleMainDrilldown = (row: MainRow, binding: string) => {
    const overrides = { itemId: str(row.ITEM_ID), fromSite: str(row.FROM_SITE) };
    if (binding === 'BOH_QTY' && str(row.BOH_TYPE) === 'MES') {
      // MES 는 MES Stock Detail + MES Stock 2-sheet 연속 조회, 활성 탭은 MES Stock (AS-IS L2062-2094)
      setDetailFilter(SHEETS.MES_STOCK_DETAIL, 'Y', overrides);
      setActiveDetailSheet(SHEETS.MES_STOCK);
      setDetailFilter(SHEETS.MES_STOCK, 'Y', overrides);
      void fetchStaticColumns([SHEETS.MES_STOCK_DETAIL, SHEETS.MES_STOCK]);
      return;
    }
    const sheet =
      binding === 'BOH_QTY' ? BOH_DRILLDOWN[str(row.BOH_TYPE)] : measureDrilldownOf(str(row.MEASURE));
    if (!sheet) return;
    setActiveDetailSheet(sheet);
    setDetailFilter(sheet, 'Y', overrides);
    void fetchStaticColumns([sheet]);
  };

  // ── Save (F7 — Detail Confirm 만. design 01 §2 SaveData_Detail) ──
  const handleSave = () => {
    // 활성 탭과 무관하게 Shipment Plan Detail 편집분을 Confirm 저장(AS-IS SaveData_Detail 은 shtPlanDetail 대상).
    if (!detailEditable) return; // 편집 불가면 조용히 무시 (AS-IS IsLock 가드)
    const rows = (planDetailGridRef.current?.collectionView?.sourceCollection ??
      []) as Record<string, unknown>[];
    const dirty = rows.filter(r => str(r.EDIT_MAIN) === 'Y' || str(r.CRUD_TYPE));
    if (dirty.length === 0) {
      // 변경 0건 저장 = toast(error) — modal alert 금지 (NSCM 표준)
      setToast({
        type: 'error',
        message: t(MSG.NO_MODIFICATION, '__No modifications have been made.'),
      });
      return;
    }
    // 행별 필수 (design 03 §3.3): TRANSPORT_MODE 공백 / CHANGE_REASON_CODE 미선택 차단
    for (const row of dirty) {
      if (str(row.TRANSPORT_MODE).trim() === '') {
        void setAlert({
          type: 'alert',
          content: t(MSG.REQUIRED_VALUE, '__{0} value is required.\', 0: \'Trans Mode'),
        });
        return;
      }
      const reason = str(row.CHANGE_REASON_CODE).trim();
      if (reason === '' || reason === '-') {
        void setAlert({
          type: 'alert',
          content: t(MSG.ROW_REASON_REQUIRED, {
            defaultValue: '_There is a shipment change. Please enter Change_Reason.',
          }),
        });
        return;
      }
    }
    // 확인창 (design 03 §4.3 — MSG01201)
    void setAlert({
      type: 'confirm',
      content: t(MSG.CONFIRM_SAVE, {
        defaultValue: '_Are you sure you want to confirm the shipping plan change requests?',
      }),
      onConfirm: () => {
        // payload = 그리드 행 그대로 — 컬럼↔SAVE 24 IN 매핑은 PROC_M(convert-sp 소관, 03 §4.3)
        mutateConfirm(dirty as unknown as PlanDetailRow[]);
      },
    });
  };

  // ── Insert (F8 — design 01 §2 InsertButton. shtPlanDetail 신규행. Hold stock 은 표시전용이라 미대상) ──
  const handleInsert = () => {
    if (!detailEditable) return; // AS-IS IsLock 가드 — 편집 기본 ON 이라 canEdit·최신Plan 판정
    if (activeDetailSheet !== SHEETS.PLAN_DETAIL) return; // 편집 시트 한정
    const g = planDetailGridRef.current;
    if (!g) return;
    const source = GridUtils.getRow(g, g.selection?.row ?? -1) as
      | Record<string, unknown>
      | undefined;
    if (!source) return; // 복사원본 없이 빈 행 생성 금지 (core §2.4 — 미조회 상태 삽입 결함)
    // 원본 행 STATUS 게이트 (AS-IS L2209/L2284 — RowCount>0 + SHIPMENT_STATUS!='C' return).
    //   공백도 != 'C' 라 삽입 차단(AS-IS 동일 — 공백을 'C' 로 승격하지 않는다, G10).
    const status = str(source.SHIPMENT_STATUS).trim();
    if (status !== 'C') return; // 'C' 아님(공백 포함) — 에러 없이 조용히 중단
    // 복사 필드는 AS-IS defaultData 명시 목록만 (전 필드 스프레드 복사 금지 — ERP_SO_NO/SHIPMENT_STATUS 제외)
    const copied: Record<string, unknown> = {};
    PLAN_DETAIL_INSERT_COPY_COLUMNS.forEach(col => {
      copied[col] = source[col];
    });
    copied.SHIPMENT_CONFIRM_QTY = 0; // 항상 0 강제
    copied.ERP_STATUS = ''; // 항상 공백 강제
    GridAction.addRow(g, { ...copied, CRUD_TYPE: 'I' } as WijmoRowItem, 'above', true);
  };

  // ── Measure (btnMeasure): spdMain 활성일 때만 팝업. spdDetail 이면 조용히 no-op (design 02 §4.6) ──
  const handleMeasure = () => {
    if (activeGrid === 'detail') return;
    setOpenMeasure(true);
  };

  // Simulation 재계산 핸들러 제거 — AS-IS 에서 Main 편집이 하드 차단(EditButton L2370~2375)이라
  //   입력 경로가 없고 버튼도 노출하지 않는다(아래 customButtons 주석). 재계산 본체는
  //   utils/shipment-plan-auto-ess.calc.ts `simulate` 에 그대로 남아 있다.
  // ── 그리드 셀 팝업 (design 03 §3.7 — 신규행 한정 + 필수값 MSG00013 가드) ──
  const openCellPopup = (kind: 'item' | 'project', row: WijmoRowItem) => {
    const division = str(row.DIVISION_ID);
    const fromSite = str(row.FROM_SITE);
    const toSite = str(row.TO_SITE);
    const required =
      kind === 'item' ? [division, fromSite, toSite] : [division, fromSite, toSite, str(row.ITEM_ID)];
    if (required.some(v => v.trim() === '')) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_FIELDS, '__Please enter the required fields.'),
      });
      return;
    }
    setCellPopupRow(row);
    setCellPopupKind(kind);
  };

  // ── hotkeyConfig (design 01 §2 확정값 — 재판단 금지) ──
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') ? handleSave : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    // Delete = NO-OP (AS-IS L2354-2356 빈 몸체) — 노출 유지 + 명시적 무동작. 키 생략·false 금지.
    delete: hasButton('DELETE') ? () => undefined : false,
    manual: false,
    upload: false,
  };

  const customButtons = [
    // Measure (btnMeasure — 아이콘 순서: GridColumnSet 없음 → Measure, hook #120)
    {
      label: t(LBL.MEASURE, '_Measure'),
      title: t(LBL.MEASURE, '_Measure'),
      action: handleMeasure,
      iconComponent: <IcMeasureSelect />,
      buttonLabel: '',
    },
    // Simulation 버튼은 노출하지 않는다 (사용자 지시 2026-10-12).
    //   AS-IS 에 버튼 자체는 있다 — `btnSimulation`(Designer) + `BtnSimulation_Click`(cs L1869) +
    //   `Simulation()`(cs L6053). 다만 Form_Load(cs L440~458)가 `PGM_AUTH_ID` 룩업에서
    //   CODE='SSP0021' AND NAME=NowGroupID 행을 찾아 `layoutControlItem12`(= btnSimulation 을 담은
    //   레이아웃 아이템, Designer L756) 의 Visibility 를 Always/Never 로 가른다.
    //   그 룩업에는 SSP0021 행이 **3개 있다**(ADMIN · SCM Viewer · SSP Planner — AS-IS/TO-BE DB 동일
    //   실측). 즉 SSP0060(행 0개 → 전원 비노출)과 달리 **특정 그룹에는 보인다.**
    //
    //   그럼에도 제거하는 이유: 같은 `bEdit_Auth` 게이트가 걸린 Main 편집이 EditButton L2370~2375 의
    //   무조건 return 으로 2023-10-04 부터 하드 차단됐다. Simulation 은 "Main SHIP_PLAN 을 고쳐
    //   재계산"하는 기능이라 입력 경로가 사라졌다 — 읽기전용 그리드 위에서 값만 흔드는 버튼이 된다.
    //   사용자 제공 AS-IS 캡처(2026-10-12)에도 툴바에 Simulation 이 없다.
    //   재계산 본체(utils/shipment-plan-auto-ess.calc.ts `simulate`)는 지우지 않는다 — 되살릴 때
    //   이 버튼 항목만 복구하면 된다.
  ];

  const cellPopupDivision = str(cellPopupRow?.DIVISION_ID);

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <ShipmentPlanAutoEssForm
          tabId={tabId}
          onSearch={handleSearch}
          onItemSearch={() => setOpenItemMain(true)}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={mainGridRef}
        gridFilter={mainGridFilterRef}
        dataCount={mainRows.length}
        excelFileName='ShipmentPlan'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />

      {/* splitContainer1 — Main(상) / Detail(하) 수직 분할 (design 01 §1) */}
      <div className={styles.gridArea}>
        <div className={styles.mainGrid}>
          <ShipmentPlanAutoEssMainGrid
            rows={mainRows}
            calendar={calendarRows}
            gridRef={mainGridRef}
            gridFilterRef={mainGridFilterRef}
            editTrackerRef={mainEditTrackerRef}
            adminColumns={staticColumns[SHEETS.MAIN]}
            staticMeasures={staticMeasures}
            bucketType={sc.bucketType}
            chkSum={sc.chkSum}
            editable={mainEditable}
            curPlanDate={sc.planDate}
            onDrilldown={handleMainDrilldown}
          />
        </div>

        <div className={styles.detailArea}>
          <ShipmentPlanAutoEssDetailBar
            onDetailSearch={handleDetailSearch}
            onModelSearch={() => setOpenItemDetailBar(true)}
            onRequestorSearch={() => setOpenRequestor(true)}
          />
          <ShipmentPlanAutoEssDetailGrid
            onOrderDetail={setOrderDetail}
            rowsBySheet={rowsBySheet}
            gridRefs={{
              [SHEETS.PLAN_DETAIL]: planDetailGridRef,
              [SHEETS.STOCK_DETAIL]: stockDetailGridRef,
              [SHEETS.OWMS_DETAIL]: owmsDetailGridRef,
              [SHEETS.HOLD_STOCK]: holdStockGridRef,
              [SHEETS.MES_STOCK]: mesStockGridRef,
              [SHEETS.MES_STOCK_DETAIL]: mesStockDetailGridRef,
              [SHEETS.SHIPMENT_RESULT]: shipmentResultGridRef,
            }}
            gridFilterRefs={{
              [SHEETS.PLAN_DETAIL]: planDetailGridFilterRef,
              [SHEETS.STOCK_DETAIL]: stockDetailGridFilterRef,
              [SHEETS.OWMS_DETAIL]: owmsDetailGridFilterRef,
              [SHEETS.HOLD_STOCK]: holdStockGridFilterRef,
              [SHEETS.MES_STOCK]: mesStockGridFilterRef,
              [SHEETS.MES_STOCK_DETAIL]: mesStockDetailGridFilterRef,
              [SHEETS.SHIPMENT_RESULT]: shipmentResultGridFilterRef,
            }}
            editTrackerRefs={{
              [SHEETS.PLAN_DETAIL]: planDetailEditTrackerRef,
            }}
            staticColumns={staticColumns}
            editable={detailEditable}
            onItemCellSearch={row => openCellPopup('item', row)}
            onProjectCellSearch={row => openCellPopup('project', row)}
          />
        </div>
      </div>

      {/* 1차·2차 Model/Nickname 팝업 — MaterialByDivisionModal(COM0013), 사용자 지시 2026-10-12.
          주의(의도적 AS-IS 이탈): AS-IS SSP0021 은 두 자리 모두 `SCM0002_ItembyDivisionPopup`
            (cs L988 btnItemId / L2499 셀)이고 그 TO-BE 대응은 `ModelByDivisionPopup`
            (SCM0002/ModelPopup → PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP)이다.
            자매 SSP0060·SSP0015 도 그걸 쓴다. COM0013 은 SP·그리드 컬럼이 다른 별개 팝업이라
            파리티 이탈이며, 사용자 결정으로 채택했다(__asis-mapping__ 해당 절 참조).
          주의(positional 계약): master 계약은 (itemId, itemName, itemClassName, **nickName**) —
            NickName 이 **4번째**다. 종전 ItemByDivisionModal 은 5인자라 자리가 다르다(아래 셀 팝업).
            자리를 잘못 받으면 모델 설명이 NICK_NAME 에 박힌다(자매 SSP0201 실제 사고). */}
      <MaterialByDivisionModal
        open={openItemMain}
        modalClose={() => setOpenItemMain(false)}
        setSelectedValue={itemId => set({ itemId: str(itemId) })}
        preSearchParams={{
          divisionId: sc.divisionId,
          scpModuleType: MENU_ID,
          operationGroup: '',
          itemId: sc.itemId,
        }}
      />

      {/* 2차 Model/Nickname 팝업 (btnItemID2 — 동일 컴포넌트, 대입 대상만 상이 — 02 §4.6) */}
      <MaterialByDivisionModal
        open={openItemDetailBar}
        modalClose={() => setOpenItemDetailBar(false)}
        setSelectedValue={itemId => set({ model: str(itemId) })}
        preSearchParams={{
          divisionId: sc.divisionId,
          scpModuleType: MENU_ID,
          operationGroup: '',
          itemId: sc.model,
        }}
      />

      {/* Detail 그리드 ITEM_ID 셀 팝업 (신규행 한정 — 03 §3.7) */}
      <ItemByDivisionModal
        open={cellPopupKind === 'item'}
        modalClose={() => setCellPopupKind(null)}
        setSelectedValue={(itemId, _itemName, _itemClassName, _itemType, nickName) => {
          if (cellPopupRow) {
            cellPopupRow.ITEM_ID = str(itemId);
            cellPopupRow.NICK_NAME = str(nickName);
            planDetailGridRef.current?.collectionView?.refresh();
          }
        }}
        preSearchParams={{ divisionId: cellPopupDivision, itemId: str(cellPopupRow?.ITEM_ID) }}
        callFromCell={true}
      />

      {/* Detail 그리드 PROJECT_CODE 셀 팝업 (신규행 한정 — 03 §3.7) */}
      <ProjectByDivisionModal
        open={cellPopupKind === 'project'}
        modalClose={() => setCellPopupKind(null)}
        setSelectedValue={(projects, projectsNames) => {
          if (cellPopupRow) {
            cellPopupRow.PROJECT_CODE = str(projects);
            cellPopupRow.PROJECT_NAME = str(projectsNames);
            planDetailGridRef.current?.collectionView?.refresh();
          }
        }}
        preSearchParams={{ divisionId: cellPopupDivision, projectCode: str(cellPopupRow?.PROJECT_CODE) }}
        callFromCell={true}
      />

      {/* Requestor 팝업 (UserInfoPopup — 02 §4.6) */}
      <RequestorModal
        open={openRequestor}
        modalClose={() => setOpenRequestor(false)}
        setSelectedValue={(userId, userName) => set({ requestorId: userId, requestorName: userName })}
      />

      {/* ERP Order Detail 팝업 (AS-IS SSP0300_OrderDetailPopup — cs L1591~1611) */}
      <OrderDetailModal
        open={orderDetail !== null}
        data={orderDetail}
        onClose={() => setOrderDetail(null)}
      />

      {/* Measure 설정 (btnMeasure — AS-IS TitleSetForm(Measure) = D00-1-005).
          종전에는 공용 ColumnSettingModal 에 columnType='M' 만 끼워 썼는데, 그 팝업의 조회 proc
          (DMF0002_GET_TITLESET_POPUP)은 목록 원천이 SCM_MST_SHEET_COLUMNS 라 Measure 를 못 내리고
          division 조건 때문에 SSP0021 에서도 0건이었다(실측 2026-10-12 — 자매 SSP0060 동일 결함).
          화면 전용 MeasureSelectModal + /measure 엔드포인트로 교체(상세 근거는 그 파일 주석). */}
      <MeasureSelectModal
        open={openMeasure}
        modalClose={() => setOpenMeasure(false)}
        measures={staticMeasures}
        visibleMeasures={visibleMeasures}
        onApply={codes => {
          applyVisibleMeasures(codes);
          // titleSet 'M' 영구 저장 → fetchStaticMeasures 로 display 플래그 갱신(MainGrid 게이트) +
          //   메인 재조회. 저장 proc 의 DELETE 는 타입별이라 컬럼('C') 개인화는 보존된다.
          void saveTitleSet({
            menuId: MENU_ID,
            sheetName: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? '',
            columnType: TITLESET_MEASURE_TYPE,
            rows: codes.map((name, i) => ({ name, sortOrderNo: i + 1 })),
          }).then(ok => {
            if (!ok) {
              void setAlert({ type: 'alert', content: t(MSG.SAVE_FAILED, '__Save failed.') });
              return;
            }
            void fetchStaticMeasures();
            if (activeGrid === 'main' && filters[SHEETS.MAIN]) void refetchMain();
          });
        }}
      />
    </>
  );
};
