import { CellType, type CellRangeEventArgs, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal } from 'features/master/src/components';
import { useMemo, useRef, useState, type MutableRefObject } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils, parseComboFilterBindings } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { COLUMNS, EDITABLE_COLUMNS, MENU_ID } from '../plan-group-master.constants';
import type { PlanGroupRow } from '../plan-group-master.types';
import { resolvePlanGroupCode } from '../utils/plan-group-master.save';

interface PlanGroupMasterGridProps {
  gridRef: MutableRefObject<FlexGrid<PlanGroupRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<PlanGroupRow> | undefined>;
  rows: PlanGroupRow[];
  staticColumns: RawFlexGridColumnConfig[];
  canEdit: boolean;
}

export const PlanGroupMasterGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  rows,
  staticColumns,
  canEdit,
}: PlanGroupMasterGridProps) => {
  const [clickedRow, setClickedRow] = useState<number>(-1);
  const [openItemModal, setOpenItemModal] = useState<boolean>(false);
  const clickedDivisionRef = useRef<string>('');

  // 컬럼 메타 보정(화면 로컬 — DB 메타 무수정, Hard Boundary 준수):
  //   1) 편집칼럼 보정(03_grid §6-1): 메타 11컬럼 전부 INPUT_TP_CD='S' 라 OPMZ_PLAN_GR_ID·ITEM_ID 가
  //      읽기전용이 된다(AS-IS 불일치). canEdit 일 때 두 컬럼만 editable('O')로 연다. 키 1~7 은 'S' 유지.
  //   2) 셀콤보 division 좁힘(03_grid §6-3): PlanGroup CMBO 는 division 필터 없이 DIVISION_ID 만 반환하므로,
  //      sales-site END_CUSTOMER 선례처럼 attribute2 에 'DIVISION_ID:DIVISION_ID' 를 더해 행 division 으로 좁힌다.
  const columns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      staticColumns.map(column => {
        let next = column;
        if (canEdit && EDITABLE_COLUMNS.includes(next.colNm)) {
          next = { ...next, inputTpCd: CELL_INPUT_EDIT_TYPE.OPTIONAL };
        }
        if (
          next.colNm === COLUMNS.OPMZ_PLAN_GR_ID &&
          !parseComboFilterBindings(next.attribute2).DIVISION_ID
        ) {
          next = {
            ...next,
            attribute2: [next.attribute2, 'DIVISION_ID:DIVISION_ID'].filter(Boolean).join(','),
          };
        }
        return next;
      }),
    [staticColumns, canEdit]
  );

  // Model(OPMZ_PLAN_GR_ITEM_ID) 셀 더블클릭 → SCM0002 Item 팝업 (W7, 03_grid §3-c).
  //   편집 가능(canEdit)일 때만. 선택 ItemID 를 그 행 셀에 반영.
  const handleGridDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid || !canEdit) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    const binding = GridUtils.getBinding(grid, ht.col);
    if (!dataItem || binding !== COLUMNS.OPMZ_PLAN_GR_ITEM_ID) return;

    clickedDivisionRef.current = String(dataItem[COLUMNS.DIVISION_ID] ?? '');
    setClickedRow(ht.row);
    setOpenItemModal(true);
  };

  // 붙여넣기 NAME→CODE 역변환 (W8, AS-IS cs:958-960). 공용 clearOutOfListComboOnPaste(후보 밖 clear)
  //   뒤에(initialized 콜백은 그리드 내부 핸들러 등록 이후 실행) 걸어, 후보로 남은 표시명(NAME)을
  //   그 행 division 범위 콤보에서 CODE 로 치환한다. 역조회원 = dataMap.getDisplayValues(행)로 좁힌 후보만
  //   (salesCompanyGuard 규약 — 전역 getKeyValue 는 cascade 밖 코드를 통과시켜 금지). 미매칭 시 무변경(NRE 방어).
  const handleInitialized = (grid: FlexGrid<PlanGroupRow>) => {
    grid.pastingCell.addHandler((sender: FlexGrid<PlanGroupRow>, event: CellRangeEventArgs) => {
      const e = event as CellRangeEventArgs & { data?: unknown; cancel?: boolean };
      if (e.cancel) return;
      if (sender.columns[e.col]?.binding !== COLUMNS.OPMZ_PLAN_GR_ID) return;
      const dataMap = sender.getColumn(COLUMNS.OPMZ_PLAN_GR_ID)?.dataMap;
      if (!dataMap) return;
      const row = sender.rows[e.row]?.dataItem;
      const names = (dataMap.getDisplayValues(row) as string[] | undefined) ?? [];
      const options = names.map(name => ({
        label: String(name),
        value: String(dataMap.getKeyValue(name) ?? ''),
      }));
      const code = resolvePlanGroupCode(String(e.data ?? ''), options);
      if (code !== undefined) e.data = code;
    });
  };

  // 팝업 선택 → 그 행 Model 셀에 SetText (gridSignal 932 등가). EditTracker 로 'M' 마킹.
  const setItemId = (itemId: string) => {
    const grid = gridRef.current;
    const dataItem = GridUtils.getRow(grid, clickedRow);
    if (!grid || !dataItem) return;
    const prev = String(dataItem[COLUMNS.OPMZ_PLAN_GR_ITEM_ID] ?? '');
    editTrackerRef.current?.storeChange(dataItem, COLUMNS.OPMZ_PLAN_GR_ITEM_ID, prev, itemId);
    dataItem[COLUMNS.OPMZ_PLAN_GR_ITEM_ID] = itemId;
    GridUtils.refreshRow(grid, clickedRow);
  };

  return (
    <>
      <DataGrid<PlanGroupRow>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={rows}
        staticColumns={columns}
        comboParams={{ mnuId: `'${MENU_ID}'` }}
        initialized={handleInitialized}
        dblClick={handleGridDblClick}
      />
      {/* Item by Division 공용 팝업(AS-IS SCM0002_ItembyDivisionPopup = COM0008, 03_grid §3-c W7).
          division = 클릭한 행의 DIVISION_ID. callFromCell → 셀 호출 모드. */}
      <ItemByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        setSelectedValue={itemId => setItemId(itemId)}
        preSearchParams={{
          divisionId: clickedDivisionRef.current,
          deptId: 'ALL',
          endCustomer: 'ALL',
          salesSite: 'ALL',
          projectCode: '',
        }}
        callFromCell={true}
      />
    </>
  );
};
