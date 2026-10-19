import type { FlexGrid } from '@mescius/wijmo.grid';
import type { MutableRefObject } from 'react';

import type { EditTracker } from '@foundation/utils';

import {
  COLUMN,
  PROGRESS_STATUS,
  SHEET_TYPE,
  type DivisionType,
  type SheetType,
} from '../capa-loss-plan.constants';
import type { Scp0106Row } from '../capa-loss-plan.types';
import {
  blockKeyOf,
  buildMeasureMap,
  recalcCurrentColumn,
  recalcLineColumn,
  type DayCountEntry,
  type RecalcChange,
} from '../utils/capaLossPlan.recalc';

interface UseCapaLossPlanCellEditParams {
  gridRef: MutableRefObject<FlexGrid | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  progressStatus: string;
  sheetType: SheetType;
  divisionType: DivisionType;
  /** GET measure 결과셋에서 만든 편집가능 measure 집합 — 재계산 디스패치 조건이기도 하다(R-18). */
  editableMeasures: Set<string>;
  /** 기간 키 -> 일수. GET 3번 커서. */
  dayCounts: Map<string, DayCountEntry>;
  /** LINE 계열 DDN 분모 — GET 4번 커서(`RS(prodCapaD)`). */
  prodCapaD: Map<string, number>;
}

const toText = (value: unknown): string => {
  if (typeof value === 'string') return value;
  if (typeof value === 'number' || typeof value === 'boolean') return String(value);
  return '';
};

/**
 * 라인 블록 키 — LINE 계열 재계산의 범위다.
 * 모델 행(`NICK_NAME != '-'`)과 라인집계 행(`NICK_NAME = '-'`)이 같은 블록에 들어가야
 * `WT_RT = DAY_CNT - (SD+TD+MC+라인합계DDN)` 의 "라인 합계" 가 성립한다(03 V-43).
 * 그래서 `NICK_NAME`/`ITEM_ID` 를 키에서 뺀다 — 모델 단위 블록키(`blockKeyOf`)와 다르다.
 * `LINE_IDX` 가 있으면 그것이 AS-IS 의 라인 블록 구분자다(R-19).
 */
const lineBlockKeyOf = (row: Scp0106Row): string => {
  const lineIdx = toText(row[COLUMN.LINE_IDX]);
  if (lineIdx) return `IDX:${lineIdx}`;
  return [
    COLUMN.DIVISION_ID,
    COLUMN.COMPANY_ID,
    COLUMN.SITE_ID,
    COLUMN.PLANT_ID,
    COLUMN.FACTORY_ID,
    COLUMN.LINE_ID,
  ]
    .map(key => toText(row[key]))
    .join('');
};

/**
 * 셀 편집 종료 후속 — AS-IS `spdMain_Changed` 의 디스패치(03 R-18):
 *   `_CURRENT` 이고 편집한 measure 가 편집가능 집합에 있으면 `RecalcSheetSelfCurrent`
 *   `_1ST_CUTOFF && LINE` 이고 편집한 measure 가 `FIRST_LINE_TARGET_YN` 집합에 있으면 `RecalcSheetSelfLine`
 *   그 외 상태(2차 컷오프 · CUTOFF_MODEL)는 **무동작**이다.
 *
 * 가드 6종은 `components/CapaLossPlanGrid.tsx` 가 AS-IS 순서대로 먼저 통과시킨다 — 특히
 * **잠금 셀이면 재계산하지 않는다**(자동계산 대상이라 무한루프가 난다).
 *
 * 값 반영은 전부 `EditTracker.storeChange` 로 기록해 `CRUD_TYPE='M'` 을 얻는다 —
 * 자체 상태필드를 신설하지 않는다(convert-core §2.4).
 *
 * R-09 의 "값 없이 dirty 만 찍히는 18 measure" 는 여기서 처리하지 않는다. EditTracker 는
 * "값이 달라졌을 때만" M 을 찍는 계약이라 값 없이 마킹하려면 규약을 깨야 한다. 대신 그 규칙의
 * **목적**(= 한 셀을 고치면 그 열의 measure 세트가 통째로 저장 대상이 된다)을 저장 payload 조립
 * 단계에서 블록 확장으로 재현한다(`hooks/useCapaLossPlanSave.ts`). 04 리포트에 차이를 기록했다.
 */
export const useCapaLossPlanCellEdit = ({
  gridRef,
  editTrackerRef,
  progressStatus,
  sheetType,
  divisionType,
  editableMeasures,
  dayCounts,
  prodCapaD,
}: UseCapaLossPlanCellEditParams) => {
  const applyChanges = (changes: RecalcChange[]): void => {
    const tracker = editTrackerRef.current;
    for (const change of changes) {
      change.row[change.columnName] = change.nextValue;
      tracker?.storeChange(
        change.row as never,
        change.columnName,
        change.previousValue as never,
        change.nextValue as never
      );
    }
  };

  const handleCellEditEnded = (rowIndex: number, binding: string) => {
    const grid = gridRef.current;
    if (!grid) return;

    /**
     * `cellEditEnded` 가 주는 `row` 는 **표시(view) 행 인덱스**다. 편집행은 표시 인덱스로
     * dataItem 을 집어 확정하고, 블록 탐색은 **원본 순서**(`collectionView.sourceCollection`)에서
     * 한다 — F3 정렬·F4 필터가 걸려도 같은 블록을 찾도록. 블록 판정 자체가 키 기반이라
     * AS-IS 의 행 오프셋(R-11)과 달리 정렬에 흔들리지 않는다.
     */
    const sourceRows = (grid.collectionView?.sourceCollection ?? []) as Scp0106Row[];
    const editedRow = grid.rows[rowIndex]?.dataItem as Scp0106Row | undefined;
    if (!editedRow) return;

    const measure = toText(editedRow[COLUMN.MEASURE]);
    if (!editableMeasures.has(measure)) return;

    const isCurrent =
      progressStatus === PROGRESS_STATUS.PRE || progressStatus === PROGRESS_STATUS.CURRENT;

    if (isCurrent) {
      const blockKey = blockKeyOf(editedRow);
      const measures = buildMeasureMap(sourceRows, blockKey);
      applyChanges(
        recalcCurrentColumn({
          measures,
          columnName: binding,
          divisionType,
          dayCounts,
          representativeRow: editedRow,
        })
      );
      grid.invalidate();
      return;
    }

    if (progressStatus === PROGRESS_STATUS.FIRST_CUTOFF && sheetType === SHEET_TYPE.LINE) {
      const lineKey = lineBlockKeyOf(editedRow);
      const blockRows = sourceRows.filter(row => lineBlockKeyOf(row) === lineKey);
      applyChanges(
        recalcLineColumn({
          blockRows,
          columnName: binding,
          divisionType,
          dayCounts,
          prodCapaD,
        })
      );
      grid.invalidate();
      return;
    }

    // 그 외 상태(2차 컷오프 · CUTOFF_MODEL)는 AS-IS 도 무동작이다 — 재계산을 "추가" 하지 않는다.
  };

  return { handleCellEditEnded };
};
