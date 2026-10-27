// SCP0133 저장 — 컬럼별 '^'-fold 평면 payload 조립 + POST + false-success 판별.
//   SCP 표준 batch-save 패턴(메모리 save-proc-per-column-caret-fold-fe) 이식 — 정본 자매는
//   SCP0006 projectRoute.plantSaveRequest.ts · SCP0126 optCapa.save.ts.
//
// 왜 useProcMutation({data:[rows]}) 가 아닌가: PKG_SCP0133 SAVE SP 2종은 각 컬럼이 별도 CLOB 인자이고
//   본문이 SCM_ARR_SPL_VAL(P_X,'^',loop) 로 행을 쪼갠다. BE execBtn 은 DATA_TP_CD='CLOB' 은 접지
//   않고 params.get(COL_NM) 을 그대로 바인드하므로(JVARCHAR 만 cvtJsonToJVarchar fold), FE 가
//   컬럼별로 '^'-join 한 평면 스칼라를 SCM_ADM_PROC_M.COL_NM(camelCase) 키로 보내야 한다.
//   raw {data:[rows]} 로 보내면 전 파라미터 NULL 바인딩 → 루프 0회 no-op + 성공 토스트.
//
// PRE_* 는 수정행의 '변경 전 키'다 — GET 이 내려준 PRE_KEY_VALUES('|' 결합)를 파싱해 채운다.
//   신규행(CRUD_TYPE='I')은 PRE_KEY_VALUES 가 비어 토큰이 모두 '' → SP 중복체크의 NVL(pre,CHR(1))
//   self-제외가 정상 동작(안 채우면 자기 자신과 충돌 ORA-20010).
//   userId 는 세션유저 — SP 가 P_USER_ID 를 루프 안 SCM_ARR_SPL_VAL 로 행별 분해하므로 행마다 실어
//   '^'-fold 한다(CREATED_BY/LAST_UPDATED_BY 갱신용, call-proc 은 세션유저 미주입).

import { apiClient } from '@foundation/apis';
import { safeString } from '@foundation/utils';

import { MENU_ID, SHEETS } from '../warehouse-capacity.constants';

export interface SaveResult {
  ok: boolean;
  message?: string;
}

type Row = Record<string, unknown>;
interface FieldSpec {
  key: string;
  get: (row: Row) => string;
}

// 날짜 표시값(FPDateText 'yyyy-MM-dd') → 저장 포맷 YYYYMMDD(숫자만 8자리). AS-IS .Replace("-","").Substring(0,8).
const ymd8 = (v: unknown): string => safeString(v).replace(/\D/g, '').slice(0, 8);

// PRE_KEY_VALUES 토큰 순서 — GET SP 본문 실측(PKG_SCP0133 BODY):
//   main:        DIVISION_ID | OPMZ_PLAN_GR_ID | WH_NM | FROM_YYYYMMDD | TO_YYYYMMDD
//   itemMapping: DIVISION_ID | OPMZ_PLAN_GR_ID | WH_NM | ITEM_ID
const PRE_DELIM = '|';
const preToken = (row: Row, idx: number): string =>
  safeString(row.PRE_KEY_VALUES).split(PRE_DELIM)[idx] ?? '';

// 값 컬럼 ↔ SCM_ADM_PROC_M.COL_NM(camelCase) 대응 — ora.py 실측(P_SCP0133_SAVE_*). activeFlag 는
//   EditTracker 가 세운 CRUD_TYPE('I'/'M'/'D') 그대로. pre* 는 PRE_KEY_VALUES 파싱값.
const MAIN_SPEC: readonly FieldSpec[] = [
  { key: 'activeFlag', get: r => safeString(r.CRUD_TYPE) },
  { key: 'divisionId', get: r => safeString(r.DIVISION_ID) },
  { key: 'opmzPlanGrId', get: r => safeString(r.OPMZ_PLAN_GR_ID) },
  { key: 'whNm', get: r => safeString(r.WH_NM) },
  { key: 'siteId', get: r => safeString(r.SCM_SITE_ID) },
  { key: 'stage', get: r => safeString(r.STAGE) },
  { key: 'fromYyyymmdd', get: r => ymd8(r.FROM_YYYYMMDD) },
  { key: 'toYyyymmdd', get: r => ymd8(r.TO_YYYYMMDD) },
  { key: 'maxCapa', get: r => safeString(r.MAX_CAPA) },
  { key: 'valueDescription', get: r => safeString(r.VALUE_DESCRIPTION) },
  { key: 'validYn', get: r => safeString(r.VALID_YN) },
  { key: 'preDivisionId', get: r => preToken(r, 0) },
  { key: 'preOpmzPlanGrId', get: r => preToken(r, 1) },
  { key: 'preWhNm', get: r => preToken(r, 2) },
  { key: 'preFromYyyymmdd', get: r => preToken(r, 3) },
  { key: 'preToYyyymmdd', get: r => preToken(r, 4) },
];

