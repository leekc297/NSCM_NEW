import { toggleClass } from '@mescius/wijmo';
import { AllowMerging, CellType, type FlexGrid as FlexGridType, type FormatItemEventArgs } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { SHEETS } from '../contribute-main.constants';
import type { MainRow } from '../types';
import { useContributeMainStore } from '../useContributeMainStore';

interface Props {
  gridRef: MutableRefObject<FlexGridType<MainRow> | undefined>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef?: MutableRefObject<EditTracker<MainRow> | undefined>;
  data: MainRow[];
}

// AS-IS analysis.md §10 — 다단 헤더 (period 라벨 + RBU 한글명 leaf) + Y#/M# 동적 PIVOT.
// BASE 6 컬럼: admin SHEET_COLUMNS (staticColumns) 로 동적 fetch — 하드코딩 0.
// PIVOT 컬럼: SP 응답 row[k] 에서 derive — dynamicColumns prop 으로 DataGrid 전달.
// chkYear: true → Y# (연도총계) / false → M# (월별).
const RBU_NAME_MAP: Record<string, string> = {
  RBU_0001: '대만',
  RBU_0002: '중국-화남',
  RBU_0008: '중국-화북',
  RBU_0003: '미주',
  RBU_0004: '유럽',
  RBU_0005: '일본',
  RBU_0007: '인도',
  RBU_0006: '기타',
  RBU_0999: '구분',
};
const RBU_ORDER = [
  'RBU_0001',
  'RBU_0002',
  'RBU_0008',
  'RBU_0003',
  'RBU_0004',
  'RBU_0005',
  'RBU_0007',
  'RBU_0006',
  'RBU_0999',
];

interface DynColLeaf {
  binding: string;
  period: string;
  periodLabel: string;
  leafLabel: string;
  rbuCode: string;
}

const buildDynamicColumns = (data: MainRow[], chkYear: boolean): FlexGridColumnConfig[] => {
  if (!data || data.length === 0) return [];
  const prefix = chkYear ? 'Y#' : 'M#';
  const allKeys = new Set<string>();
  for (const row of data) {
    for (const k of Object.keys(row)) {
      if (k.startsWith(prefix)) allKeys.add(k);
    }
  }
  const leaves: DynColLeaf[] = Array.from(allKeys)
    .map(k => {
      const [, period, corp] = k.split('#');
      return {
        binding: k,
        period: period ?? '',
        periodLabel:
          period?.length === 6 ? `${period.slice(0, 4)}-${period.slice(4)}` : (period ?? ''),
        leafLabel: RBU_NAME_MAP[corp ?? ''] ?? corp ?? '',
        rbuCode: corp ?? '',
      };
    })
    .sort((a, b) => {
      const periodCmp = a.period.localeCompare(b.period);
      if (periodCmp !== 0) return periodCmp;
      return RBU_ORDER.indexOf(a.rbuCode) - RBU_ORDER.indexOf(b.rbuCode);
    });

  // DMF0007 customer-forecast-master 패턴 — 각 leaf 마다 별도 group (1:1) 으로 분리.
  // 같은 header 의 인접 group 은 wijmo 가 자동 가로 머지 → group cell rowspan 안 함.
  // ⭐ `height: 24` 의무 (= `HEIGHT_BY_COLUMN_DEPTH.TWO_DEPTH`, `columnMapping.ts:28`)
  // — DataGrid wrapper 가 staticColumns 만 자동 적용하므로 dynamicColumns 는 화면에서 명시.
  return leaves.map(leaf => {
    // RBU_0999 (구분 컬럼) = readonly. 그 외 Y#/M# = OPTIONAL 편집 가능.
    // GridUtils.isEditableCell 가 column._inputEditType 없으면 default false (편집 불가)
    // 처리 → 동적 컬럼에 명시 의무 (hook #70 P2 related).
    const isRbu999 = leaf.rbuCode === 'RBU_0999';
    return {
      header: leaf.periodLabel || leaf.period,
      align: 'center',
      allowSorting: false,
      allowMerging: false,
      height: 24,
      columns: [
        {
          binding: leaf.binding,
          header: leaf.leafLabel,
          width: 80,
          align: 'right',
          format: 'n2',
          allowSorting: false,
          allowMerging: false,
          height: 24,
          _inputEditType: isRbu999 ? CELL_INPUT_EDIT_TYPE.SEARCH_ONLY : CELL_INPUT_EDIT_TYPE.OPTIONAL,
        },
      ],
    };
  }) as FlexGridColumnConfig[];
};

