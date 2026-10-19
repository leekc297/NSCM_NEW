import {
  CellType,
  type CellRangeEventArgs,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, SHEETS } from '../plant-site.constants';
import { CONST, SHEET_INDEX } from '../plant-site.constants';
import { usePlantSiteStore } from '../usePlantSiteStore';
import { deriveScmSiteId, isSiteCellRowLocked, isWarrantyRow, str } from '../utils/plant-site.util';

import { CityByCountryModal } from './modals/CityByCountryModal';
import { VendorModal } from './modals/VendorModal';

type SiteRow = ResponseData<MENU_ID, SHEETS.SITE, 'o_rc1'>;

interface PlantSiteGridProps {
  gridRef: MutableRefObject<FlexGrid<SiteRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: SiteRow[];
  setActiveTab: (tab: SHEET_INDEX) => void;
}

export const PlantSiteGrid = ({ gridRef, gridFilterRef, data, setActiveTab }: PlantSiteGridProps) => {
  const editTrackerRef = useRef<EditTracker<SiteRow> | undefined>();

  const staticColumns = usePlantSiteStore(state => state.staticColumns);
  const setDetailContext = usePlantSiteStore(state => state.setDetailContext);

  const [clickedRow, setClickedRow] = useState<number>(-1);
  const [clickedBinding, setClickedBinding] = useState<string>('');
  const [openVendor, setOpenVendor] = useState<boolean>(false);
  const [openCity, setOpenCity] = useState<boolean>(false);

  const handleFocus = () => setActiveTab(SHEET_INDEX.SITE);

  // Vendor 팝업 확정 — 클릭 셀에 따라 R-17(신규행 PLANT_NAME)/R-18(전행 HQ Vendor) 분기.
  const setVendor = (companyId: string, vendorCode: string, vendorName: string) => {
    const row = GridUtils.getRow(gridRef.current, clickedRow);
    if (!row) return;
    const tracker = editTrackerRef.current;
    if (clickedBinding === 'PLANT_NAME') {
      // R-17: PLANT_ID/PLANT_NAME/COMPANY_ID + SCM_SITE_ID 파생(신규행 한정).
      if (row.CRUD_TYPE !== CRUD_TYPE.INSERT) return;
      tracker?.storeChange(row, 'PLANT_NAME', row.PLANT_NAME, vendorName);
      row.PLANT_ID = vendorCode;
      row.PLANT_NAME = vendorName;
      row.COMPANY_ID = companyId;
      row.SCM_SITE_ID = deriveScmSiteId(vendorCode, row.DIVISION_ID, row.OPERATION_GROUP);
    } else {
      // R-18: HQ_VENDOR_CODE/HQ_VENDOR_CODE_NAME(전 행, 편집모드).
      tracker?.storeChange(row, 'HQ_VENDOR_CODE_NAME', row.HQ_VENDOR_CODE_NAME, vendorName);
      row.HQ_VENDOR_CODE = vendorCode;
      row.HQ_VENDOR_CODE_NAME = vendorName;
    }
    GridUtils.refreshRow(gridRef.current, clickedRow);
  };

  // City 팝업 확정 — R-20: COUNTRY·CITY 동시 반영.
  const setCity = (country: string, city: string) => {
    const row = GridUtils.getRow(gridRef.current, clickedRow);
    if (!row) return;
    editTrackerRef.current?.storeChange(row, 'CITY', row.CITY, city);
    row.COUNTRY = country;
    row.CITY = city;
    GridUtils.refreshRow(gridRef.current, clickedRow);
  };

  // 행 조건부 편집 잠금 — R-05/22/23 + 기존행 DIVISION_ID 잠금(신규행만 콤보). 같은 판정 함수
  //   (isSiteCellRowLocked)를 beginningEdit(차단)·pastingCell(붙여넣기 우회 방지)·formatItem(편집색)에
  //   공통 적용한다(grid-behavior-parity §2, hook #95).
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const rowLocked = (s: FlexGrid<SiteRow>, rowIdx: number, colIdx: number): boolean => {
      const binding = s.columns[colIdx]?.binding;
      const row = GridUtils.getRow(s, rowIdx);
      return !!binding && !!row && isSiteCellRowLocked(binding, row);
    };
    const editHandler = (s: FlexGrid<SiteRow>, e: CellRangeEventArgs) => {
      if (rowLocked(s, e.row, e.col)) e.cancel = true;
    };
    // 공용 DataGrid 가 메타(INPUT_TP_CD) 기준으로 칠한 편집색을 행 조건 잠금 셀에서만 걷어낸다.
    const formatHandler = (s: FlexGrid<SiteRow>, e: FormatItemEventArgs) => {
      if (e.panel !== s.cells) return;
      if (rowLocked(s, e.row, e.col)) e.cell.classList.remove('wj-cell-editable');
    };
    grid.beginningEdit.addHandler(editHandler);
    grid.pastingCell.addHandler(editHandler);
    grid.formatItem.addHandler(formatHandler);
    return () => {
      grid.beginningEdit.removeHandler(editHandler);
      grid.pastingCell.removeHandler(editHandler);
      grid.formatItem.removeHandler(formatHandler);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [data]);

  // 셀 편집 파생 — R-21(SCM_SITE_ID)·R-24(FP_PLAN_PERIOD)·R-25(HQ 클리어)·R-05(Warranty Logistic).
  const handleCellEdit = (grid: FlexGrid<SiteRow>, e: CellRangeEventArgs) => {
    const binding = grid.columns[e.col]?.binding;
    const row = GridUtils.getRow(grid, e.row);
    if (!binding || !row) return;

    if (binding === 'DIVISION_ID' || binding === 'OPERATION_GROUP') {
      // R-21: SCM_SITE_ID 재파생(PLANT_ID 공백 아니면).
      row.SCM_SITE_ID = deriveScmSiteId(row.PLANT_ID, row.DIVISION_ID, row.OPERATION_GROUP);
      // R-05: Warranty('W') 행은 Logistic Plant 고정(A002).
      if (isWarrantyRow(row.OPERATION_GROUP)) row.LOGISTIC_PLANT_ID = CONST.WARRANTY_LOGISTIC_PLANT;
      GridUtils.refreshRow(grid, e.row);
      return;
    }
    if (binding === 'PROD_FROZEN') {
      // R-24: FP_PLAN_PERIOD = PROD_FROZEN 값 복사(자기 자신 잠금).
      row.FP_PLAN_PERIOD = str(row.PROD_FROZEN);
      GridUtils.refreshRow(grid, e.row);
      return;
    }
    if (binding === 'HQ_VENDOR_CODE_NAME' && !str(row.HQ_VENDOR_CODE_NAME)) {
      // R-25: HQ_VENDOR_CODE_NAME 공백 -> HQ_VENDOR_CODE 클리어.
      row.HQ_VENDOR_CODE = '';
      GridUtils.refreshRow(grid, e.row);
    }
  };

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const row = GridUtils.getRow(grid, ht.row);
    const binding = GridUtils.getBinding(grid, ht.col);
    if (!row || !binding) return;

    // R-17: 신규행 PLANT_NAME -> Vendor 팝업.
    if (row.CRUD_TYPE === CRUD_TYPE.INSERT && binding === 'PLANT_NAME') {
      setClickedRow(ht.row);
      setClickedBinding('PLANT_NAME');
      setOpenVendor(true);
      return;
    }
    // R-18: HQ Vendor Name -> Vendor 팝업(전 행).
    if (binding === 'HQ_VENDOR_CODE_NAME') {
      setClickedRow(ht.row);
      setClickedBinding('HQ_VENDOR_CODE_NAME');
      setOpenVendor(true);
      return;
    }
    // R-20: COUNTRY/CITY -> City 팝업.
    if (binding === 'COUNTRY' || binding === 'CITY') {
      setClickedRow(ht.row);
      setOpenCity(true);
      return;
    }
    // 그 외(읽기전용 셀) 더블클릭 = 마스터 선택 -> sub 3시트 row-context 로드(R-32).
    if (GridUtils.isEditableCell(grid, ht.row, ht.col)) return;
    setDetailContext({
      divisionId: str(row.DIVISION_ID),
      scmSiteId: str(row.SCM_SITE_ID),
      plantId: str(row.PLANT_ID),
      operationGroup: str(row.OPERATION_GROUP),
      ospYn: str(row.OSP_YN),
      siteDescription: str(row.SITE_DESCRIPTION),
    });
  };

  const clicked = GridUtils.getRow(gridRef.current, clickedRow);

  return (
    <>
      <DataGrid<SiteRow>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={data}
        staticColumns={staticColumns.site}
        // G10: AS-IS SCP0001.cs 전 컬럼 FPMerge.None(main·sub 공통) + siSub.SmartColMerge()는 병합 대상
        //   컬럼이 없어 no-op — 이 화면은 셀 병합이 없다. 기본값(ColumnHeaders, 헤더 그룹만)으로 둔다.
        alternatingRowStep={0}
        // site.DIVISION_ID(Division_SCP)·LOGISTIC_PLANT_ID(PlantByDivision1_SCP_ALL) 등 @mnuId 화면토큰 해소.
        comboParams={{ mnuId: 'SCP0001' }}
        gotFocus={handleFocus}
        cellEditEnded={handleCellEdit}
        pastedCell={handleCellEdit}
        dblClick={handleDblClick}
      />
      <VendorModal
        open={openVendor}
        modalClose={() => setOpenVendor(false)}
        setSelectedValue={setVendor}
        vendorCode={clickedBinding === 'PLANT_NAME' ? clicked?.PLANT_ID : clicked?.HQ_VENDOR_CODE}
      />
      <CityByCountryModal
        open={openCity}
        modalClose={() => setOpenCity(false)}
        setSelectedValue={setCity}
        country={clicked?.COUNTRY}
        city={clicked?.CITY}
      />
    </>
  );
};
