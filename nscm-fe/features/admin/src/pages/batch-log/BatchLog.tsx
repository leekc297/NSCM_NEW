import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { TitleArea } from '@shared/lges';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';

import { MENU_ID, SHEETS, SHEET_INDEX } from './batch-log.constants';
import styles from './BatchLog.module.scss';
import { BatchHistGrid } from './components/BatchHistGrid';
import { BatchLogForm } from './components/BatchLogForm';
import { BatchLogGrid } from './components/BatchLogGrid';
import { BatchStepGrid } from './components/BatchStepGrid';
import { useBatchLogStore } from './useBatchLogStore';

export const BatchLog = ({ tabId, title }: PageProps<MENU_ID>) => {
  const [activeGrid, setActiveGrid] = useState<SHEET_INDEX>(SHEET_INDEX.BATCH_LOG);

  const batchLogGridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.BATCH_LOG>>>();
  const batchLogGridFilterRef = useRef<FlexGridFilter>();
  const stepGridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.STEP_INFO>>>();
  const stepGridFilterRef = useRef<FlexGridFilter>();
  const histGridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.BATCH_LOG_HIST>>>();
  const histGridFilterRef = useRef<FlexGridFilter>();

  const isOpenSearchArea = useBatchLogStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useBatchLogStore(state => state.setOpenSearchArea);
  const filters = useBatchLogStore(state => state.filters);
  const searchParams = useBatchLogStore(state => state.searchParams);
  const setListFilter = useBatchLogStore(state => state.setListFilter);
  const setDetailFilter = useBatchLogStore(state => state.setDetailFilter);
  const adminColumns = useBatchLogStore(state => state.adminColumns);
  const fetchAdminColumns = useBatchLogStore(state => state.fetchAdminColumns);

  // 마운트 1회 — admin 등록 컬럼 로드. 미등록/실패면 각 그리드가 constants fallback.
  useEffect(() => {
    void fetchAdminColumns();
  }, [fetchAdminColumns]);

  const { data: batchLogData } = useTabProcQuery<MENU_ID, SHEETS.BATCH_LOG>({
    menuId: MENU_ID,
    sheetName: SHEETS.BATCH_LOG,
    tabId,
    filters: filters[SHEETS.BATCH_LOG],
    enabled: !!filters[SHEETS.BATCH_LOG],
  });

  const { data: stepData } = useTabProcQuery<MENU_ID, SHEETS.STEP_INFO>({
    menuId: MENU_ID,
    sheetName: SHEETS.STEP_INFO,
    tabId,
    filters: filters[SHEETS.STEP_INFO],
    enabled: !!filters[SHEETS.STEP_INFO],
  });

  const { data: histData } = useTabProcQuery<MENU_ID, SHEETS.BATCH_LOG_HIST>({
    menuId: MENU_ID,
    sheetName: SHEETS.BATCH_LOG_HIST,
    tabId,
    filters: filters[SHEETS.BATCH_LOG_HIST],
    enabled: !!filters[SHEETS.BATCH_LOG_HIST],
  });

  // itemsSource 참조 안정화 — 매 렌더 새 배열은 DataGrid memo 를 무력화한다(nscm 함정 4).
  const batchLogRows = useMemo(() => batchLogData?.batchLog ?? [], [batchLogData]);
  const stepRows = useMemo(() => stepData?.stepInfo ?? [], [stepData]);
  const histRows = useMemo(() => histData?.batchLogHist ?? [], [histData]);

  // Main 행 더블클릭 → 선택 JOB_ID 로 Step/Hist 재조회(master->detail, AS-IS cs L254~271).
  const handleSelectJob = (jobId: string) => {
    setDetailFilter(jobId);
  };

  // 조회 전용 — search 만. Edit/Save/Insert/Delete 없음(AS-IS EditButton 은 차단, 3시트 read-only).
  const hotkeyConfig: HotkeyConfig = {
    search: setListFilter,
    insert: false,
    delete: false,
    save: false,
    manual: false,
    upload: false,
  };

  const activeGridRef =
    activeGrid === SHEET_INDEX.STEP_INFO
      ? stepGridRef
      : activeGrid === SHEET_INDEX.BATCH_LOG_HIST
        ? histGridRef
        : batchLogGridRef;
  const activeGridFilterRef =
    activeGrid === SHEET_INDEX.STEP_INFO
      ? stepGridFilterRef
      : activeGrid === SHEET_INDEX.BATCH_LOG_HIST
        ? histGridFilterRef
        : batchLogGridFilterRef;

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <BatchLogForm onSearch={setListFilter} />
      <SubTitle
        menuId={MENU_ID}
        grid={activeGridRef}
        gridFilter={activeGridFilterRef}
        countGrid={batchLogGridRef}
        dataCount={batchLogRows.length}
        excelFileName='BatchLog'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <div className={styles.outerModule}>
        <PanelGroup className={styles.tableWrapper} orientation='vertical'>
          <Panel defaultSize={45} minSize={20}>
            <BatchLogGrid
              gridRef={batchLogGridRef}
              gridFilterRef={batchLogGridFilterRef}
              data={batchLogRows}
              adminColumns={adminColumns[SHEETS.BATCH_LOG]}
              setActiveGrid={setActiveGrid}
              onSelectJob={handleSelectJob}
            />
          </Panel>
          <PanelSeparator className={styles.rowSplitBar} />
          <Panel defaultSize={55} minSize={20}>
            <PanelGroup className={styles.bottomRow} orientation='horizontal'>
              <Panel defaultSize={55} minSize={20}>
                <div className={styles.paneModule}>
                  {/* AS-IS 시트명 'Step Info'(cs L163). i18n LBL 코드 등록 deferred(Hook #114, DB ERROR). */}
                  <TitleArea isSubTitle title='Step Info' depth='h4' />
                  <BatchStepGrid
                    gridRef={stepGridRef}
                    gridFilterRef={stepGridFilterRef}
                    data={stepRows}
                    adminColumns={adminColumns[SHEETS.STEP_INFO]}
                    setActiveGrid={setActiveGrid}
                  />
                </div>
              </Panel>
              <PanelSeparator className={styles.colSplitBar} />
              <Panel defaultSize={45} minSize={20}>
                <div className={styles.paneModule}>
                  {/* AS-IS 시트명 'Batch Run Log'(cs L166). i18n LBL 코드 등록 deferred(Hook #114, DB ERROR). */}
                  <TitleArea isSubTitle title='Batch Run Log' depth='h4' />
                  <BatchHistGrid
                    gridRef={histGridRef}
                    gridFilterRef={histGridFilterRef}
                    data={histRows}
                    adminColumns={adminColumns[SHEETS.BATCH_LOG_HIST]}
                    setActiveGrid={setActiveGrid}
                  />
                </div>
              </Panel>
            </PanelGroup>
          </Panel>
        </PanelGroup>
      </div>
    </>
  );
};
