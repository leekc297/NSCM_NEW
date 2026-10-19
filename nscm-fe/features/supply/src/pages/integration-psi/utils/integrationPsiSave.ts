// SCP0111 저장 payload 빌더 (design 03 §4-저장 cs:1233-1626). 변경셀(수정 M / 신규 I)만 셀 단위로
//   펼쳐(unfold) 19키 '^'delim CLOB 배열 payload 를 만든다 — SAVE SP 가 배열을 MERGE 하는 계약.
//   수정(M): preQty≠qty 인 월/BOH 셀만, modiQty=qty-preQty(가감값, cs:1560,1603).
//   신규(I): **Plan 전체 개월수**(plan_start월~HORIZON_END, cs:1510~1511) modiQty=절대값. 상수 이식 금지 — 규칙 재현.

import type { EditTracker } from '@foundation/utils';

import { OPERATION_GROUP_CODE } from '../integration-psi.constants';

import { periodMonthRange } from './integrationPsiColumns';

type Row = Record<string, unknown>;

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
const num = (v: unknown): number => {
  if (v === undefined || v === null || v === '') return 0;
  const n =
    typeof v === 'number' ? v : typeof v === 'string' ? Number(v.replace(/,/g, '')) : NaN;
  return Number.isFinite(n) ? n : 0;
};

// OPERATION_GROUP 표시명(Pack/Cell/Electrode) → 저장 코드(P/A/E) 역변환 (design 03 §4 cs:1207-1219).
//   lookup 부재(매핑 불가)면 null 반환 → 호출부가 MSG00001 에러 처리(추측 코드 저장 금지).
export const operationGroupToCode = (displayName: string): string | null => {
  const key = displayName.trim() as keyof typeof OPERATION_GROUP_CODE;
  return key in OPERATION_GROUP_CODE ? OPERATION_GROUP_CODE[key] : null;
};

// 6자리 YYYYMM pivot 바인딩 판정 (integrationPsiColumns 와 동일 기준 — 고정열 제외 6자리 숫자).
const isYyyymm = (binding: string, fixedBindings: ReadonlySet<string>): boolean =>
  !fixedBindings.has(binding) && /^\d{6}$/.test(binding);

// 저장 셀 1건 (SAVE SP 19 배열 컬럼). yyyymm='BOH' 이면 BOH_QTY 셀(measure=INV).
//
// 주의: `action`('I'|'M')이 곧 SP 의 **P_ACTIVE_FLAG** 다. 별도 action 파라미터는 없다
//   (P_SCP0111_SAVE_INTEGRATION_PSI 는 IN 19개뿐 — ALL_ARGUMENTS 실측 2026-10-13).
//   SP 는 셀마다 토큰을 떼어(L725 `V_ACTIVE_FLAG := F_TOKEN(T_ACTIVE_FLAG, V_MST_LOOP_CNT)`)
//   `IF V_ACTIVE_FLAG = 'I'`(L751, 일반 / L3325·L3384, ADMIN) · `IF V_ACTIVE_FLAG = 'M'`(L3359, ADMIN)
//   로 분기한다. 그래서 여기에 'Y' 같은 값을 넣으면 **신규 INSERT 분기가 영영 안 돈다**.
export interface SaveCell {
  action: 'I' | 'M';
  planType: string;
  divisionId: string;
  companyId: string;
  plantId: string;
  operationGroup: string; // **표시명**(Pack/Cell/Electrode) — 코드 아님. baseCell 주석 참고
  seqFlag: string;
  cellitemId: string;
  itemId: string;
  measure: string;
  toSite: string;
  lineId: string;
  valuationType: string;
  toProduct: string;
  incoterms: string;
  yyyymm: string; // 월(YYYYMM). BOH 수정셀도 plan start 월을 쓴다 — 리터럴 'BOH' 금지
  modiQty: string; // 가감값(M) / 절대값(I)
  bohQty: string; // ADMIN 저장 전용(일반 저장은 미사용)
}

export interface UnfoldResult {
  cells: SaveCell[];
  // OPERATION_GROUP 코드 역변환 실패 행 존재 여부 (design 03 §4 lookup 부재 = MSG00001).
  opGroupLookupMissing: boolean;
  // 신규행에 LINE_ID 가 sentinel('-') 인 채 저장 시도 (design 03 §5 MSG00453 확인 대상).
  hasEmptyLineInsert: boolean;
}

