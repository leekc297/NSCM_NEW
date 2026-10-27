// SCP0122 PlanActivityMgmt — utils 단위테스트 (2026-10-22 보완). 하네스 골격 __tests__/*.asis.spec.ts 는 vitest include
//   (src/**/*.test.ts) 밖이라 실행되지 않으므로 실테스트는 형제 화면과 같이 utils 옆 *.test.ts 에 둔다.
import { describe, expect, it } from 'vitest';

import type { PlanActivityMgmtRow } from '../plan-activity-mgmt.types';

import {
  buildSavePayload,
  hasDuplicateNewRow,
  isPicked,
  isUnchangedRow,
  parseSaveResult,
  sortByNameCi,
} from './plan-activity-mgmt.util';

const row = (values: Record<string, unknown>): PlanActivityMgmtRow =>
  values as PlanActivityMgmtRow;

// 2026-10-22 보완분 — utils 의 AS-IS 재현 로직(저장 판정·중복체크·변경없음·캐럿접기·콤보 기본선택/정렬)
describe('SCP0122 PlanActivityMgmt — utils (AS-IS 재현)', () => {
  it('저장 결과: RESULT_CODE=S 만 성공, 건수는 RESULT_CNT (AS-IS cs:505,508)', () => {
    expect(parseSaveResult({ o_result_cursor: [{ RESULT_CODE: 'S', RESULT_CNT: 3 }] })).toEqual({
      success: true,
      detail: '3',
    });
  });

  it('저장 결과: SP 가 삼킨 실패(RESULT_CODE=F)는 실패 + 오류문 (HTTP 200 이어도)', () => {
    expect(
      parseSaveResult({
        o_result_cursor: [{ RESULT_CODE: 'F', RESULT_CNT: '[-1]ORA-00001: unique constraint' }],
      })
    ).toEqual({ success: false, detail: '[-1]ORA-00001: unique constraint' });
  });

  it('저장 결과: 결과 커서가 없으면 성공으로 보지 않는다', () => {
    expect(parseSaveResult(undefined).success).toBe(false);
    expect(parseSaveResult({ o_result_cursor: [] }).success).toBe(false);
  });

  it('중복체크: 수정(M)된 기존행의 조회 당시 코드(PRE_OPMZ_ACTV_CD)와 같은 신규행은 중복 (AS-IS 스냅샷 기준 cs:338,453)', () => {
    const existing = row({
      CRUD_TYPE: 'M',
      OPMZ_PRS_CD: 'P1',
      OPMZ_PLAN_GR_ID: 'G1',
      OPMZ_ACTV_CD: 'B',
      PRE_OPMZ_ACTV_CD: 'A',
    });
    const added = row({ CRUD_TYPE: 'I', OPMZ_PRS_CD: 'P1', OPMZ_PLAN_GR_ID: 'G1', OPMZ_ACTV_CD: 'A' });
    expect(hasDuplicateNewRow([added], [existing])).toBe(true);
  });

  it('중복체크: 키(PRS_CD+PLAN_GR_ID+ACTV_CD)가 다르면 중복 아님', () => {
    const existing = row({ OPMZ_PRS_CD: 'P1', OPMZ_PLAN_GR_ID: 'G1', PRE_OPMZ_ACTV_CD: 'A' });
    const added = row({ CRUD_TYPE: 'I', OPMZ_PRS_CD: 'P1', OPMZ_PLAN_GR_ID: 'G2', OPMZ_ACTV_CD: 'A' });
    expect(hasDuplicateNewRow([added], [existing])).toBe(false);
  });

  it('변경없음: D 가 아니고 코드·순번이 PRE_* 와 같으면 저장 제외 (AS-IS cs:428-430)', () => {
    const base = { OPMZ_ACTV_CD: 'A', PRE_OPMZ_ACTV_CD: 'A', OPMZ_ACTV_SEQ: 1, PRE_OPMZ_ACTV_SEQ: 1 };
    expect(isUnchangedRow(row({ ...base, CRUD_TYPE: 'M' }))).toBe(true);
    expect(isUnchangedRow(row({ ...base, CRUD_TYPE: 'D' }))).toBe(false);
    expect(isUnchangedRow(row({ ...base, CRUD_TYPE: 'M', OPMZ_ACTV_SEQ: 2 }))).toBe(false);
  });

  it('저장 payload: 컬럼별 캐럿(^) 접기 + PROC_M COL_NM 키 (AS-IS cs:463-495)', () => {
    const payload = buildSavePayload(
      [
        row({ CRUD_TYPE: 'I', OPMZ_PRS_CD: 'P1', OPMZ_PLAN_GR_ID: 'G1', OPMZ_ACTV_CD: 'A', OPMZ_ACTV_SEQ: 1, PRE_OPMZ_ACTV_CD: '' }),
        row({ CRUD_TYPE: 'D', OPMZ_PRS_CD: 'P1', OPMZ_PLAN_GR_ID: 'G1', OPMZ_ACTV_CD: 'B', OPMZ_ACTV_SEQ: 2, PRE_OPMZ_ACTV_CD: 'B' }),
      ],
      'user1'
    );
    expect(payload).toEqual({
      activeFlag: 'I^D',
      prsCd: 'P1^P1',
      planGrId: 'G1^G1',
      actvCd: 'A^B',
      actvSeq: '1^2',
      preActvCd: '^B',
      userId: 'user1',
    });
  });

  it('Plan Group 정렬: NAME 대소문자 무시 (AS-IS ORDER BY OPMZ_PLAN_GR_NAME, CI 콜레이션)', () => {
    const sorted = sortByNameCi([
      { label: 'beta', value: '2' },
      { label: 'Alpha', value: '1' },
      { label: 'Bucket 10', value: '4' },
      { label: 'Bucket 2', value: '3' },
    ]);
    expect(sorted.map(option => option.value)).toEqual(['1', '2', '4', '3']);
  });

  it('콤보 기본선택 판정: 빈값·후보 밖 값은 미선택 → 첫 후보 선택 대상 (AS-IS setListBox 첫 행)', () => {
    const options = [{ label: 'A', value: 'A' }];
    expect(isPicked('', options)).toBe(false);
    expect(isPicked('Z', options)).toBe(false);
    expect(isPicked('A', options)).toBe(true);
  });
});
