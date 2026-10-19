import { AllowMerging, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { clampNonNegative, isCellEditable } from '../utils/warehouseCapacityEditLock';
import { MSG } from '../warehouse-capacity.constants';
import type { MainRow } from '../warehouse-capacity.types';

interface Props {
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType<MainRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<MainRow> | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  onFocus: () => void;
}

/**
 * Warehouse Capacity 시트(design 03 §1.1, 15컬럼) — DataGrid. 컬럼은 admin
 * `SCM_MST_SHEET_COLUMNS`(PROGRAM_ID='SCP0133', 31행 실측)를 그대로 쓴다(속성 단위 덮어쓰기 금지,
 * convert-core §2.3).
 *
 * 편집잠금(design 01 §2 #2/#6, gridSignals#7~18) — 조회 직후에도 바로 편집 가능하며, DIVISION_ID·
 * 감사4컬럼·PRE_KEY_VALUES 만 항상 잠금(`isCellEditable` 단일 진실원, EditButton 토글 어포던스
 * 미이식). admin `INPUT_TP_CD` 는 현재 전 컬럼 'S'(design 03 실측)라 메타만으로는 편집이 열리지
 * 않는다 — 메타 정비는 `05_register.sql` 대상, 정비 전까지 이 코드의 화이트리스트가 유일한
 * 편집 게이트다.
 *
 * MAX_CAPA 음수 클램프 0(design 03 §3 #27) — TO-BE 문구 확인된 MSG00085 사용(AS-IS MSG00193 은
 * TO-BE 문구 미대조라 MSG00085 하나로 통일, Hook #114).
 *
 * SmartColMerge(design 03 §3 #18, line1180) — 병합 대상 컬럼이 detail 공란이라 미확정
 * (`guides/grid-behavior-parity.md` §1.1). 확인 필요로 명시하고 `allowMerging` 은 None 유지 —
 * 추측 병합 적용 금지.
 */
export const WarehouseCapacityGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  onFocus,
}: Props) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const item = sender.rows[e.row]?.dataItem as MainRow | undefined;
      if (!item) {
        e.cancel = true;
        return;
      }
      e.cancel = !isCellEditable(binding);
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    g.pastingCell.addHandler(beginningEditHandler as never);

    // MAX_CAPA 음수 클램프 0(design 03 §3 #27, MSG00085).
    const cellEditEndedHandler = (
      sender: FlexGridType<MainRow>,
      e: { row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'MAX_CAPA') return;
      const row = GridUtils.getRow(sender, e.row);
      if (!row) return;
      const { value, coerced } = clampNonNegative((row as Record<string, unknown>)[binding]);
      if (coerced) {
        editTrackerRef.current?.storeChange(
          row,
          binding as never,
          (row as Record<string, unknown>)[binding] as never,
          value as never
        );
        (row as Record<string, unknown>)[binding] = value;
        setToast({
          type: 'error',
          message: t(
            MSG.NUMBER_NON_NEGATIVE,
            '_Only values greater than or equal to {0} are allowed.'
          ).replace('{0}', '0'),
        });
        sender.invalidate();
      }
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler as never);
    g.pastedCell.addHandler(cellEditEndedHandler as never);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(beginningEditHandler as never);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler as never);
        g.pastedCell?.removeHandler(cellEditEndedHandler as never);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [adminColumns]);

  return (
    <DataGrid<MainRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows}
      staticColumns={adminColumns ?? []}
      allowMerging={AllowMerging.None}
      gotFocus={onFocus}
    />
  );
};
