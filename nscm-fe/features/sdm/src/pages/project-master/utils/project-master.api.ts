// ⭐ SDM5010 — call-proc 직접 호출 헬퍼 (PKG_SDM5010 — 승인 CONFIRM/반려 CANCEL/TAB2 SAVE).
//   ⭐ 전 액션 = **행별 단건 호출** (확정 결정 — '^' 다행 금지: 빈 토큰 행밀림·날짜 파싱 함정,
//     SDM1010 §0.2 계보). 빈 값 = '' (단건이라 안전 — '-' 센티널 금지: TO_DATE 파싱 오류).
//   ⭐ 성공판정 = 결과커서 **CODE 이름** '0' + **EVENT 처리건수** (project-list.api 계약 이식 —
//     위치기반 추출 금지, memory feedback_callproc_result_cursor_code_check. EVENT 0 =
//     실패 처리·성공 토스트 금지 — D12 허위성공 방어 정오표 방침).
//   실패(예외)는 RAISE_APPLICATION_ERROR → HTTP 오류 경로로 수신. BTN 2본은 내부 COMMIT 보유 (D21).
import { apiClient } from '@foundation/apis';
import { safeString } from '@foundation/utils';

import { BTN, MENU_ID, SHEETS } from '../project-master.constants';

export interface CallProcResult {
  ok: boolean;
  /** SP 결과커서 CODE 원문 — '0'=성공 ('1'/'-1' = 가드 실패 — D10/D12 정정분·SAVE 계약 외 FLAG) */
  code?: string;
  /** SP 결과커서 MSG ('SUCCESS') 또는 BE 오류 메시지 */
  message?: string;
  /** SP 결과커서 EVENT — 처리건수 (NULL → 0. EVENT 0 = 성공 토스트 금지 축) */
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
    // CODE 커서 미반환 응답 — PKG_SDM5010 계약(전 SP O_RESULT_CURSOR 필수)에서 비정상 → 실패 취급
    return { ok: false, event: 0, message: undefined };
  }
  // ⭐ 이름 기반 추출 (CODE/MSG/EVENT — 커서 계약)
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

// 승인 payload (P_SDM5010_BTN_TAB1_CONFIRM 15 IN 중 sesUserId BE주입 제외 14키 —
//   PROC_M COL_NM camelCase 1:1, 계약 ①. 키 과부족 = generic call-proc -9994 계보)
export interface ConfirmTab1Payload {
  dpjtKey: string;
  dpjtCode: string;
  dpjtSeq: string;
  dpjtKeyParent: string;
  divisionId: string;
  dpjtClass: string;
  endCustomer: string;
  dpjtName: string;
  cellType: string;
  stackMethod: string;
  bizType: string;
  sopDate: string; // 'YYYY-MM-DD 00:00:00' 또는 '' (SP TO_DATE SUBSTR 1..10 'YYYY-MM-DD')
  sopPlantId: string;
  note: string;
}

// 승인 — 행마다 1회 단건 호출 (E06 — 편집값 반영 + COMPLETE/NORMAL 전이. D12 정정분 =
//   갱신 0건 시 CODE '-1' 실패 커서 → ok=false)
export const callConfirmTab1 = (payload: ConfirmTab1Payload): Promise<CallProcResult> =>
  callProc(SHEETS.TAB1, BTN.CONFIRM, { ...payload });

// 반려 payload (P_SDM5010_BTN_TAB1_CANCEL 5 IN 중 sesUserId BE주입 제외 4키 — 계약 ①)
export interface CancelTab1Payload {
  divisionId: string;
  dpjtKey: string;
  dpjtKeyParent: string;
  note: string; // 현재 행 내용 전달 (P-10 — SP 는 본행 REJECT/DISABLED 전이 + NOTE 기록)
}

// 반려 — 행마다 1회 단건 호출 (E07 — D3 정정분: 부모행 복구 WHERE = P_DPJT_KEY_PARENT)
export const callCancelTab1 = (payload: CancelTab1Payload): Promise<CallProcResult> =>
  callProc(SHEETS.TAB1, BTN.CANCEL, { ...payload });

// TAB2 저장 payload (P_SDM5010_SAVE_TAB2_PJT_MASTER 5 IN 중 sesUserId BE주입 제외 4키 — 계약 ①.
//   D1 신규 작성분 — activeFlag 'M' 단건만 유효(그 외 CODE '1'), disabled = 서버 3상태 문자열 그대로)
export interface SaveTab2Payload {
  activeFlag: string; // 'M' 고정 (P-13 — 호출부가 CRUD_TYPE 'M' 행만 filter)
  dpjtKey: string;
  dpjtDevelopStatus: string;
  disabled: string; // 'CHECKED' 정확 일치만 DISABLED, 그 외 NORMAL (계약 ⑥)
}

// TAB2 저장 — 행마다 1회 단건 호출 (E20 — 성공 Toast MSG00002 + 재조회는 호출부)
export const callSaveTab2 = (payload: SaveTab2Payload): Promise<CallProcResult> =>
  callProc(SHEETS.TAB2, BTN.SAVE, { ...payload });
