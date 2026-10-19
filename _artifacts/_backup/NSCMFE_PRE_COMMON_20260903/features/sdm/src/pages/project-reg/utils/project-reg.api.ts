// ⭐ SDM1010 — call-proc 직접 호출 헬퍼 (신본 PKG_SDM1010 — SAVE/REQ/CANCEL + 권한 모달 SAVE 3종).
//   ⭐ 저장/버튼 = **행별 단건 호출** (계약 결정 1 — '^' 다행 금지: [^\^]+ 가 빈 토큰을 건너뛰어
//     행 정렬이 밀리는 함정 §0.2 + SOP_DATE TO_DATE 파싱 함정 실측). 값 규약: 빈 값 = ''(단건이라
//     안전, '-' 금지 — 날짜 파싱 오류).
//   예외: §11/§12 replace-set 의 P_USER_ID 는 '^' 구분 전체 목록 계약 그대로 (USER_ID 는 항상 값 —
//     빈 토큰 없음), §13 반려는 단건 반복.
//   ⭐ 성공판정 = 결과커서 **CODE 이름** '0' + **EVENT 처리건수** (위치기반 추출 금지 —
//     memory feedback_callproc_result_cursor_code_check. GET 계열 EVENT=NULL / SAVE·BTN 계열 =
//     TO_CHAR(처리건수) — EVENT '0' 이면 성공 토스트 금지, §0.1 허위성공 방지 계보).
//   실패(예외)는 RAISE_APPLICATION_ERROR(-20001) → HTTP 오류 경로로 수신 (§0.1).
import { apiClient } from '@foundation/apis';
import { safeString } from '@foundation/utils';

import { MENU_ID, SHEETS } from '../project-reg.constants';

export interface CallProcResult {
  ok: boolean;
  /** SP 결과커서 CODE 원문 — '0'=성공 (신본은 '0' 또는 ORA 예외뿐 — '-1' 은 데드코드 §0.1) */
  code?: string;
  /** SP 결과커서 MSG ('SUCCESS') 또는 BE 오류 메시지 */
  message?: string;
  /** SP 결과커서 EVENT — SAVE·BTN 처리건수 (GET 계열 NULL → 0) */
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
  // status 500/403 은 responseErrorInterceptor 가 resolve → 직접 차단 (false success 방지)
  if (res.status >= 400 || Number((res.data as { code?: string })?.code)) {
    return {
      ok: false,
      event: 0,
      message: (res.data as { message?: string })?.message?.trim(),
    };
  }
  const first = extractRows(res.data)?.[0];
  if (!first || !('CODE' in first)) {
    // CODE 커서 미반환 응답 — 신본 계약(§0.1 전 SP O_RESULT_CURSOR 필수)에서 비정상 → 실패 취급
    return { ok: false, event: 0, message: undefined };
  }
  // ⭐ 이름 기반 추출 (CODE/MSG/EVENT — §0.1 커서 계약)
  const code = safeString(first.CODE).trim();
  const msg = typeof first.MSG === 'string' ? first.MSG.trim() : undefined;
  const event = Number(safeString(first.EVENT ?? '0').trim() || '0');
  return {
    ok: code === '0',
    code,
    message: msg,
    event: Number.isFinite(event) ? event : 0,
  };
};

// TAB1 저장 payload (§2 P_SDM1010_SAVE_TAB1_PJT_REG — 14 IN 중 sesUserId BE주입 제외 13키.
//   PROC_M COL_NM camelCase 1:1 — 키 과부족 = generic call-proc -9994 계보)
export interface SaveTab1Payload {
  activeFlag: string; // 'I'/'M'/'D' (FE 신규행 'C' → 'I' 변환은 toSavePayload)
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
  sopDate: string; // 'YYYY-MM-DD 00:00:00' 또는 '' (§2 TO_DATE 고정 마스크)
  sopPlantId: string;
}

// TAB1 SAVE — 행마다 1회 순차 호출 (I=서버 TEMP_* 채번 — KEY/CODE 빈 값·SEQ '1' /
//   M·D=커서 수신 KEY·CODE·SEQ 실값 필수 — 빈 값이면 가드 불충족 EVENT=0, 2026-08-13 실측)
export const callSaveTab1 = (payload: SaveTab1Payload): Promise<CallProcResult> =>
  callProc(SHEETS.TAB1, 'SAVE', { ...payload });

// 등록요청 — §3 (WRITING→WAITING. 가드 불충족 = CODE 0/EVENT 0). 행별 단건
export const callReqTab1 = (payload: { divisionId: string; dpjtKey: string }): Promise<CallProcResult> =>
  callProc(SHEETS.TAB1, 'REQ', { ...payload });

// 요청취소 — §4 (WAITING→WRITING). 행별 단건
export const callCancelTab1 = (payload: {
  divisionId: string;
  dpjtKey: string;
}): Promise<CallProcResult> => callProc(SHEETS.TAB1, 'CANCEL', { ...payload });

// 권한관리 OK ① — §11 입력(WRITE) replace-set: 최종 목록 전체 USER_ID '^' join.
//   포함=CONFIRM(요청 승인 포함) / 요청자 제외=REJECT / 무요청 제외=NULL 소거 (delta 아님)
export const callSaveAuthWrite = (dpjtKey: string, userIds: string[]): Promise<CallProcResult> =>
  callProc(SHEETS.POP1_GRID2, 'SAVE', {
    activeFlag: 'I', // §11 본문 미사용 — 시그니처 충족용
    dpjtKey,
    userId: userIds.join('^'),
    sesDivisionId: '',
  });

// 권한관리 OK ② — §12 조회(READ) replace-set (§11 동형)
export const callSaveAuthRead = (dpjtKey: string, userIds: string[]): Promise<CallProcResult> =>
  callProc(SHEETS.POP1_GRID3, 'SAVE', {
    activeFlag: 'I',
    dpjtKey,
    userId: userIds.join('^'),
    sesDivisionId: '',
  });

// 권한관리 OK ③ — §13 반려 단건 (DPJT_AUTH_TYPE_REQ IS NOT NULL 행만 → REJECT). 사용자별 반복
export const callRejectAuthReq = (dpjtKey: string, userId: string): Promise<CallProcResult> =>
  callProc(SHEETS.POP1_GRID4, 'SAVE', { dpjtKey, userId });