const ITEM_SPEC: readonly FieldSpec[] = [
  { key: 'activeFlag', get: r => safeString(r.CRUD_TYPE) },
  { key: 'divisionId', get: r => safeString(r.DIVISION_ID) },
  { key: 'opmzPlanGrId', get: r => safeString(r.OPMZ_PLAN_GR_ID) },
  { key: 'whNm', get: r => safeString(r.WH_NM) },
  { key: 'siteId', get: r => safeString(r.SCM_SITE_ID) },
  { key: 'stage', get: r => safeString(r.STAGE) },
  { key: 'itemId', get: r => safeString(r.ITEM_ID) },
  { key: 'storPer', get: r => safeString(r.STOR_PER) },
  { key: 'storLoc', get: r => safeString(r.STOR_LOC) },
  { key: 'validYn', get: r => safeString(r.VALID_YN) },
  { key: 'valueDescription', get: r => safeString(r.VALUE_DESCRIPTION) },
  { key: 'preDivisionId', get: r => preToken(r, 0) },
  { key: 'preOpmzPlanGrId', get: r => preToken(r, 1) },
  { key: 'preWhNm', get: r => preToken(r, 2) },
  { key: 'preItemId', get: r => preToken(r, 3) },
];

// 컬럼별 '^'-fold. userId 는 세션유저를 행마다 실어 fold(SP 가 행별 분해).
const foldPayload = (spec: readonly FieldSpec[], rows: readonly Row[], userId: string): Record<string, string> => {
  const payload: Record<string, string> = {};
  for (const { key, get } of spec) payload[key] = rows.map(get).join('^');
  payload.userId = rows.map(() => userId).join('^');
  return payload;
};

// false-success 차단 — 상위 code 는 ORA 실패에도 '0'(HTTP 성공)이므로 내부 커서를 본다:
//   o_result_cursor[0].RESULT_CODE !== '0' 또는 o_rc1[0].RESULT_CODE === 'F' 면 실패, 메시지 노출.
const parseResult = (data: { code?: unknown; message?: unknown; result?: unknown } | undefined): SaveResult => {
  const result = (data?.result ?? {}) as Record<string, unknown>;
  const rc = (result.o_result_cursor as Record<string, unknown>[] | undefined)?.[0];
  const rc1 = (result.o_rc1 as Record<string, unknown>[] | undefined)?.[0];
  const statusCode = rc ? safeString(rc.RESULT_CODE) : '';
  const failed =
    Boolean(Number(data?.code)) ||
    (rc != null && statusCode !== '0') ||
    (rc1 != null && safeString(rc1.RESULT_CODE) === 'F');
  if (failed) {
    const message =
      safeString(rc?.RESULT_MESSAGE).trim() ||
      safeString(rc1?.RESULT_CNT).trim() ||
      safeString(data?.message).trim() ||
      '저장 중 오류가 발생했습니다.';
    return { ok: false, message };
  }
  return { ok: true };
};

const submit = async (sheet: SHEETS, spec: readonly FieldSpec[], rows: readonly Row[], userId: string): Promise<SaveResult> => {
  const payload = foldPayload(spec, rows, userId);
  try {
    const res = await apiClient.post<Record<string, unknown>>(`/${MENU_ID}/${sheet}/SAVE/call-proc`, payload);
    if (res.status >= 400) return { ok: false, message: '저장 중 오류가 발생했습니다.' };
    return parseResult(res.data);
  } catch (e) {
    return { ok: false, message: e instanceof Error ? e.message : '저장 중 오류가 발생했습니다.' };
  }
};

export const submitMainSave = (rows: readonly Row[], userId: string): Promise<SaveResult> =>
  submit(SHEETS.MAIN, MAIN_SPEC, rows, userId);

export const submitItemMappingSave = (rows: readonly Row[], userId: string): Promise<SaveResult> =>
  submit(SHEETS.ITEM_MAPPING, ITEM_SPEC, rows, userId);
