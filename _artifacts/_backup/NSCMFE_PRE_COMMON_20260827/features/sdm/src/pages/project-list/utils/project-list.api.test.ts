import { beforeEach, describe, expect, it, vi } from 'vitest';

import { apiClient } from '@foundation/apis';

import { callReqProjectAuth, callReqProjectReg, type ReqPjtRegPayload } from './project-list.api';

// ⭐ SDM1020 call-proc 결과판정 계약 (project-reg.api 이식분 검증) — CODE **이름 기반** '0' +
//   EVENT 건수 / status>=400·code≠0 실패 / CODE 커서 미반환 = 실패 (허위성공 방지 계보).
vi.mock('@foundation/apis', () => ({
  apiClient: { post: vi.fn() },
}));

// vi.mock 으로 갈아끼운 순수 mock 함수라 `this` 바인딩 개념이 없다 — 규칙이 경고하는
//   "객체에서 떼어내 호출" 위험이 성립하지 않아 이 줄만 예외로 둔다.
// eslint-disable-next-line @typescript-eslint/unbound-method
const postMock = vi.mocked(apiClient).post;

const respond = (over: Partial<{ status: number; data: unknown }> = {}) =>
  postMock.mockResolvedValueOnce({
    status: 200,
    data: { code: '0', message: 'success', result: [{ CODE: '0', MSG: 'SUCCESS', EVENT: '2' }] },
    ...over,
  } as never);

const regPayload: ReqPjtRegPayload = {
  activeFlag: 'M',
  dpjtKey: 'PJT2600001_000001',
  dpjtCode: 'PJT2600001',
  dpjtSeq: '1',
  divisionId: '81',
  dpjtClass: 'CLASS_A',
  endCustomer: 'EC01',
  dpjtName: 'Test Project',
  cellType: 'ALS',
  stackMethod: 'STK',
  bizType: 'CELL',
  sopDate: '2026-10-01 00:00:00',
  sopPlantId: 'PLT1',
};

beforeEach(() => {
  postMock.mockReset();
});

describe('callReqProjectReg — BTN REQ 행별 단건 (계약 ①·②)', () => {
  it('URL = /SDM1020/Project List/REQ/call-proc + PROC_M COL_NM 13키 payload 그대로', async () => {
    respond();
    const r = await callReqProjectReg(regPayload);
    expect(postMock).toHaveBeenCalledWith('/SDM1020/Project List/REQ/call-proc', { ...regPayload });
    expect(r.ok).toBe(true);
    expect(r.code).toBe('0');
    expect(r.event).toBe(2);
  });

  it('CODE 이름 기반 판정 — CODE ≠ "0" = 실패 (위치기반 추출 금지 계보)', async () => {
    respond({ data: { code: '0', result: [{ CODE: '-1', MSG: 'ERR', EVENT: null }] } });
    const r = await callReqProjectReg(regPayload);
    expect(r.ok).toBe(false);
    expect(r.event).toBe(0);
  });

  it('EVENT NULL/비수치 = 0 (성공이어도 처리건수 0 — 성공 토스트 금지 축)', async () => {
    respond({ data: { code: '0', result: [{ CODE: '0', MSG: 'SUCCESS', EVENT: null }] } });
    const r = await callReqProjectReg(regPayload);
    expect(r.ok).toBe(true);
    expect(r.event).toBe(0);
  });

  it('HTTP status ≥ 400 = 실패 (responseErrorInterceptor resolve — false success 방지 gate §1-3)', async () => {
    respond({ status: 500, data: { message: 'ORA-20001: fail' } });
    const r = await callReqProjectReg(regPayload);
    expect(r.ok).toBe(false);
    expect(r.message).toBe('ORA-20001: fail');
  });

  it('BE code ≠ 0 = 실패', async () => {
    respond({ data: { code: '500', message: 'proc error', result: null } });
    const r = await callReqProjectReg(regPayload);
    expect(r.ok).toBe(false);
    expect(r.message).toBe('proc error');
  });

  it('CODE 커서 미반환 = 실패 취급 (O_RESULT_CURSOR 필수 계약)', async () => {
    respond({ data: { code: '0', result: [] } });
    const r = await callReqProjectReg(regPayload);
    expect(r.ok).toBe(false);
  });

  it('결과가 {커서명: rows[]} 객체 형태여도 추출 (extractRows 양쪽 대응)', async () => {
    respond({
      data: { code: '0', result: { o_result_cursor: [{ CODE: '0', MSG: 'SUCCESS', EVENT: '1' }] } },
    });
    const r = await callReqProjectReg(regPayload);
    expect(r.ok).toBe(true);
    expect(r.event).toBe(1);
  });
});

describe('callReqProjectAuth — AUTHREQ 단건 (계약 ①·②)', () => {
  it('URL = /SDM1020/Project List/AUTHREQ/call-proc + 3키(서버 3상태 문자열 그대로)', async () => {
    respond({ data: { code: '0', result: [{ CODE: '0', MSG: 'SUCCESS', EVENT: '1' }] } });
    const r = await callReqProjectAuth({
      dpjtKey: 'PJT2600001_000001',
      dpjtAuthReqWrite: 'CHECKED',
      dpjtAuthReqRead: 'UNCHECKED',
    });
    expect(postMock).toHaveBeenCalledWith('/SDM1020/Project List/AUTHREQ/call-proc', {
      dpjtKey: 'PJT2600001_000001',
      dpjtAuthReqWrite: 'CHECKED',
      dpjtAuthReqRead: 'UNCHECKED',
    });
    expect(r.ok).toBe(true);
    expect(r.event).toBe(1);
  });

  it('SP no-op 가드(동일 요청 반복 등 CASE 0) = ok + EVENT 0 — 호출부 성공 토스트 금지 축', async () => {
    respond({ data: { code: '0', result: [{ CODE: '0', MSG: 'SUCCESS', EVENT: '0' }] } });
    const r = await callReqProjectAuth({
      dpjtKey: 'PJT2600001_000001',
      dpjtAuthReqWrite: 'UNCHECKED',
      dpjtAuthReqRead: 'UNCHECKED',
    });
    expect(r.ok).toBe(true);
    expect(r.event).toBe(0);
  });
});
