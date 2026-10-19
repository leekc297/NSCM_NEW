// ⭐ SDM2020 — call-proc 직접 호출 헬퍼 (SAVEPLANT / CONFIRM 2본).
//   ⭐ 두 SP 는 '^' 벌크 파서 보유 (REGEXP_SUBSTR '[^\^]+' 인덱스 파싱) → SPMS 표준 = 벌크 1건
//   (lib/bulk-save — 빈 값 ' ' 센티널). 스칼라 IN (dpjtCode/dpjtBuildNo/plantId…) 은 조인하지 않는다.
//   성공판정 = parseCallProcResult 공통 (CODE 이름 '0' + EVENT 처리건수. EVENT 0 = 성공 토스트 금지).
//   세션 규약 (BE NDaoInterface 실측): sesUserId 만 BE 자동주입 — sesDivisionId 는 FE 세션값 전달.
import { apiClient } from '@foundation/apis';

import { parseCallProcResult, type CallProcResult } from '../../../lib/call-proc';
import { BTN, MENU_ID, SHEETS } from '../plan-yield.constants';

export type { CallProcResult } from '../../../lib/call-proc';

const callProc = async (
  sheet: SHEETS,
  btnCd: string,
  payload: Record<string, string>
): Promise<CallProcResult> => {
  const res = await apiClient.post<Record<string, unknown>>(
    `/${MENU_ID}/${sheet}/${btnCd}/call-proc`,
    payload
  );
  return parseCallProcResult(res.status, res.data);
};

// 샘플 요청 법인 저장 payload — PKG_SDM2020.P_SDM2020_SAVE_PJT_SAMPLE_BUILD IN (PROC_M COL_NM camelCase 1:1).
//   SP 는 P_OPERATION_ID 전달 시 요청법인 저장 모드(빌드 생성 x) — 빌드 헤더 IN(dpjtBuildType 등)은 미전송.
//   replace-set: 패널 전 행을 '^' 로 접어 1건 전송 (SP 가 빌드 단위 DELETE 후 INSERT). dpjtKey 는 SP 가 해석.
export interface SavePlantPayload {
  dpjtCode: string; // P_DPJT_CODE (스칼라)
  dpjtBuildNo: string; // P_DPJT_BUILD_NO (스칼라)
  mgmtType: string; // P_MGMT_TYPE '^' (양음극 C/A/-)
  operationGroup: string; // P_OPERATION_GROUP '^'
  operationId: string; // P_OPERATION_ID '^'
  plantId: string; // P_PLANT_ID '^' (빈 값 = ' ')
  confirmFlag: string; // P_CONFIRM_FLAG '^' (CHECKED/UNCHECKED)
  sesDivisionId: string; // P_SES_DIVISION_ID
}

export const callSavePlant = (payload: SavePlantPayload): Promise<CallProcResult> =>
  callProc(SHEETS.PLANT, BTN.SAVE_PLANT, { ...payload });

// 수율/Loss 계획 확정 payload — PKG_SDM2020.P_SDM2020_SAVE_PJT_YIELD IN (camelCase 1:1).
//   선택 **공정 그룹**(구분)의 조건행(그룹 헤더행 제외) 전 행을 '^' 로 접어 1건 전송 — 편집값만.
//   ⚠ SP 변경 필요 (2026-09-04): 조회 단위가 공정 1건에서 구분 1블록으로 바뀌어 한 그리드에 여러 공정이
//   섞인다. plantId/operationId 는 더 이상 스칼라가 아니라 행별 '^' 배열이고, DELETE 범위도 선택 공정
//   단위가 아니라 (dpjtBuildNo + operationGroup + mgmtType) 단위여야 한다.
export interface ConfirmYieldPayload {
  dpjtCode: string; // 스칼라
  dpjtBuildNo: string; // 스칼라
  operationGroup: string; // 스칼라 — 선택 구분 (공정 그룹 E/A/P)
  mgmtType: string; // 스칼라 — 양음극 (C/A/-)
  yieldVer: string; // 스칼라 — 첫 행 YIELD_VER
  yieldMgmtKey: string; // '^'
  plantId: string; // '^' — 행별 요청법인 (구분 안에서 공정마다 다르다)
  operationId: string; // '^' — 행별 공정
  checkedFlag: string; // '^' CHECKED/UNCHECKED/NONE
  yieldVal: string; // '^' Delta (조정) (빈 값 ' ')
  addInfo1: string; // '^' 비고 (조정사유) (빈 값 ' ')
  sesDivisionId: string;
}

export const callConfirmYield = (payload: ConfirmYieldPayload): Promise<CallProcResult> =>
  callProc(SHEETS.YIELD, BTN.CONFIRM, { ...payload });