// 행의 SP 배열 공통 컬럼 채우기 (measure/식별키).
const baseCell = (row: Row): Omit<SaveCell, 'action' | 'yyyymm' | 'modiQty'> => ({
  planType: s(row.PLAN_TYPE),
  divisionId: s(row.DIVISION_ID),
  companyId: s(row.COMPANY_ID),
  plantId: s(row.PLANT_ID),
  // P_OPERATION_GROUP = **표시명**('Pack'/'Cell'/'Electrode')이다. 코드(P/A/E)가 아니다.
  //   SP 가 받은 값을 스스로 코드로 바꾼다 — `V_OPERATION_GROUP` 은 패키지 전체에서 아래 한 곳에만 쓰인다
  //   (ALL_SOURCE 실측 2026-10-13: L730 토큰 분해, L786~788 INSERT CASE. UPDATE WHERE 에는 등장하지 않음):
  //     L786  (CASE WHEN V_OPERATION_GROUP = 'Pack' THEN 'P'
  //     L787        WHEN V_OPERATION_GROUP = 'Cell' THEN 'A'
  //     L788        ELSE 'E' END)
  //   종전처럼 코드를 보내면 'P'·'A' 가 어느 WHEN 에도 안 걸려 **ELSE 로 떨어져 전부 'E'(Electrode)로 저장**된다.
  //   Electrode 만 우연히 맞아 드러나지 않았다. AS-IS 도 그리드 셀 값(= C.SEGMENT2 표시명)을 그대로 보낸다(cs:1461).
  operationGroup: s(row.OPERATION_GROUP).trim(),
  seqFlag: s(row.SEQ_FLAG),
  cellitemId: s(row.CELL_ITEM_ID),
  itemId: s(row.ITEM_ID),
  measure: s(row.MEASURE),
  toSite: s(row.TO_SITE),
  lineId: s(row.LINE_ID),
  valuationType: s(row.VALUE_TYPE),
  toProduct: s(row.TO_PRODUCT),
  incoterms: s(row.INCOTERMS),
  bohQty: s(row.BOH_QTY),
});

// YYYYMM 에 개월수를 더한다(월 롤오버). HORIZON 부재 시 fallback 산정용.
const addYyyymm = (yyyymm: string, months: number): string => {
  if (!/^\d{6}$/.test(yyyymm)) return yyyymm;
  const total =
    Number(yyyymm.slice(0, 4)) * 12 + (Number(yyyymm.slice(4, 6)) - 1) + months;
  return `${Math.floor(total / 12)}${String((total % 12) + 1).padStart(2, '0')}`;
};

// 신규행(I) 삽입 대상 월 — **조회기간이 아니라 Plan 의 전체 개월수**다.
//   AS-IS cs:1510~1511  dtToMonth = Data.Common(CalendarMonth, plan_start월, this._toDate 월)
//                        `_toDate` = SCPPlanPeriod HORIZON_END_DATE, 부재 시 plan_start+11월(cs:267~278)
//        cs:1514~1537  그 월 전체를 루프 돌며 한 달에 한 셀씩 쌓는다.
//   화면 조회기간(From~To)으로 좁히면 **행이 모자라게 생성된다** — 실측(2026-10-13): PLAN_START=20260817
//   의 정상 월 범위는 202608~202803(20개월)인데 조회기간 6개월만 생성돼 불완전 등록이 됐다.
export const insertTargetMonths = (
  planStartYyyymmdd: string,
  horizonEndYyyymmdd: string
): string[] => {
  const from = planStartYyyymmdd.slice(0, 6);
  if (!/^\d{6}$/.test(from)) return [];
  const horizon = horizonEndYyyymmdd.slice(0, 6);
  const to = /^\d{6}$/.test(horizon) && horizon >= from ? horizon : addYyyymm(from, 11);
  return periodMonthRange(from, to);
};

