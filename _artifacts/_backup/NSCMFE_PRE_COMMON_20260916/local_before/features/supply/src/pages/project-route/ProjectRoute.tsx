import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useEffect, useMemo, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction, safeString } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ProjectRouteBomGrid } from './components/ProjectRouteBomGrid';
import { ProjectRouteForm } from './components/ProjectRouteForm';
import { ProjectRouteMainGrid } from './components/ProjectRouteMainGrid';
import { ProjectRoutePlantGrid } from './components/ProjectRoutePlantGrid';
import { useProjectRouteValidation } from './hooks/useProjectRouteValidation';
import { MENU_ID, MSG, RESPONSE_SET, SHEETS } from './project-route.constants';
import type { BomRow, PlantRow, SiteRow } from './project-route.types';
import styles from './ProjectRoute.module.scss';
import { useProjectRouteStore } from './useProjectRouteStore';
import { buildMonthColumns } from './utils/projectRoute.calendar';

export const ProjectRoute = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const { setAlert, setToast } = useMessageStore.getState();
  const sessionUserId = useSessionStore(s => s.session.userId);

  const mainGridRef = useRef<FlexGrid<SiteRow>>();
  const bomGridRef = useRef<FlexGrid<BomRow>>();
  const plantGridRef = useRef<FlexGrid<PlantRow>>();
  const mainFilterRef = useRef<FlexGridFilter>();
  const bomFilterRef = useRef<FlexGridFilter>();
  const plantFilterRef = useRef<FlexGridFilter>();
  const plantEditTrackerRef = useRef<EditTracker<PlantRow>>();

  const initialized = useProjectRouteStore(s => s.initialized);
  const filters = useProjectRouteStore(s => s.filters);
  const searchParams = useProjectRouteStore(s => s.searchParams);
  const siteKey = useProjectRouteStore(s => s.siteKey);
  const bomKey = useProjectRouteStore(s => s.bomKey);
  const isBomClicked = useProjectRouteStore(s => s.isBomClicked);
  const staticColumns = useProjectRouteStore(s => s.staticColumns);
  const openSearchArea = useProjectRouteStore(s => s.openSearchArea);
  const setOpenSearchArea = useProjectRouteStore(s => s.setOpenSearchArea);
  const setFilters = useProjectRouteStore(s => s.setFilters);
  const applySiteKey = useProjectRouteStore(s => s.applySiteKey);
  const applyBomKey = useProjectRouteStore(s => s.applyBomKey);
  const fetchStaticColumns = useProjectRouteStore(s => s.fetchStaticColumns);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const { validatePlantSave } = useProjectRouteValidation();

  // ---- 3 시트 조회(연쇄 enabled 게이트) ----
  const { data: siteData } = useTabProcQuery<MENU_ID, SHEETS.SITE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SITE,
    tabId,
    filters: filters[SHEETS.SITE],
    enabled: !!filters[SHEETS.SITE],
  });
  const { data: bomData } = useTabProcQuery<MENU_ID, SHEETS.BOM>({
    menuId: MENU_ID,
    sheetName: SHEETS.BOM,
    tabId,
    filters: filters[SHEETS.BOM],
    enabled: !!filters[SHEETS.BOM],
  });
  const { data: plantData, refetch: refetchPlant } = useTabProcQuery<MENU_ID, SHEETS.PLANT>({
    menuId: MENU_ID,
    sheetName: SHEETS.PLANT,
    tabId,
    filters: filters[SHEETS.PLANT],
    enabled: !!filters[SHEETS.PLANT],
  });

  // 참조 안정화(nscm-patterns §5-4). division 변경 시 새 [] 로 비운다.
  const siteRows = useMemo(
    () => siteData?.site ?? [],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [siteData, searchParams.divisionId]
  );
  const bomRows = useMemo(() => bomData?.bom ?? [], [bomData]);
  const plantRows = useMemo(() => plantData?.plant ?? [], [plantData]);

  // 동적 월 컬럼 = Period From/To 파생(design/03 §2). Period 변경 시 재빌드.
  const monthColumns = useMemo(
    () => buildMonthColumns(searchParams.fromYyyymm, searchParams.toYyyymm),
    [searchParams.fromYyyymm, searchParams.toYyyymm]
  );

  // R11(design/03 §3.2) — BOM reload 시 Main 해당 행 PLANT_PER_ITEM = nInput/nTot 파생표시.
  //   nTot=BOM 행수, nInput=PRIMARY_PLANT 비어있지 않은 행수. 재조회 없이 해당 행만 갱신.
  useEffect(() => {
    if (!siteKey || bomRows.length === 0) return;
    const nTot = bomRows.length;
    const nInput = bomRows.filter(r => String(r.PRIMARY_PLANT ?? '').trim() !== '').length;
    const grid = mainGridRef.current;
    const source = grid?.collectionView?.sourceCollection as unknown as SiteRow[] | undefined;
    const target = source?.find(
      r =>
        String(r.DIVISION_ID ?? '') === siteKey.divisionId &&
        String(r.SCM_SITE_ID ?? '') === siteKey.scmSiteId &&
        String(r.ITEM_ID ?? '') === siteKey.itemId &&
        String(r.PROJECT_CODE ?? '') === siteKey.projectCode
    );
    if (target) {
      (target as Record<string, unknown>).PLANT_PER_ITEM = `${nInput}/${nTot}`;
      grid?.collectionView?.refresh();
    }
  }, [bomRows, siteKey]);

  // CELL_TYPE 'CA*' 는 Plant 편집불가(design/03 R-EDIT).
  const plantReadOnly = (bomKey?.cellType ?? '').toUpperCase().startsWith('CA');

  // ---- mount 1회 컬럼 메타 fetch(admin 즉시반영 baseline) ----
  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // ---- Button 핸들러 ----
  const handleSearch = useCallback(() => {
    setFilters();
    void fetchStaticColumns();
  }, [setFilters, fetchStaticColumns]);

  // Insert(design/03 R-INS-DEF) — BOM 더블클릭 선행 필수(MSG00116). 신규행 기본값 5종 세팅.
  const handleInsert = () => {
    if (!isBomClicked || !siteKey || !bomKey || !bomKey.itemId) {
      void setAlert({
        type: 'alert',
        content: t(MSG.INSERT_NEED_BOM, '_BOM Item 을 먼저 더블클릭하세요.'),
      });
      return;
    }
    const grid = plantGridRef.current;
    if (!grid) return;
    GridAction.addRow(grid, {
      DIVISION_ID: siteKey.divisionId,
      SCM_SITE_ID: siteKey.scmSiteId,
      PROJECT_CODE: siteKey.projectCode,
      ITEM_ID: bomKey.itemId,
      VALID_YN: 'Y',
    });
  };

  // Delete(design/03 R-DEL) — 신규행('I')만 제거. 기존행은 삭제 불가.
  const handleDelete = () => {
    const grid = plantGridRef.current;
    const sel = grid?.selectedItems?.[0] as PlantRow | undefined;
    if (!grid || !sel || sel.CRUD_TYPE !== 'I') {
      void setAlert({ type: 'alert', content: t('LBL00666', '_신규 행만 삭제할 수 있습니다.') });
      return;
    }
    GridAction.removeRow(grid);
  };

  // 저장검증 실패 셀 하이라이트(design/03 §3.4 SetBGColor). 뷰행 index 로 배경색 직접 지정.
  //   주의: Wijmo 는 스크롤/refresh 시 셀 DOM 을 재활용해 이 배경이 지워질 수 있다(persistent 하이라이트는
  //   formatItem + IS_PASS_N* 플래그가 정석 — 04_react-gap 잔여 gap 기재). 저장 차단·MSG 는 정상 동작.
  const markInvalidCells = (cells: { row: PlantRow; column: string }[]) => {
    const grid = plantGridRef.current;
    if (!grid) return;
    const items = grid.collectionView?.items ?? [];
    cells.forEach(({ row, column }) => {
      const viewRow = items.indexOf(row);
      const col = grid.columns.findIndex(c => c.binding === column);
      if (viewRow >= 0 && col >= 0) {
        const cellEl = grid.cells.getCellElement(viewRow, col);
        cellEl?.style.setProperty('background-color', '#ffd7d7', 'important');
      }
    });
  };

  // Save(design/03 §4.4) — 검증 N1~N9 통과 후 ^-delim CLOB 로 SAVE_PLANT 호출.
  const handleSave = async () => {
    const grid = plantGridRef.current;
    if (!grid) return;
    grid.finishEditing();
    const source = (grid.collectionView?.sourceCollection ?? []) as unknown as PlantRow[];
    const changed = source.filter(r => r.CRUD_TYPE === 'I' || r.CRUD_TYPE === 'M');
    if (changed.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_CHANGE, '_수정한 내용이 없습니다.') });
      return;
    }

    // 검증은 화면 전체 VALID_YN='Y' 행 대비(design/03 §3.4 중첩/연속성 등).
    const v = validatePlantSave(source);
    if (!v.ok) {
      markInvalidCells(v.invalidCells);
      void setAlert({ type: 'alert', content: t(v.msgId ?? MSG.SAVE_ERROR, '_저장 검증 실패') });
      return;
    }

    const userId = sessionUserId ?? '';
    const acc: Record<string, string[]> = {
      activeFlag: [],
      prioritySeq: [],
      divisionId: [],
      projectCode: [],
      scmSiteId: [],
      plantSiteId: [],
      itemId: [],
      priority: [],
      fromYyyymmdd: [],
      toYyyymmdd: [],
      validYn: [],
      // createdBy/lastUpdatedBy 키는 BE 세션 덮어쓰기 회피 위해 List 접미(nscm-patterns §5-11).
      createdByList: [],
      creationDate: [],
      lastUpdatedByList: [],
    };
    const ymd8 = (v2: unknown) => safeString(v2).replace(/\D/g, '');
    for (const r of changed) {
      const rec = r as Record<string, unknown>;
      const isInsert = r.CRUD_TYPE === 'I';
      acc.activeFlag.push(isInsert ? 'I' : 'M');
      acc.prioritySeq.push(safeString(rec.PRIORITY_SEQ));
      acc.divisionId.push(safeString(rec.DIVISION_ID));
      acc.projectCode.push(safeString(rec.PROJECT_CODE));
      acc.scmSiteId.push(safeString(rec.SCM_SITE_ID));
      acc.plantSiteId.push(safeString(rec.PLANT_SITE_ID));
      acc.itemId.push(safeString(rec.ITEM_ID));
      acc.priority.push(safeString(rec.PRIORITY));
      acc.fromYyyymmdd.push(ymd8(rec.FROM_YYYYMMDD));
      acc.toYyyymmdd.push(ymd8(rec.TO_YYYYMMDD));
      acc.validYn.push(safeString(rec.VALID_YN));
      acc.createdByList.push(isInsert ? userId : safeString(rec.CREATED_BY));
      acc.creationDate.push(isInsert ? '' : safeString(rec.CREATION_DATE));
      acc.lastUpdatedByList.push(userId);
    }
    const payload: Record<string, string> = {};
    for (const [k, arr] of Object.entries(acc)) payload[k] = arr.join('^');

    try {
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${SHEETS.PLANT}/SAVE/call-proc`,
        payload
      );
      // false-success 차단(nscm-patterns §5-10) — 인터셉터가 500 도 resolve.
      if (res.status >= 400 || Number(res.data?.code)) {
        const reason =
          (res.data as { message?: string })?.message?.trim() ||
          t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.');
        void setAlert({ type: 'alert', content: reason });
        return;
      }
      void setToast({ type: 'success', message: t(MSG.SAVE_RESULT, '_저장되었습니다.') });
      plantEditTrackerRef.current?.clearChanges();
      void refetchPlant(); // 저장 후 Plant 재조회(design/03 §4.4)
    } catch (e) {
      const msg = e instanceof Error ? e.message : t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.');
      void setAlert({ type: 'alert', content: msg });
    }
  };

  // Input All(btnAllFind, design/01 R5) — SCM0002_ProjectRouteListSavePopup 일괄등록 팝업.
  //   해당 팝업은 별도 화면(SCM0002)이라 본 화면 폴더 밖(Hard Boundary). 미변환 상태를 정직 고지.
  const handleInputAll = () => {
    void setAlert({
      type: 'alert',
      content: t(
        'MSG_NOT_CONVERTED',
        '_Input All 일괄등록 팝업(SCM0002)은 아직 전환되지 않았습니다. 별도 화면 전환 후 연결됩니다.'
      ),
    });
  };

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    save: hasButton('SAVE') ? handleSave : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    manual: false,
    upload: false,
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && <ProjectRouteForm onSearch={handleSearch} />}
      <SubTitle
        menuId={MENU_ID}
        grid={plantGridRef}
        gridFilter={plantFilterRef}
        dataCount={plantRows.length}
        excelFileName='ProjectRoute'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
        customButtons={[
          {
            label: t('LBL_INPUT_ALL', '_Input All'),
            title: t('LBL_INPUT_ALL', '_Input All'),
            action: handleInputAll,
            buttonLabel: '',
          },
        ]}
      />
      <PanelGroup className={styles.tableWrapper} orientation='vertical'>
        <Panel defaultSize={40} minSize={15}>
          <ProjectRouteMainGrid
            gridRef={mainGridRef}
            gridFilterRef={mainFilterRef}
            data={siteRows}
            staticColumns={staticColumns[RESPONSE_SET.SITE]}
            monthColumns={monthColumns}
            divisionId={searchParams.divisionId}
            onRowDblClick={applySiteKey}
          />
        </Panel>
        <PanelSeparator className={styles.splitBar} />
        <Panel defaultSize={60} minSize={20}>
          <PanelGroup orientation='horizontal'>
            <Panel defaultSize={50} minSize={20}>
              <ProjectRouteBomGrid
                gridRef={bomGridRef}
                gridFilterRef={bomFilterRef}
                data={bomRows}
                staticColumns={staticColumns[RESPONSE_SET.BOM]}
                onRowDblClick={applyBomKey}
              />
            </Panel>
            <PanelSeparator className={styles.splitBar} />
            <Panel defaultSize={50} minSize={20}>
              <ProjectRoutePlantGrid
                gridRef={plantGridRef}
                gridFilterRef={plantFilterRef}
                editTrackerRef={plantEditTrackerRef}
                data={plantRows}
                staticColumns={staticColumns[RESPONSE_SET.PLANT]}
                siteKey={siteKey}
                bomKey={bomKey}
                readOnly={plantReadOnly}
              />
            </Panel>
          </PanelGroup>
        </Panel>
      </PanelGroup>
    </>
  );
};
