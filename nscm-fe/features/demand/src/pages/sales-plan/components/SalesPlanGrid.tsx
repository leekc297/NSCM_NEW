import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { FlexGridColumn } from '@mescius/wijmo.react.grid';
import { FlexGridFilter } from '@mescius/wijmo.react.grid.filter';
import { useEffect, useMemo, type RefObject } from 'react';

import { DataGrid } from '@shared/components';

import { useSalesPlanExpression } from '../hooks/useSalesPlanExpression';
import { FROZEN_COL_COUNT, MAIN_COLUMNS } from '../sales-plan.constants';
import type { SalesPlanMeta, SalesPlanRow, SpreadTitleRow } from '../sales-plan.types';

interface Props {
  gridRef: RefObject<FlexGridType<SalesPlanRow> | null>;
  gridFilterRef: RefObject<FlexGridFilter | undefined>;
  rows: SalesPlanRow[];
  titleRows: SpreadTitleRow[];        // 동적 헤더 메타 (P_DMF0021_GET_SPREAD_TITLE 결과)
  meta?: SalesPlanMeta;                // 현재 주 강조용 (THIS_YYYYMMWW)
  showColor: boolean;                  // chkColor (실적/계획/현재주 분기)
  showSum: boolean;                    // chkSum (W_/M_ visibility)
  bucketType: 'DAILY' | 'WEEKLY' | 'MONTHLY';
  divisionId: string;                  // 사업부 분기 (40/81/82)
  isEditMode: boolean;                 // F2 Edit Mode (편집 가능 cell 잠금 해제)
  loading: boolean;
  onCellDoubleClick?: (row: number, col: number, binding: string) => void;  // Item/Project 셀 dblClick popup
}

