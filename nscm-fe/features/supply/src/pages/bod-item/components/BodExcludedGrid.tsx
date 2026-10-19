import {
  AllowMerging,
  type CellRangeEventArgs,
  type FlexGrid,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  BOD_EXCLUDED_COLUMN,
  BOD_EXCLUDED_EDITABLE,
  BOD_EXCLUDED_MERGE_COLUMNS,
  BOD_EXCLUDED_NEW_ROW_KEYS,
  MENU_ID,
  SHEETS,
} from '../bod-item.constants';
import type { BodExcludedRow } from '../bod-item.types';
import { useBodItemStore } from '../useBodItemStore';
import { toSingleRowHeaderColumns } from '../utils/bod-item.util';

interface BodExcludedGridProps {
  gridRef: MutableRefObject<FlexGrid<BodExcludedRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: BodExcludedRow[];
  isEditMode: boolean;
  divisionId: string;
  /** ITEM_ID 셀 더블클릭 → Material-by-division 팝업(03 §5-7). */
  onItemCellDblClick: (row: BodExcludedRow, rowIndex: number) => void;
  /** BOD_ID 셀 더블클릭 → GetBODItem 팝업(retList cascade 신규행 채움, 03 §5-7). */
  onBodCellDblClick: (row: BodExcludedRow, rowIndex: number) => void;
}

// ITEM_ID/BOD_ID = 팝업 셀(더블클릭으로 열림) — 인라인 편집 진입을 취소한다(#5-16 팝업 셀 편집취소).
const POPUP_CELLS: readonly string[] = [BOD_EXCLUDED_COLUMN.ITEM_ID, BOD_EXCLUDED_COLUMN.BOD_ID];

/**
 * Excluded Item 시트 그리드 — 편집가능=BOD_EX_FROM/TO_YYYYMMDD·VALID_YN(03 §3-A). 신규행은 Excluded
 * 시트에서만 추가(bodItem 은 추가불가), 키(DIVISION_ID/ITEM_ID/BOD_ID)는 팝업으로 채운다. ITEM_ID/BOD_ID
 * 셀 더블클릭으로 Material/GetBODItem 팝업을 열고(#5-16 편집취소), VALID_YN 콤보(YesOrNo)는 admin 메타 구동.
 * 세로 병합(SmartColMerge cs:403/799, 03 §3-E) + 편집모드 편집가능 셀 편집색(#95)은 bodItem 과 동일 처방.
 */
export const BodExcludedGrid = ({
  gridRef,
  gridFilterRef,
  data,
  isEditMode,
  divisionId,
  onItemCellDblClick,
  onBodCellDblClick,
}: BodExcludedGridProps) => {
  const rawStaticColumns = useBodItemStore(state => state.staticColumns[SHEETS.BOD_EXCLUDED]);
  // 헤더 1줄 강제(화면 예외) — admin 메타의 소/대분류 그룹라벨을 벗겨 단일행으로 렌더(AS-IS 파리티).
  const staticColumns = useMemo(() => toSingleRowHeaderColumns(rawStaticColumns), [rawStaticColumns]);

  const isEditModeRef = useRef(isEditMode);
  isEditModeRef.current = isEditMode;

  // 편집가능 게이트 — 팝업 셀(ITEM_ID/BOD_ID)은 인라인 편집을 취소하고 그 자리에서 팝업을 연다.
  //   네이티브 'dblclick' DOM 이벤트(hostElement 레벨)에 의존하던 이전 방식은 frozen+세로병합 컬럼
  //   조합에서 이벤트가 전혀 올라오지 않는 증상이 있어(2026-10-02 실측 — 더블클릭해도 핸들러 자체가
  //   호출 안 됨), Wijmo 가 실제로 처리하는 beginningEdit(더블클릭/F2/Enter 로 편집 진입 시도) 로 옮긴다.
  //   그 외 컬럼은 편집모드 + 화이트리스트일 때만 편집 허용.
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const handler = (s: FlexGrid<BodExcludedRow>, e: CellRangeEventArgs) => {
      const binding = s.columns[e.col]?.binding;
      if (!binding) return;
      if (POPUP_CELLS.includes(binding)) {
        e.cancel = true;
        // AS-IS SpdMain_CellDoubleClick 가드(cs:1775, buttonGuards #12) 등가 — 편집모드가 아니면 팝업 미오픈
        //   (04_react-gap.md G-DBLCLICK-EDITMODE-GUARD).
        if (!isEditModeRef.current) return;
        const dataItem = GridUtils.getRow(s, e.row) as BodExcludedRow | undefined;
        if (!dataItem) return;
        if (binding === BOD_EXCLUDED_COLUMN.ITEM_ID) onItemCellDblClick(dataItem, e.row);
        else if (binding === BOD_EXCLUDED_COLUMN.BOD_ID) onBodCellDblClick(dataItem, e.row);
        return;
      }
      if (!isEditModeRef.current) {
        e.cancel = true;
        return;
      }
      if (BOD_EXCLUDED_EDITABLE.includes(binding)) return;
      // 신규행(Insert) 키 컬럼(DIVISION_ID)은 그 행에 한해 편집 허용 — BOD_EXCLUDED_NEW_ROW_KEYS가
      //   정의만 되고 어디서도 적용되지 않아(죽은 상수) 신규행도 DIVISION_ID 를 영구히 편집할 수
      //   없던 결함(사용자 리포트 2026-10-06: 복수 division 조회 후 Insert 시 Division 미표시).
      if (BOD_EXCLUDED_NEW_ROW_KEYS.includes(binding)) {
        const dataItem = GridUtils.getRow(s, e.row) as (BodExcludedRow & WijmoRowItem) | undefined;
        if (dataItem?.CRUD_TYPE === CRUD_TYPE.INSERT || dataItem?.CRUD_TYPE === CRUD_TYPE.CREATE) return;
      }
      e.cancel = true;
    };
    grid.beginningEdit.addHandler(handler);
    return () => grid.beginningEdit.removeHandler(handler);
  }, [gridRef, onItemCellDblClick, onBodCellDblClick]);

  // 컬럼별 병합(allowMerging) — 공용 DataGrid 는 allowMerging prop 이 켜지면 전 컬럼에 true 를 씌우므로,
  // updatedLayout 마다 BOD_EXCLUDED_MERGE_COLUMNS 외 컬럼을 false 로 되돌린다(bodItem 표준 처방).
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const apply = () => {
      for (const col of grid.columns) {
        if (!col.binding) continue;
        col.allowMerging = BOD_EXCLUDED_MERGE_COLUMNS.has(col.binding);
      }
    };
    grid.updatedLayout.addHandler(apply);
    apply();
    return () => {
      grid.updatedLayout?.removeHandler(apply);
    };
  }, [gridRef, data]);

  // 편집가능 셀 배경(노란색)은 공용 DataGrid 가 컬럼 메타(INPUT_TP_CD)로 지정한다 —
  //   화면에서 별도 색상 지정하지 않는다(사용자 지시 2026-09-29, wj-cell-editable 공통 처리).

  const itemsSource = useMemo(() => data, [data]);

  return (
    <DataGrid<BodExcludedRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={itemsSource}
      staticColumns={staticColumns}
      allowMerging={AllowMerging.Cells}
      comboParams={{ divisionId, mnuId: MENU_ID }}
    />
  );
};
