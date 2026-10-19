import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { CapaNewModelPopup } from 'features/master/src/components';
import { type RefObject, useCallback, useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction, safeString } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import {
  useSaveWithValidation,
  useTabBtnPermissions,
  useTabComboQueries,
  useTabProcQuery,
} from '@shared/hooks';
import { TitleArea } from '@shared/lges';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore, useSessionStore, useUIStore } from '@shared/stores';

import { ProjectRouteListSaveModal } from './components/modals/ProjectRouteListSaveModal';
import { ProjectRouteBomGrid } from './components/ProjectRouteBomGrid';
import { ProjectRouteForm } from './components/ProjectRouteForm';
import { ProjectRouteMainGrid } from './components/ProjectRouteMainGrid';
import { ProjectRoutePlantGrid } from './components/ProjectRoutePlantGrid';
import { useProjectRouteValidation } from './hooks/useProjectRouteValidation';
import {
  COLUMN_SHEET_NAME,
  COMBO,
  EXCLUDE_EE_DIVISION,
  LBL,
  MENU_ID,
  MSG,
  RESPONSE_SET,
  SHEETS,
} from './project-route.constants';
import type { BomRow, PlantRow, SiteRow } from './project-route.types';
import styles from './ProjectRoute.module.scss';
import { useProjectRouteStore } from './useProjectRouteStore';
import { buildMonthColumns } from './utils/projectRoute.calendar';
import { submitPlantSaveRequest } from './utils/projectRoute.plantSaveRequest';

