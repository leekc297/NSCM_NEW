// master(WH_IN) 저장 payload 조립 (design 03 §4 — P_SSP0015_SAVE_SHIPMENT_PSI 14 IN flat).
//   편집된 D_ 기간셀만 행별로 flat 하게 펼친다(측정치 WH_IN 행 한정). 음수는 저장 abort(MSG00084).

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

export interface MainSaveMeta {
  divisionId: string;
  planStartYyyymmdd: string;
  userId: string;
}

export interface MainSavePayload {
  activeFlag: string; // P_ACTIVE_FLAG
  divisionId: string; // P_DIVISION_ID
  fromSite: string; // P_FROM_SITE
  itemId: string; // P_ITEM_ID
  planStartYyyymmdd: string; // P_PLAN_START_YYYYMMDD
  yyyymmdd: string; // P_YYYYMMDD (D_ 컬럼 일자)
  planType: string; // P_PLAN_TYPE
  seq: string; // P_SEQ
  measure: string; // P_MEASURE ('WH_IN')
  qty: string; // P_QTY
  userId: string; // P_USER_ID
  debugMode: string; // P_DEBUG_MODE
}

/**
 * 편집된 WH_IN 측정치 행의 D_ 셀을 flat payload 로 조립한다.
 *   originalOf: EditTracker 원본값 조회(변경 셀만 대상). negatives: 음수 셀 목록.
 */
export const collectMainSaveRows = (
  rows: Record<string, unknown>[],
  dayBindings: string[],
  originalOf: (row: Record<string, unknown>) => Record<string, unknown> | undefined,
  meta: MainSaveMeta
): { payload: MainSavePayload[]; negatives: string[] } => {
  const payload: MainSavePayload[] = [];
  const negatives: string[] = [];
  rows.forEach(row => {
    if (str(row.MEASURE) !== 'WH_IN') return;
    if (str(row.CRUD_TYPE) !== 'M') return;
    const original = originalOf(row);
    dayBindings.forEach(binding => {
      const current = row[binding];
      const orig = original?.[binding];
      if (orig === undefined) return; // 변경 셀만
      // D_ 기간셀은 수치/문자 primitive — str() 정규화로 비교(no-base-to-string 회피)
      if (str(current) === str(orig)) return;
      const qty = Number(current ?? 0);
      const yyyymmdd = binding.slice(2);
      if (qty < 0) {
        negatives.push(`${str(row.ITEM_ID)}:${yyyymmdd}`);
        return;
      }
      payload.push({
        activeFlag: 'U',
        divisionId: meta.divisionId,
        fromSite: str(row.FROM_SITE),
        itemId: str(row.ITEM_ID),
        planStartYyyymmdd: meta.planStartYyyymmdd,
        yyyymmdd,
        planType: str(row.PLAN_TYPE),
        seq: str(row.SEQ),
        measure: 'WH_IN',
        qty: String(qty),
        userId: meta.userId,
        debugMode: 'F',
      });
    });
  });
  return { payload, negatives };
};
