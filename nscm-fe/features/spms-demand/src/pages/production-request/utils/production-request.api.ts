// ⭐ SDM2010 — call-proc 직접 호출 헬퍼 (PKG_SDM2010 SAVE 2본 — 전부 단건).
//   성공판정 = parseCallProcResult 공통 (SDM lib/call-proc — CODE 이름 '0' + EVENT 처리건수.
//   EVENT '0' 이면 성공 토스트 금지 — 허위성공 방지 계보). 실패(예외)는 RAISE_APPLICATION_ERROR
//   → HTTP 오류 경로로 수신.
//   ⚠ 세션 파라미터 규약 (BE NDaoInterface._selectList 실측): sesUserId 만 BE 자동주입 —
//   sesDivisionId 는 자동주입되지 않으므로 payload 에 FE 세션값으로 직접 넣는다.
import { apiClient } from '@foundation/apis';
import { CRUD_TYPE } from '@foundation/constants';

import { parseCallProcResult, toText, type CallProcResult } from '../../../lib/call-proc';
import { parseAnyDate } from '../../../lib/date';
import { BTN, MENU_ID, SHEETS } from '../production-request.constants';
import type { DemandRow } from '../production-request.types';

export type { CallProcResult } from '../../../lib/call-proc';

// 샘플 빌드 저장 payload — P_SDM2010_SAVE_PJT_SAMPLE_BUILD IN (PROC_M COL_NM camelCase 1:1).
//   ⚠ 설계서에 P_DPJT_BUILD_SEQ 가 빌드/묶음 2회 기재 — 묶음 차수는 P_DPJT_BIND_SEQ 오기로 보고
//   bindSeq 로 전달한다 (constants.ts 정오 메모 — PROC_M 등재 시 실서명과 대조 필수).
export interface SaveSampleBuildPayload {
  dpjtCode: string; // P_DPJT_CODE — Tree 선택 정보
  dpjtBuildNo: string; // P_DPJT_BUILD_NO — Tree 선택 정보
  dpjtBuildType: string; // P_DPJT_BUILD_TYPE — 빌드 차수 구분 (사용자 입력)
  dpjtBuildSeq: string; // P_DPJT_BUILD_SEQ — 빌드 차수 Sequence (사용자 입력)
  dpjtBindType: string; // P_DPJT_BIND_TYPE — 묶음 차수 구분 (사용자 입력)
  dpjtBindSeq: string; // 묶음 차수 Sequence (사용자 입력 — 위 정오 메모)
  note: string; // P_NOTE — 특이사항
  sesDivisionId: string; // P_SES_DIVISION_ID — FE 세션값 (BE 자동주입 아님 — 상단 규약)
}

export const callSaveSampleBuild = async (
  payload: SaveSampleBuildPayload
): Promise<CallProcResult> => {
  const res = await apiClient.post<Record<string, unknown>>(
    `/${MENU_ID}/${SHEETS.BUILD}/${BTN.SAVE_BUILD}/call-proc`,
    { ...payload }
  );
  return parseCallProcResult(res.status, res.data);
};

// 샘플 수요 저장 payload — P_SDM2010_SAVE_PJT_SAMPLE_DEMAND IN (PROC_M COL_NM camelCase 1:1).
//   ⭐ 행별 단건 호출 (SDM1020 확정 계보 — '^' bulk join 금지: 빈 토큰 행밀림/스칼라 세션값 오염 함정).
export interface SaveSampleDemandPayload {
  activeFlag: string; // 'I' / 'M' / 'D' (CRUD_TYPE 'C'→'I' 매핑 — 호출부)
  dpjtCode: string;
  dpjtBuildNo: string;
  demandSeq: string; // 신규 행은 '' — SP 채번
  useType: string;
  reqProcess: string;
  useDetail: string;
  reqQty: string;
  reqQtyUom: string;
  prodCode: string;
  cellCode: string;
  shipReqDate: string; // 'YYYY-MM-DD …' 또는 '' (SP SUBSTR 1..10 파싱)
  procType: string;
  procPlanDate: string;
  pic: string;
  changeReason: string;
  sesDivisionId: string; // P_SES_DIVISION_ID — FE 세션값 (BE 자동주입 아님 — 상단 규약)
}

export const callSaveSampleDemand = async (
  payload: SaveSampleDemandPayload
): Promise<CallProcResult> => {
  const res = await apiClient.post<Record<string, unknown>>(
    `/${MENU_ID}/${SHEETS.DEMAND}/${BTN.SAVE_DEMAND}/call-proc`,
    { ...payload }
  );
  return parseCallProcResult(res.status, res.data);
};

// 날짜 셀 → SP TO_DATE 호환 'YYYY-MM-DD' / 빈 값 '' ('-' 센티널 금지 — TO_DATE 파싱 오류 계보)
const toDateParam = (value: unknown): string => {
  const parsed = parseAnyDate(value);
  return parsed ? parsed.format('YYYY-MM-DD') : '';
};

/** 수요 그리드 변경 행 → 저장 payload (CRUD_TYPE 'C'→'I' 매핑 — SP I/M/D 분기) */
export const toSaveDemandPayload = (
  row: DemandRow,
  sesDivisionId: string
): SaveSampleDemandPayload => ({
  activeFlag: row.CRUD_TYPE === CRUD_TYPE.CREATE ? CRUD_TYPE.INSERT : toText(row.CRUD_TYPE),
  dpjtCode: toText(row.DPJT_CODE),
  dpjtBuildNo: toText(row.DPJT_BUILD_NO),
  demandSeq: toText(row.DEMAND_SEQ),
  useType: toText(row.USE_TYPE),
  reqProcess: toText(row.REQ_PROCESS),
  useDetail: toText(row.USE_DETAIL),
  reqQty: toText(row.REQ_QTY),
  reqQtyUom: toText(row.REQ_QTY_UOM),
  prodCode: toText(row.PROD_CODE),
  cellCode: toText(row.CELL_CODE),
  shipReqDate: toDateParam(row.SHIP_REQ_DATE),
  procType: toText(row.PROC_TYPE),
  procPlanDate: toDateParam(row.PROC_PLAN_DATE),
  pic: toText(row.PIC),
  changeReason: toText(row.CHANGE_REASON),
  sesDivisionId,
});
