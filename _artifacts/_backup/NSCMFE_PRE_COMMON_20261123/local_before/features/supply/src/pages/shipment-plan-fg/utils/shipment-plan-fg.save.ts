// 저장(P_SCP0009_SAVE_ANL_SHIP_PLAN_FG_WEEKLY / _FIX_DATASET) 26필드 JSON 래퍼 payload 조립.
//   근거: .atlas/gscm-design/SCP0009/design/03_grid-columns.md §4.4(26필드 목록) +
//   ora.py all_type_attrs 실측(T_SCP0009_ROW, iter-2 재확인) — 두 SP 모두 동일 TVP(T_SCP0009_TAB) 형상.
//   "행 단위 = 변경된 셀 1개"(AS-IS ForeColor==Red 탐지 방식 대신 EditTracker.getOriginalValues() 사용).
//
// 전송 방식: 두 SP 의 IN 파라미터는 TABLE 타입(T_SCP0009_TAB)이라 nscm-be 가 바인딩하지 못한다(Types.ARRAY/STRUCT
//   처리 코드 없음). 그래서 API_M 은 CLOB(JSON 배열) 래퍼 P_SCP0009_SAVE_ANL_SHIP_PLAN_FG_WEEKLY_JSON /
//   P_SCP0009_SAVE_ANL_SHIP_FG_FIX_DATASET_JSON 를 가리킨다(design/05_register.sql 끝의 G2 블록, 래퍼는
//   07_sp_json_wrapper.sql). 서버는 요청 본문의 `data` 객체 배열을 JSON 문자열로 바꿔 CLOB 로 넘기고, 래퍼는
//   아래 SaveCellRow 키(camelCase, 대소문자 구분)를 JSON_TABLE 로 읽는다.
import type { EditTracker } from '@foundation/utils';

import { dynColKindOf } from './shipment-plan-fg.editLock';

// design 03 §4.4 26필드 순서 그대로(A 포함) — 원 SP 의 TVP(T_SCP0009_ROW) ATTR_NO 1~26과 1:1.
export interface SaveCellRow {
  a: string; // A — 용도 확인 필요(design 03 §4.4, ATTR_NO=1). 빈 문자열로 전송.
  activeFlag: string; // P_ACTIVE_FLAG — 일반 저장은 기존행(SHIP_PLAN_AMEND) 수정뿐이라 'M', Fix 는 'I', Unfix 는 'D'(SP 가 'D' 일 때만 삭제)
  divisionId: string;
  planStartYyyymmdd: string;
  planType: string;
  seq: string;
  bizType: string;
  projectCode: string;
  itemId: string;
  toSite: string;
  incoterms: string;
  fromSite: string;
  bodId: string;
  measure: string;
  yyyymmdd: string; // D_ 는 binding 의 일자 8자리. W_/M_ 는 binding 앞 8자리로 잘리므로 SP 요구값 확인 필요
  qty: string;
  originFromDivisionId: string;
  originToDivisionId: string;
  electrodeType: string;
  fixReason: string; // Fix 저장 시에만 값 채움(핸들러가 결정), 일반 저장은 빈 문자열
  bucketType: string;
  transMode: string;
  createdBy: string;
  lastUpdatedBy: string;
  timeZone: string;
  debugMode: string;
}

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// GET SP(PKG_SCP0009.P_SCP0009_GET_SHIPMENT_PLAN_FG :1271) 가 NULL 인 ELECTRODE_TYPE 을 그리드
//   표시용 '/' 로 바꿔 내려준다(NVL(NULLIF(RTRIM(...),''),'/')). SAVE SP(P_SCP0009_SAVE_ANL_SHIP_PLAN_FG_WEEKLY
//   :5002/5023) 의 기존행 매칭은 NVL(A.ELECTRODE_TYPE,'-') = NVL(B.P_ELECTRODE_TYPE,'-') 라, 표시값
//   '/' 를 그대로 되돌려 보내면 실제 저장값(NULL→'-')과 달라 매칭 실패 → UPDATE 대신 INSERT 를 시도해
//   PK 중복(ORA-00001)이 난다(2026-10-13 division=82 실측 재현, DB 조회로 확정). 저장 전 표시
//   placeholder 를 원래 빈 값으로 되돌린다.
const ELECTRODE_TYPE_PLACEHOLDER = '/';
const unplaceholderElectrodeType = (v: string): string => (v === ELECTRODE_TYPE_PLACEHOLDER ? '' : v);