export const ContributeMainGrid = ({ gridRef, gridFilterRef, editTrackerRef, data }: Props) => {
  const internalRef = useRef<FlexGridType<MainRow> | undefined>();
  const chkYear = useContributeMainStore(s => s.searchParams.chkYear);
  const staticColumns = useContributeMainStore(s => s.staticColumns[SHEETS.MAIN]);

  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(
    () => buildDynamicColumns(data, chkYear),
    [data, chkYear]
  );

  // 동적 PIVOT 컬럼 cell coloring — 동적 컬럼 (admin 메타 없음) 에서 wrapper 의
  // formatEditableColumns 가 isEditableCell=false 로 판정해 wj-cell-editable 을 제거.
  // 따라서 wrapper 가 등록한 이후(=mount 시점) 핸들러를 다시 등록 → FIFO 호출 순서에서
  // wrapper 다음에 호출되어 최종 toggle 결과가 살아남음.
  useEffect(() => {
    const grid = gridRef.current ?? internalRef.current;
    if (!grid) return;
    const handler = (_s: FlexGridType<MainRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const col = e.panel.columns[e.col];
      if (!col?.binding) return;
      if (!col.binding.startsWith('Y#') && !col.binding.startsWith('M#')) return;
      const isRbu999 = col.binding.endsWith('RBU_0999');
      toggleClass(e.cell, 'wj-cell-editable', !isRbu999);
      toggleClass(e.cell, 'wj-cell-non-editable', isRbu999);
    };
    grid.formatItem.addHandler(handler);
    grid.invalidate();
    return () => grid.formatItem.removeHandler(handler);
  }, [staticColumns, dynamicColumns]);

  // AS-IS Dsdm_Changed 1:1 — 동적 컬럼 (Y#/M#) 수정만 EDIT_FLAG='M' 마킹.
  // BASE 6 컬럼은 readonly 라 영향 없음. RBU_0999 도 cell coloring 으로 readonly.
  // dependency [staticColumns, dynamicColumns] — gridRef.current 가 set 된 후 등록 보장
  // (handler 미등록 시 row.EDIT_FLAG 변경 안 됨 → handleSave dirty=0 사고).
  useEffect(() => {
    const grid = gridRef.current ?? internalRef.current;
    if (!grid) return;
    const handler = (
      _s: FlexGridType<MainRow>,
      e: { row: number; col: number }
    ) => {
      const col = grid.columns[e.col];
      if (!col?.binding) return;
      if (!col.binding.startsWith('Y#') && !col.binding.startsWith('M#')) return;
      const row = grid.rows[e.row]?.dataItem as MainRow | undefined;
      if (row && row.EDIT_FLAG === 'N') row.EDIT_FLAG = 'M';
    };
    grid.cellEditEnded.addHandler(handler);
    return () => grid.cellEditEnded.removeHandler(handler);
  }, [staticColumns, dynamicColumns]);

  // 다단 헤더 row 높이는 buildDynamicColumns 의 group/leaf 객체 안 `height: 24` 로 해결됨.
  // (DataGrid wrapper 의 HEIGHT_BY_COLUMN_DEPTH.TWO_DEPTH = 24 정합).
  // hook #70 P2 — internalRef 는 useEffect 에서 gridRef.current 가 set 된 후 동기화.
  useEffect(() => {
    if (gridRef.current) internalRef.current = gridRef.current;
  }, [staticColumns, dynamicColumns]);

  // BE 응답 row 의 EDIT_FLAG='N' 으로 인해 DataGrid wrapper 의 setEditableColumns 가
  // beginningEdit 를 cancel (GridUtils.isEditableCell 의 OPTIONAL 분기 = editFlag !== 'N').
  // 동적 컬럼 (Y#/M#) 은 EDIT_FLAG 무관 항상 편집 가능 의도 (AS-IS LockRange 는 별도) →
  // beginningEdit 핸들러 등록 (wrapper 다음 FIFO) + cancel=false 강제.
  useEffect(() => {
    const grid = gridRef.current ?? internalRef.current;
    if (!grid) return;
    const handler = (
      _s: FlexGridType<MainRow>,
      e: { col: number; cancel: boolean }
    ) => {
      const col = grid.columns[e.col];
      if (!col?.binding) return;
      if (!col.binding.startsWith('Y#') && !col.binding.startsWith('M#')) return;
      if (col.binding.endsWith('RBU_0999')) return; // RBU_0999 readonly
      e.cancel = false; // 동적 PIVOT cell 편집 강제 허용
    };
    grid.beginningEdit.addHandler(handler);
    return () => grid.beginningEdit.removeHandler(handler);
  }, [staticColumns, dynamicColumns]);

  // 사용자 F3 누르기 전 sort indicator 표시 사고 fix:
  // wijmo column.allowSorting 기본값 true → DataGrid wrapper 의 formatSortableColumns 가
  // 모든 column 에 wj-sort-unsorted-icon 표시. GridAction.toggleColumnSort(F3) 가 토글
  // 방식이라 default false 로 강제. 사용자가 F3 누르면 true 로 토글 → indicator 표시.
  useEffect(() => {
    const grid = internalRef.current;
    if (!grid) return;
    grid.columns.forEach(col => {
      col.allowSorting = false;
    });
    grid.invalidate();
  }, [dynamicColumns, staticColumns]);

  return (
    <DataGrid<MainRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      staticColumns={staticColumns}
      dynamicColumns={dynamicColumns}
      itemsSource={data}
      allowMerging={AllowMerging.All}
    />
  );
};
