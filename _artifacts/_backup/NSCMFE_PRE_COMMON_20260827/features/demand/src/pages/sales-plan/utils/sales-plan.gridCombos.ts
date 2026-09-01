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

// 셀 비우기 patch 생성 — cascade 계단 clear 와 모달 취소가 같은 규칙(빈 문자열)으로 비운다.
//   null 이 아니라 '' 인 이유: 신규행 기본값(INSERT_ROW_DEFAULTS)이 전부 '' 라 미입력 상태와
//   같은 표현이어야 저장 필수값 검증(validate)이 둘을 구분 없이 걸러낸다.
export const buildClearPatch = (fields: readonly string[]): Record<string, string> =>
  Object.fromEntries(fields.map(f => [f, '']));

// 콤보 rows 중복 제거 — CODE 기준 첫 행만 남긴다(콤보 SQL 정렬 순서 보존).
//   코드 목록은 CODE 유일이 의미상 보장인데, CMBO_SQL 이 행을 불려 내려보내는 경우가 있다.
//   실측(2026-08-17 Measure 드롭다운 중복): CMBO 'Measure' 는 @mnuId 만 받고 division 필터가
//   없어(comboContext) SCM_MST_SHEET_MEASURE 에 division 별로 적재된 같은 measure 가 등록
//   division 수만큼 반복돼 온다. DataMap 은 소스 배열을 그대로 펼치므로 그 중복이 셀 드롭다운
//   항목 중복으로 보인다. (동류 사고: sales-reports P_DMF0044_GET_MEASURE 권한 조인 16행)
export const dedupeComboRowsByCode = <T extends Record<string, unknown>>(rows: T[]): T[] => {
  const byCode = new Map<string, T>();
  for (const row of rows) {
    const code = toCellStr(row.CODE).trim();
    if (!byCode.has(code)) byCode.set(code, row);
  }
  return [...byCode.values()];
};

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
    rec.DEPT_ID = ''; // Catch_Up 전환 시 팀 초기화+잠금 (AS-IS L4950~4951 — CC-12)
  } else {
    rec.FCST_TYPE = INSERT_DEFAULT_FCST_TYPE; // ETC 고정 (SalesAmt_LOC = 기타매출 제약)
    rec.DOM_EXP = '';
    rec.INCOTERMS = '';
    rec.DEPT_ID = ''; // 복귀 시에도 초기화 후 재입력 (AS-IS L5004~5008 — CC-20)
  }
  // 기존 기간 입력 전체 초기화 (cutoff 스왑으로 무효화된 입력 제거)
  dynBindings.forEach(b => {
    if (rec[b] != null && rec[b] !== '') rec[b] = null;
  });
};
