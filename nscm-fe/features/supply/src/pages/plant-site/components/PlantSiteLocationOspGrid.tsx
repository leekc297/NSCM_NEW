import {
  type CellRangeEventArgs,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, type MutableRefObject } from 'react';

import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import type { MENU_ID, SHEETS } from '../plant-site.constants';
import { MSG, SHEET_INDEX } from '../plant-site.constants';
import { usePlantSiteStore } from '../usePlantSiteStore';
import { isLocationOspCellRowLocked, str } from '../utils/plant-site.util';

type LocationOspRow = ResponseData<MENU_ID, SHEETS.LOCATION_OSP, 'o_rc1'>;

interface PlantSiteLocationOspGridProps {
  gridRef: MutableRefObject<FlexGrid<LocationOspRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: LocationOspRow[];
  setActiveTab: (tab: SHEET_INDEX) => void;
  isMainDirty: () => boolean;
}

export const PlantSiteLocationOspGrid = ({
  gridRef,
  gridFilterRef,
  data,
  setActiveTab,
  isMainDirty,
}: PlantSiteLocationOspGridProps) => {
  const { t } = useTranslation();
  const editTrackerRef = useRef<EditTracker<LocationOspRow> | undefined>();

  const staticColumns = usePlantSiteStore(state => state.staticColumns);
  const selectedSite = usePlantSiteStore(state => state.selectedSite);
  const { setAlert } = useMessageStore.getState();

  const handleFocus = () => setActiveTab(SHEET_INDEX.LOCATION_OSP);

  // STORAGE_ID(StorageByDivPlant_SCP) @divisionId, PLANT_ID(PlantByDivision1_SCP_ALL) 화면 컨텍스트.
  const comboParams = useMemo(
    () => ({ mnuId: 'SCP0001', divisionId: selectedSite?.divisionId ?? '' }),
    [selectedSite]
  );

  // 편집 가드 — 행 잠금 판정(isLocationOspCellRowLocked)은 beginningEdit·pastingCell·formatItem
  //   3곳 공통 적용(grid-behavior-parity §2, hook #95 — 붙여넣기 우회·편집색 불일치 방지).
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const rowLocked = (s: FlexGrid<LocationOspRow>, rowIdx: number, colIdx: number): boolean => {
      const binding = s.columns[colIdx]?.binding;
      const row = GridUtils.getRow(s, rowIdx);
      // 교정(§6-8③): STORAGE_ID 는 MERGE 키 -> 기존행 STORAGE_ID 편집 잠금(신규행만 편집).
      return !!binding && !!row && isLocationOspCellRowLocked(binding, row);
    };
    const editHandler = (s: FlexGrid<LocationOspRow>, e: CellRangeEventArgs) => {
      // R-06①(G6): 상단 site 그리드에 미저장 변경이 있으면 하단 편집 차단(AS-IS cs:556-560).
      if (isMainDirty()) {
        e.cancel = true;
        void setAlert({
          type: 'alert',
          content: t(MSG.MAIN_SUB_EDIT_NOTICE, '_상단 그리드의 변경사항을 먼저 저장하세요.'),
        });
        return;
      }
      // R-06③: 내주(OSP_YN='N') 마스터 선택 상태에서는 Location(OSP) 편집 차단.
      if (selectedSite && selectedSite.ospYn !== 'Y') {
        e.cancel = true;
        void setAlert({
          type: 'alert',
          content: t(MSG.ONLY_OSP_LOCATION, '_Outsourcing Vendor만 Location(OSP)을 등록할 수 있습니다.'),
        });
        return;
      }
      if (rowLocked(s, e.row, e.col)) e.cancel = true;
    };
    // 붙여넣기는 alert 없이 동일 게이트만 통과시킨다(다중 셀 paste 의 알림 반복 방지).
    const pasteHandler = (s: FlexGrid<LocationOspRow>, e: CellRangeEventArgs) => {
      if (isMainDirty() || (selectedSite && selectedSite.ospYn !== 'Y') || rowLocked(s, e.row, e.col))
        e.cancel = true;
    };
    const formatHandler = (s: FlexGrid<LocationOspRow>, e: FormatItemEventArgs) => {
      if (e.panel !== s.cells) return;
      if (rowLocked(s, e.row, e.col)) e.cell.classList.remove('wj-cell-editable');
    };
    grid.beginningEdit.addHandler(editHandler);
    grid.pastingCell.addHandler(pasteHandler);
    grid.formatItem.addHandler(formatHandler);
    return () => {
      grid.beginningEdit.removeHandler(editHandler);
      grid.pastingCell.removeHandler(pasteHandler);
      grid.formatItem.removeHandler(formatHandler);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [selectedSite]);

  // R-16: PLANT_ID 변경 -> STORAGE_ID 콤보 재조회(재조회형 'D') 전제로 기존 값 클리어.
  const handleCellEdit = (grid: FlexGrid<LocationOspRow>, e: CellRangeEventArgs) => {
    const binding = grid.columns[e.col]?.binding;
    const row = GridUtils.getRow(grid, e.row);
    if (!binding || !row) return;
    if (binding === 'PLANT_ID' && str(row.STORAGE_ID)) {
      row.STORAGE_ID = '';
      GridUtils.refreshRow(grid, e.row);
    }
  };

  return (
    <DataGrid<LocationOspRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns.locationOsp}
      comboParams={comboParams}
      gotFocus={handleFocus}
      cellEditEnded={handleCellEdit}
      pastedCell={handleCellEdit}
    />
  );
};
