import { beforeEach, describe, expect, it, vi } from 'vitest';

import { apiClient } from '@foundation/apis';

import { callConfirmTab1, type ConfirmTab1Payload } from './project-master.api';

vi.mock('@foundation/apis', () => ({
  apiClient: { post: vi.fn() },
}));

// eslint-disable-next-line @typescript-eslint/unbound-method
const postMock = vi.mocked(apiClient.post);

const payload: ConfirmTab1Payload = {
  dpjtKey: 'PJT2600001_000001',
  dpjtCode: '000001',
  dpjtSeq: '1',
  dpjtKeyParent: '',
  divisionId: '81',
  dpjtClass: 'CLASS_A',
  endCustomer: 'EC01',
  dpjtName: 'Test Project',
  cellType: 'ALS',
  stackMethod: 'STK',
  bizType: 'CELL',
  sopDate: '2026-10-01 00:00:00',
  sopPlantId: 'PLT1',
  note: '',
};

beforeEach(() => {
  postMock.mockReset();
});

describe('callConfirmTab1', () => {
  it('preserves an EVENT message code for localized validation errors', async () => {
    postMock.mockResolvedValueOnce({
      status: 200,
      data: {
        code: '0',
        message: 'success',
        result: {
          result: [{ MSG: 'ERR_RTN: - Validation Check', CODE: '-1', EVENT: 'MSG00060' }],
          DATARESULT: [],
        },
      },
    } as never);

    const result = await callConfirmTab1(payload);

    expect(result).toMatchObject({
      ok: false,
      code: '-1',
      message: 'ERR_RTN: - Validation Check',
      event: 0,
      messageId: 'MSG00060',
    });
  });

  it('extracts the message code when EVENT also contains validation details', async () => {
    postMock.mockResolvedValueOnce({
      status: 200,
      data: {
        code: '0',
        message: 'success',
        result: {
          result: [
            {
              MSG: 'ERR_RTN: - Validation Check',
              CODE: '-1',
              EVENT: 'MSG00060^PJT_CODE',
            },
          ],
          DATARESULT: [],
        },
      },
    } as never);

    const result = await callConfirmTab1(payload);

    expect(result.messageId).toBe('MSG00060');
  });
});
