import { CellType, type CellRangeEventArgs, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import { t } from '@foundation/i18n';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import type { MENU_ID, SHEET_NAME } from '../customer-fcst-master.constants';
import {
  hasDuplicateRowKey,
  hasOtherYInPeriod,
  isDateBinding,
  isRowKeyBinding,
} from '../customer-fcst-master.uniqueCheck';
import { useCustomerFcstMasterStore } from '../useCustomerFcstMasterStore';

interface CustomerFcstMasterFcstGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEET_NAME>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<ResponseData<MENU_ID, SHEET_NAME>> | undefined>;
  data: ResponseData<MENU_ID, SHEET_NAME>[];
}

export const CustomerFcstMasterFcstGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
}: CustomerFcstMasterFcstGridProps) => {
  const staticColumns = useCustomerFcstMasterStore(state => state.staticColumns);
  const dateColumns = useCustomerFcstMasterStore(state => state.dateColumns);

  // 셀 콤보는 comboId 만 넘긴다 (comboParams 미전달). Division 좁힘은 서버 바인드가 아니라 행 단위
  // cascade 가 맡는다 — 컬럼 메타 attribute2 의 DIVISION_ID:DIVISION_ID 가 그 행의 DIVISION_ID 로
  // 후보를 거른다. 콤보를 division 무관하게 한 벌만 받으므로 division 을 바꿔도 재조회가 없다.
  //
  // Team / End Customer / Sales Site 의 행 단위 후보 좁힘과 상위 변경 시 하위 셀 비우기는 공용
  // DataGrid 가 컬럼 메타로 처리한다 — 콤보는 cellCboDataTp, 종속 규약은 attribute2 다.
  // 화면에 cascade 표를 두지 않는다. 표를 두면 메타와 두 벌이 되어 관리자가 메타를 고쳐도 화면이
  // 안 따라간다 (2026-08-25 정리 — GRID_CASCADE_FILTERS / GRID_CASCADE_CLEAR 제거).
  // 규약은 columnMapping.filterComboRowsByRowItem / DataGrid.findStaleComboCells 참조.

  // 중복 검사 위반 — MSG00136 안내 후 방금 들어온 값을 되돌린다(AS-IS SetText ""). 기존 행은
  //   EditTracker 에 되돌림을 기록해 수정상태(M) 판정이 어긋나지 않게 한다. 신규 행은 I 그대로다.
  const rejectCell = (
    sender: FlexGrid<ResponseData<MENU_ID, SHEET_NAME>>,
    dataItem: ResponseData<MENU_ID, SHEET_NAME>,
    binding: string,
    revertTo: string
  ) => {
    void useMessageStore.getState().setAlert({
      type: 'alert',
      content: t('MSG00136', '_동일 구간에 하나의 Y만 가능합니다.'),
    });
    if (dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT && dataItem.CRUD_TYPE !== CRUD_TYPE.DELETE) {
      editTrackerRef.current?.storeChange(dataItem, binding, dataItem[binding], revertTo);
    }
    (dataItem as Record<string, unknown>)[binding] = revertTo;
    sender.invalidate();
  };

  // 셀 편집 종료 / 붙여넣기 공통 — ① Active N 시 날짜 칸 전부 N(종전 동작), ② 신규 행 키 중복(MSG00136),
  //   ③ 같은 구간 Y 하나(MSG00136). ②③의 규칙과 AS-IS 근거는 customer-fcst-master.uniqueCheck 참조.
  //   비교 대상은 필터로 숨긴 행까지 포함한 그리드 소스 전체다(AS-IS 도 시트 전행을 돌았다).
  const handleCellChange = (
    sender: FlexGrid<ResponseData<MENU_ID, SHEET_NAME>>,
    cellRangeEventArgs: CellRangeEventArgs
  ) => {
    if (cellRangeEventArgs.panel.cellType !== CellType.Cell) return;

    const row = cellRangeEventArgs.row;
    const col = cellRangeEventArgs.col;
    const rawBinding = GridUtils.getBinding(sender, col);
    const binding = rawBinding == null ? '' : String(rawBinding);
    const dataItem = GridUtils.getRow(sender, row);
    if (!binding || !dataItem) return;

    const allRows =
      (sender.collectionView?.sourceCollection as ResponseData<MENU_ID, SHEET_NAME>[] | undefined) ??
      (sender.itemsSource as ResponseData<MENU_ID, SHEET_NAME>[]);

    // ② 신규 행 키 셀(Division / End Customer / Sales Site / Group / Measure) — 5키 같은 행이 또 있으면 취소
    if (isRowKeyBinding(binding)) {
      if (hasDuplicateRowKey(allRows, dataItem)) rejectCell(sender, dataItem, binding, '');
      return;
    }

    // ③ 날짜 칸에 Y — 4키 같은 행 중 같은 칸이 Y 인 행이 또 있으면 취소(N 으로)
    if (isDateBinding(binding)) {
      if (dataItem[binding] === 'Y' && hasOtherYInPeriod(allRows, dataItem, binding)) {
        rejectCell(sender, dataItem, binding, 'N');
      }
      return;
    }

    // ① Active 를 N 으로 바꾸면 날짜 칸을 전부 N 으로(종전 동작 유지)
    if (binding !== 'VALID_YN') return;
    if (dataItem[binding] !== 'N') return;

    Object.keys(dataItem).forEach(key => {
      if (!isDateBinding(key)) return;

      if (dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT && dataItem.CRUD_TYPE !== CRUD_TYPE.DELETE)
        editTrackerRef.current?.storeChange(dataItem, key, dataItem[key], 'N');

      dataItem[key] = 'N';
    });
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEET_NAME>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns ?? []}
      dynamicColumns={dateColumns ?? []}
      cellEditEnded={handleCellChange}
      // 붙여넣기도 같은 검사를 탄다 — AS-IS 는 DataModel Changed 가 입력 경로와 무관하게 한 번 돌았다.
      pastedCell={handleCellChange}
    />
  );
};
