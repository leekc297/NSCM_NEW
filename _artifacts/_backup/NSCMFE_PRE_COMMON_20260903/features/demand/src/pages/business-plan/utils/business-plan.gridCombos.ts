// ⭐ DMF0042 — Grid 셀 콤보 dataMap 스왑/원복 헬퍼 (hook #59 §5-G — beginningEdit 스왑 + cellEditEnded 원복).
//   근거(라인 = AS-IS DMF0042_1_BizPlan.cs):
//     · Insert 콤보 바인딩 : InsertRow L1187~1214 — DEPT_ID(40=DEPT_ID40)/END_CUSTOMER(40)/
//       SCM_SITE_ID(40/81/82)/CURRENCY(CURRENCY_LIST)/CELL_PROD_SITE(40, GetCellProdSite).
//     · 행 cascade         : ComboSelChange L1565~1596 40 전용 2키 (constants GRID_CASCADE_FILTERS 참조).
import { DataMap } from '@mescius/wijmo.grid';

import type { BusinessPlanRow } from '../business-plan.types';

// 타입 안전 string 변환 — string/number 만 (객체는 ''). no-base-to-string 회피.
export const toCellStr = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 행 컨텍스트 cascade 필터 — 콤보 원본 rows 를 상위 셀 값으로 클라 필터 (관대 통과: 공란/'ALL' = 통과).
export const filterComboRowsByRow = (
  src: Record<string, unknown>[],
  row: BusinessPlanRow,
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
  // Map 복합 키 dedup (hook #59 §3) — 필터 후 division 컨텍스트 유지.
  return [
    ...new Map(
      filtered.map(cr => [`${toCellStr(cr.DIVISION_ID)}|${toCellStr(cr.CODE)}`, cr])
    ).values(),
  ];
};

// Insert Measure 블록 원천 — CMBO 'DMF0042_BP_Measure' rows 를 division 토큰으로 클라 필터
//   (AS-IS Data.Common("DMF0042_BP_Measure", division) 1:1 — DIVISION_ID 미보유 콤보는 전체 통과).
export const measureBlockOf = (rows: Record<string, unknown>[], divisionId: string): string[] => {
  const d = (divisionId ?? '').trim();
  return rows
    .filter(r => {
      const dv = toCellStr(r.DIVISION_ID).trim();
      return !dv || !d || dv === d;
    })
    .map(r => toCellStr(r.CODE).trim())
    .filter(Boolean);
};

// 콤보 rows → DataMap (0건 = null — 메타 주도, 하드코딩 fallback 금지)
export const buildDataMap = (rows: Record<string, unknown>[]): DataMap | null =>
  rows.length > 0 ? new DataMap(rows, 'CODE', 'NAME') : null;
