// ⭐ DMF0044 — Grid 셀 콤보 dataMap 헬퍼 (hook #59 §5-G — business-plan.gridCombos 동형 축약).
//   AS-IS cascade: spdMain_Changed M-6/M-7 (L1174~1293) — DEPARTMENT_ID→DEPT_ID 콤보,
//   DEPT_ID→고객/제품군 콤보 연동 (CMBO 'DMF0044_MDF_DEPARTMENT'/'DMF0044_DEPARTMENT_TEAM2' 원천).
import { DataMap } from '@mescius/wijmo.grid';

import type { SalesReportRow } from '../sales-reports.types';

export const toCellStr = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 행 컨텍스트 cascade 필터 (관대 통과: 공란/'ALL' = 통과)
export const filterComboRowsByRow = (
  src: Record<string, unknown>[],
  row: SalesReportRow,
  cascade: { rowKey: string; comboKey: string }[]
): Record<string, unknown>[] => {
  const rowRec = row as Record<string, unknown>;
  const filtered = src.filter(cr =>
    cascade.every(({ rowKey, comboKey }) => {
      const rv = toCellStr(rowRec[rowKey]).trim();
      const cv = toCellStr(cr[comboKey]).trim();
      return !rv || rv === 'ALL' || !cv || rv === cv;
    })
  );
  return [
    ...new Map(
      filtered.map(cr => [`${toCellStr(cr.DIVISION_ID)}|${toCellStr(cr.CODE)}`, cr])
    ).values(),
  ];
};

// 콤보 rows → DataMap (0건 = null — 메타 주도, 하드코딩 fallback 금지)
export const buildDataMap = (rows: Record<string, unknown>[]): DataMap | null =>
  rows.length > 0 ? new DataMap(rows, 'CODE', 'NAME') : null;

// Grid 행 cascade 정의 — DEPARTMENT_ID → DEPT_ID (AS-IS ComboSelChange M-6)
export const GRID_CASCADE_FILTERS: Record<string, { rowKey: string; comboKey: string }[]> = {
  DEPT_ID: [{ rowKey: 'DEPARTMENT_ID', comboKey: 'DEPARTMENT_ID' }],
};
