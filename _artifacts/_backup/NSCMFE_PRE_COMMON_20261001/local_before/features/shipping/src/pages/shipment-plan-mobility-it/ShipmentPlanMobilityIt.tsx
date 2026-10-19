import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ColumnSettingModal, ItemByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction, GridUtils } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
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
  SHEETS,
  TITLESET_MEASURE_TYPE,
} from './shipment-plan-mobility-it.constants';
import type { ConfirmDetailRow, HoldStockRow, MainRow } from './shipment-plan-mobility-it.types';
import styles from './ShipmentPlanMobilityIt.module.scss';
import { useShipmentPlanMobilityItStore } from './useShipmentPlanMobilityItStore';
import { measureDrilldownOf } from './utils/shipment-plan-mobility-it.detailSheets';
import { collectMainSaveRows } from './utils/shipment-plan-mobility-it.save';

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
  const initialized = useShipmentPlanMobilityItStore(s => s.initialized);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  // 편집 기본 ON — canEdit = hasButton('EDIT') 마운트 1회(AS-IS EditButton 토글 미이식, convert-core §2.4).
  //   R7a(GetSSPUserCheck→MSG00251)·R7b(이전 Plan→MSG00170) 업무가드는 미배포/데이터 조건이라
  //   fail-open — convert-sp 후속(04_react-gap.md 확인필요).
  const canEdit = hasButton('EDIT');

  // ── 모달 open state ──
  const [openItemMain, setOpenItemMain] = useState(false);
  const [openItemDetail, setOpenItemDetail] = useState(false);
  const [openMeasure, setOpenMeasure] = useState(false);
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
    }),
    [confirmData, whStockData, holdStockData, mesStockData, scsStockData, stockLocData, resultData]
  );

  // ── 저장 mutation (Confirm Detail — SAVE_SHIPMENT_REQUEST_CONFIRM_40) ──
  const savingRef = useRef(false);
  const { mutate: mutateConfirm } = useProcMutation<MENU_ID, SHEETS.CONFIRM_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.CONFIRM_DETAIL,
    tabId,
    onSuccess: () => {
      confirmEditTrackerRef.current?.clearChanges();
      setToast({ type: 'success', message: t(MSG.SAVED, { defaultValue: '_Saved successfully.' }) });
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
      setToast({ type: 'success', message: t(MSG.SAVED, { defaultValue: '_Saved successfully.' }) });
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
      setToast({ type: 'success', message: t(MSG.SAVED, { defaultValue: '_Saved successfully.' }) });
      setDetailFilter(SHEETS.MES_STOCK, 'N');
    },
  });

  // ── mount — keep-alive 잔여 filters 무효화 + 컬럼 메타 1회 fetch ──
  useEffect(() => {
    clearFilters();
    if (!initialized)
      void fetchStaticColumns([SHEETS.MAIN, SHEETS.MAIN_PACKER, SHEETS.CONFIRM_DETAIL]);
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
        content: t(MSG.REQUIRED_FIELDS, { defaultValue: '_Please enter the required fields.' }),
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
        content: t(MSG.NO_MODIFICATION, { defaultValue: '_There are unsaved changes. Search again?' }),
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
      if (!canEdit) return;
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
          content: t(MSG.NEGATIVE_QTY, { defaultValue: '_Quantity must be 0 or greater.' }),
        });
        return;
      }
      if (payload.length === 0) {
        setToast({
          type: 'error',
          message: t(MSG.NO_MODIFICATION, { defaultValue: '_No modifications have been made.' }),
        });
        return;
      }
      if (savingRef.current) return;
      savingRef.current = true;
      void apiClient
        .post(`/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`, payload)
        .then(res => {
          if (res.status >= 400 || Number(res.data?.code)) {
            void setAlert({
              type: 'alert',
              content: t(MSG.SAVE_FAILED, { defaultValue: '_Save failed.' }),
            });
            return;
          }
          mainEditTrackerRef.current?.clearChanges();
          setToast({ type: 'success', message: t(MSG.SAVED, { defaultValue: '_Saved successfully.' }) });
          if (mainSheet === 'packer') void refetchPacker();
          else void refetchMain();
        })
        .finally(() => {
          savingRef.current = false;
        });
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
          message: t(MSG.NO_MODIFICATION, { defaultValue: '_No modifications have been made.' }),
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
            content: t(MSG.REQUIRED_VALUE, { defaultValue: '_{0} value is required.', 0: 'Shipment Qty' }),
          });
          return;
        }
        // Shipment Date* — 빈값 차단 (라벨 * 필수)
        if (str(row.SHIPMENT_DATE).trim() === '') {
          void setAlert({
            type: 'alert',
            content: t(MSG.REQUIRED_VALUE, { defaultValue: '_{0} value is required.', 0: 'Shipment Date' }),
          });
          return;
        }
        if (str(row.TRANSPORT_MODE).trim() === '') {
          void setAlert({
            type: 'alert',
            content: t(MSG.REQUIRED_VALUE, { defaultValue: '_{0} value is required.', 0: 'Trans Mode' }),
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
          message: t(MSG.NO_MODIFICATION, { defaultValue: '_No modifications have been made.' }),
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
          message: t(MSG.NO_MODIFICATION, { defaultValue: '_No modifications have been made.' }),
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
      label: t(LBL.MEASURE, { defaultValue: 'Measure' }),
      title: t(LBL.MEASURE, { defaultValue: 'Measure' }),
      action: handleMeasure,
      iconComponent: <IcMeasureSelect />,
      buttonLabel: '',
    },
  ];

  const activeMainSheet = mainSheet === 'packer' ? SHEETS.MAIN_PACKER : SHEETS.MAIN;

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
        <div className={styles.mainGrid}>
          <ShipmentPsiMainGrid
            rows={mainRows}
            calendar={calendarRows}
            gridRef={mainGridRef}
            gridFilterRef={mainGridFilterRef}
            editTrackerRef={mainEditTrackerRef}
            adminColumns={staticColumns[activeMainSheet]}
            bucketType={sc.bucketType}
            chkSum={sc.chkSum}
            editable={canEdit}
            curPlanDate={sc.planDate}
            onDrilldown={handleMainDrilldown}
          />
        </div>

        <div className={styles.detailArea}>
          <ShipmentPsiDetailBar
            onDetailSearch={handleDetailSearch}
            onModelSearch={() => setOpenItemDetail(true)}
            onRequestorSearch={() =>
              void setAlert({
                type: 'alert',
                content: t(MSG.REQUIRED_FIELDS, {
                  defaultValue: '_Requestor search popup (UserInfoPopup) is pending.',
                }),
              })
            }
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

      {/* 1차 Item 팝업 (btnItemId — SCM0002_ItembyDivisionPopup, division 40) */}
      <ItemByDivisionModal
        open={openItemMain}
        modalClose={() => setOpenItemMain(false)}
        setSelectedValue={itemId => set({ itemId: str(itemId) })}
        preSearchParams={{ divisionId: FIXED_DIVISION, itemId: sc.itemId }}
        callFromCell={false}
      />

      {/* 2차 Model 팝업 (btnItemID2 — 동일 컴포넌트 재사용) */}
      <ItemByDivisionModal
        open={openItemDetail}
        modalClose={() => setOpenItemDetail(false)}
        setSelectedValue={itemId => set({ model: str(itemId) })}
        preSearchParams={{ divisionId: FIXED_DIVISION, itemId: sc.model }}
        callFromCell={false}
      />

      {/* Measure 설정 (R3 — TitleSetForm 대응, 공용 ColumnSettingModal + TITLESET 'M') */}
      <ColumnSettingModal
        open={openMeasure}
        modalClose={() => setOpenMeasure(false)}
        menuId={MENU_ID}
        sheetName={ADMIN_SHEET_NAME[activeMainSheet] ?? ''}
        columnType={TITLESET_MEASURE_TYPE}
        onSave={() => {
          setOpenMeasure(false);
          if (mainSheet === 'packer' && filters[SHEETS.MAIN_PACKER]) void refetchPacker();
          else if (filters[SHEETS.MAIN]) void refetchMain();
        }}
      />
    </>
  );
};
