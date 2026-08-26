import { beforeEach, describe, expect, it, vi } from 'vitest';

import { apiClient } from '@foundation/apis';

import {
  callCancelTab1,
  callConfirmTab1,
  callSaveTab2,
  type ConfirmTab1Payload,
} from './project-master.api';

// ⭐ SDM5010 call-proc 결과판정 계약 (project-list.api 이식분 검증) — CODE **이름 기반** '0' +
//   EVENT 건수 / status>=400·code≠0 실패 / CODE 커서 미반환 = 실패 (D12 허위성공 방어 계보).
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
    data: { code: '0', message: 'success', result: [{ CODE: '0', MSG: 'SUCCESS', EVENT: '1' }] },
    ...over,
  } as never);

const confirmPayload: ConfirmTab1Payload = {
  dpjtKey: 'PJT001_000002',
  dpjtCode: 'MC2501',
  dpjtSeq: '2',
  dpjtKeyParent: 'PJT001_000001',
  divisionId: '81',
  dpjtClass: 'CLASS_A',
  endCustomer: 'EC01',
  dpjtName: 'Test Project',
  cellType: 'ALS',
  stackMethod: 'STK',
  bizType: 'CELL',
  sopDate: '2026-10-01 00:00:00',
  sopPlantId: 'PLT1',
  note: 'memo',
};

beforeEach(() => {
  postMock.mockReset();
});

describe('callConfirmTab1 — BTN CONFIRM 행별 단건 (계약 ①·②)', () => {
  it('URL = /SDM5010/TAB1/CONFIRM/call-proc + PROC_M COL_NM 14키 payload 그대로', async () => {
    respond();
    const r = await callConfirmTab1(confirmPayload);
    expect(postMock).toHaveBeenCalledWith('/SDM5010/TAB1/CONFIRM/call-proc', { ...confirmPayload });
    expect(r.ok).toBe(true);
    expect(r.event).toBe(1);
  });

  it('CODE 이름 기반 판정 — CODE ≠ "0" = 실패 (D10/D12 정정분 "-1" 커서 — 위치기반 추출 금지)', async () => {
    respond({ data: { code: '0', result: [{ CODE: '-1', MSG: 'ERR', EVENT: null }] } });
    const r = await callConfirmTab1(confirmPayload);
    expect(r.ok).toBe(false);
    expect(r.event).toBe(0);
  });

  it('EVENT NULL/비수치 = 0 (성공이어도 처리건수 0 — 성공 토스트 금지 축)', async () => {
    respond({ data: { code: '0', result: [{ CODE: '0', MSG: 'SUCCESS', EVENT: null }] } });
    const r = await callConfirmTab1(confirmPayload);
    expect(r.ok).toBe(true);
    expect(r.event).toBe(0);
  });

  it('HTTP status ≥ 400 = 실패 (responseErrorInterceptor resolve — false success 방지 gate §1-3)', async () => {
    respond({ status: 500, data: { message: 'ORA-20001: fail' } });
    const r = await callConfirmTab1(confirmPayload);
    expect(r.ok).toBe(false);
    expect(r.message).toBe('ORA-20001: fail');
  });

  it('BE code ≠ 0 = 실패', async () => {
    respond({ data: { code: '500', message: 'proc error', result: null } });
    const r = await callConfirmTab1(confirmPayload);
    expect(r.ok).toBe(false);
    expect(r.message).toBe('proc error');
  });

  it('CODE 커서 미반환 = 실패 취급 (O_RESULT_CURSOR 필수 계약)', async () => {
    respond({ data: { code: '0', result: [] } });
    const r = await callConfirmTab1(confirmPayload);
    expect(r.ok).toBe(false);
  });

  it('결과가 {커서명: rows[]} 객체 형태여도 추출 (extractRows 양쪽 대응)', async () => {
    respond({
      data: { code: '0', result: { o_result_cursor: [{ CODE: '0', MSG: 'SUCCESS', EVENT: '1' }] } },
    });
    const r = await callConfirmTab1(confirmPayload);
    expect(r.ok).toBe(true);
    expect(r.event).toBe(1);
  });
});

describe('callCancelTab1 — BTN CANCEL 행별 단건 (계약 ①·②)', () => {
  it('URL = /SDM5010/TAB1/CANCEL/call-proc + 4키(divisionId/dpjtKey/dpjtKeyParent/note)', async () => {
    respond();
    const r = await callCancelTab1({
      divisionId: '81',
      dpjtKey: 'PJT001_000002',
      dpjtKeyParent: 'PJT001_000001',
      note: 'reject memo',
    });
    expect(postMock).toHaveBeenCalledWith('/SDM5010/TAB1/CANCEL/call-proc', {
      divisionId: '81',
      dpjtKey: 'PJT001_000002',
      dpjtKeyParent: 'PJT001_000001',
      note: 'reject memo',
    });
    expect(r.ok).toBe(true);
  });
});

describe('callSaveTab2 — SAVE 행별 단건 (계약 ①·② — D1 신규 SP)', () => {
  it('URL = /SDM5010/TAB2/SAVE/call-proc + 4키 (activeFlag \'M\'/disabled 서버 문자열 계약 ⑥)', async () => {
    respond();
    const r = await callSaveTab2({
      activeFlag: 'M',
      dpjtKey: 'PJT001_000001',
      dpjtDevelopStatus: 'PROD',
      disabled: 'UNCHECKED',
    });
    expect(postMock).toHaveBeenCalledWith('/SDM5010/TAB2/SAVE/call-proc', {
      activeFlag: 'M',
      dpjtKey: 'PJT001_000001',
      dpjtDevelopStatus: 'PROD',
      disabled: 'UNCHECKED',
    });
    expect(r.ok).toBe(true);
  });

  it('계약 외 FLAG 가드 (SP CODE \'1\' — \'M\' 단건만 유효) = 실패 판정', async () => {
    respond({ data: { code: '0', result: [{ CODE: '1', MSG: 'INVALID FLAG', EVENT: '0' }] } });
    const r = await callSaveTab2({
      activeFlag: 'M',
      dpjtKey: 'PJT001_000001',
      dpjtDevelopStatus: 'PROD',
      disabled: 'CHECKED',
    });
    expect(r.ok).toBe(false);
    expect(r.event).toBe(0);
  });
});
