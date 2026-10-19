import type { FlexGrid } from '@mescius/wijmo.grid';
import type { MutableRefObject } from 'react';

import type { EditTracker } from '@foundation/utils';

import { COLUMN, SHEETS, type GridSheet } from '../capa-speed-plan.constants';
import type { Scp0105Row } from '../capa-speed-plan.types';
import { isCellEditable, syncElectrodeTypeAcrossLine } from '../utils/capaSpeedPlan.editLock';
import { recalcPpmCell } from '../utils/capaSpeedPlan.recalc';

interface UseCapaSpeedPlanCellEditParams {
  gridRef: MutableRefObject<FlexGrid | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  sheetName: GridSheet;
}

/**
 * 셀 편집 종료 후속 — AS-IS `_defaultDataModel_Changed`(cs:3116~3118) 순서:
 *   `CheckEltrEquipmentType`(설비유형 일괄 동기화) -> `RecalcSheet`(PPM 자동계산).
 * 두 경로 모두 바뀐 행을 `EditTracker.storeChange` 로 기록해 `CRUD_TYPE='M'` 을 얻는다 —
 * 자체 상태필드를 신설하지 않는다(convert-core §2.4).
 */
export const useCapaSpeedPlanCellEdit = ({
  gridRef,
  editTrackerRef,
  sheetName,
}: UseCapaSpeedPlanCellEditParams) => {
  const handleCellEditEnded = (rowIndex: number, binding: string) => {
    const grid = gridRef.current;
    const tracker = editTrackerRef.current;
    if (!grid) return;

    /**
     * `cellEditEnded` 가 주는 `row` 는 **표시(view) 행 인덱스**다. 그것을 원본 배열 인덱스로
     * 곧바로 쓰면 F3 정렬·F4 필터가 걸린 순간 다른 행이 기준행이 된다. 그래서 편집행은 표시
     * 인덱스로 **dataItem 을 집어** 확정하고, 이후 이웃 탐색(행 오프셋)은 **원본 순서**
     * (`collectionView.sourceCollection`)에서 한다.
     *
     * 원본 순서로 푸는 이유: PPM 자동계산의 오프셋(-1/-2)은 조회 정렬
     * (`... , M.SORT_ORDER_NO`)이 만든 measure 배치에만 의미가 있다(03 R-18/V-29). AS-IS spread 는
     * 정렬·필터가 없어 표시 순서 == 원본 순서였으므로, **원본 순서가 곧 AS-IS 의미**다. 표시
     * 순서로 풀면 사용자가 정렬하거나 블록 안 한 행만 필터로 가린 순간 이웃이 다른 measure 행으로
     * 바뀌어, 엉뚱한 행에 계산값이 써지고 `CRUD_TYPE='M'` 까지 찍혀 저장된다(iter-3 감사 A3-01).
     * 무정렬·무필터(= AS-IS 조건)에서는 두 순서가 같아 동작 차이가 없다.
     */
    const sourceRows = (grid.collectionView?.sourceCollection ?? []) as Scp0105Row[];
    const editedRow = grid.rows[rowIndex]?.dataItem as Scp0105Row | undefined;
    if (!editedRow) return;
    const editedRowIndex = sourceRows.indexOf(editedRow);
    if (editedRowIndex < 0) return;

    // (1) ELTR 설비유형 일괄 동기화 — 6키가 모두 채워진 행에서만 발동(R-22/R-23).
    //     대상은 표시 중인 행이 아니라 **시트 전체**다 — AS-IS 는 필터가 없어 전 행을 훑으므로
    //     여기서도 원본 컬렉션을 넘긴다(필터로 가려진 행도 같은 라인이면 맞춰져야 한다).
    if (sheetName === SHEETS.ELTR && binding === COLUMN.ELTR_LN_TP_CD) {
      for (const synced of syncElectrodeTypeAcrossLine(sourceRows, editedRow)) {
        synced.row[COLUMN.ELTR_LN_TP_CD] = synced.nextValue;
        tracker?.storeChange(
          synced.row as never,
          COLUMN.ELTR_LN_TP_CD,
          synced.previousValue,
          synced.nextValue
        );
      }
    }

    // (2) PPM 자동계산 — ASSEMBLY 시트에서만, 그리고 **PPM 행 셀이 lock 상태일 때만**(cs:2914).
    //     사용자가 직접 넣을 수 있는 셀이면 덮어쓰지 않는다는 뜻이다.
    //     행 오프셋(-1/-2)은 **원본 순서** 기준이다(위 주석). 이웃이 같은 라인x모델 블록인지는
    //     `recalcPpmCell` 이 한 번 더 확인한다.
    if (sheetName !== SHEETS.ASSEMBLY) return;
    const result = recalcPpmCell(sourceRows, editedRowIndex, binding);
    if (!result) return;
    const ppmRow = sourceRows[result.ppmRowIndex];
    if (!ppmRow) return;
    const ppmCellEditable = isCellEditable({
      sheetName,
      binding,
      row: ppmRow,
      isEditMode: true,
    });
    if (ppmCellEditable) return;
    ppmRow[binding] = result.value;
    tracker?.storeChange(
      ppmRow as never,
      binding,
      result.previousValue as never,
      result.value as never
    );
    grid.invalidate();
  };

  return { handleCellEditEnded };
};
