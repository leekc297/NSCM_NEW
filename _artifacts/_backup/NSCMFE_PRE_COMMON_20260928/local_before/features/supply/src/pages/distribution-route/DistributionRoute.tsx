import { FileExceluploadIcon } from '@lges/design-system/icon';
import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { RegionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction, GridUtils } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { DistributionRouteForm } from './components/DistributionRouteForm';
import { DistributionRouteGrid } from './components/DistributionRouteGrid';
import { ExcelUploadModal } from './components/modals/ExcelUploadModal';
import { MENU_ID, MSG, SHEETS } from './distribution-route.constants';
import type { DistributionRouteRow } from './distribution-route.types';
import styles from './DistributionRoute.module.scss';
import { useDistributionRouteValidation } from './hooks/useDistributionRouteValidation';
import { useDistributionRouteStore } from './useDistributionRouteStore';
import { routeInsertDefaults } from './utils/distributionRoute.editLock';
import { submitRouteSaveRequest } from './utils/distributionRoute.saveRequest';

type RegionMode = 'search-from' | 'search-to' | 'cell-from' | 'cell-to' | null;

// AS-IS GSCM.SCP.Master.UIL SCP0005_DistributionRoute — 단일 그리드 마스터 편집 화면.
//   설계: .atlas/gscm-design/SCP0005/design/00~03. 상세 매핑: __asis-mapping__.md.
export const DistributionRoute = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const sessionUserId = useSessionStore(s => s.session.userId);
  const { validateRows } = useDistributionRouteValidation();
  // 필수 컬럼(메타 INPUT_TP_CD=M/IM 또는 라벨 *) 저장검증 — 전 화면 공통.
  const { saveWithValidation } = useSaveWithValidation();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();

  const sc = useDistributionRouteStore(s => s.searchCondition);
  const setSearchCondition = useDistributionRouteStore(s => s.setSearchCondition);
  const filters = useDistributionRouteStore(s => s.filters);
  const setFilter = useDistributionRouteStore(s => s.setFilter);
  const openSearchArea = useDistributionRouteStore(s => s.openSearchArea);
  const setOpenSearchArea = useDistributionRouteStore(s => s.setOpenSearchArea);
  const staticColumns = useDistributionRouteStore(s => s.staticColumns);
  const fetchStaticColumns = useDistributionRouteStore(s => s.fetchStaticColumns);
  const initialized = useDistributionRouteStore(s => s.initialized);

  const [regionMode, setRegionMode] = useState<RegionMode>(null);
  const [openExcelUpload, setOpenExcelUpload] = useState(false);
  const clickedRowRef = useRef<DistributionRouteRow | null>(null);
  const clickedIndexRef = useRef<number>(-1);

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.ROUTE>({
    menuId: MENU_ID,
    sheetName: SHEETS.ROUTE,
    tabId,
    filters: filters[SHEETS.ROUTE],
    enabled: !!filters[SHEETS.ROUTE],
  });
  const rows = useMemo<DistributionRouteRow[]>(() => data?.o_rc1 ?? [], [data]);

  // 저장 조립기 호출 래퍼 — 컬럼별 '^'-fold payload 로 SAVE_ROUTE 호출(SCP0006 submitPlantSave 동형).
  //   성공 시 편집마킹 해제 + 재조회, 실패 시 사유 Toast(false-success 는 조립기가 이미 걸러 ok=false).
  const submitRouteSave = async (changed: DistributionRouteRow[]) => {
    const result = await submitRouteSaveRequest(changed, sessionUserId ?? '');
    if (!result.ok) {
      setToast({ type: 'error', message: result.message ?? t(MSG.SAVE_DUP, '_저장에 실패하였습니다.') });
      return;
    }
    setToast({ type: 'success', message: t(MSG.SAVE_SUCCESS, '_저장되었습니다.') });
    editTrackerRef.current?.clearChanges();
    void refetch();
  };

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const handleSearch = () => {
    setFilter();
    void fetchStaticColumns();
  };

  // 신규행 — 빈 route 행 + VALID_YN='Y' (design 03 R6). AS-IS Edit 전제(M5)는 NSCM 상시편집 표준으로
  //   대체(sister screen SCP0020 선례) — 신규 route 는 상위 복사원본이 없는 독립 행이라 조회 전제 불요.
  const handleInsert = () => {
    const grid = gridRef.current;
    if (!grid) return;
    GridAction.addRow(grid, routeInsertDefaults());
  };

  // 삭제 — 신규행('I')만 즉시 제거, 기존행 삭제 차단 (design 03 R18 / M8 — deleteOnlyNew=true).
  const handleDelete = () => {
    const grid = gridRef.current;
    if (!grid) return;
    GridAction.removeRow(grid, true);
  };

  // 저장검증 실패 셀 하이라이트 (design 03 R16 리셋 + R17 InvalidColor). sister SCP0006 markInvalidCells 동형.
  //   R16: 재검증 시작 시 직전 마킹 원복 → R17: 위반 셀 배경 지정. 뷰행 index 로 셀 DOM 배경 직접 지정.
  //   주의: Wijmo 는 스크롤/refresh 시 셀 DOM 을 재활용해 배경이 지워질 수 있다(persistent 하이라이트는
  //   formatItem 플래그가 정석 — 04_react-gap 잔여 gap). 저장 응답색(R14/R15 99010/99020)은 SP 배포 후 런타임.
  const markedCellsRef = useRef<HTMLElement[]>([]);
  const markInvalidCells = (cells: { row: Record<string, unknown>; column: string }[]) => {
    markedCellsRef.current.forEach(el => el.style.removeProperty('background-color'));
    markedCellsRef.current = [];
    const grid = gridRef.current;
    if (!grid) return;
    const items = (grid.collectionView?.items ?? []) as Record<string, unknown>[];
    cells.forEach(({ row, column }) => {
      const viewRow = items.indexOf(row);
      const col = grid.columns.findIndex(c => c.binding === column);
      if (viewRow >= 0 && col >= 0) {
        const cellEl = grid.cells.getCellElement(viewRow, col);
        if (cellEl) {
          cellEl.style.setProperty('background-color', '#ffd7d7', 'important');
          markedCellsRef.current.push(cellEl);
        }
      }
    });
  };

  const handleSave = () => {
    const grid = gridRef.current;
    grid?.finishEditing();
    const src = (grid?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    const dirty = src.filter(r => r.CRUD_TYPE);
    if (dirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No changes.') });
      return;
    }
    // 클라 검증(R17/G4) 통과 후 메타 필수검증(saveWithValidation) → mutate.
    const v = validateRows(dirty);
    if (!v.ok) {
      markInvalidCells(v.invalidCells);
      return;
    }
    markInvalidCells([]);
    saveWithValidation(
      dirty as unknown as DistributionRouteRow[],
      staticColumns[SHEETS.ROUTE],
      changed => void submitRouteSave(changed)
    );
  };

  // 도시팝업 반환값 반영 (design 02 §4.6 조회조건 / design 03 R11·R12 그리드 셀).
  const setRegion = (
    countryCode: string,
    _countryName: string,
    cityCode: string,
    cityName: string
  ) => {
    if (regionMode === 'search-from') {
      setSearchCondition({ fromCountry: countryCode, fromCity: cityCode });
      return;
    }
    if (regionMode === 'search-to') {
      setSearchCondition({ toCountry: countryCode, toCity: cityCode });
      return;
    }
    const grid = gridRef.current;
    const row = clickedRowRef.current;
    const idx = clickedIndexRef.current;
    if (!grid || !row || idx < 0) return;
    const prefix = regionMode === 'cell-from' ? 'FROM' : 'TO';
    const countryCol = `${prefix}_COUNTRY`;
    const cityCol = `${prefix}_CITY`;
    const nameCol = `${prefix}_CITY_NAME`;
    const tracker = editTrackerRef.current;
    const r = row as Record<string, unknown>;
    tracker?.storeChange(row as never, countryCol, r[countryCol] as never, countryCode as never);
    tracker?.storeChange(row as never, cityCol, r[cityCol] as never, cityCode as never);
    tracker?.storeChange(row as never, nameCol, r[nameCol] as never, cityName as never);
    r[countryCol] = countryCode;
    r[cityCol] = cityCode;
    r[nameCol] = cityName;
    GridUtils.refreshRow(grid, idx);
  };

  const openCellRegion = (row: DistributionRouteRow, rowIndex: number, mode: RegionMode) => {
    clickedRowRef.current = row;
    clickedIndexRef.current = rowIndex;
    setRegionMode(mode);
  };

  const regionCountry =
    regionMode === 'search-from'
      ? sc.fromCountry
      : regionMode === 'search-to'
        ? sc.toCountry
        : '';
  const regionCity =
    regionMode === 'search-from' ? sc.fromCity : regionMode === 'search-to' ? sc.toCity : '';

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    save: hasButton('SAVE') ? handleSave : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    manual: false,
    upload: false,
  };

  // Excel Upload (design 01 §2-E1). Excel Form(btnExcel_Form)은 AS-IS 숨김(R1) — 렌더하지 않음.
  //   버튼 코드 = 'UPLOAD'(SCM_ADM_MNU_BTN_MPG_M 등록 실측, API=P_SCP0005_EXCEL_UPLOAD). 'EXCEL'(다운로드)
  //   코드로 게이트하면 미등록이라 hasButton=false → 업로드 버튼이 숨는다(gap-resolve iter-1 정정).
  const customButtons = [
    ...(hasButton('UPLOAD')
      ? [
          {
            label: t('LBL00346', 'Excel Upload'),
            action: () => setOpenExcelUpload(true),
            iconComponent: <FileExceluploadIcon />,
            iconPosition: 'leading' as const,
          },
        ]
      : []),
  ];

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <DistributionRouteForm
          onSearch={handleSearch}
          onFromSearch={() => setRegionMode('search-from')}
          onToSearch={() => setRegionMode('search-to')}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='DistributionRoute'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        customButtons={customButtons}
        searchParam={sc}
      />

      <div className={styles.gridWrapper}>
        <DistributionRouteGrid
          rows={rows}
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          editTrackerRef={editTrackerRef}
          adminColumns={staticColumns[SHEETS.ROUTE]}
          onFromCellDblClick={(row, idx) => openCellRegion(row, idx, 'cell-from')}
          onToCellDblClick={(row, idx) => openCellRegion(row, idx, 'cell-to')}
          onRouteIdDblClick={() => {
            // ROUTE_ID 더블클릭 → Route 이력 상세팝업(SCP0005_DistributionRoutePopup, design 03 R8).
            //   상세팝업은 별도 화면 activity 위임(design 03 §6 #3) — 본 화면은 트리거만 배선.
          }}
          onFocus={() => undefined}
        />
      </div>

      {/* 도시검색 팝업 — 공용 RegionModal(SCM0002_CitybyCountry 대응, design 02 §4.6 / 03 R11·R12) */}
      <RegionModal
        open={regionMode !== null}
        modalClose={() => setRegionMode(null)}
        setSelectedValue={setRegion}
        country={regionCountry}
        city={regionCity}
      />

      {/* Excel 업로드 팝업 (design 01 §2-E1) — 완료 후 재조회 */}
      <ExcelUploadModal
        open={openExcelUpload}
        modalClose={() => setOpenExcelUpload(false)}
        onUploaded={() => void refetch()}
      />
    </>
  );
};
