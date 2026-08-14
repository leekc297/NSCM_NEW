// ⭐ DMF0021 — Grid 셀 콤보 dataMap 스왑/원복 헬퍼 (hook #59 §5-G — beginningEdit 스왑 + cellEditEnded 원복).
//   근거(라인 = AS-IS DMF0021_SalesPlan.cs):
//     · Catch_Up 셀콤보 3종 : DOM_EXP(dtCustomsHandbook L4877) / INCOTERMS(L4896) /
//       FCST_TYPE(ETC 제외 — SALES_TYPE_CODE 중 ETC 제외 L4903·InsertRow ETC 고정 L2944 대비).
//     · Insert Measure 콤보 : GET_SALES_PLAN_MEASUREINFO (L2925 dtMearsure — 기본 SalesAmt_LOC).
//     · 행 cascade          : ComboSelChange 6키 (constants GRID_CASCADE_FILTERS/CLEAR 참조).
import { DataMap } from '@mescius/wijmo.grid';

import { INSERT_DEFAULT_FCST_TYPE } from '../sales-plan.constants';
import type { MeasureInfoRow, SalesPlanRow } from '../sales-plan.types';

// 타입 안전 string 변환 — string/number 만 (객체는 ''). no-base-to-string 회피.
export const toCellStr = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// FCST_TYPE Catch_Up 편집 콤보 — 전체 'FcstType' 콤보 rows 에서 ETC 제외 (AS-IS FCST_TYPE(ETC 제외) 1:1).
export const buildCatchUpFcstTypeMap = (
  fcstTypeRows: Record<string, unknown>[]
): DataMap | null => {
  const filtered = fcstTypeRows.filter(
    r => toCellStr(r.CODE).trim().toUpperCase() !== INSERT_DEFAULT_FCST_TYPE
  );
  return filtered.length > 0 ? new DataMap(filtered, 'CODE', 'NAME') : null;
};

// Insert 행 MEASURE 편집 콤보 — GET_SALES_PLAN_MEASUREINFO (CODE/NAME/DISPLAY_SEQ) → DataMap.
export const buildMeasureInfoMap = (rows: MeasureInfoRow[]): DataMap | null => {
  const sorted = [...rows].sort((a, b) => Number(a.DISPLAY_SEQ ?? 0) - Number(b.DISPLAY_SEQ ?? 0));
  return sorted.length > 0
    ? new DataMap(sorted as unknown as Record<string, unknown>[], 'CODE', 'NAME')
    : null;
};

// 행 컨텍스트 cascade 필터 — 콤보 원본 rows 를 상위 셀 값으로 클라 필터 (관대 통과: 공란/'ALL' = 통과).
export const filterComboRowsByRow = (
  src: Record<string, unknown>[],
  row: SalesPlanRow,
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

// ⭐ R6 — Measure 전환 시 행 재구성 (AS-IS ComboSelChange Measure 분기 L4774~5082 —
//   Catch_Up: ItemId 모달 전환+clear(L4870)/DomExp·Incoterms·FcstType 개방/Team 잠금 /
//   SalesAmt_LOC 복귀: FCST_TYPE='ETC' 고정(L2944 계보)+3종 잠금 / 공통: 기존 기간 입력 전체 초기화).
//   잠금/개방 자체는 insertStaticEditable(editLock R5)이 row.MEASURE 실시간 참조로 반영 —
//   여기서는 값 재세팅만 수행.
export const applyMeasureSwitch = (
  row: SalesPlanRow,
  nextMeasure: string,
  dynBindings: readonly string[]
): void => {
  const rec = row as Record<string, unknown>;
  if (nextMeasure === 'Catch_Up') {
    rec.FCST_TYPE = ''; // 개방 — 사용자가 ETC 제외 콤보에서 선택
    rec.DOM_EXP = '';
    rec.INCOTERMS = '';
    rec.ITEM_ID = ''; // 모달 전용 전환 + clear (L4870)
    rec.ITEM_CLASS_NAME = '';
    rec.NICK_NAME = '';
  } else {
    rec.FCST_TYPE = INSERT_DEFAULT_FCST_TYPE; // ETC 고정 (SalesAmt_LOC = 기타매출 제약)
    rec.DOM_EXP = '';
    rec.INCOTERMS = '';
  }
  // 기존 기간 입력 전체 초기화 (cutoff 스왑으로 무효화된 입력 제거)
  dynBindings.forEach(b => {
    if (rec[b] != null && rec[b] !== '') rec[b] = null;
  });
};
