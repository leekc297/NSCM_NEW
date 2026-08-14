// ⭐ SDM1010 권한관리 팝업 순수함수 — 신본 계약(§8~§13) 1:1 검증 (2026-08-13 재배선):
//   도메인 WRITE/READ · 요청 행 식별 = USER_ID · 승인 = 목록 포함(OK replace-set 저장 시 CONFIRM §11) ·
//   반려 = decisions REJECT 목록(OK 시 §13 단건 반복).
import { describe, expect, it } from 'vitest';

import { AUTH_STATUS, AUTH_TYPE, MSG, REQ_DECISION } from '../project-reg.constants';
import type { Pop1AuthRow, Pop1ReqRow, Pop1UserRow } from '../project-reg.types';

import {
  addUsersToList,
  applyRequestDecision,
  buildAuthUserIds,
  buildRejectUserIds,
  moveUsersBetweenLists,
  removeUsersFromList,
  toAuthRow,
} from './project-reg.authPopup';

const user = (id: string, over: Record<string, string> = {}): Pop1UserRow =>
  ({
    USER_ID: id,
    USER_NAME: `이름${id}`,
    JOB_CODE: 'J1',
    JOB_NAME: '책임',
    DEPT_ID: 'D1',
    DEPT_NAME: '기타협력업체',
    ...over,
  }) as Pop1UserRow;

const authRow = (id: string): Pop1AuthRow => toAuthRow(user(id));

// §10 커서 12컬럼 형상 — 요청 행 (기본 = REQUEST 상태 WRITE 요청)
const req = (id: string, over: Record<string, string> = {}): Pop1ReqRow =>
  ({
    DPJT_AUTH_STATUS: AUTH_STATUS.REQUEST,
    DPJT_AUTH_STATUS_NAME: '요청',
    DPJT_KEY: 'TEMP_X_000001',
    USER_ID: id,
    USER_NAME: `이름${id}`,
    JOB_CODE: 'J1',
    JOB_NAME: '책임',
    DEPT_ID: 'D1',
    DEPT_NAME: '기타협력업체',
    DPJT_AUTH_TYPE: AUTH_TYPE.WRITE,
    DPJT_AUTH_TYPE_NAME: '입력',
    PROCESS: '',
    ...over,
  }) as Pop1ReqRow;

const base = () => ({ inputList: [] as Pop1AuthRow[], readList: [] as Pop1AuthRow[], decisions: {} });

describe('addUsersToList — (+) 추가 (설계 메시지: 입력/조회 리스트 기존재)', () => {
  it('체크 사용자를 대상 리스트에 추가 (WRITE=입력 / 소속 리스트가 곧 권한 유형)', () => {
    const r = addUsersToList(base(), [user('u1')], AUTH_TYPE.WRITE);
    expect(r.ok).toBe(true);
    expect(r.inputList.map(x => x.USER_ID)).toEqual(['u1']);
    expect(r.readList).toEqual([]);
  });

  it('0건 체크 = MSG00709 / 입력 기존재 = MSG00716 / 조회 기존재 = MSG00717', () => {
    expect(addUsersToList(base(), [], AUTH_TYPE.WRITE).msgId).toBe(MSG.NO_CHECKED);
    const withInput = { ...base(), inputList: [authRow('u1')] };
    expect(addUsersToList(withInput, [user('u1')], AUTH_TYPE.WRITE).msgId).toBe(MSG.AUTH_INPUT_DUP);
    const withRead = { ...base(), readList: [authRow('u1')] };
    expect(addUsersToList(withRead, [user('u1')], AUTH_TYPE.READ).msgId).toBe(MSG.AUTH_READ_DUP);
  });

  it('입력 기존재 사용자도 조회 리스트에는 추가 가능 (리스트별 독립 판정)', () => {
    const withInput = { ...base(), inputList: [authRow('u1')] };
    const r = addUsersToList(withInput, [user('u1')], AUTH_TYPE.READ);
    expect(r.ok).toBe(true);
    expect(r.readList).toHaveLength(1);
  });
});

describe('removeUsersFromList — (−) 제외 (확정은 OK replace-set — 목록 제외 = 서버 소거/반려 §11·§12)', () => {
  it('체크 행 제거, 0건 = MSG00709', () => {
    const a = authRow('u1');
    const st = { ...base(), inputList: [a, authRow('u2')] };
    const r = removeUsersFromList(st, [a], AUTH_TYPE.WRITE);
    expect(r.ok).toBe(true);
    expect(r.inputList.map(x => x.USER_ID)).toEqual(['u2']);
    expect(removeUsersFromList(st, [], AUTH_TYPE.WRITE).msgId).toBe(MSG.NO_CHECKED);
  });

  it('요청 승인으로 추가된 행 제거 = 해당 승인 결정도 원복 (key = USER_ID)', () => {
    const st0 = base();
    const approved = applyRequestDecision(st0, req('u1'), AUTH_TYPE.WRITE);
    expect(approved.decisions['u1']?.status).toBe(REQ_DECISION.APPROVE);
    const r = removeUsersFromList(approved, [approved.inputList[0]], AUTH_TYPE.WRITE);
    expect(r.ok).toBe(true);
    expect(r.inputList).toEqual([]);
    expect(r.decisions['u1']).toBeUndefined();
  });
});

