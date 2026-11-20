// SCP0131 저장 — 컬럼별 '^'-fold 평면 payload 조립 + POST + false-success 판별.
//   SCP 표준 batch-save 패턴(메모리 save-proc-per-column-caret-fold-fe) 이식 — 정본 자매는
//   SCP0133 warehouseCapacity.saveRequest.ts · SCP0126 optCapa.save.ts.
//
// 왜 공용 useProcMutation({data:[rows]}) 가 아닌가: PKG_SCP0131.P_SCP0131_SAVE_SALES_SITE_PRIORITY
//   파라미터가 전부 CLOB 이고 본문이 SCM_ARR_SPL_VAL(P_X,'^',loop) 로 행을 쪼갠다. BE execBtn 은
//   DATA_TP_CD='CLOB' 은 접지 않고 params.get(COL_NM) 을 그대로 바인드하므로(JVARCHAR 만 fold),
//   FE 가 컬럼별로 '^'-join 한 평면 스칼라를 SCM_ADM_PROC_M.COL_NM(camelCase) 키로 보내야 한다.
//   raw {data:[rows]} 로 보내면 전 파라미터(activeFlag·pre*) NULL 바인딩 → UPDATE/DELETE 의
//   WHERE ...=V_PRE_*(=C_NOMATCH) 가 0행 매칭 → no-op + 성공 토스트(실제 미저장).
//
// PRE_* 는 수정/삭제행의 '변경 전 키'다 — GET 이 내려준 PRE_KEY_VALUES('|' 결합)를 파싱해 채운다.
//   토큰 순서(PKG_SCP0131 GET 본문 실측):
//     DIVISION_ID | OPMZ_PLAN_GR_ID | SCM_SITE_ID | ITEM_ID | FROM_YYYYMMDD | TO_YYYYMMDD | PRIO_RANK
//   신규행(CRUD_TYPE='I')은 PRE_KEY_VALUES 가 비어 토큰이 모두 '' — INSERT 분기는 pre* 미사용.
//   userId 는 세션유저 — SP 가 P_USER_ID 를 루프 안 SCM_ARR_SPL_VAL 로 행별 분해하므로 행마다 실어
//   '^'-fold 한다(CREATED_BY/LAST_UPDATED_BY 갱신용, call-proc 은 세션유저 미주입).

import { apiClient } from '@foundation/apis';
import { safeString } from '@foundation/utils';

import { MENU_ID, SHEETS } from '../sales-site-priority.constants';

export interface SaveResult {
  ok: boolean;
  message?: string;
  // 저장 성공 건수 — SP o_rc1[0].RESULT_CNT(AS-IS MSG00004 저장 건수). 성공 토스트 {0} 치환용.
  count?: number;
}

type Row = Record<string, unknown>;
interface FieldSpec {
  key: string;
  get: (row: Row) => string;
}

// 날짜 표시값(FPDateText 'yyyy-MM-dd' 또는 'yyyy-MM-dd HH:mm:ss') → 저장 포맷 YYYYMMDD(숫자만 8자리).
//   AS-IS .Replace("-","").Substring(0,8) 등가. 저장검증(From>To)도 동일 정규화를 공유한다 — GET 은
//   'yyyy-MM-dd HH:mm:ss'(시간부 포함), 붙여넣기 셀은 복사원 포맷 그대로라, 문자열 원형 비교는
//   포맷·구분자·시간부 불일치에 깨진다(useSalesSitePriorityValidation 재사용).
export const ymd8 = (v: unknown): string => safeString(v).replace(/\D/g, '').slice(0, 8);

const PRE_DELIM = '|';
const preToken = (row: Row, idx: number): string =>
  safeString(row.PRE_KEY_VALUES).split(PRE_DELIM)[idx] ?? '';

// 값 컬럼 ↔ SCM_ADM_PROC_M.COL_NM(camelCase) 대응 — ora.py 실측(P_SCP0131_SAVE_SALES_SITE_PRIORITY).
//   activeFlag 는 EditTracker 가 세운 CRUD_TYPE('I'/'M'/'D') 그대로. pre* 는 PRE_KEY_VALUES 파싱값.
const MAIN_SPEC: readonly FieldSpec[] = [
  { key: 'activeFlag', get: r => safeString(r.CRUD_TYPE) },
  { key: 'divisionId', get: r => safeString(r.DIVISION_ID) },
  { key: 'opmzPlanGrId', get: r => safeString(r.OPMZ_PLAN_GR_ID) },
  { key: 'scmSiteId', get: r => safeString(r.SCM_SITE_ID) },
  { key: 'itemId', get: r => safeString(r.ITEM_ID) },
  { key: 'prioRank', get: r => safeString(r.PRIO_RANK) },
  { key: 'fromYyyymmdd', get: r => ymd8(r.FROM_YYYYMMDD) },
  { key: 'toYyyymmdd', get: r => ymd8(r.TO_YYYYMMDD) },
  { key: 'valueDescription', get: r => safeString(r.VALUE_DESCRIPTION) },
  { key: 'validYn', get: r => safeString(r.VALID_YN) },
  { key: 'preDivisionId', get: r => preToken(r, 0) },
  { key: 'preOpmzPlanGrId', get: r => preToken(r, 1) },
  { key: 'preScmSiteId', get: r => preToken(r, 2) },
  { key: 'preItemId', get: r => preToken(r, 3) },
  { key: 'prePrioRank', get: r => preToken(r, 6) },
  { key: 'preFromYyyymmdd', get: r => preToken(r, 4) },
  { key: 'preToYyyymmdd', get: r => preToken(r, 5) },
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
  // 성공 시 RESULT_CNT(저장 건수) 추출 — 숫자 아니면 undefined(호출측이 submit 행수로 폴백).
  const cnt = Number(safeString(rc1?.RESULT_CNT).trim());
  return { ok: true, count: Number.isFinite(cnt) && cnt > 0 ? cnt : undefined };
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
