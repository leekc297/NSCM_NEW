// Main 저장 payload 조립 (design 03 §3-H/§4.2) — 순수 함수.
//   "편집 마킹된 D_ 셀"만 (row 식별키 + YYYYMMDD + 값) flat 리스트로 — 그리드 전체 전송 금지.
//   dirty 판정은 AS-IS ForeColor=Red 대신 EditTracker 원본값 비교(CRUD_TYPE 'M' + 셀 단위 diff)로 재현.
//   전송은 수동 조립 경로(apiClient.post call-proc — np §3.2. SAVE 15 IN 은 ALL_ARGUMENTS 실측,
//   payload 키 ↔ P_* 매핑은 PROC_M(convert-sp 소관) 등재 대상).

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
const num = (v: unknown): number => {
  const n = Number(v);
  return Number.isFinite(n) ? n : 0;
};

export interface MainSaveContext {
  divisionId: string;
  companyId: string;
  planStartYyyymmdd: string; // 선택 Plan Date
  userId: string;
  userDeptId: string;
}

export type MainSaveRow = Record<string, string>;

/**
 * Main 저장 대상 수집 — 편집된 D_ 셀(원본값과 다른 셀)만 flat 행으로.
 *   originalOf: EditTracker 가 보관한 행별 "변경된 컬럼 원본값" 맵(그 키 중 D_ 만 diff 대상).
 *   음수(MSG00225 — AS-IS MSG00084)는 negatives 로 분리 — 호출부가 저장 자체를 abort 한다.
 */
export const collectMainSaveRows = (
  rows: Record<string, unknown>[],
  dayCols: readonly string[],
  originalOf: (row: Record<string, unknown>) => Record<string, unknown> | undefined,
  ctx: MainSaveContext
): { payload: MainSaveRow[]; negatives: { row: Record<string, unknown>; day: string }[] } => {
  const payload: MainSaveRow[] = [];
  const negatives: { row: Record<string, unknown>; day: string }[] = [];

  const daySet = new Set(dayCols);
  rows.forEach(row => {
    if (str(row.CRUD_TYPE) !== 'M') return;
    const original = originalOf(row);
    if (!original) return;
    Object.keys(original).forEach(day => {
      if (!daySet.has(day)) return;
      const current = num(row[day]);
      const before = num(original[day]);
      if (current === before) return;
      if (current < 0) {
        negatives.push({ row, day });
        return;
      }
      payload.push({
        activeFlag: 'M', // 1 P_ACTIVE_FLAG
        divisionId: ctx.divisionId, // 2 P_DIVISION_ID
        companyId: ctx.companyId, // 3 P_COMPANY_ID
        fromSite: str(row.FROM_SITE), // 4 P_FROM_SITE
        itemId: str(row.ITEM_ID), // 5 P_ITEM_ID
        toSite: str(row.TO_SITE), // 6 P_TO_SITE
        transportMode: str(row.TRANSPORT_MODE), // 7 P_TRANSPORT_MODE
        incoterms: str(row.INCOTERMS), // 8 P_INCOTERMS
        fcstType: str(row.FCST_TYPE), // 9 P_FCST_TYPE
        planStartYyyymmdd: ctx.planStartYyyymmdd, // 10 P_PLAN_START_YYYYMMDD
        yyyymmdd: day.slice(2), // 11 P_YYYYMMDD ('D_20260901' → '20260901')
        shipmentQty: String(current), // 12 P_SHIPMENT_QTY
        userId: ctx.userId, // 13 P_USER_ID
        userDeptId: ctx.userDeptId, // 14 P_USER_DEPT_ID
        debugMode: 'F', // 15 DEBUG_MODE
      });
    });
  });

  return { payload, negatives };
};
