import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MeasureSelectModal, ModelByDivisionPopup } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcMeasureSelect } from '@foundation/assets';
import dayjs from '@foundation/dayjs';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useMutation } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import { GridAction, GridUtils } from '@foundation/utils';
import { MainTitle, saveTitleSet, SsoUserModal, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useProcMutation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ShipmentPsiDetailBar } from './components/ShipmentPsiDetailBar';
import { ShipmentPsiDetailGrid } from './components/ShipmentPsiDetailGrid';
import { ShipmentPsiForm } from './components/ShipmentPsiForm';
import { ShipmentPsiMainGrid } from './components/ShipmentPsiMainGrid';
import {
  ADMIN_SHEET_NAME,
  FIXED_DIVISION,
  LBL,
  MENU_ID,
  MSG,
  RESULT_TYPE_BY_SHEET,
  SHEETS,
  TITLESET_MEASURE_TYPE,
} from './shipment-plan-mobility-it.constants';
import type { ConfirmDetailRow, HoldStockRow, MainRow } from './shipment-plan-mobility-it.types';
import styles from './ShipmentPlanMobilityIt.module.scss';
import { useShipmentPlanMobilityItStore } from './useShipmentPlanMobilityItStore';
import { measureDrilldownOf } from './utils/shipment-plan-mobility-it.detailSheets';
import { collectMainSaveRows, type MainSaveFolded } from './utils/shipment-plan-mobility-it.save';

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
  // 편집 기본 ON — canEdit = hasButton('EDIT') 마운트 1회(AS-IS EditButton 토글 미이식, convert-core §2.4).
  const canEdit = hasButton('EDIT');
  // R7b(이전 Plan 편집차단, MSG00170) — AS-IS oldPlanDate!=newPlanDate 는 spdMain 편집 가드다. 선택 Plan
  //   Date 가 최신(콤보 [0])이 아니면 master(PSI) 편집만 차단(알럿 없이 — 사용자 지시 2026-09-30). Detail
  //   시트는 자체 가드 유지. latestPlanDate 미확정('')·planDate 미선택이면 통과(로드 전 불필요 차단 방지).
  const isLatestPlan = !latestPlanDate || !sc.planDate || sc.planDate === latestPlanDate;
  const canEditMain = canEdit && isLatestPlan;

  // ── 모달 open state ──
  const [openItemMain, setOpenItemMain] = useState(false);
  const [openItemDetail, setOpenItemDetail] = useState(false);
  const [openMeasure, setOpenMeasure] = useState(false);
  const [openRequestor, setOpenRequestor] = useState(false);
  const [, setConfirmDetailNo] = useState('');

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
    enabled: !!filters[SHEETS.MAIN_PACKER],
  });
  const { data: calendarData } = useTabProcQuery<MENU_ID, SHEETS.CALENDAR>({
    menuId: MENU_ID,
    sheetName: SHEETS.CALENDAR,
    tabId,
    filters: filters[SHEETS.CALENDAR],
    enabled: !!filters[SHEETS.CALENDAR],
  });
  const { data: confirmData } = useTabProcQuery<MENU_ID, SHEETS.CONFIRM_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.CONFIRM_DETAIL,
    tabId,
    filters: filters[SHEETS.CONFIRM_DETAIL],
    enabled: !!filters[SHEETS.CONFIRM_DETAIL],
  });
  const { data: whStockData } = useTabProcQuery<MENU_ID, SHEETS.WH_STOCK>({
    menuId: MENU_ID,
    sheetName: SHEETS.WH_STOCK,
    tabId,
    filters: filters[SHEETS.WH_STOCK],
    enabled: !!filters[SHEETS.WH_STOCK],
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

  const mainRows = useMemo<MainRow[]>(
    () => (mainSheet === 'packer' ? (packerData?.o_rc1 ?? []) : (mainData?.o_rc1 ?? [])) as MainRow[],
    [mainSheet, mainData, packerData]
  );
  const calendarRows = useMemo(() => calendarData?.o_rc1 ?? [], [calendarData]);

  const rowsBySheet = useMemo(
    () => ({
      [SHEETS.CONFIRM_DETAIL]: (confirmData?.o_rc1 ?? []) as WijmoRowItem[],
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
      // WH In Plan Detail — WH_IN measure 드릴다운 소스(부모 커서). 배선 전까지 헤더만(빈 데이터).
      [SHEETS.WH_IN_PLAN_DETAIL]: [] as WijmoRowItem[],
    }),
    [confirmData, whStockData, holdStockData, mesStockData, scsStockData, stockLocData, resultData]
  );

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
      if (mainSheet === 'packer') void refetchPacker();
      else void refetchMain();
    },
    onError: (error: Error) => {
      void setAlert({ type: 'alert', content: error.message || t(MSG.SAVE_FAILED, '__Save failed.') });
    },
  });

  // ── 저장 mutation (Confirm Detail — SAVE_SHIPMENT_REQUEST_CONFIRM_40) ──
  const { mutate: mutateConfirm } = useProcMutation<MENU_ID, SHEETS.CONFIRM_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.CONFIRM_DETAIL,
    tabId,
    onSuccess: () => {
      confirmEditTrackerRef.current?.clearChanges();
      setToast({ type: 'success', message: t(MSG.SAVED, '__Saved successfully.') });
      setDetailFilter(SHEETS.CONFIRM_DETAIL, 'N');
    },
  });
  // Hold stock 저장 (SAVE_BLOCK_STOCK_DATA — SP 배포 확인, 03 §4 / iter-1 I03) ──
  const { mutate: mutateHold } = useProcMutation<MENU_ID, SHEETS.HOLD_STOCK>({
    menuId: MENU_ID,
    sheetName: SHEETS.HOLD_STOCK,
    tabId,
    onSuccess: () => {
      holdStockEditTrackerRef.current?.clearChanges();
      setToast({ type: 'success', message: t(MSG.SAVED, '__Saved successfully.') });
      setDetailFilter(SHEETS.HOLD_STOCK, 'N');
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

  const handleSearch = () => {
    // 필수 (Plan Date* / Period*)
    if (!sc.planDate || !sc.periodFrom) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_FIELDS, '__Please enter the required fields.'),
      });
      return;
    }
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
    setDetailFilter(activeDetailSheet, 'N');
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

  // ── Save (F7 — 활성 그리드/시트 분기, 01 R8 / 03 §4) ──
  const handleSave = () => {
    if (activeGrid === 'main') {
      if (!canEditMain) return; // 이전 Plan(비최신)·EDIT 권한 없음 → master 저장 차단(R7b)
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
      // 확인창 (validations #13/#17 MSG00324 → MSG01201) → ERP 인터페이스 연쇄는 convert-sp/런타임 후속
      void setAlert({
        type: 'confirm',
        content: t(MSG.CONFIRM_SAVE, {
          defaultValue: '_Are you sure you want to confirm the shipping plan change requests?',
        }),
        onConfirm: () => mutateConfirm(dirty as unknown as ConfirmDetailRow[]),
      });
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
      mutateHold(dirty as unknown as HoldStockRow[]);
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
    if (!canEdit) return;
    if (activeDetailSheet !== SHEETS.HOLD_STOCK) return; // AS-IS Insert 가드(Hold stock 한정, 01 R5)
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
        HOLD_YYYYMMDD: sc.planDate,
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
    if (!canEdit) return;
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

  // 확정구간 기준일 = Plan Date + (Packer 2 / 그 외 20)일 (AS-IS Re_Design confirmDay, SSP0015.cs L2766/2770).
  //   이 일자 이하 기간 컬럼(SUM 포함)은 회색 확정구간, 이후 WH_IN D_ 는 편집(Yellow).
  const confirmDay = sc.planDate
    ? dayjs(sc.planDate, 'YYYYMMDD').add(mainSheet === 'packer' ? 2 : 20, 'day').format('YYYYMMDD')
    : '';

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
      editable={canEditMain}
      confirmDay={confirmDay}
      onDrilldown={handleMainDrilldown}
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

      {/* splitContainer1 — Master(상) / Detail(하) 수직 분할 (01 §1) */}
      <div className={styles.gridArea}>
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
            staticColumns={staticColumns}
            editable={canEdit}
            onConfirmDetail={setConfirmDetailNo}
          />
        </div>
      </div>

      {/* 1차 Item 팝업 (btnItemId — ModelByDivisionPopup, 2차와 동일 팝업) */}
      <ModelByDivisionPopup
        open={openItemMain}
        onClose={() => setOpenItemMain(false)}
        onSelect={selected => set({ itemId: str(selected.itemId) })}
        params={{ divisionId: FIXED_DIVISION, itemId: sc.itemId }}
      />

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
            if (mainSheet === 'packer' && filters[SHEETS.MAIN_PACKER]) void refetchPacker();
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
    </>
  );
};
