import { FileExceluploadIcon } from '@lges/design-system/icon';
import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { RegionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction, GridUtils, safeString } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { FileExceldownloadIcon } from '@shared/lges-icons';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { DistributionRouteForm } from './components/DistributionRouteForm';
import { DistributionRouteGrid } from './components/DistributionRouteGrid';
import { ExcelUploadModal } from './components/modals/ExcelUploadModal';
import {
  ADMIN_SHEET_NAME,
  LBL,
  MENU_ID,
  MSG,
  R14_DUP_DATA_COLUMNS,
  R15_DUP_PRIORITY_COLUMNS,
  SAVE_ERR,
  SHEETS,
  TEMPLATE_EXCEL_PREFIX,
} from './distribution-route.constants';
import { FORM_COLUMNS } from './distribution-route.excelForm';
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
  const setAlert = useMessageStore.getState().setAlert;
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
      // 저장 실패는 사용자가 읽고 넘어가야 하는 메시지라 toast 가 아니라 alert 로 노출한다.
      void setAlert({ type: 'alert', content: result.message ?? t(MSG.SAVE_DUP, '_저장에 실패하였습니다.') });
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
    // 저장검증 실패는 표준과 동일하게 alert 만 노출한다 — 검증 실패 셀 분홍칠은 전 화면 비표준이라
    //   하지 않는다. (서버 응답 중복키 색칠 R14/R15 buildSaveErrorCells 만 별개 기능으로 분홍 유지.)
    setInvalidCells([]);
    // 1) 필수 미입력(빈값)은 전 화면 공통 표준검증(saveWithValidation, 메타 * 기준)으로 통일 —
    //    표준 메시지 "[항목] 값은 필수 입력 항목입니다." alert. 빈 신규행 저장 시 헤더 빨간점과
    //    동일한 필드가 걸린다(다른 화면과 동일 동작).
    // 2) 통과 후 AS-IS 고유 의미검증(PRIORITY>=1, 요일 1개 이상)을 mutate 콜백에서 수행 — alert 만.
    saveWithValidation(
      dirty as unknown as DistributionRouteRow[],
      staticColumns[SHEETS.ROUTE],
      changed => {
        if (!validateRows(changed as unknown as Record<string, unknown>[]).ok) return;
        void submitRouteSave(changed);
      }
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

  // Excel Form 다운로드 — 팝업 없이 클릭 즉시 다운로드(hook #135 §6, 정본 DMF0014 handleExcelFormDownload).
  //   업로드 양식은 다른 화면과 동일하게 데이터 없이 헤더 1행만 내려보낸다(빈 배열). 헤더 스타일(굵게·가운데·
  //   '@'텍스트)은 flatExcelDownload 공통이라 전 화면 동일하다.
  const handleExcelFormDownload = () => {
    void GridAction.flatExcelDownload([], FORM_COLUMNS, TEMPLATE_EXCEL_PREFIX).catch(() => {
      void useMessageStore
        .getState()
        .setAlert({ type: 'alert', content: t('MSG00618', '_An error occurred.') });
    });
  };

  // Excel Form → Excel Upload 순 (hook #135 §6 — 정본 DMF0082/DMF0014 배치). Excel 2종은 customButtons 로
  //   배치한다(표준 'upload' 슬롯은 customButtons 뒤에 렌더되어 순서가 깨진다).
  //   btnExcel_Form 은 AS-IS 숨김(R1)이었으나 사용자 요구(2026-09-29)로 별도 버튼 분리 노출한다.
  //   업로드 버튼 코드 = 'UPLOAD'(SCM_ADM_MNU_BTN_MPG_M 실측, API=P_SCP0005_EXCEL_UPLOAD). Excel Form 은
  //   전용 FORM_DATA 배선이 없어(Approach 1 = FE 전용) 업로드 권한(UPLOAD)에 함께 게이트한다.
  const customButtons = [
    ...(hasButton('UPLOAD')
      ? [
          {
            label: t(LBL.EXCEL_FORM, '_Excel Form'),
            action: handleExcelFormDownload,
            iconComponent: <FileExceldownloadIcon />,
            iconPosition: 'leading' as const,
          },
          {
            label: t(LBL.EXCEL_UPLOAD, '_Excel Upload'),
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

      {/* Excel 업로드 팝업 (design 01 §2-E1) — 검증(mode=0) 후 onSave(mode=1) 저장, 완료 후 재조회 */}
      <ExcelUploadModal
        open={openExcelUpload}
        modalClose={() => setOpenExcelUpload(false)}
        onUploaded={() => void refetch()}
        onSave={async () => {
          // PKG_SCP0005.P_SCP0005_EXCEL_UPLOAD(mode=1) — 검증 통과분 DB 반영(2번째 호출).
          //   라우팅 (SCP0005, 'Distribution Route', UPLOAD_SAVE) → 업로드 SP (SCM_ADM_MNU_BTN_MPG_M 실측).
          //   P_PROGRAM_ID='SCP0005' · P_SHEET_NAME='Distribution Route' · P_CREATED_BY=세션 = mode=0 스테이징 키와 동일.
          try {
            const res = await apiClient.post<Record<string, unknown>>(
              `/${MENU_ID}/${ADMIN_SHEET_NAME[SHEETS.ROUTE]}/UPLOAD_SAVE/call-proc`,
              {
                mode: 1,
                createdBy: sessionUserId,
                programId: MENU_ID,
                sheetName: ADMIN_SHEET_NAME[SHEETS.ROUTE],
              }
            );
            const code = Number((res.data as { code?: string })?.code ?? 0);
            const inner = (
              res.data?.result as { o_result_cursor?: { CODE?: string; MSG?: string }[] }
            )?.o_result_cursor?.[0];
            // SP 반환 CODE!='0' = 실패(전량 게이트 위반 등) — MSG passthrough
            if (res.status >= 400 || code || (inner && inner.CODE !== '0')) {
              return {
                ok: false,
                message: inner?.MSG || (res.data as { message?: string })?.message,
              };
            }
            return { ok: true };
          } catch (e) {
            return { ok: false, message: e instanceof Error ? e.message : undefined };
          }
        }}
      />
    </>
  );
};
