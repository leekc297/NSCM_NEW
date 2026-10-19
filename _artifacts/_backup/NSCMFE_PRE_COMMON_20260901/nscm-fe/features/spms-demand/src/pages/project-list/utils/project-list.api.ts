// ⭐ SDM1020 — call-proc 직접 호출 헬퍼 (PKG_SDM1020 — 등록요청 BTN_REQ + 권한요청 REQ_AUTH).
//   ⭐ 등록요청 = **행별 단건 호출** (확정 결정 — SP 는 '^' 벌크 파서(REGEXP_SUBSTR)지만 1행 문자열
//     호환. '^' join 금지: [^\^]+ 가 빈 토큰을 건너뛰어 행 정렬이 밀리는 함정 + SOP_DATE TO_DATE
//     파싱 함정 — SDM1010 §0.2 계보 동일). 빈 값 = '' (단건이라 안전 — '-' 센티널 금지).
//   ⭐ 성공판정 = parseCallProcResult 공통 (SDM lib/call-proc — CODE 이름 '0' + EVENT 처리건수.
//     GET 계열 EVENT=NULL / BTN 계열 = TO_CHAR(처리건수) — EVENT '0' 이면 성공 토스트 금지).
//   실패(예외)는 RAISE_APPLICATION_ERROR → HTTP 오류 경로로 수신. BTN 2본은 내부 COMMIT 보유 (O-4).
import { apiClient } from '@foundation/apis';

import { parseCallProcResult, type CallProcResult } from '../../../lib/call-proc';
import { BTN, MENU_ID, SHEETS } from '../project-list.constants';

export type { CallProcResult } from '../../../lib/call-proc';

const callProc = async (
  sheet: string,
  btnCd: string,
  payload: Record<string, string>
): Promise<CallProcResult> => {
  const res = await apiClient.post<Record<string, unknown>>(
    `/${MENU_ID}/${sheet}/${btnCd}/call-proc`,
    payload
  );
  return parseCallProcResult(res.status, res.data);
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