// AS-IS DMF0021_SalesPlan.cs Grid 정밀 fact (Option A 정정 — 2026-06-09):
//   L735 LockColumn(0, MaxCol, true) — 최초 전체 잠금 (편집 mode 진입 시 해제)
//   L739 SmartColMerge() — 좌측 dimension 컬럼 자동 머지
//   L797~ PROJECT_CODE / ITEM_ID cellTypeImage 셀 우측 돋보기 (dblClick popup 호출)
//   L816~856 setResultPeriod (chkColor 시 실적 Gainsboro / 계획 White / 현재 주 BevelBorder Green)
//   L3715~3743 ColumnHeaderSpan "SUM" (Large/Small 그룹 SUM 헤더)
//   L3863 spdMain_CellDoubleClick — 40 사업부 Catch_Up 시 dblClick popup
//   L3918~4085 Dsdm_Changed — D_ 편집 시 Weekly+Monthly SUM 자동 재계산 (Expression hook)
//   L4540~5075 spdMain_ComboSelChange — Measure 변경 시 cascade lock (Expression hook 28)
//
// 룰 12 §11.5 PIVOT frozenColumns + §11.6 HierarchicalMergeManager
// 룰 12 §11.7 _inputEditType 표준 (S=read-only / M=필수 / O=선택 / IM/IO=Insert 전용)
// 룰셋 fe-import-check: DataGrid (@shared/components), FlexGridColumn (@mescius/wijmo.react.grid)
export const SalesPlanGrid = ({
  gridRef, gridFilterRef, rows, titleRows, meta,
  showColor, showSum, bucketType, divisionId, isEditMode, loading,
  onCellDoubleClick,
}: Props) => {

  // Expression 120 매핑 (useSalesPlanExpression hook):
  //   - SUM 헤더 5 (chkSum visibility)
  //   - chkColor (실적/계획/현재주 분기 색상)
  //   - EditButton 13 + InsertRow 70 (isEditMode/bucketType 별 D_/W_/M_ 잠금)
  //   - Dsdm_Changed 3 (D_ 편집 시 W_/M_ SUM cascade + 빨간색)
  //   - spdMain_ComboSelChange 28 (Measure 변경 시 cascade lock)
  useSalesPlanExpression({
    gridRef,
    meta,
    showColor,
    showSum,
    bucketType,
    divisionId,
    isEditMode,
  });

  // dblClick handler (AS-IS spdMain_CellDoubleClick L3772~3915)
  //   - PROJECT_CODE 셀 dblClick → Project popup 호출
  //   - ITEM_ID 셀 dblClick → Item popup 호출 (40 사업부 Catch_Up 시 사전 가드)
  useEffect(() => {
    const g = gridRef.current;
    if (!g || !onCellDoubleClick) return;

    const handler = (sender: FlexGridType<SalesPlanRow>, e: { row: number; col: number }) => {
      const col = sender.columns[e.col];
      const binding = String(col?.binding ?? '');
      // visibility false / Insert 'I' 행 외 dblClick 차단 (AS-IS L3772)
      if (!col?.visible) return;
      const rowItem = sender.rows[e.row]?.dataItem as SalesPlanRow;
      // AS-IS L3863 — 40 사업부 + Measure=Catch_Up + Item 셀일 때만 popup
      const division = String((rowItem as Record<string, unknown>)?.DIVISION_ID ?? divisionId);
      const measure = String(rowItem?.MEASURE ?? '');
      const allowPopup =
        binding === 'PROJECT_CODE' ||
        binding === 'ITEM_ID' ||
        (division === '40' && measure === 'Catch_Up' && binding === 'ITEM_ID');
      if (!allowPopup) return;
      onCellDoubleClick(e.row, e.col, binding);
    };
    g.cellDoubleClick?.addHandler?.(handler as never);
    return () => { g.cellDoubleClick?.removeHandler?.(handler as never); };
  }, [gridRef, onCellDoubleClick, divisionId]);

  // 동적 시간축 컬럼 그룹화 (YYYY > YYYY-MM > MMDD 3단 헤더)
  //   AS-IS .cs L1300~1383 SetSpreadColumn — BASIS_START_DATE2 (binding) + WEEK_NAME/MMDD (header)
  const dynamicGroups = useMemo(() => {
    if (!titleRows || titleRows.length === 0) return [];
    const groupMap = new Map<string, SpreadTitleRow[]>();
    titleRows.forEach(t => {
      const k = t.BASIS_YYYYMM ?? t.MON;
      if (!groupMap.has(k)) groupMap.set(k, []);
      groupMap.get(k)!.push(t);
    });
    return Array.from(groupMap.entries()).map(([ym, items]) => ({ ym, items }));
  }, [titleRows]);

  return (
    <DataGrid
      ref={gridRef}
      itemsSource={rows}
      autoGenerateColumns={false}
      allowSorting                        // F3 자동 활성
      allowDragging={false}
      frozenColumns={FROZEN_COL_COUNT}    // 룰 12 §11.5 PIVOT frozenColumns (BASE 4 cols 좌측 고정)
      loading={loading}
    >
      {/* Static (BASE) columns — 51 cols (5 DefColumns 그룹)
          ⚠️ AS-IS 부분 편집 가능 (DMF0048 과 다름):
            - Edit Mode 진입 시 권한 영역 (D_/W_/M_) 만 잠금 해제 — Expression hook 자동
            - BASE 51 cols 는 대부분 read-only (_inputEditType='S')
            - Insert 행은 추가 잠금 해제 (handleInsert 에서 _inputEditType='IM'/'IO' 동적) */}
      {MAIN_COLUMNS.filter(c => c.visible !== false).map(col => {
        const isPopupCell = col._ctrlType === 'FPModal';
        const isInputRequired = col._inputEditType === 'M' || col._inputEditType === 'IM';
        const isInputOptional = col._inputEditType === 'O' || col._inputEditType === 'IO';
        const isReadOnly = col._inputEditType === 'S';
        return (
          <FlexGridColumn
            key={col.key}
            binding={col.key}
            header={col.header}
            width={col.width}
            align={col.align === 'C' ? 'center' : col.align === 'R' ? 'right' : 'left'}
            format={col.format}
            isReadOnly={isReadOnly}
            allowMerging={col.merge}
            cssClass={
              isPopupCell
                ? 'wj-cell-popup'
                : isInputRequired
                  ? 'wj-cell-editable wj-cell-required'
                  : isInputOptional
                    ? 'wj-cell-editable'
                    : 'wj-cell-readonly'
            }
          />
        );
      })}

      {/* Dynamic time-axis columns — D_ / W_ / M_ (Bucket 별 분기)
          AS-IS L1409: D_/W_/M_ 컬럼 isReadOnly 는 Expression hook 이 동적 토글
          To-Be: 모든 동적 컬럼 isReadOnly=false (Expression hook 이 Bucket/Division 별 분기) */}
      {dynamicGroups.flatMap(g =>
        g.items.map(t => {
          const binding = t.BASIS_START_DATE2;
          return (
            <FlexGridColumn
              key={binding}
              binding={binding}
              header={t.MMDD || t.WEEK_NAME}
              width={70}
              align="right"
              format="n0"
              isReadOnly={false}                  // Expression hook 이 동적 토글
              cssClass="wj-cell-dynamic"
            />
          );
        }),
      )}

      {/* Filter — F4 자동 활성 */}
      <FlexGridFilter
        ref={(f: FlexGridFilter | null) => {
          if (f) gridFilterRef.current = f;
        }}
      />
    </DataGrid>
  );
};
