import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import type { PageProps } from '@foundation/models';
import { GridAction, type EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore } from '@shared/stores';

import { ChangeRequestPlanSubGrid } from './components/ChangeRequestPlanSubGrid';
import { RequestActionBar } from './components/RequestActionBar';
import { RequestInfoPanel } from './components/RequestInfoPanel';
import { ShipmentChangeRequestPlanForm } from './components/ShipmentChangeRequestPlanForm';
import { ShipmentChangeRequestPlanMainGrid } from './components/ShipmentChangeRequestPlanMainGrid';
import { ShipmentChangeRequestPlanModals } from './components/ShipmentChangeRequestPlanModals';
import { useShipmentChangeRequestPlanCellCombos } from './hooks/useShipmentChangeRequestPlanCellCombos';
import { useShipmentChangeRequestPlanRequestor } from './hooks/useShipmentChangeRequestPlanRequestor';
import { useShipmentChangeRequestPlanSaveActions } from './hooks/useShipmentChangeRequestPlanSaveActions';
import { useShipmentChangeRequestPlanToolbar } from './hooks/useShipmentChangeRequestPlanToolbar';
import { useShipmentChangeRequestPlanBaseDay } from './hooks/useShipmentChangeRequestPlanValidation';
import {
  ITEM_POPUP_COLUMN,
  LBL,
  MENU_ID,
  MSG,
  PROJECT_POPUP_COLUMN,
  SHEETS,
} from './shipment-change-request-plan.constants';
import type { MainRow, SubRow } from './shipment-change-request-plan.types';
import styles from './ShipmentChangeRequestPlan.module.scss';
import { useShipmentChangeRequestPlanStore } from './useShipmentChangeRequestPlanStore';
import { buildMainColumns, buildSubColumns } from './utils/shipmentChangeRequestPlanColumns';
import { type GridRowData } from './utils/shipmentChangeRequestPlanDerive';
import { buildCopiedRow, buildNewRow } from './utils/shipmentChangeRequestPlanInsert';