describe('moveUsersBetweenLists — ∨∧ 입력↔조회 이동', () => {
  it('∨ 입력→조회: 원 리스트 제거 + 도착 리스트 추가 (소속 = 권한 유형), ∧ 역방향 동일', () => {
    const a = authRow('u1');
    const st = { ...base(), inputList: [a] };
    const down = moveUsersBetweenLists(st, [a], AUTH_TYPE.READ);
    expect(down.ok).toBe(true);
    expect(down.inputList).toEqual([]);
    expect(down.readList.map(x => x.USER_ID)).toEqual(['u1']);
    const b = down.readList[0];
    const up = moveUsersBetweenLists(down, [b], AUTH_TYPE.WRITE);
    expect(up.ok).toBe(true);
    expect(up.inputList.map(x => x.USER_ID)).toEqual(['u1']);
    expect(up.readList).toEqual([]);
  });

  it('도착 리스트 기존재 = MSG00716/717 + 이동 없음', () => {
    const a = authRow('u1');
    const st = { ...base(), inputList: [a], readList: [authRow('u1')] };
    const r = moveUsersBetweenLists(st, [a], AUTH_TYPE.READ);
    expect(r.msgId).toBe(MSG.AUTH_READ_DUP);
    expect(r.inputList).toHaveLength(1);
  });
});

describe('applyRequestDecision — 요청 처리 (설계 2.2/2.3/2.4 — 신본: 승인 = 목록 포함이 곧 확정 경로)', () => {
  it('[✓입력] 승인 = 입력 리스트 pending 추가 + APPROVE(WRITE) 결정 (2.2)', () => {
    const r = applyRequestDecision(base(), req('u1'), AUTH_TYPE.WRITE);
    expect(r.ok).toBe(true);
    expect(r.inputList.map(x => x.USER_ID)).toEqual(['u1']);
    expect(r.decisions['u1']).toEqual({ status: REQ_DECISION.APPROVE, authType: AUTH_TYPE.WRITE });
  });

  it('[✓조회] 승인 = 요청(입력)과 다른 권한으로 승인 가능 (2.4)', () => {
    const r = applyRequestDecision(base(), req('u1', { DPJT_AUTH_TYPE: AUTH_TYPE.WRITE }), AUTH_TYPE.READ);
    expect(r.ok).toBe(true);
    expect(r.readList.map(x => x.USER_ID)).toEqual(['u1']);
    expect(r.decisions['u1']).toEqual({ status: REQ_DECISION.APPROVE, authType: AUTH_TYPE.READ });
  });

  it('[x반려] = REJECT 결정 + 리스트 무변경 (2.3 — OK 시 §13 단건 호출 대상)', () => {
    const r = applyRequestDecision(base(), req('u1'), 'REJECT');
    expect(r.ok).toBe(true);
    expect(r.inputList).toEqual([]);
    expect(r.decisions['u1']).toEqual({ status: REQ_DECISION.REJECT });
  });

  it('결정 변경 = 이전 승인 추가분 원복 (입력 승인 → 반려 → 리스트에서 제거)', () => {
    const approved = applyRequestDecision(base(), req('u1'), AUTH_TYPE.WRITE);
    const rejected = applyRequestDecision(approved, req('u1'), 'REJECT');
    expect(rejected.inputList).toEqual([]);
    expect(rejected.decisions['u1']).toEqual({ status: REQ_DECISION.REJECT });
  });

  it('승인 대상 리스트에 사용자 기존재 = MSG00716/717 + 상태 불변', () => {
    const st = { ...base(), inputList: [authRow('u1')] };
    const r = applyRequestDecision(st, req('u1'), AUTH_TYPE.WRITE);
    expect(r.ok).toBe(false);
    expect(r.msgId).toBe(MSG.AUTH_INPUT_DUP);
    expect(r.decisions['u1']).toBeUndefined();
    expect(r.inputList).toHaveLength(1);
  });
});

describe('buildAuthUserIds / buildRejectUserIds — OK 페이로드 (replace-set §11·§12 / 반려 §13)', () => {
  it('리스트별 최종 USER_ID 목록 — 중복·빈 USER_ID 제거 (순서 보존)', () => {
    expect(buildAuthUserIds([authRow('u1'), authRow('u1'), authRow(''), authRow('u2')])).toEqual([
      'u1',
      'u2',
    ]);
    expect(buildAuthUserIds([])).toEqual([]);
  });

  it('반려 목록 = REJECT 결정만 (승인은 목록 포함이 곧 확정 — 미동봉)', () => {
    expect(
      buildRejectUserIds({
        u1: { status: REQ_DECISION.APPROVE, authType: AUTH_TYPE.READ },
        u2: { status: REQ_DECISION.REJECT },
        u3: { status: REQ_DECISION.REJECT },
      })
    ).toEqual(['u2', 'u3']);
    expect(buildRejectUserIds({})).toEqual([]);
  });
});