// 변경셀 unfold — 수정(M): EditTracker 원본값으로 modiQty=qty-preQty 산출, 변경된 월/BOH 셀만.
//   신규(I): CRUD_TYPE='I' 행을 **Plan 전체 개월수**만큼 절대값으로 삽입(insertTargetMonths).
//   design 03 §4-저장: 미변경 셀은 제외(preQty==qty skip cs:1293-1368).
export const unfoldSaveCells = (params: {
  source: Row[];
  tracker: EditTracker | undefined;
  fixedBindings: ReadonlySet<string>;
  // Plan 식별 — 신규행 삽입 월 범위와 BOH 수정셀의 yyyymm 토큰을 여기서 도출한다.
  planStartYyyymmdd: string;
  horizonEndYyyymmdd: string;
}): UnfoldResult => {
  const { source, tracker, fixedBindings, planStartYyyymmdd, horizonEndYyyymmdd } = params;
  const insertMonths = insertTargetMonths(planStartYyyymmdd, horizonEndYyyymmdd);
  // BOH(measure=INV) 수정셀의 yyyymm 토큰 = **plan start 월**. AS-IS cs:1577
  //   `AppendString(ref p_yyyymm, p_plan_start_yyyymmdd.Substring(0,6), iCount)` —
  //   리터럴 'BOH' 가 아니다. 'BOH' 를 보내면 SP INSERT(L755)가 YYYYMM='BOH' 인 쓰레기 행을 만든다
  //   (실측 2026-10-13: 4행 생성됨).
  const bohYyyymm = planStartYyyymmdd.slice(0, 6);
  const cells: SaveCell[] = [];
  let opGroupLookupMissing = false;
  let hasEmptyLineInsert = false;

  const originals = tracker?.getOriginalValues();

  for (const row of source) {
    const crud = s(row.CRUD_TYPE);
    if (crud !== 'I' && crud !== 'M') continue;

    // operationGroupToCode 는 **검증 전용**이다 — 반환 코드를 SP 로 보내지 않는다(baseCell 주석 참고).
    //   매핑 불가(= 알 수 없는 표시명)면 추측 저장 대신 차단한다(design 03 §4 cs:1207~1219).
    if (operationGroupToCode(s(row.OPERATION_GROUP)) === null) {
      opGroupLookupMissing = true;
      continue; // lookup 실패 행은 저장 대상 제외(호출부가 MSG00001 로 차단)
    }
    const base = baseCell(row);

    if (crud === 'I') {
      // 신규행 — LINE_ID sentinel 확인(MSG00453 대상). Plan 전체 개월수를 절대값으로 삽입.
      if (s(row.LINE_ID).trim() === '-' || s(row.LINE_ID).trim() === '') {
        hasEmptyLineInsert = true;
      }
      for (const ym of insertMonths) {
        cells.push({ ...base, action: 'I', yyyymm: ym, modiQty: String(num(row[ym])) });
      }
      // 주의: 신규행에 **BOH 전용 셀을 추가하지 않는다.** AS-IS 신규 경로(cs:1514~1537)는 월 루프뿐이고
      //   BOH 토큰이 없다(일반 저장 payload 에 p_boh_qty 자체가 없다 — ADMIN 저장만 보낸다).
      //   종전처럼 `yyyymm:'BOH'` 를 끼우면 SP INSERT 가 YYYYMM='BOH' 쓰레기 행을 만든다.
      continue;
    }

    // 수정행(M) — EditTracker 가 기록한 변경 셀만 modiQty=qty-preQty 가감값으로.
    const changed = originals?.get(row as never);
    if (!changed) continue;
    for (const binding of Object.keys(changed)) {
      const isBoh = binding === 'BOH_QTY';
      if (!isBoh && !isYyyymm(binding, fixedBindings)) continue; // 수량셀(월/BOH)만 저장 대상
      const pre = num(changed[binding]);
      const now = num(row[binding]);
      if (pre === now) continue; // 실변경 없음
      cells.push({
        ...base,
        action: 'M',
        yyyymm: isBoh ? bohYyyymm : binding, // BOH 는 plan start 월(AS-IS cs:1577)
        modiQty: String(now - pre), // 가감값
      });
    }
  }

  return { cells, opGroupLookupMissing, hasEmptyLineInsert };
};

// SaveCell[] → 일반 저장 payload (P_SCP0111_SAVE_INTEGRATION_PSI 19 CLOB 배열 + planStartYyyymmdd/userId).
//   키명 = SCM_ADM_PROC_M COL_NM camelCase 가정(자매 sales-plan buildSavePayload 규약). 확인필요: SCP0111
//   procedures.d.ts 미등재라 실제 파라미터 key 매핑은 05_register + 타입 등록 후 검증(design 03 §6).
export const buildGeneralPayload = (
  cells: SaveCell[],
  planStartYyyymmdd: string,
  userId: string
): Record<string, string> | null => {
  if (cells.length === 0) return null;
  const join = (sel: (c: SaveCell) => string): string => cells.map(sel).join('^');
  return {
    // P_ACTIVE_FLAG = 셀별 action('I'|'M'). SaveCell 주석의 SP 분기 근거 참고 —
    //   'Y' 고정으로 보내던 종전 구현은 신규행 INSERT 분기(L751)를 통과하지 못해 **아무 행도 안 들어갔다**
    //   (사용자 신고 2026-10-13: 저장했는데 안 됨. 실측상 PROD_PLAN 0행 / INV 재계산만 26행 갱신).
    activeFlag: join(c => c.action),
    planType: join(c => c.planType),
    divisionId: join(c => c.divisionId),
    companyId: join(c => c.companyId),
    plantId: join(c => c.plantId),
    operationGroup: join(c => c.operationGroup),
    seqFlag: join(c => c.seqFlag),
    cellitemId: join(c => c.cellitemId),
    itemId: join(c => c.itemId),
    measure: join(c => c.measure),
    toSite: join(c => c.toSite),
    lineId: join(c => c.lineId),
    valuationType: join(c => c.valuationType),
    toProduct: join(c => c.toProduct),
    incoterms: join(c => c.incoterms),
    yyyymm: join(c => c.yyyymm),
    modiQty: join(c => c.modiQty),
    planStartYyyymmdd,
    userId,
  };
};

// ADMIN 저장 payload (P_SCP0111_SAVE_PSI_ADMIN — 일반 19 + p_boh_qty). BOH_QTY 를 절대값으로 함께 전송.
export const buildAdminPayload = (
  cells: SaveCell[],
  planStartYyyymmdd: string,
  userId: string
): Record<string, string> | null => {
  const general = buildGeneralPayload(cells, planStartYyyymmdd, userId);
  if (general === null) return null;
  return { ...general, bohQty: cells.map(c => c.bohQty).join('^') };
};