export const ProjectRoute = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const { setAlert, setToast } = useMessageStore.getState();
  const setProgress = useUIStore.getState().setProgress;
  const sessionUserId = useSessionStore(s => s.session.userId);

  const mainGridRef = useRef<FlexGrid<SiteRow>>();
  const bomGridRef = useRef<FlexGrid<BomRow>>();
  const plantGridRef = useRef<FlexGrid<PlantRow>>();
  const mainFilterRef = useRef<FlexGridFilter>();
  const bomFilterRef = useRef<FlexGridFilter>();
  const plantFilterRef = useRef<FlexGridFilter>();
  const plantEditTrackerRef = useRef<EditTracker<PlantRow>>();

  // 3 그리드(Main/BOM/Plant)가 한 화면에 공존한다. 메인화면 그리드는 DataGrid 가 F3/F4 를 자체
  //   등록하지 않고(scopeId===null → DataGrid.tsx 참조) SubTitle 이 F4 를 전담하는데, SubTitle 은
  //   넘겨받은 grid 하나만 대상으로 하고 그 grid.containsFocus() 일 때만 F4 가 동작한다. 따라서
  //   SubTitle 에 넘기는 grid/gridFilter 를 "지금 포커스된 그리드" 로 바꿔줘야 F4 가 포커스 그리드에
  //   걸린다(Formation 동일 패턴). 각 그리드 gotFocus 로 activeSheet 를 갱신 → 재렌더로 반영.
  const [activeSheet, setActiveSheet] = useState<RESPONSE_SET>(RESPONSE_SET.SITE);
  const gridRefs: Record<RESPONSE_SET, RefObject<FlexGrid | undefined>> = {
    [RESPONSE_SET.SITE]: mainGridRef,
    [RESPONSE_SET.BOM]: bomGridRef,
    [RESPONSE_SET.PLANT]: plantGridRef,
  };
  const gridFilterRefs: Record<RESPONSE_SET, RefObject<FlexGridFilter | undefined>> = {
    [RESPONSE_SET.SITE]: mainFilterRef,
    [RESPONSE_SET.BOM]: bomFilterRef,
    [RESPONSE_SET.PLANT]: plantFilterRef,
  };

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
  const { saveWithValidation } = useSaveWithValidation();

  // Input All 버튼 disabled 판정용(design/01 R1). 콤보 조회는 ProjectRouteForm 과 동일
  //   queryKey 를 공유해 react-query 캐시가 재사용되므로 추가 네트워크 요청은 없다.
  // ProjectRouteForm 과 동일 EE 제외 후처리(project-route.constants.ts COMBO.DIVISION 주석) — 같은
  //   queryKey 라 react-query 캐시를 공유, 추가 네트워크 요청 없음.
  const [divisionsRaw] = useTabComboQueries({ filters: [COMBO.DIVISION] });
  const divisions = useMemo(() => divisionsRaw?.filter(EXCLUDE_EE_DIVISION), [divisionsRaw]);
  const noDivisionAuth = divisions !== undefined && divisions.length === 0;

  // ---- 3 시트 조회(연쇄 enabled 게이트) ----
  const { data: siteData } = useTabProcQuery<MENU_ID, SHEETS.SITE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SITE,
    tabId,
    filters: filters[SHEETS.SITE],
    enabled: !!filters[SHEETS.SITE],
  });
  const { data: bomData, refetch: refetchBom } = useTabProcQuery<MENU_ID, SHEETS.BOM>({
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

  // R-RESTORE(design/03 §3 R-RESTORE, cs L618-629) — AfterFindDataBOM 이후 이전에 더블클릭했던
  //   Main/BOM 셀 위치로 스크롤·선택을 복원한다(Plant 는 AS-IS 도 복원 없음 — 매 조회 최상단 유지).
  //   G9 교정(04_impl-gap-audit): BOM 재조회(Main 더블클릭 후 최초 진입 + Save 후 refetchBom 공통)
  //   마다 Main/BOM 그리드의 선택 표시를 siteKey/bomKey 로 되돌린다.
  useEffect(() => {
    if (!siteKey) return;
    const grid = mainGridRef.current;
    if (!grid) return;
    const idx = grid.rows.findIndex(row => {
      const r = row?.dataItem as SiteRow | undefined;
      return (
        !!r &&
        String(r.DIVISION_ID ?? '') === siteKey.divisionId &&
        String(r.SCM_SITE_ID ?? '') === siteKey.scmSiteId &&
        String(r.ITEM_ID ?? '') === siteKey.itemId &&
        String(r.PROJECT_CODE ?? '') === siteKey.projectCode
      );
    });
    if (idx >= 0) {
      grid.select(idx, Math.max(0, grid.selection.col));
      grid.scrollIntoView(idx, -1);
    }
  }, [bomRows, siteKey]);

  useEffect(() => {
    if (!bomKey) return;
    const grid = bomGridRef.current;
    if (!grid) return;
    const idx = grid.rows.findIndex(row => {
      const r = row?.dataItem as BomRow | undefined;
      return (
        !!r &&
        String(r.ITEM_ID ?? '') === bomKey.itemId &&
        String(r.OPERATION_GROUP_ID ?? '') === bomKey.operationId
      );
    });
    if (idx >= 0) {
      grid.select(idx, Math.max(0, grid.selection.col));
      grid.scrollIntoView(idx, -1);
    }
  }, [bomRows, bomKey]);

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
  //   G2 교정(04_impl-gap-audit): AS-IS EditButton()(design/03 §4 L493-527)은 CA*(외주) 선택 시
  //   Edit 진입 자체를 무반응(메시지 없음) 차단해 Insert 로직에 도달하지 못한다 — plantReadOnly 로
  //   동일 조건 재현. BOM 미선택(MSG00116)과 달리 CA* 는 alert 없이 조용히 무시한다.
  const handleInsert = () => {
    if (plantReadOnly) return;
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
  //   G8 교정(04_impl-gap-audit): AS-IS DeleteButton()(L482 미선택, L484-488 기존행)은 두 경우 모두
  //   메시지 없이 무반응이다(00_checklist.md §4d hasMessage=false) — alert 를 내지 않는다.
  const handleDelete = () => {
    const grid = plantGridRef.current;
    const sel = grid?.selectedItems?.[0] as PlantRow | undefined;
    if (!grid || !sel || sel.CRUD_TYPE !== 'I') return;
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

  // 실제 SAVE_PLANT 호출(payload 조립 + false-success 판별, utils/projectRoute.plantSaveRequest 공용).
  //   saveWithValidation 의 메타 필수검증 통과 후에만 호출된다. Input All 팝업의 Save 도 동일 유틸 사용
  //   (AS-IS 도 같은 SP `SCP.SCP0006_SAVE_PROJECT_ROUTE_PLANT` 를 호출 — Roslyn 실측).
  const submitPlantSave = async (changed: PlantRow[]) => {
    const result = await submitPlantSaveRequest(changed, sessionUserId ?? '');
    if (!result.ok) {
      void setAlert({
        type: 'alert',
        content: result.message ?? t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.'),
      });
      return;
    }
    void setToast({ type: 'success', message: t(MSG.SAVE_RESULT, '_저장되었습니다.') });
    plantEditTrackerRef.current?.clearChanges();
    // 저장 후 BOM+Plant 동시 재조회(design/03 §4.5 — AS-IS SaveData()가 SAVE_PLANT+GET_BOM+GET_PLANT
    //   를 한 배치로 실행. BOM 의 PRIMARY_PLANT 갱신 → R11 파생(PLANT_PER_ITEM)의 최신화 근거).
    //   G3 교정(04_impl-gap-audit): 개별 fire-and-forget 2회는 원자성이 약해 과도기적으로 BOM/Plant가
    //   서로 다른 시점의 데이터를 보일 수 있었다 — Promise.all 로 두 재조회를 함께 대기한다.
    void Promise.all([refetchBom(), refetchPlant()]);
  };

  // Save(design/03 §4.4) — 검증 N1~N9 통과 후 ^-delim CLOB 로 SAVE_PLANT 호출.
  //   H1 교정(04_impl-gap-audit): 공통 saveWithValidation 로 메타 필수(INPUT_TP_CD=M/IM) 컬럼
  //   빈값(PLANT_SITE_ID/PRIORITY/FROM/TO 등)을 커스텀 N1~N9 뒤에 추가 차단 — N7 은 PRIORITY 형식만
  //   보고 빈값 자체는 걸러내지 못해 필수값 누락 신규행이 저장으로 샐 수 있었다(SCP0020 동형 사고).
  const handleSave = () => {
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
      // N8-a(design/03 §3)는 AS-IS 가 메시지 없이 조용히 저장을 막는 유일한 분기 — alert 생략.
      if (!v.silent) {
        void setAlert({ type: 'alert', content: t(v.msgId ?? MSG.SAVE_ERROR, '_저장 검증 실패') });
      }
      return;
    }

    saveWithValidation(changed, staticColumns[RESPONSE_SET.PLANT], rows => void submitPlantSave(rows));
  };

  // Input All(btnAllFind, design/01 R5) — SCM0002_ProjectRouteListSavePopup 일괄등록 팝업.
  //   AS-IS 소스(GSCM/06.UIL/GSCM.SCM.Popup.UIL/SCM0002_ProjectRouteListSavePopup.cs) 실측 반영.
  const [openInputAllModal, setOpenInputAllModal] = useState(false);
  const handleInputAll = () => setOpenInputAllModal(true);

  // A5(design/03, cs L1389-1446) — Plant Assign 더블클릭 → CAPA New Model 팝업(공용 컴포넌트,
  //   SCP0049_CAPA/SCP0201_CAPA 와 공유 — .atlas/gscm-design/SCP0049 참고). 팝업 자체는 UI 만
  //   완성된 상태(SP 미배포, capa-new-model-popup.constants.ts 헤더 참고).
  const [capaPopupParams, setCapaPopupParams] = useState<{
    divisionId: string;
    plantId: string;
    groupId: string;
    operationId: string;
    itemId: string;
  } | null>(null);
  const handlePlantDblClick = (row: PlantRow) => {
    const rec = row as Record<string, unknown>;
    setCapaPopupParams({
      divisionId: siteKey?.divisionId ?? '',
      plantId: safeString(rec.PLANT_ID),
      groupId: safeString(rec.OPERATION_GROUP_ID),
      operationId: safeString(rec.OPERATION_ID),
      itemId: safeString(rec.ITEM_ID),
    });
  };

  // Excel Download 대상(AS-IS BaseForm.ExcelButton, GSCM 01.Framework/GSCM.Windows.Forms/UI/BaseForm.cs:4151
  //   실측) 재현 — AS-IS 는 포커스된 Spread 를 내보내고, 포커스가 없으면 보이는 첫 Spread(Main)를 쓴다.
  //   SubTitle 기본 동작은 grid prop(Plant) 고정이라, Main만 조회하고 바로 Excel 을 누르면(Plant 미선택)
  //   빈 파일이 나가는 AS-IS 대비 회귀가 있었다 — 여기서 focus 우선/Main 폴백으로 override 한다.
  const handleExcelDownload = () => {
    const target =
      [mainGridRef.current, bomGridRef.current, plantGridRef.current].find(g =>
        g?.containsFocus()
      ) ?? mainGridRef.current;
    if (!target) return;
    void GridAction.excelDownload(target, 'ProjectRoute', setProgress);
  };

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    save: hasButton('SAVE') ? handleSave : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    excel: handleExcelDownload,
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
      {/* 3 그리드(Main/BOM Explosion/Plant Assign)가 항상 동시에 보이므로, 상단 툴바 줄의 건수
          배지는 어느 그리드인지 모호해 숨기고 각 그리드 제목 줄에서 나눠 표시한다
          (GroupUser.tsx/AuthRequest.tsx 동일 패턴 — hideTotalCases). 툴바 동작 대상은 그대로 Plant. */}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRefs[activeSheet]}
        gridFilter={gridFilterRefs[activeSheet]}
        dataCount={plantRows.length}
        hideTotalCases
        excelFileName='ProjectRoute'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
        customButtons={[
          // Input All(btnAllFind, design/01 R5) — 검색영역이 아닌 그리드 툴바(Save 좌측)로 배치.
          {
            label: t(LBL.INPUT_ALL, '_Input All'),
            action: handleInputAll,
            disabled: noDivisionAuth,
          },
        ]}
      />
      <PanelGroup className={styles.tableWrapper} orientation='vertical'>
        <Panel defaultSize={40} minSize={15}>
          {/* 그리드별 건수 표시(위 hideTotalCases 참고). Main 은 화면의 주 그리드라 제목 없이 건수만. */}
          <div className={styles.gridSection}>
            <TitleArea
              isSubTitle
              title=''
              depth='h4'
              totalCases={siteRows.length === 0 ? undefined : siteRows.length}
            />
            <ProjectRouteMainGrid
              gridRef={mainGridRef}
              gridFilterRef={mainFilterRef}
              data={siteRows}
              staticColumns={staticColumns[RESPONSE_SET.SITE]}
              monthColumns={monthColumns}
              divisionId={searchParams.divisionId}
              onRowDblClick={applySiteKey}
              gotFocus={() => setActiveSheet(RESPONSE_SET.SITE)}
            />
          </div>
        </Panel>
        <PanelSeparator className={styles.splitBarRow} />
        <Panel defaultSize={60} minSize={20}>
          <PanelGroup orientation='horizontal'>
            <Panel defaultSize={50} minSize={20}>
              <div className={styles.gridSection}>
                <TitleArea
                  isSubTitle
                  title={COLUMN_SHEET_NAME[RESPONSE_SET.BOM]}
                  depth='h4'
                  totalCases={bomRows.length === 0 ? undefined : bomRows.length}
                />
                <ProjectRouteBomGrid
                  gridRef={bomGridRef}
                  gridFilterRef={bomFilterRef}
                  data={bomRows}
                  staticColumns={staticColumns[RESPONSE_SET.BOM]}
                  onRowDblClick={applyBomKey}
                  gotFocus={() => setActiveSheet(RESPONSE_SET.BOM)}
                />
              </div>
            </Panel>
            <PanelSeparator className={styles.splitBarCol} />
            <Panel defaultSize={50} minSize={20}>
              <div className={styles.gridSection}>
                <TitleArea
                  isSubTitle
                  title={COLUMN_SHEET_NAME[RESPONSE_SET.PLANT]}
                  depth='h4'
                  totalCases={plantRows.length === 0 ? undefined : plantRows.length}
                />
                <ProjectRoutePlantGrid
                  gridRef={plantGridRef}
                  gridFilterRef={plantFilterRef}
                  editTrackerRef={plantEditTrackerRef}
                  data={plantRows}
                  staticColumns={staticColumns[RESPONSE_SET.PLANT]}
                  siteKey={siteKey}
                  bomKey={bomKey}
                  readOnly={plantReadOnly}
                  onRowDblClick={handlePlantDblClick}
                  gotFocus={() => setActiveSheet(RESPONSE_SET.PLANT)}
                />
              </div>
            </Panel>
          </PanelGroup>
        </Panel>
      </PanelGroup>
      <ProjectRouteListSaveModal
        open={openInputAllModal}
        onClose={() => setOpenInputAllModal(false)}
        divisionId={searchParams.divisionId}
        divisionName={divisions?.find(d => d.CODE === searchParams.divisionId)?.NAME}
        onSaved={handleSearch}
      />
      <CapaNewModelPopup
        open={!!capaPopupParams}
        onClose={() => setCapaPopupParams(null)}
        params={capaPopupParams ?? undefined}
      />
    </>
  );
};
