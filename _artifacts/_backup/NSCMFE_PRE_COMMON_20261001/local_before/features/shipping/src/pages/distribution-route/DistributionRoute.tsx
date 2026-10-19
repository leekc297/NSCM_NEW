import { FileExceluploadIcon } from '@lges/design-system/icon';
import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { RegionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction, GridUtils, safeString } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { DistributionRouteForm } from './components/DistributionRouteForm';
import { DistributionRouteGrid } from './components/DistributionRouteGrid';
import { ExcelUploadModal } from './components/modals/ExcelUploadModal';
import {
  MENU_ID,
  MSG,
  R14_DUP_DATA_COLUMNS,
  R15_DUP_PRIORITY_COLUMNS,
  SAVE_ERR,
  SHEETS,
} from './distribution-route.constants';
import type { DistributionRouteRow, InvalidCell } from './distribution-route.types';
import styles from './DistributionRoute.module.scss';
import { useDistributionRouteValidation } from './hooks/useDistributionRouteValidation';
import { useDistributionRouteStore } from './useDistributionRouteStore';
import { routeInsertDefaults } from './utils/distributionRoute.editLock';
import { submitRouteSaveRequest } from './utils/distributionRoute.saveRequest';

type RegionMode = 'search-from' | 'search-to' | 'cell-from' | 'cell-to' | null;

// AS-IS GSCM.SCP.Forms.UIL SCP0005_DistributionRoute — 단일 그리드 마스터 편집 화면(domain SSP/Shipping).
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
  const clearFilters = useDistributionRouteStore(s => s.clearFilters);
  const initialized = useDistributionRouteStore(s => s.initialized);

  const [regionMode, setRegionMode] = useState<RegionMode>(null);
  const [openExcelUpload, setOpenExcelUpload] = useState(false);
  // 저장검증(R17/G4)·저장응답(R14/R15) 위반 셀 — 그리드 formatItem 영속 하이라이트(gap G3).
  const [invalidCells, setInvalidCells] = useState<InvalidCell[]>([]);
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

  // 저장 응답 중복오류(99010/99020) → 위반행 해당 구간 셀 색칠 대상 계산 (design 03 R14/R15, gap G2).
  //   SP 가 첫 중복행에서 raise 하며 O_RESULT_CURSOR 로 위반행 식별자를 되돌려준다(saveRequest 가 cause
  //   에서 회수). 그리드 실 dataItem 을 매칭해야 formatItem 하이라이트가 걸린다 — ROUTE_ID(기존행) 우선,
  //   없으면(신규행) FROM/TO·TRANSPORT_MODE 조합으로 매칭.
  const buildSaveErrorCells = (
    errCode: string | undefined,
    errorRow: Record<string, unknown> | undefined
  ): InvalidCell[] => {
    if (!errorRow) return [];
    if (errCode !== SAVE_ERR.DUP_DATA && errCode !== SAVE_ERR.DUP_PRIORITY) return [];
    const grid = gridRef.current;
    const items = (grid?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    const rid = safeString(errorRow.ROUTE_ID);
    const sameCombo = (r: Record<string, unknown>) =>
      safeString(r.FROM_COUNTRY) === safeString(errorRow.FROM_COUNTRY) &&
      safeString(r.FROM_CITY) === safeString(errorRow.FROM_CITY) &&
      safeString(r.TO_COUNTRY) === safeString(errorRow.TO_COUNTRY) &&
      safeString(r.TO_CITY) === safeString(errorRow.TO_CITY) &&
      safeString(r.TRANSPORT_MODE) === safeString(errorRow.TRANSPORT_MODE);
    let match = rid ? items.find(r => safeString(r.ROUTE_ID) === rid) : undefined;
    if (!match) match = items.find(sameCombo);
    if (!match) return [];
    const cols =
      errCode === SAVE_ERR.DUP_PRIORITY ? R15_DUP_PRIORITY_COLUMNS : R14_DUP_DATA_COLUMNS;
    return cols.map(column => ({ row: match, column }));
  };

  // 저장 조립기 호출 래퍼 — 컬럼별 '^'-fold payload 로 SAVE_ROUTE 호출(SCP0006 submitPlantSave 동형).
  //   성공 시 편집마킹·위반색 해제 + 재조회, 실패 시 사유 Toast + (중복오류면) 위반행 셀 색칠(R14/R15).
  const submitRouteSave = async (changed: DistributionRouteRow[]) => {
    const result = await submitRouteSaveRequest(changed, sessionUserId ?? '');
    if (!result.ok) {
      setInvalidCells(buildSaveErrorCells(result.errCode, result.errorRow));
      setToast({ type: 'error', message: result.message ?? t(MSG.SAVE_DUP, '_저장에 실패하였습니다.') });
      return;
    }
    setInvalidCells([]);
    setToast({ type: 'success', message: t(MSG.SAVE_SUCCESS, '_저장되었습니다.') });
    editTrackerRef.current?.clearChanges();
    void refetch();
  };

  useEffect(() => {
    // mount 시 조회조건 필터 초기화 — AS-IS Form_Load 자동조회 없음(design 02 §4). 탭 재오픈/persist
    //   잔존 filters 가 있으면 enabled 게이트가 켜져 stale 자동조회가 나갈 수 있어(keep-alive), 진입마다
    //   filters 를 비워 명시 Search 전까지 조회를 막는다(nscm-patterns §5-7).
    clearFilters();
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

  const handleSave = () => {
    const grid = gridRef.current;
    grid?.finishEditing();
    const src = (grid?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    const dirty = src.filter(r => r.CRUD_TYPE);
    if (dirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No changes.') });
      return;
    }
    // 재검증 시작 시 직전 위반색 리셋(R16) → 전 편집행 검증(R17/G4). 위반 셀은 formatItem 이 영속 색칠(G3).
    setInvalidCells([]);
    const v = validateRows(dirty);
    if (!v.ok) {
      setInvalidCells(v.invalidCells);
      return;
    }
    // 클라 검증 통과 후 메타 필수검증(saveWithValidation) → mutate.
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
          invalidCells={invalidCells}
          onFromCellDblClick={(row, idx) => openCellRegion(row, idx, 'cell-from')}
          onToCellDblClick={(row, idx) => openCellRegion(row, idx, 'cell-to')}
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
