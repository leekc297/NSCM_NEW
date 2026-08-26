// ⭐ SDM1020 — call-proc 직접 호출 헬퍼 (PKG_SDM1020 — 등록요청 BTN_REQ + 권한요청 REQ_AUTH).
//   ⭐ 등록요청 = **행별 단건 호출** (확정 결정 — SP 는 '^' 벌크 파서(REGEXP_SUBSTR)지만 1행 문자열
//     호환. '^' join 금지: [^\^]+ 가 빈 토큰을 건너뛰어 행 정렬이 밀리는 함정 + SOP_DATE TO_DATE
//     파싱 함정 — SDM1010 §0.2 계보 동일). 빈 값 = '' (단건이라 안전 — '-' 센티널 금지).
//   ⭐ 성공판정 = 결과커서 **CODE 이름** '0' + **EVENT 처리건수** (project-reg.api 계약 이식 —
//     위치기반 추출 금지, memory feedback_callproc_result_cursor_code_check. GET 계열 EVENT=NULL /
//     BTN 계열 = TO_CHAR(처리건수) — EVENT '0' 이면 성공 토스트 금지, 허위성공 방지 계보).
//   실패(예외)는 RAISE_APPLICATION_ERROR → HTTP 오류 경로로 수신. BTN 2본은 내부 COMMIT 보유 (O-4).
import { apiClient } from '@foundation/apis';

import { BTN, MENU_ID, SHEETS } from '../project-list.constants';

import { toText } from './project-list.value';

export interface CallProcResult {
  ok: boolean;
  /** SP 결과커서 CODE 원문 — '0'=성공 (PKG_SDM1020 은 '0' 또는 ORA 예외뿐) */
  code?: string;
  /** SP 결과커서 MSG ('SUCCESS') 또는 BE 오류 메시지 */
  message?: string;
  /** SP 결과커서 EVENT — BTN 처리건수 (GET 계열 NULL → 0) */
  event: number;
}

// 결과커서 rows 추출 — result 가 배열(단일 커서) 또는 {커서명: rows[]} 객체 양쪽 대응
const extractRows = (data: unknown): Record<string, unknown>[] | undefined => {
  const result = (data as { result?: unknown })?.result;
  if (Array.isArray(result)) return result as Record<string, unknown>[];
  if (result && typeof result === 'object') {
    const arr = Object.values(result as Record<string, unknown>).find(v => Array.isArray(v));
    return arr as Record<string, unknown>[] | undefined;
  }
  return undefined;
};

const callProc = async (
  sheet: string,
  btnCd: string,
  payload: Record<string, string>
): Promise<CallProcResult> => {
  const res = await apiClient.post<Record<string, unknown>>(
    `/${MENU_ID}/${sheet}/${btnCd}/call-proc`,
    payload
  );
  // status 500/403 은 responseErrorInterceptor 가 resolve → 직접 차단 (false success 방지 — gate §1-3)
  if (res.status >= 400 || Number((res.data as { code?: string })?.code)) {
    return {
      ok: false,
      event: 0,
      message: (res.data as { message?: string })?.message?.trim(),
    };
  }
  const first = extractRows(res.data)?.[0];
  if (!first || !('CODE' in first)) {
    // CODE 커서 미반환 응답 — PKG_SDM1020 계약(전 SP O_RESULT_CURSOR 필수)에서 비정상 → 실패 취급
    return { ok: false, event: 0, message: undefined };
  }
  // ⭐ 이름 기반 추출 (CODE/MSG/EVENT — O-3 커서 계약)
  const code = toText(first.CODE).trim();
  const msg = typeof first.MSG === 'string' ? first.MSG.trim() : undefined;
  const event = Number(toText(first.EVENT).trim() || '0');
  return {
    ok: code === '0',
    code,
    message: msg,
    event: Number.isFinite(event) ? event : 0,
  };
};

// 등록요청 payload (P_SDM1020_BTN_REQ_PJT_REG 15 IN 중 sesUserId BE주입 제외 13키 —
//   PROC_M COL_NM camelCase 1:1, 계약 ①. 키 과부족 = generic call-proc -9994 계보)
export interface ReqPjtRegPayload {
  activeFlag: string; // 'M' — D4: FE 는 수정('M') 행만 전달 (SP 분기 부재 — 항상 변경본 INSERT 경로)
  dpjtKey: string;
  dpjtCode: string;
  dpjtSeq: string;
  divisionId: string;
  dpjtClass: string;
  endCustomer: string;
  dpjtName: string;
  cellType: string;
  stackMethod: string;
  bizType: string;
  sopDate: string; // 'YYYY-MM-DD 00:00:00' 또는 '' (SP TO_DATE 'YYYY-MM-DD HH24:MI:SS' 마스크)
  sopPlantId: string;
}

// 등록요청 — 행마다 1회 순차 호출 (변경본 신규 INSERT + 원본 MODIFYING 전이(D3 정정분). EVENT 합산)
export const callReqProjectReg = (payload: ReqPjtRegPayload): Promise<CallProcResult> =>
  callProc(SHEETS.MAIN, BTN.REQ, { ...payload });

// 권한요청 payload (P_SDM1020_REQ_PJT_AUTH 5 IN 중 sesUserId BE주입 제외 3키 — 계약 ①.
//   write/read 값 = 커서 3상태 문자열 그대로 ('CHECKED' 는 SP 수용값 집합 'Y/TRUE/CHECKED/CHECK' 포함)
export interface ReqPjtAuthPayload {
  dpjtKey: string;
  dpjtAuthReqWrite: string;
  dpjtAuthReqRead: string;
}

// 권한요청 — 단건 호출 (MERGE — 신규 REQUEST INSERT / 기존 UPDATE. ADMIN·WRITE CONFIRM·동일 반복 =
//   no-op 가드 CASE 0 → EVENT 0. 취소(NONE) 경로는 SP 미처리 — 정오표 D12, PKG 정정 승인 대기)
export const callReqProjectAuth = (payload: ReqPjtAuthPayload): Promise<CallProcResult> =>
  callProc(SHEETS.MAIN, BTN.AUTHREQ, { ...payload });
