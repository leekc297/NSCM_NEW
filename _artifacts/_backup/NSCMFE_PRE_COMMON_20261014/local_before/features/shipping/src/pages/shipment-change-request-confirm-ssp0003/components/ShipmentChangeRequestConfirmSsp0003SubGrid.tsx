import {
  AllowMerging,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import {
  CHANGE_TYPE_PLAN,
  MENU_ID,
  SUB_COL,
  SUB_GROUP_LABEL,
  SUB_PLAN_HIDE_COLUMN,
} from '../shipment-change-request-confirm-ssp0003.constants';
import type { SubRow } from '../shipment-change-request-confirm-ssp0003.types';
import { buildColumns } from '../utils/shipmentChangeRequestConfirmSsp0003Columns';

interface Props {
  rows: SubRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  division: string;
  changeType: string; // 선택 마스터행 CHANGE_TYPE — 'P'(Plan) 시 컬럼세트 분기(design 03 §2)
  adminColumns?: RawFlexGridColumnConfig[];
  // CHK 상태머신(design 03 §3.4): 체크된 행 CONFIRM_ID 집합 + 활성 여부(status else/Q 만 토글) + 토글 콜백.
  checkedIds: string[];
  chkEditable: boolean;
  onToggle: (confirmId: string) => void;
  onToggleAll: (check: boolean) => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' || typeof v === 'boolean' ? String(v) : '';

// _sChangeType='P'(Plan): ERP_SO_NO 숨김 + 그룹라벨 "Confirmed"->"Plan"/"Change"->"Confirm"(메타에 없어 FE 오버라이드).
//   else(C/N/A): ERP_SO_NO 표시 + 그룹라벨 "Confirmed"/"Change"(메타 SMALL_CLASS_LABEL_NAME 일치). design 03 §2.
const applyChangeTypeBranch = (
  cols: RawFlexGridColumnConfig[],
  changeType: string
): RawFlexGridColumnConfig[] => {
  const isPlan = changeType === CHANGE_TYPE_PLAN;
  if (!isPlan) return cols; // else 분기 = 메타 그대로(Confirmed/Change), ERP_SO_NO visible 유지
  return cols.map(c => {
    if (c.colNm === SUB_PLAN_HIDE_COLUMN) return { ...c, visible: false };
    if (c.sClsLblNm === SUB_GROUP_LABEL.DEFAULT.confirmed)
      return { ...c, sClsLblNm: SUB_GROUP_LABEL.PLAN.confirmed };
    if (c.sClsLblNm === SUB_GROUP_LABEL.DEFAULT.change)
      return { ...c, sClsLblNm: SUB_GROUP_LABEL.PLAN.change };
    return c;
  });
};

// AS-IS siSub "Shipment Change Request Confirm Detail" (54열, CHK 제외 전열 LockColumn=조회전용, design 03 §3.3).
//   CHK(선택 체크박스)만 상태별 활성(§3.4): 마스터 SHIPMENT_STATUS else(Q)일 때 사용자가 토글, 그 외는 표시·잠금.
//   CHK 는 편집기가 아니라 클릭 토글(EditTracker 미개입 — read-only 그리드) — project-list 체크박스 패턴 동일.
//   2단 헤더(Confirmed/Change 또는 Plan/Confirm, SMALL_CLASS_LABEL_NAME, hook #93). 셀콤보 2(FCST_TYPE/STATUS_DETAIL).
//   AS-IS 셀 병합 없음(SmartColMerge 주석·Add*Column FPMerge 전부 dead block, react-gap-audit iter-1 SSP0003-06) → AllowMerging.None.
export const ShipmentChangeRequestConfirmSsp0003SubGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  division,
  changeType,
  adminColumns,
  checkedIds,
  chkEditable,
  onToggle,
  onToggleAll,
}: Props) => {
  const columns = useMemo(
    () => applyChangeTypeBranch(buildColumns(adminColumns, true), changeType),
    [adminColumns, changeType]
  );
  const comboParams = useMemo(
    () => ({ mnuId: `'${MENU_ID}'`, divisionId: `'${division}'` }),
    [division]
  );

  const [grid, setGrid] = useState<FlexGridType | undefined>();
  // 핸들러가 최신 값을 보되 재등록 없이 동작하도록 ref 미러(project-list 패턴).
  const checkedRef = useRef<Set<string>>(new Set());
  const editableRef = useRef(chkEditable);
  const onToggleRef = useRef(onToggle);
  const onToggleAllRef = useRef(onToggleAll);
  checkedRef.current = useMemo(() => new Set(checkedIds), [checkedIds]);
  editableRef.current = chkEditable;
  onToggleRef.current = onToggle;
  onToggleAllRef.current = onToggleAll;

  const rowId = (g: FlexGridType, r: number): string =>
    str((g.rows[r]?.dataItem as Record<string, unknown> | undefined)?.[SUB_COL.CONFIRM_ID]);

  const allChecked = (g: FlexGridType): boolean =>
    g.rows.length > 0 && g.rows.every(r => checkedRef.current.has(str((r.dataItem as Record<string, unknown>)?.[SUB_COL.CONFIRM_ID])));

  // CHK 체크박스 렌더 + 전체선택 헤더 + 클릭 토글 — grid 준비(initialized) 후 1회 등록.
  useEffect(() => {
    if (!grid) return;

    const isChkCol = (col: number): boolean => grid.columns[col]?.binding === SUB_COL.CHK;

    const formatHandler = (_s: FlexGridType, e: FormatItemEventArgs) => {
      // 셀 CHK 체크박스
      if (e.panel === grid.cells && isChkCol(e.col)) {
        const checked = checkedRef.current.has(rowId(grid, e.row));
        const cb = document.createElement('input');
        cb.type = 'checkbox';
        cb.checked = checked;
        cb.disabled = !editableRef.current;
        cb.tabIndex = -1;
        e.cell.innerHTML = '';
        e.cell.appendChild(cb);
        return;
      }
      // 헤더 전체선택 체크박스(§3.4 #2)
      if (e.panel === grid.columnHeaders && e.cell && isChkCol(e.col)) {
        const cb = document.createElement('input');
        cb.type = 'checkbox';
        cb.checked = allChecked(grid);
        cb.disabled = !editableRef.current;
        cb.tabIndex = -1;
        e.cell.innerHTML = '';
        e.cell.appendChild(cb);
      }
    };
    grid.formatItem.addHandler(formatHandler);

    const clickHandler = (ev: MouseEvent) => {
      const ht = grid.hitTest(ev);
      if (!ht || ht.col < 0 || !isChkCol(ht.col) || !editableRef.current) return;
      // 헤더 클릭 = 전체 토글
      if (ht.panel === grid.columnHeaders) {
        onToggleAllRef.current(!allChecked(grid));
        return;
      }
      // 셀 클릭 = 행 토글
      if (ht.panel === grid.cells && ht.row >= 0) {
        const id = rowId(grid, ht.row);
        if (id) onToggleRef.current(id);
      }
    };
    grid.hostElement.addEventListener('click', clickHandler);

    return () => {
      try {
        grid.formatItem.removeHandler(formatHandler);
        grid.hostElement.removeEventListener('click', clickHandler);
      } catch {
        /* unmount race */
      }
    };
     
  }, [grid]);

  // 체크 상태·활성·행 변경 시 체크박스 재렌더(핸들러는 ref 로 최신값을 본다).
  useEffect(() => {
    grid?.invalidate();
  }, [grid, checkedIds, chkEditable, rows]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      isReadOnly={true}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      comboParams={comboParams}
      initialized={g => setGrid(g)}
      // AS-IS 셀 병합 없음(SmartColMerge/FPMerge 전부 dead) → 파리티상 병합 비활성(SSP0003-06 해소).
      allowMerging={AllowMerging.None}
    />
  );
};