// 일반 저장과 Fix 저장이 공유하는 행 식별 필드(정보컬럼 → SP 필드).
const rowIdentityFields = (r: Record<string, unknown>) => ({
  divisionId: s(r.DIVISION_ID),
  bizType: s(r.BIZ_TYPE),
  projectCode: s(r.PROJECT_CODE),
  itemId: s(r.ITEM_ID),
  toSite: s(r.TO_SITE),
  incoterms: s(r.INCOTERMS),
  fromSite: s(r.FROM_SITE),
  bodId: s(r.BOD_ID),
  measure: s(r.MEASURE),
  originFromDivisionId: s(r.ORIGIN_FROM_DIVISION_ID),
  originToDivisionId: s(r.ORIGIN_TO_DIVISION_ID),
  electrodeType: unplaceholderElectrodeType(s(r.ELECTRODE_TYPE)),
});

// 변경된 D_/W_/M_ 셀만 순회해 26필드 행으로 변환한다. row 는 정보컬럼(§0)을 그대로 갖고 있으므로
//   Division/PlanDate/Type/Seq/BizType 등은 그 행에서 그대로 읽는다(design 03 §1.A 44개 정보컬럼).
export const buildSaveRows = (
  tracker: EditTracker | undefined,
  userId: string,
  timeZone: string,
  fixReason = '',
  activeFlag = 'M'
): SaveCellRow[] => {
  if (!tracker) return [];
  const rows: SaveCellRow[] = [];
  tracker.getOriginalValues().forEach((changed, row) => {
    const r = row as unknown as Record<string, unknown>;
    Object.keys(changed).forEach(binding => {
      if (!dynColKindOf(binding)) return; // 정보컬럼은 편집 대상이 아니므로(§0) 저장 후보에서 제외
      const yyyymmdd = binding.slice(2, 10); // D_yyyymmdd/W_.../M_yyyymm — design 03 §4.4 P_YYYYMMDD
      rows.push({
        a: '',
        activeFlag,
        ...rowIdentityFields(r),
        planStartYyyymmdd: s(r.PLAN_START_YYYYMMDD),
        planType: s(r.PLAN_TYPE),
        seq: s(r.SEQ),
        yyyymmdd,
        qty: s(r[binding]),
        fixReason,
        bucketType: dynColKindOf(binding) === 'D' ? 'DAILY' : dynColKindOf(binding) === 'W' ? 'WEEKLY' : 'MONTHLY',
        transMode: s(r.TRANSPORT_MODE),
        createdBy: userId,
        lastUpdatedBy: userId,
        timeZone,
        debugMode: 'F',
      });
    });
  });
  return rows;
};

export interface FixRowContext {
  userId: string;
  timeZone: string;
  fixReason: string;
  activeFlag: 'I' | 'D'; // Fix='I', Unfix='D'(.cs:4272, 4292)
  planStartYyyymmdd: string;
  planType: string;
  seq: string;
  bucketType: string; // 조회조건 Bucket 값(AS-IS cboBucketType, .cs:4428)
}

// Fix/Unfix 대상 셀(D_ 컬럼)을 26필드 행으로 변환한다(.cs:4409-4433). Plan 식별값과 Bucket 은 행이 아니라
//   조회조건 값을 쓰고(.cs:4336-4338, 4428), 수량은 콤마를 제거하며 빈 값이면 '0' 이다(.cs:4390-4391).
export const buildFixRows = (
  cells: { row: Record<string, unknown>; binding: string }[],
  ctx: FixRowContext
): SaveCellRow[] =>
  cells.map(({ row, binding }) => ({
    a: '',
    activeFlag: ctx.activeFlag,
    ...rowIdentityFields(row),
    planStartYyyymmdd: ctx.planStartYyyymmdd,
    planType: ctx.planType,
    seq: ctx.seq,
    yyyymmdd: binding.slice(2, 10),
    qty: s(row[binding]).replace(/,/g, '') || '0',
    fixReason: ctx.fixReason,
    bucketType: ctx.bucketType,
    transMode: '', // AS-IS Fix 경로는 p_trans_mode 를 채우지 않는다
    createdBy: ctx.userId,
    lastUpdatedBy: ctx.userId,
    timeZone: ctx.timeZone,
    debugMode: 'F',
  }));

// call-proc 요청 본문. 키 이름 `data` 는 PROC_M 의 CLOB 파라미터명과 같아야 한다.
export const buildSavePayload = (rows: SaveCellRow[]): { data: SaveCellRow[] } => ({ data: rows });

export const isSaveResultFailure = (res: { status: number; data?: { code?: unknown } }): boolean =>
  res.status >= 400 || Number(res.data?.code ?? 0) !== 0;
