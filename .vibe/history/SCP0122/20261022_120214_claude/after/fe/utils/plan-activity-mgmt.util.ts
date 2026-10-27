import { CRUD_TYPE } from '@foundation/constants';
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

// 콤보 값이 현재 후보 안에서 선택돼 있는지 — 아니면(빈값·후보 밖) Form 이 AS-IS 처럼 첫 후보를 고른다.
export const isPicked = (value: string, options: Option[]): boolean =>
  value !== '' && options.some(option => option.value === value);

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

// 실데이터 변경 없음 판정 — AS-IS Save_Data cs:428-430: D 가 아니고 ACTV_CD·ACTV_SEQ 가 PRE_* 와 같으면 저장 대상 제외.
//   (편집 후 원래 값으로 되돌린 M 행, 코드·순번을 비워 둔 I 행이 해당 — AS-IS 와 같이 MSG00001 이전에 건너뛴다.)
export const isUnchangedRow = (row: PlanActivityMgmtRow): boolean => {
  const record = row as Record<string, unknown>;
  return (
    record.CRUD_TYPE !== CRUD_TYPE.DELETE &&
    str(record.OPMZ_ACTV_CD) === str(record.PRE_OPMZ_ACTV_CD) &&
    str(record.OPMZ_ACTV_SEQ) === str(record.PRE_OPMZ_ACTV_SEQ)
  );
};

// 신규행(I) 중복체크 — 직전 조회결과에 PRS_CD+PLAN_GR_ID+ACTV_CD 동일행이 있으면 true(design 03 §4.4 MSG00443).
//   조회결과(existingRows)가 없으면 중복체크 생략(2025-07-02 AS-IS 주석) — 호출부에서 빈 배열 처리.
//   AS-IS cs:338,453 은 조회 직후 스냅샷(dtPlanActivityAll = ds.Tables[0].Copy())과 비교한다 — 그 뒤 수정(M)·삭제(D)
//   표시와 무관하게 조회 당시 코드가 기준이다. 기존행의 조회 당시 코드 = PRE_OPMZ_ACTV_CD(SP 가 OPMZ_ACTV_CD 를 그대로
//   내려줌), PRS_CD·PLAN_GR_ID 는 편집 불가라 현재값 = 조회값.
export const hasDuplicateNewRow = (
  newRows: PlanActivityMgmtRow[],
  existingRows: PlanActivityMgmtRow[]
): boolean => {
  const keyOf = (row: PlanActivityMgmtRow, actvCdColumn: string): string => {
    const record = row as Record<string, unknown>;
    return [record.OPMZ_PRS_CD, record.OPMZ_PLAN_GR_ID, record[actvCdColumn]].map(str).join('');
  };
  const existingKeys = new Set(existingRows.map(row => keyOf(row, 'PRE_OPMZ_ACTV_CD')));
  return newRows.some(row => existingKeys.has(keyOf(row, OPMZ_ACTV_CD)));
};

// SAVE SP 결과 판정 — P_SCP0122_SAVE_PLAN_ACTIVITY_MGMT 는 실패도 예외를 삼키고(ROLLBACK) o_result_cursor 1행으로
//   돌려준다: 성공 RESULT_CODE='S' + RESULT_CNT=처리 건수 / 실패 RESULT_CODE='F' + RESULT_CNT='[SQLCODE]SQLERRM'.
//   BE call-proc 은 커서를 그대로 result 에 담아 envelope code 는 성공이므로 FE 가 이 행으로 판정해야 한다
//   (AS-IS cs:505 `Tables[0].Rows[0][0] == "S"`). 위치가 아니라 컬럼명으로 꺼낸다.
export interface PlanActivitySaveResult {
  success: boolean;
  // 성공 = 처리 건수, 실패 = SP 오류문(RESULT_CNT 원문)
  detail: string;
}

export const parseSaveResult = (result: unknown): PlanActivitySaveResult => {
  const cursor =
    result && typeof result === 'object'
      ? (result as Record<string, unknown>).o_result_cursor
      : undefined;
  const head = Array.isArray(cursor) ? (cursor[0] as Record<string, unknown> | undefined) : undefined;
  return {
    success: str(head?.RESULT_CODE) === 'S',
    detail: str(head?.RESULT_CNT),
  };
};

// Plan Group 후보 정렬 — AS-IS SCP0121_GET_SEARCH_INFO Tables[3] `ORDER BY OPMZ_PLAN_GR_NAME`(2025-10-20, MSSQL CI
//   콜레이션 = 대소문자 무시). 콤보 PlanGroup_SCP_ALL 은 ORDER BY 가 없고, 첫 후보 자동선택이 이 순서를 따르므로
//   화면이 직접 정렬한다(대문자 비교 → 동률이면 원문 비교, GAP392 UPPER(x),x 관례).
export const sortByNameCi = <T extends { label: string }>(options: T[]): T[] =>
  [...options].sort((a, b) => {
    const upperA = a.label.toUpperCase();
    const upperB = b.label.toUpperCase();
    if (upperA !== upperB) return upperA < upperB ? -1 : 1;
    if (a.label === b.label) return 0;
    return a.label < b.label ? -1 : 1;
  });

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
