import type { ComboResponse } from '@foundation/models';

import { ACTIVITY_SYNC_COLUMNS, OPMZ_ACTV_CD } from '../plan-activity-mgmt.constants';
import type { PlanActivityMgmtRow } from '../plan-activity-mgmt.types';

export const str = (value: unknown): string =>
  typeof value === 'string' ? value : typeof value === 'number' ? String(value) : '';

interface Option {
  label: string;
  value: string;
}

// 콤보 응답(CODE/NAME) -> 드롭다운 옵션. NAME 없으면 CODE 표시(hook #87 CODE/NAME 규약).
export const toComboOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(row => ({ label: str(row.NAME) || str(row.CODE), value: str(row.CODE) }));

// OPMZ_ACTV_NAME 셀콤보 변경 -> 콤보행(7컬럼)에서 OPMZ_ACTV_CD + 파생 5컬럼을 복사(Auto-Sync, design 03 §3-R3).
//   콤보 셀값 = CODE 이므로 selectedCode = row[OPMZ_ACTV_NAME]. 콤보행이 없으면(코드 미매칭) 파생을 비운다.
export const applyActivitySync = (
  row: PlanActivityMgmtRow,
  comboRow: ComboResponse | undefined
): void => {
  const record = row as Record<string, unknown>;
  record[OPMZ_ACTV_CD] = str(comboRow?.CODE) || str(record[OPMZ_ACTV_CD]);
  for (const column of ACTIVITY_SYNC_COLUMNS) {
    record[column] = str(comboRow?.[column]);
  }
};

// 신규행(I) 중복체크 — 직전 조회결과에 PRS_CD+PLAN_GR_ID+ACTV_CD 동일행이 있으면 true(design 03 §4.4 MSG00443).
//   조회결과(existingRows)가 없으면 중복체크 생략(2025-07-02 AS-IS 주석) — 호출부에서 빈 배열 처리.
export const hasDuplicateNewRow = (
  newRows: PlanActivityMgmtRow[],
  existingRows: PlanActivityMgmtRow[]
): boolean => {
  const keyOf = (row: PlanActivityMgmtRow): string => {
    const record = row as Record<string, unknown>;
    return [record.OPMZ_PRS_CD, record.OPMZ_PLAN_GR_ID, record.OPMZ_ACTV_CD].map(str).join('');
  };
  const existingKeys = new Set(existingRows.map(keyOf));
  return newRows.some(row => existingKeys.has(keyOf(row)));
};

// 저장 payload — 컬럼별로 변경행 값을 캐럿(^)으로 접어 파라미터 문자열 전송(AS-IS CString.AppendString,
//   SP SCM_ARR_SPL_VAL(...,'^',i) 파싱). design 03 §4.4 SAVE 7파라미터 = 6개 컬럼접기 + userId(세션).
//   키명 = SCM_ADM_PROC_M.COL_NM(camelCase 컨벤션, 자매 SCP0005/SCP0006). snake_case p_* 로 보내면
//   BE 가 COL_NM 으로 값을 못 찾아 조용히 NULL 바인딩·SUCCESS 반환한다(메모리 generic-callproc-param-key-must-match-proc-m-colnm).
//   userId 는 감사/HISTORY user 기록용 — call-proc(execBtn)는 세션 userId 를 자동주입하지 않으므로(call-proc2 전용,
//   메모리 save-proc-per-column-caret-fold-fe) 호출부가 세션에서 읽어 전달한다.
//   M/D 의 WHERE 키 = preActvCd(PRE_OPMZ_ACTV_CD, 수정전 코드).
export interface PlanActivitySavePayload {
  activeFlag: string;
  prsCd: string;
  planGrId: string;
  actvCd: string;
  actvSeq: string;
  preActvCd: string;
  userId: string;
}

export const buildSavePayload = (
  rows: PlanActivityMgmtRow[],
  userId: string
): PlanActivitySavePayload => {
  const fold = (pick: (record: Record<string, unknown>) => unknown): string =>
    rows.map(row => str(pick(row as Record<string, unknown>))).join('^');
  return {
    activeFlag: fold(record => record.CRUD_TYPE),
    prsCd: fold(record => record.OPMZ_PRS_CD),
    planGrId: fold(record => record.OPMZ_PLAN_GR_ID),
    actvCd: fold(record => record.OPMZ_ACTV_CD),
    actvSeq: fold(record => record.OPMZ_ACTV_SEQ),
    preActvCd: fold(record => record.PRE_OPMZ_ACTV_CD),
    userId,
  };
};
