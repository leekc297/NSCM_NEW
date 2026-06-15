import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { FlexGridColumn } from '@mescius/wijmo.react.grid';
import { FlexGridFilter } from '@mescius/wijmo.react.grid.filter';
import { useMemo, type RefObject } from 'react';

import { DataGrid } from '@shared/components';

import { useSalesMonitoringExpression } from '../hooks/useSalesMonitoringExpression';
import { FROZEN_COL_COUNT, MAIN_COLUMNS } from '../sales-monitoring.constants';
import type { SalesMonitoringMeta, SalesMonitoringRow, SpreadTitleRow } from '../sales-monitoring.types';

interface Props {
  gridRef: RefObject<FlexGridType<SalesMonitoringRow> | null>;
  gridFilterRef: RefObject<FlexGridFilter | undefined>;
  rows: SalesMonitoringRow[];
  titleRows: SpreadTitleRow[];        // 동적 헤더 메타 (P_DMF0048_GET_SPREAD_TITLE 결과)
  meta?: SalesMonitoringMeta;         // 현재 주 강조용 (THIS_YYYYMMWW)
  showColor: boolean;                  // chkColor (setResultPeriod 실적/계획 구간 색상 분기)
  showSum: boolean;                    // chkSum (SUM 컬럼 W_/M_ visibility)
  bucketType: 'DAILY' | 'WEEKLY' | 'MONTHLY';  // expression hook 분기 (SetSpreadColumn bucket 분기)
  loading: boolean;
}

// AS-IS DMF0048_SalesMonitoring.cs Grid 정밀 fact (Option A 정정 — 2026-06-08):
//   L735 LockColumn(0, MaxCol, true) — 최초 전체 잠금 (편집 mode 진입 시 해제)
//   L739 SmartColMerge() — 좌측 dimension 컬럼 자동 머지
//   L797~ PROJECT_CODE / ITEM_ID cellTypeImage 셀 우측 돋보기 (Sheet 표시만, dblClick X)
//   L856~949 setResultPeriod (chkColor 시 실적 Gainsboro / 계획 White / 현재 주 BevelBorder Green)
//   L1350~1378 ColumnHeaderSpan "SUM" (Large/Small 그룹 SUM 헤더)
//   L1385~1388 spdMain_CellDoubleClick — ⚠️ 빈 함수 (To-Be 매핑 불필요)
//   L1390~1544 Dsdm_Changed — D_ 컬럼 편집 시 Weekly+Monthly SUM 자동 재계산
//
// 룰 12 §11.5 PIVOT frozenColumns + §11.6 HierarchicalMergeManager
// 룰셋 fe-import-check: DataGrid (@shared/components), FlexGridColumn (@mescius/wijmo.react.grid)
export const SalesMonitoringGrid = ({
  gridRef,
  gridFilterRef,
  rows,
  titleRows,
  meta,
  showColor,
  showSum,
  bucketType,
  loading,
}: Props) => {
  // Expression 7건 매핑 (useSalesMonitoringExpression hook):
  //   - chkSum (W_/M_ visibility toggle)
  //   - chkColor (setResultPeriod 실적/계획/현재 주 색상 분기)
  //   - Dsdm_Changed cellEditEnded (Weekly+Monthly SUM 자동 계산)
  useSalesMonitoringExpression({
    gridRef,
    meta,
    showColor,
    showSum,
    bucketType,
  });

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
      {/* Static (BASE) columns — 51 cols
          ⚠️ AS-IS 부분 편집 가능: D_ 컬럼만 편집 가능 (Dsdm_Changed L1409)
          BASE 51 cols 는 모두 read-only (_inputEditType='S') */}
      {MAIN_COLUMNS.filter(c => c.visible !== false).map(col => (
        <FlexGridColumn
          key={col.key}
          binding={col.key}
          header={col.header}
          width={col.width}
          align={col.align === 'C' ? 'center' : col.align === 'R' ? 'right' : 'left'}
          format={col.format}
          isReadOnly
          allowMerging={col.merge}
          cssClass="wj-cell-readonly"
        />
      ))}

      {/* Dynamic time-axis columns — D_ / W_ / M_ (Bucket 별 분기)
          AS-IS L1409: D_ 컬럼만 편집 가능 (Dsdm_Changed)
          To-Be: D_ 컬럼 isReadOnly=false / W_,M_ 는 SUM 컬럼 — read-only + 자동 계산 */}
      {dynamicGroups.flatMap(g =>
        g.items.map(t => {
          const binding = t.BASIS_START_DATE2;
          const isEditable = binding.startsWith('D_');  // D_ 만 편집 가능
          return (
            <FlexGridColumn
              key={binding}
              binding={binding}
              header={t.MMDD || t.WEEK_NAME}
              width={70}
              align="right"
              format="n0"
              isReadOnly={!isEditable}
              cssClass={isEditable ? 'wj-cell-editable' : 'wj-cell-readonly'}
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
