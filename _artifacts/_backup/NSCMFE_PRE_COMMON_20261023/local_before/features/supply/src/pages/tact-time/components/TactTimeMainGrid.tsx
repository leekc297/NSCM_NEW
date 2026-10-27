import { AllowMerging, CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import {
  MAX_TACT_TIME_FALLBACK,
  MSG,
  OPERATION_GROUP_ELECTRODE,
  PACKER_COLUMNS,
  PLANT_COLUMNS,
  TACT_MODE,
} from '../tact-time.constants';
import type { MainRow } from '../tact-time.types';
import { buildColumns } from '../utils/tactTimeColumns';
import { clampTactTime, deriveJumboMin, deriveTactTimeFromDaily } from '../utils/tactTimeDerive';
import { isPackerCellEditable, isPlantCellEditable } from '../utils/tactTimeEditLock';

interface Props {
  mode: TACT_MODE;
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  // Edit(F2) 진입 여부 — false 면 조회직후 전체 readOnly (design 03 §3.2 마지막 문단).
  editMode: boolean;
  adminColumns?: RawFlexGridColumnConfig[];
  onRowDblClick: (row: MainRow) => void;
  onFocus: () => void;
}

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

export const TactTimeMainGrid = ({
  mode,
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  editMode,
  adminColumns,
  onRowDblClick,
  onFocus,
}: Props) => {
  const { t } = useTranslation();
  const isPlant = mode === TACT_MODE.PLANT;
  const setToast = useMessageStore.getState().setToast;

  const columns = useMemo(
    () => buildColumns(isPlant ? PLANT_COLUMNS : PACKER_COLUMNS, adminColumns),
    [isPlant, adminColumns]
  );

  // 최신 editMode/mode 를 stale 없이 참조 (핸들러는 mount 후 등록, deps 최소화).
  const editModeRef = useRef(editMode);
  editModeRef.current = editMode;
  const isPlantRef = useRef(isPlant);
  isPlantRef.current = isPlant;

  // 편집잠금(beginningEdit) + 파생 Auto-Sync(cellEditEnded) 핸들러 — SalesFuturePriceGrid 패턴.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 조회직후 전체 readOnly, Edit 진입 시 white-list 로 셀별 해제 (design 03 §3.2).
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      if (!editModeRef.current) {
        e.cancel = true;
        return;
      }
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) {
        e.cancel = true;
        return;
      }
      const editable = isPlantRef.current
        ? isPlantCellEditable(binding, row)
        : isPackerCellEditable(binding, row);
      if (!editable) e.cancel = true;
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // 파생 Auto-Sync — 전극 JUMBO_MIN / Packer TACT_TIME + TACT_TIME clamp (design 03 §3.3).
    const cellEditEndedHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const tracker = editTrackerRef.current;
      const setCell = (key: string, value: number) => {
        const prev = row[key];
        tracker?.storeChange(row as never, key, prev as never, value as never);
        row[key] = value;
      };

      if (isPlantRef.current) {
        // 전극(E): TACT_TIME 또는 LANE_QTY 변경 -> JUMBO_MIN 파생 (cs:2639/2644)
        if (
          (binding === 'TACT_TIME' || binding === 'LANE_QTY') &&
          s(row.OPERATION_GROUP_ID) === OPERATION_GROUP_ELECTRODE
        ) {
          setCell('JUMBO_MIN', deriveJumboMin(row.TACT_TIME, row.LANE_QTY));
        }
      } else if (binding === 'DAILY_CAPACITY') {
        // Packer: DAILY_CAPACITY 변경 -> TACT_TIME 파생 (cs:2717/2722)
        setCell('TACT_TIME', deriveTactTimeFromDaily(row.DAILY_CAPACITY));
      }

      // TACT_TIME 셀입력 clamp [MIN, MAX] (cs:2895 — MSG00203). Max 실측 SQL 은 asis.py 차단(확인 필요).
      if (binding === 'TACT_TIME') {
        const { value, clamped } = clampTactTime(row.TACT_TIME, MAX_TACT_TIME_FALLBACK);
        if (clamped) {
          setCell('TACT_TIME', value);
          setToast({ type: 'error', message: t(MSG.TACT_MAX_CLAMP, '_Tact Time out of range.') });
        }
      }
      sender.invalidate();
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    g.pastedCell.addHandler(cellEditEndedHandler);

    const dblclickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const row = g.rows[ht.row]?.dataItem as MainRow | undefined;
      if (row) onRowDblClick(row);
    };
    g.hostElement.addEventListener('dblclick', dblclickHandler);

    // 상단 그리드 셀 병합 — AS-IS siMain.SmartColMerge() 이식(cs:277 등).
    //   공용 CustomMergeManager(DataGrid 자동설치)가 좌측 누적 키로 선행 식별컬럼
    //   (Division/Site/Model/Nick Name)만 계층 병합하고, 신규행(CRUD_TYPE='I')은 병합에서 제외한다.
    //   값/감사 컬럼은 행마다 값이 달라 자연히 묶이지 않는다. AllowMerging.All 은 DataGrid prop 로 지정.
    for (let i = 0; i < g.columns.length; i++) g.columns[i].allowMerging = true;
    g.invalidate(true);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler);
        g.hostElement?.removeEventListener('dblclick', dblclickHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns, onRowDblClick]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      allowMerging={AllowMerging.All}
      gotFocus={onFocus}
    />
  );
};
