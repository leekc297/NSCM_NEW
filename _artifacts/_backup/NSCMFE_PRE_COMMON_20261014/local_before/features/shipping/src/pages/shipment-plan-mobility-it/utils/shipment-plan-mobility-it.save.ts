// master(WH_IN) 저장 payload 조립 (design 03 §4 — P_SSP0015_SAVE_SHIPMENT_PSI).
//   ⚠️ proc 는 각 IN 파라미터를 '^' 로 접은 다중행 문자열로 받아 루프 처리한다
//   (본문 SCM_ARR_SPL_CNT(P_ACTIVE_FLAG,'^') + WHILE LOOP). BE call-proc(makeProcedure)도 단일 Map 을
//   기대하므로, 편집된 D_ 기간셀(측정치 WH_IN 행)을 컬럼별 '^'-폴딩 '단일 객체'로 보낸다(행 객체 배열 아님 —
//   과거 배열 전송이 저장 에러의 원인, 2026-09-30). 음수는 저장 abort(MSG00084).

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

export interface MainSaveMeta {
  divisionId: string;
  planStartYyyymmdd: string;
  userId: string;
}

// 편집 셀 1건의 12 IN 값(폴딩 전 단위). 최종 전송은 컬럼별 '^'-join 단일 객체(MainSaveFolded).
interface MainSaveCell {
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

export type MainSaveFolded = Record<keyof MainSaveCell, string>;

/**
 * 편집된 WH_IN 측정치 행의 D_ 셀을 컬럼별 '^'-폴딩 단일 객체로 조립한다.
 *   originalOf: EditTracker 원본값 조회(변경 셀만 대상). negatives: 음수 셀 목록.
 *   변경 셀이 없으면 payload=null.
 */
export const collectMainSaveRows = (
  rows: Record<string, unknown>[],
  dayBindings: string[],
  originalOf: (row: Record<string, unknown>) => Record<string, unknown> | undefined,
  meta: MainSaveMeta
): { payload: MainSaveFolded | null; negatives: string[] } => {
  const cells: MainSaveCell[] = [];
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
      cells.push({
        // proc P_SSP0015_SAVE_SHIPMENT_PSI 은 activeFlag='M'(수정)·'I'(삽입)일 때만 DML 실행(본문 IF V_ACTIVE_FLAG
        //   = 'M' OR 'I'). 편집 셀은 수정이므로 'M'. 'U' 는 no-op 라 "성공인데 미저장" 사고(2026-09-30).
        activeFlag: 'M',
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
  if (cells.length === 0) return { payload: null, negatives };
  // 컬럼별 '^'-폴딩 — proc 이 파라미터마다 같은 개수의 세그먼트를 기대(SCM_ARR_SPL_CNT 기준 루프).
  const fold = (k: keyof MainSaveCell): string => cells.map(c => c[k]).join('^');
  const payload: MainSaveFolded = {
    activeFlag: fold('activeFlag'),
    divisionId: fold('divisionId'),
    fromSite: fold('fromSite'),
    itemId: fold('itemId'),
    planStartYyyymmdd: fold('planStartYyyymmdd'),
    yyyymmdd: fold('yyyymmdd'),
    planType: fold('planType'),
    seq: fold('seq'),
    measure: fold('measure'),
    qty: fold('qty'),
    userId: fold('userId'),
    debugMode: fold('debugMode'),
  };
  return { payload, negatives };
};
