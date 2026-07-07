// SYS0013 Main grid — AS-IS SCM0005_DynamicQueryList.cs L208-228 정합.
// CRUD: Insert/Edit/Delete 추적 → store.mainPendingChanges → SAVE 시 P_SYS0013_SAVE_QUERY_LIST.
// 메모리 룰 #70 P7: beginningEdit handler 등록 — 의도 binding 만 e.cancel=false override (Edit 활성).
import { SelectionMode, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import { SHEETS, SHEET_INDEX } from '../dynamic-query.constants';
import type { QueryRow } from '../dynamic-query.types';
import { useDynamicQueryStore } from '../useDynamicQueryStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<QueryRow> | null>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: QueryRow[];
  // 행 더블클릭 → Designer(View) 탭 진입 (DESIGN TABPAGE1 → TABPAGE2).
  onEnterDesigner?: () => void;
  // 현재 활성 탭 — Designer 진입 후 숨겨진 grid 의 row0 재선택이 selectedQueryId 를 덮어쓰지 않도록 가드.
  activePage?: SHEET_INDEX;
}

// 편집 허용 binding (AS-IS EditButton L301-316 — ROLE/CREATED_BY~ADMIN_ONLY_YN 잠금).
const EDITABLE_BINDINGS = new Set([
  'DQ_NAME',
  'DESCRIPTION',
  'DQ_TEXT',
  'VALID_YN',
  'ADMIN_ONLY_YN',
  'DIVISION_ID',
]);

export const DynamicQueryMainGrid = ({
  gridRef,
  gridFilterRef,
  data,
  onEnterDesigner,
  activePage,
}: Props) => {
  const setSelectedQueryId = useDynamicQueryStore(s => s.setSelectedQueryId);
  const staticColumns = useDynamicQueryStore(s => s.staticColumns[SHEETS.MAIN]);
  const trackMainModify = useDynamicQueryStore(s => s.trackMainModify);

  // Register 탭일 때만 selectionChanged 가 selectedQueryId 를 갱신 (Designer 진입 후 grid 재선택 무시).
  // ref 동기화 — dblclick 에서 동기 변경하여 탭전환 직후 spurious selectionChanged race 차단.
  const activePageRef = useRef(activePage);
  activePageRef.current = activePage;

  const handleSelectionChanged = (g: FlexGrid<QueryRow>) => {
    if (activePageRef.current !== SHEET_INDEX.REGISTER) return;
    const row = g.selectedItems[0] as QueryRow | undefined;
    const dqId = row?.DQ_ID;
    if (dqId !== undefined && dqId !== null && dqId !== '') {
      setSelectedQueryId(String(dqId));
    }
  };

  const handleCellEditEnded = (g: FlexGrid<QueryRow>, e: { row: number; col: number }) => {
    const row = g.rows[e.row]?.dataItem as QueryRow | undefined;
    if (!row) return;
    const id = row.DQ_ID;
    if (id === undefined || id === null || id === '') return;
    trackMainModify(String(id), row as unknown as Record<string, unknown>);
  };

  // beginningEdit handler 등록 — admin 메타 INPUT_TP_CD 무관하게 의도 binding 편집 허용.
  // (메모리 #70 P7 — wrapper 의 isEditableCell 이 INPUT_TP_CD='S' 시 cancel=true → override 의무)
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const onBeginningEdit = (
      sender: FlexGrid<QueryRow>,
      e: { cancel: boolean; col: number; row: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (EDITABLE_BINDINGS.has(binding)) {
        e.cancel = false;
      }
    };
    grid.beginningEdit.addHandler(onBeginningEdit);
    return () => {
      grid.beginningEdit.removeHandler(onBeginningEdit);
    };
  }, [gridRef]);

  // 행 더블클릭 → Designer 진입 (DESIGN TABPAGE1 → TABPAGE2).
  // DataGrid wrapper 의 dblClick prop(ref 배선) 사용 + hitTest 로 더블클릭한 실제 row 확정
  // → selectedItems 타이밍/탭전환 재선택과 무관.
  const handleDblClick = (e: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid || !onEnterDesigner) return;
    const ht = grid.hitTest(e);
    if (!ht || ht.row < 0) return;
    const row = grid.rows[ht.row]?.dataItem as QueryRow | undefined;
    const dqId = row?.DQ_ID;
    if (dqId === undefined || dqId === null || dqId === '') return;
    setSelectedQueryId(String(dqId)); // 더블클릭한 실제 row 로 확정
    activePageRef.current = SHEET_INDEX.DESIGNER; // 동기 가드 — 직후 spurious selectionChanged 차단
    onEnterDesigner();
  };

  return (
    <DataGrid<QueryRow>
      gridRef={gridRef as MutableRefObject<FlexGrid<QueryRow> | undefined>}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      selectionMode={SelectionMode.Row}
      selectionChanged={handleSelectionChanged}
      cellEditEnded={handleCellEditEnded}
      dblClick={handleDblClick}
    />
  );
};