// AS-IS GSCM.SSP.Forms.UIL/Plan/SSP0200_ShipmentChangeRequest.cs (정본 6,906행).
//   상세 매핑·dead 미이식 근거: __asis-mapping__.md / design/04_react-gap.md.
//   주의: 편집모드 모드토글(EditButton/SwitchLock)은 미이식 — 편집 기본 ON(convert-core §2.4).
//   주의: SP 6건 미이관(convert-sp 후속) — JVFlag·VP From Site·전극 소수자리 재판정·From Site 셀콤보·
//         ERP 오류확정은 런타임 실행체인 미완이다.
export const ShipmentChangeRequestPlan = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  // 감사·세션 인자는 FE 가 실어야 한다 — /call-proc 은 세션을 주입하지 않는다.

  const mainGridRef = useRef<FlexGrid>();
  const mainFilterRef = useRef<FlexGridFilter>();
  const subGridRef = useRef<FlexGrid>();
  const subFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();
  const savingRef = useRef(false);
  const popupTargetRef = useRef<{ row: GridRowData; binding: string } | null>(null);

  const sc = useShipmentChangeRequestPlanStore(s => s.searchParams);
  const setSearchParams = useShipmentChangeRequestPlanStore(s => s.setSearchParams);
  const filters = useShipmentChangeRequestPlanStore(s => s.filters);
  const setFilter = useShipmentChangeRequestPlanStore(s => s.setFilter);
  const clearFilters = useShipmentChangeRequestPlanStore(s => s.clearFilters);
  const openSearchArea = useShipmentChangeRequestPlanStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentChangeRequestPlanStore(s => s.setOpenSearchArea);
  const staticColumns = useShipmentChangeRequestPlanStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentChangeRequestPlanStore(s => s.fetchStaticColumns);
  const fetchDayRange = useShipmentChangeRequestPlanStore(s => s.fetchDayRange);
  const singleProcess = useShipmentChangeRequestPlanStore(s => s.singleProcess);
  const requestInfo = useShipmentChangeRequestPlanStore(s => s.requestInfo);
  const setRequestInfo = useShipmentChangeRequestPlanStore(s => s.setRequestInfo);
  const clearRequestInfo = useShipmentChangeRequestPlanStore(s => s.clearRequestInfo);
  const initSessionFields = useShipmentChangeRequestPlanStore(s => s.initSessionFields);
  const fetchRequestorDept = useShipmentChangeRequestPlanStore(s => s.fetchRequestorDept);

  // 편집모드 기본 ON — mount 시 권한만 1회 결정한다. 모드 토글 state 신설 금지(convert-core §2.4).
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const canEdit = hasButton('EDIT');

  const [openItem, setOpenItem] = useState(false);
  const [openProject, setOpenProject] = useState(false);
  const [openApproval, setOpenApproval] = useState(false);
  const [openInsertMultiple, setOpenInsertMultiple] = useState(false);

  const { data: mainData, refetch: refetchMain } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const { data: subData, refetch: refetchSub } = useTabProcQuery<MENU_ID, SHEETS.SUB>({
    menuId: MENU_ID,
    sheetName: SHEETS.SUB,
    tabId,
    filters: filters[SHEETS.SUB],
    enabled: !!filters[SHEETS.SUB],
  });

  const mainRows = useMemo<MainRow[]>(() => mainData?.o_rc1 ?? [], [mainData]);
  const subRows = useMemo<SubRow[]>(() => subData?.o_rc1 ?? [], [subData]);

  // 셀 콤보 주입 dataMap (design 03 §1.3 D-1/D-2) — 상세 근거는 훅 헤더 주석 참조.
  const { mainDataMaps, subDataMaps, loadTransMode, loadEndCustomer, isTransModeLoaded } =
    useShipmentChangeRequestPlanCellCombos(sc.divisionId);

  // 출하일 상·하한 기준일수(CHANGE_REQ_DAY). 미조회면 undefined -> 해당 검증은 수행하지 않는다.
  const changeReqDay = useShipmentChangeRequestPlanBaseDay();

  /**
   * shtMain 파생 컬럼셋은 **페이지가 소유한다**. 그리드 로컬 useMemo 로 두면 같은 컬럼셋이
   *   `saveWithValidation` 에 닿지 않아 div 분기로 숨긴 필수컬럼까지 필수검증 대상이 된다
   *   (`useSaveWithValidation` 은 `col.visible !== false` 로만 숨김을 제외한다).
   */
  const mainColumns = useMemo(
    () =>
      buildMainColumns(staticColumns[SHEETS.MAIN], {
        divisionId: sc.divisionId,
        changeType: sc.changeType,
        dataMaps: mainDataMaps,
      }),
    [staticColumns, sc.divisionId, sc.changeType, mainDataMaps]
  );

  // ChangeType='P' 분기 2단 헤더 라벨은 i18n 경유다(영문 하드코딩 금지).
  //   메타 기본값(Confirmed/Change)은 그대로 쓰고 'P' 일 때만 덮어쓴다(§2.1 P5·P6).
  const planLabels = useMemo(
    () => ({
      plan: t(LBL.PLAN, '_Plan'),
      confirm: t(LBL.CONFIRM, '_Confirm'),
    }),
    [t]
  );

  /** shtSub 파생 컬럼셋도 페이지가 소유한다 — 요청확정의 메타 필수검증에 같은 셋이 닿아야 한다. */
  const subColumns = useMemo(
    () => buildSubColumns(staticColumns[SHEETS.SUB], sc.changeType, subDataMaps, planLabels),
    [staticColumns, sc.changeType, subDataMaps, planLabels]
  );

  useEffect(() => {
    // 진입 자동 조회 금지 — keep-alive 잔여 filters 무효화 + 기간 기본값 + 컬럼메타 fetch.
    //   초기 mount 에서 cascade 핸들러를 부르지 않는다(AS-IS InitEvent() 가 마지막, design 02 §4.1-2).
    //   컬럼메타는 mount 마다 **무조건** refetch 한다 — store 가 persist 라서 initialized 로 게이트하면
    //   메타(INPUT_TP_CD/폭/콤보)를 고친 뒤 열려 있던 탭이 낡은 컬럼셋을 계속 쓴다(CLAUDE.md §2 체크 3항).
    clearFilters();
    initSessionFields();
    // 요청부서는 세션 축이다(AS-IS SetUserInfo cs:517~526). detail 조회 o_rc2(모델 담당자)로 채우지 않는다.
    void fetchRequestorDept();
    void fetchDayRange('');
    void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 요청부서 보완 + 승인자 빈칸 자동채움(o_rc2) — 상세는 훅 헤더 주석.
  useShipmentChangeRequestPlanRequestor(subData);

  const refetchAll = useCallback(() => {
    // 저장 후 재조회 = FindButton 등가(master + detail 동시, hook #131).
    //   filters 가 불변인 저장 후 경로에서만 refetch 를 직접 쓴다.
    void refetchMain?.();
    void refetchSub?.();
  }, [refetchMain, refetchSub]);

  const alert = useCallback(
    (msgId: string, defaultText: string, arg?: string) => {
      // `{0}` 치환은 i18next interpolation 이 아니라 문자열 replace 다 — 공용 i18n 설정이
      //   interpolation prefix 를 바꾸지 않아(기본 `{{}}`) `{ 0: arg }` 로는 치환되지 않고
      //   '{0}' 리터럴이 그대로 노출된다. 정본 관례 = useSaveWithValidation.ts 의 .replace('{0}', …).
      void setAlert({
        type: 'alert',
        content: t(msgId, { defaultValue: defaultText }).replace('{0}', arg ?? ''),
      });
    },
    [setAlert, t]
  );

  // FindButton(cs:757) — master + detail 동시 조회(V-09).
  const handleSearch = () => {
    if (!sc.divisionId) {
      // Division 권한 0건 = 조회 차단. TO-BE MSG00097 은 뜻이 달라 쓰지 않는다.
      alert(MSG.NO_AUTH_DIVISION, 'No authority assigned.');
      return;
    }
    setFilter();
    void fetchStaticColumns();
  };

  // InsertButton(cs:765) — 내부 가드 RowCount>0. 빈 그리드에서는 삽입하지 않는다(V-12 / CP-15).
  //   복사원은 호출 시점의 포커스 행 1회 고정이다. 다건 경로에서 매 회차 selection 을 다시 읽으면
  //   GridAction 이 selection 을 옮기지 않아 2건부터 방금 삽입한 빈 행을 복사한다.
  const copySourceRow = (): GridRowData | undefined => {
    const grid = mainGridRef.current;
    if (!grid || mainRows.length === 0) return undefined;
    const source = (grid.collectionView?.sourceCollection ?? []) as GridRowData[];
    return source[Math.max(grid.selection?.row ?? 0, 0)];
  };

  const handleInsert = () => {
    const grid = mainGridRef.current;
    if (!grid || !canEdit) return;
    const base = copySourceRow();
    if (!base) return;
    GridAction.addRow(grid, buildCopiedRow(base, sc.divisionId) as never, 'above', true);
  };

  // btnNew(cs:3375) — AS-IS 가 의도적으로 RowCount>0 가드를 뺀 경로다. 빈 그리드에서도 추가된다.
  const handleNew = () => {
    const grid = mainGridRef.current;
    if (!grid || !canEdit) return;
    GridAction.addRow(grid, buildNewRow(sc.divisionId) as never, 'above', true);
  };

  // btnInsertMultiple(cs:2924) — 팝업 건수만큼. ITEM_ID 아이콘 셀이 없는 것이 AS-IS 차이다(CP-15).
  //   세트 삽입으로 한 번에 넣는다 — handleInsert 를 n회 반복하면 2건부터 빈 행을 복사한다(addRowSet 주석).
  const handleInsertMultiple = (count: number) => {
    const grid = mainGridRef.current;
    if (!grid || !canEdit || count <= 0) return;
    const base = copySourceRow();
    if (!base) return;
    const copied = Array.from({ length: count }, () => buildCopiedRow(base, sc.divisionId));
    GridAction.addRowSet(grid, copied as never[], 'above', { preserveMergeManager: true });
  };

  // 팝업 대상 셀 참조 해제 — 셀 팝업을 취소한 뒤 조회조건 돋보기로 열면 결과가 이전 셀에 쓰이는 것을 막는다.
  const clearPopupTarget = useCallback(() => {
    popupTargetRef.current = null;
  }, []);

  const handlePopupCellDblClick = useCallback((row: GridRowData, binding: string) => {
    popupTargetRef.current = { row, binding };
    if (binding === ITEM_POPUP_COLUMN) setOpenItem(true);
    else if (binding === PROJECT_POPUP_COLUMN) setOpenProject(true);
  }, []);

  // SSP0300_OrderDetailPopup / SCM0002_ShipmentPlanRequestPopup 드릴다운 — TO-BE 공용 컴포넌트가 없다.
  //   임의 신설 대신 미구현으로 남기고 04 확인필요로 올린다(조용한 제외 금지).
  const handleDrillDown = useCallback((_row: GridRowData, _binding: string) => undefined, []);

  const handleBlocked = useCallback(
    (msgId: string, defaultText: string, arg?: string) => alert(msgId, defaultText, arg),
    [alert]
  );

  const writeCell = (value: string, nameValue?: string, nameCol?: string) => {
    const target = popupTargetRef.current;
    if (!target) return;
    const prev = target.row[target.binding];
    if (prev !== value) {
      editTrackerRef.current?.storeChange(
        target.row as never,
        target.binding,
        prev as never,
        value as never
      );
      target.row[target.binding] = value;
      if (nameCol && nameValue !== undefined) target.row[nameCol] = nameValue;
      mainGridRef.current?.invalidate();
    }
    popupTargetRef.current = null;
  };

  const { handleSave, handleRequestComplete, handleCancel } =
    useShipmentChangeRequestPlanSaveActions({
      mainGridRef,
      editTrackerRef,
      savingRef,
      // 파생 컬럼셋(숨김 반영본)을 넘긴다 — store raw 를 넘기면 숨긴 필수컬럼이 검증 대상이 된다.
      staticColumns: mainColumns,
      subColumns,
      requestInfo,
      subRows: subRows as unknown as GridRowData[],
      changeType: sc.changeType,
      changeReqDay,
      alert,
      translate: (key, defaultValue) => t(key, { defaultValue }),
      confirm: async (msgId, defaultText) =>
        !!(await setAlert({ type: 'confirm', content: t(msgId, { defaultValue: defaultText }) })),
      refetchAll,
      clearRequestInfo,
      setRequestNo: requestNo => setRequestInfo({ requestNo }),
    });

  const { hotkeyConfig, customButtons } = useShipmentChangeRequestPlanToolbar({
    hasButton,
    onSearch: handleSearch,
    onInsert: handleInsert,
    onSave: handleSave,
    onNew: handleNew,
    onInsertMultiple: () => setOpenInsertMultiple(true),
  });

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <ShipmentChangeRequestPlanForm
          onSearch={handleSearch}
          onItemSearch={() => {
            // 조회조건 경로 — 직전에 셀 팝업을 열고 취소했을 수 있으므로 대상 셀 참조를 먼저 끊는다.
            clearPopupTarget();
            setOpenItem(true);
          }}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={mainGridRef}
        gridFilter={mainFilterRef}
        dataCount={mainRows.length}
        excelFileName='ShipmentChangeRequest'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />

      {/* splitContainer1 Orientation=Horizontal = 상/하 분할. 'horizontal' 로 쓰면 좌우로 갈라진다. */}
      <div className={styles.splitWrapper}>
        <PanelGroup className={styles.panelGroup} orientation='vertical'>
          <Panel defaultSize={39} minSize={20}>
            <div className={styles.mainPane}>
              <ShipmentChangeRequestPlanMainGrid
                rows={mainRows}
                gridRef={mainGridRef}
                gridFilterRef={mainFilterRef}
                editTrackerRef={editTrackerRef}
                singleProcess={singleProcess}
                canEdit={canEdit}
                columns={mainColumns}
                dataMaps={mainDataMaps}
                changeReqDay={changeReqDay}
                loadTransMode={loadTransMode}
                loadEndCustomer={loadEndCustomer}
                isTransModeLoaded={isTransModeLoaded}
                onPopupCellDblClick={handlePopupCellDblClick}
                onDrillDown={handleDrillDown}
                onBlocked={handleBlocked}
              />
            </div>
          </Panel>
          <PanelSeparator className={styles.splitBar} />
          {/* FixedPanel=Panel2 재현 — 하단을 minSize/maxSize 로 좁혀 상단만 늘어나게 한다(V-02). */}
          <Panel defaultSize={61} minSize={40} maxSize={75}>
            <div className={styles.bottomPane}>
              <div className={styles.requestInfo}>
                <RequestInfoPanel
                  requestInfo={requestInfo}
                  canEdit={canEdit}
                  canSearchApproval={hasButton('EDIT')}
                  onChange={setRequestInfo}
                  onApprovalSearch={() => setOpenApproval(true)}
                />
              </div>
              <RequestActionBar
                canRequestComplete={hasButton('SAVE')}
                canCancel={hasButton('DELETE')}
                onRequestComplete={handleRequestComplete}
                onCancel={handleCancel}
              />
              <div className={styles.subPane}>
                <ChangeRequestPlanSubGrid
                  rows={subRows}
                  gridRef={subGridRef}
                  gridFilterRef={subFilterRef}
                  canEdit={canEdit}
                  columns={subColumns}
                />
              </div>
            </div>
          </Panel>
        </PanelGroup>
      </div>

      <ShipmentChangeRequestPlanModals
        divisionId={sc.divisionId}
        openItem={openItem}
        openProject={openProject}
        openApproval={openApproval}
        openInsertMultiple={openInsertMultiple}
        calledFromCell={!!popupTargetRef.current}
        setOpenItem={setOpenItem}
        setOpenProject={setOpenProject}
        setOpenApproval={setOpenApproval}
        setOpenInsertMultiple={setOpenInsertMultiple}
        clearPopupTarget={clearPopupTarget}
        writeCell={writeCell}
        setSearchItemId={itemId => setSearchParams({ itemId })}
        setRequestInfo={setRequestInfo}
        onInsertMultiple={handleInsertMultiple}
      />
    </>
  );
};
