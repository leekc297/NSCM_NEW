import {
  CellType,
  DataMap,
  type CellRangeEventArgs,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';

import type { MENU_ID, SHEETS } from '../plant-site.constants';
import { CONST, SHEET_INDEX } from '../plant-site.constants';
import { usePlantSiteStore } from '../usePlantSiteStore';
import { lookupCityByCode } from '../utils/plant-site.cityLookup';
import {
  COMBO,
  FROZEN_TYPE_LOOKUP_TYPE,
  LOGISTIC_PLANT_COMBO_ID,
  OPERATION_GROUP_LOOKUP_TYPE,
} from '../utils/plant-site.plantSiteCombo';
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

  // OPERATION_GROUP/FROZEN_TYPE 셀 콤보 후보 화면 직접 조회 — 공용 DataGrid 자동 콤보가 컬럼별
  //   ATTRIBUTE1(lookupType)을 읽지 못해 늘 빈 후보를 받는 결함 우회(plant-site.plantSiteCombo.ts 주석).
  //   LOGISTIC_PLANT_ID 는 그 결함은 없으나(정상 동작 콤보), Warranty 행 단일옵션(A002) 제한(G02-b)을
  //   걸려면 이 컬럼도 화면이 직접 관리해야 해서 같이 조회한다. divisionId 바인드는 주지 않는다 —
  //   공용 파이프라인도 전량 조회 후 행 DIVISION_ID 로 클라 좁힘이었다(SQL @divisionId IS NULL 분기).
  const [operationGroupRows, frozenTypeRows, logisticPlantRows] = useTabComboQueries({
    filters: [
      { comboId: COMBO.LOOKUP_COMMON, lookupType: OPERATION_GROUP_LOOKUP_TYPE, mnuId: 'SCP0001' },
      { comboId: COMBO.LOOKUP_COMMON, lookupType: FROZEN_TYPE_LOOKUP_TYPE, mnuId: 'SCP0001' },
      { comboId: LOGISTIC_PLANT_COMBO_ID, mnuId: 'SCP0001' },
    ],
  });

  // R-05(a) baseline: OPERATION_GROUP 컬럼 최초 columnGroups 빌드에 쓰일 원본 P/A/E 후보.
  //   행별(Warranty) 후보는 아래 operationGroupDataMap useEffect 가 updatedLayout 시점에 곧바로
  //   덮어쓴다 — 여기 배열에는 'W' 를 넣지 않는다(넣으면 다시 전 행 leak, D-02 결정 위반).
  const siteColumns = useMemo(() => {
    if (
      operationGroupRows === undefined ||
      frozenTypeRows === undefined ||
      logisticPlantRows === undefined
    ) {
      return staticColumns.site;
    }
    return staticColumns.site.map(col => {
      if (col.colNm === 'OPERATION_GROUP') {
        return { ...col, cellCboDataTp: undefined, dataMap: operationGroupRows };
      }
      if (col.colNm === 'FROZEN_TYPE') {
        return { ...col, cellCboDataTp: undefined, dataMap: frozenTypeRows };
      }
      if (col.colNm === 'LOGISTIC_PLANT_ID') {
        return { ...col, cellCboDataTp: undefined, dataMap: logisticPlantRows };
      }
      return col;
    });
  }, [staticColumns.site, operationGroupRows, frozenTypeRows, logisticPlantRows]);

  // R-05(a): OPERATION_GROUP 셀 콤보 — AS-IS SetCellTypeCombo(iRow, colIdx, dtProdTypeW)(cs:709)는
  //   행별(iRow)로만 'W'(Warranty) 후보를 얹는다. Wijmo Column.dataMap 은 컬럼 전체 설정이라 후보
  //   배열을 그대로 넣으면 새 행 포함 전 행에 새므로(D-02 결정), DataMap.getDisplayValues 를 행별로
  //   오버라이드해 재현한다(project-route-warranty DIVISION_ID getDisplayValues insert-only 패턴 준용).
  const operationGroupDataMap = useMemo(() => {
    if (operationGroupRows === undefined) return null;
    const allRows = [...operationGroupRows, { CODE: CONST.WARRANTY_OP_GROUP, NAME: 'Warranty' }];
    const warrantyRow = allRows[allRows.length - 1];
    const map = new DataMap(allRows, 'CODE', 'NAME');
    const baseDisplayValues = map.getDisplayValues.bind(map) as (item?: WijmoRowItem) => string[];
    map.getDisplayValues = (item?: WijmoRowItem): string[] => {
      const all = [...new Set(baseDisplayValues(item))];
      // 행 컨텍스트 없는 호출(필터 패널 등)은 전체 유지 — 비우면 필터가 죽는다.
      if (!item) return all;
      // Warranty 행만 W 후보 유지, 그 외(신규행 포함)는 P/A/E만 — cs:709 행별 콤보 재현.
      if (isWarrantyRow((item as SiteRow).OPERATION_GROUP)) return all;
      return all.filter(name => name !== warrantyRow.NAME);
    };
    return map;
  }, [operationGroupRows]);

  // OPERATION_GROUP 컬럼에 행별 DataMap 부착. 공용 DataGrid 의 자동 재적용은 cellCboDataTp 가 있는
  //   컬럼만 다시 붙이므로(DataGrid.tsx applyComboDataMaps 스킵 조건) 이 컬럼은 대상 밖 — columnGroups
  //   재대입(구조 변경)마다 col.dataMap 이 지워지므로 updatedLayout 에서 직접 재부착한다
  //   (project-route-warranty DIVISION_ID 패턴 그대로).
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid || !operationGroupDataMap) return;
    const attach = () => {
      const col = grid.getColumn('OPERATION_GROUP');
      if (col && col.dataMap !== operationGroupDataMap) col.dataMap = operationGroupDataMap;
    };
    grid.updatedLayout.addHandler(attach);
    attach();
    return () => {
      try {
        grid.updatedLayout.removeHandler(attach);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, operationGroupDataMap]);

  // R-05(b): LOGISTIC_PLANT_ID 셀 콤보 — AS-IS SetCellTypeCombo(iRow, LOGISTIC_PLANT_ID, dtLogisticW)
  //   (SCP0001_PlantSite.cs:710, dtLogisticW={CODE:"A002",NAME:"A002"} 리터럴, 240-246행)는 Warranty
  //   행에서만 드롭다운을 A002 단일 옵션으로 바꾼다. A002 는 공장 마스터(SCM_MST_PLANT_SN)에 없는 코드라
  //   서버 조회로는 얻을 수 없다 — AS-IS 처럼 클라에서 리터럴로 합성한다. 그 외 행은 기존 division 필터
  //   (ATTRIBUTE2=DIVISION_ID:DIVISION_ID, DB 실측)를 그대로 재현한다.
  const logisticPlantDataMap = useMemo(() => {
    if (logisticPlantRows === undefined) return null;
    const warrantyOption = { CODE: CONST.WARRANTY_LOGISTIC_PLANT, NAME: CONST.WARRANTY_LOGISTIC_PLANT };
    const allRows = [...logisticPlantRows, warrantyOption];
    const map = new DataMap(allRows, 'CODE', 'NAME');
    map.getDisplayValues = (item?: WijmoRowItem): string[] => {
      if (!item) return logisticPlantRows.map(row => row.NAME);
      const row = item as SiteRow;
      // Warranty 행은 A002 단일 옵션 — cs:710 행별 콤보 재현.
      if (isWarrantyRow(row.OPERATION_GROUP)) return [warrantyOption.NAME];
      // 기존 division 필터 재현(공용 filterComboRowsByRowItem 과 동일 규칙, row 값 비면 전체 유지).
      const divisionId = str(row.DIVISION_ID);
      return logisticPlantRows
        .filter(candidate => !divisionId || str(candidate.DIVISION_ID) === divisionId)
        .map(candidate => candidate.NAME);
    };
    return map;
  }, [logisticPlantRows]);

  // LOGISTIC_PLANT_ID 컬럼에 행별 DataMap 부착 — OPERATION_GROUP 과 동일 이유·동일 패턴.
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid || !logisticPlantDataMap) return;
    const attach = () => {
      const col = grid.getColumn('LOGISTIC_PLANT_ID');
      if (col && col.dataMap !== logisticPlantDataMap) col.dataMap = logisticPlantDataMap;
    };
    grid.updatedLayout.addHandler(attach);
    attach();
    return () => {
      try {
        grid.updatedLayout.removeHandler(attach);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, logisticPlantDataMap]);

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
      return;
    }
    // CITY 직접 키인·붙여넣기·삭제 → 형제 화면 SCP0005(SetCityCode) 동작 재현(사용자 결정 2026-10-06).
    //   CITY 코드로만 공용 조회(country 무관): 매칭 시 COUNTRY·CITY(정규화)를 함께 채우고, 무매칭(잘못된
    //   코드)·빈값(삭제) 시 COUNTRY 를 비운다. COUNTRY 편집에는 캐스케이드가 없다 — 단독 삭제·단독 키인
    //   허용(SCP0005 는 country 핸들러가 없어 해당 칸만 반영). 도시팝업 경로(setCity)는 프로그램 세팅이라
    //   cellEditEnded 를 안 타므로 여기서 겹치지 않는다.
    if (binding === 'CITY') {
      const tracker = editTrackerRef.current;
      const setCell = (key: 'COUNTRY' | 'CITY', value: string) => {
        if (row[key] === value) return;
        tracker?.storeChange(row, key, row[key], value);
        row[key] = value;
      };
      void lookupCityByCode(str(row.CITY)).then(res => {
        if (res.status === 'defer') return; // 조회 실패 — 기존 country/city 유지
        if (res.status === 'match') {
          setCell('COUNTRY', res.country);
          setCell('CITY', res.city); // CITY 코드 정규화(SCP0005 dr[CITY]=drs[0]["CITY"])
        } else {
          // nomatch(잘못된 코드) + 빈값(삭제) → COUNTRY 비움(CITY 입력값은 유지)
          setCell('COUNTRY', '');
        }
        GridUtils.refreshRow(grid, e.row);
      });
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
        staticColumns={siteColumns}
        // G10: AS-IS SCP0001.cs 전 컬럼 FPMerge.None(main·sub 공통) + siSub.SmartColMerge()는 병합 대상
        //   컬럼이 없어 no-op — 이 화면은 셀 병합이 없다. 기본값(ColumnHeaders, 헤더 그룹만)으로 둔다.
        alternatingRowStep={0}
        // site.DIVISION_ID(Division_SCP) 등 @mnuId 화면토큰 해소. LOGISTIC_PLANT_ID 는 G02-b 로
        //   화면이 직접 조회하는 콤보로 바뀌어 이 comboParams 대상에서 빠졌다.
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
