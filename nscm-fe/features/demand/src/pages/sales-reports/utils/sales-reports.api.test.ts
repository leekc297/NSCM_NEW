import { beforeEach, describe, expect, it, vi } from 'vitest';

const { postMock } = vi.hoisted(() => ({ postMock: vi.fn() }));

vi.mock('@foundation/apis', () => ({
  apiClient: { post: postMock },
}));

import { MENU_ID, SHEETS } from '../sales-reports.constants';

import { callProc, callSaveCutoff, callSaveEtc, saveTitleSet } from './sales-reports.api';

describe('callProc', () => {
  beforeEach(() => {
    postMock.mockReset();
  });

  it('status>=400 이면 실패 + message 전달', async () => {
    postMock.mockResolvedValue({ status: 500, data: { message: 'server error' } });
    const result = await callProc(SHEETS.MAIN, 'SAVE', {});
    expect(result).toStrictEqual({ ok: false, message: 'server error' });
  });

  it('첫 커서 첫 값이 \'success\' 이면 성공', async () => {
    postMock.mockResolvedValue({ status: 200, data: { result: [{ MSG: 'success' }] } });
    const result = await callProc(SHEETS.MAIN, 'SAVE', {});
    expect(result).toStrictEqual({ ok: true });
  });

  it('첫 값이 숫자 문자열이면 성공 (에러 문구 아님)', async () => {
    postMock.mockResolvedValue({ status: 200, data: { result: [{ CODE: '0' }] } });
    const result = await callProc(SHEETS.MAIN, 'SAVE', {});
    expect(result).toStrictEqual({ ok: true });
  });

  it('첫 값이 비-숫자 오류 문자열이면 실패로 passthrough', async () => {
    postMock.mockResolvedValue({
      status: 200,
      data: { result: [{ MSG: '중복된 데이터입니다.' }] },
    });
    const result = await callProc(SHEETS.MAIN, 'SAVE', {});
    expect(result).toStrictEqual({ ok: false, message: '중복된 데이터입니다.' });
  });

  it('결과가 비어있으면 성공으로 처리', async () => {
    postMock.mockResolvedValue({ status: 200, data: { result: [] } });
    const result = await callProc(SHEETS.MAIN, 'SAVE', {});
    expect(result).toStrictEqual({ ok: true });
  });
});

// TC-DMF0044-F 저장 이원화 라우팅 — ETC='SAVE' / Cutoff='SAVE_CF'.
describe('callSaveEtc / callSaveCutoff routing', () => {
  beforeEach(() => {
    postMock.mockReset();
    postMock.mockResolvedValue({ status: 200, data: { result: [] } });
  });

  it('callSaveEtc 는 SAVE 버튼코드로 호출', async () => {
    await callSaveEtc({ a: '1' });
    expect(postMock).toHaveBeenCalledWith(`/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`, { a: '1' });
  });

  it('callSaveCutoff 는 SAVE_CF 버튼코드로 호출', async () => {
    await callSaveCutoff({ a: '1' });
    expect(postMock).toHaveBeenCalledWith(`/${MENU_ID}/${SHEETS.MAIN}/SAVE_CF/call-proc`, {
      a: '1',
    });
  });
});

describe('saveTitleSet', () => {
  beforeEach(() => {
    postMock.mockReset();
  });

  it('saveRows 가 비어있으면 호출 없이 false', async () => {
    const result = await saveTitleSet('C', []);
    expect(result).toBe(false);
    expect(postMock).not.toHaveBeenCalled();
  });

  it('\'^\' 구분 payload 로 컬럼 순서를 유지해 전달한다', async () => {
    postMock.mockResolvedValue({ status: 200, data: { result: [] } });
    await saveTitleSet('C', [{ name: 'COL_A' }, { name: 'COL_B', sortOrderNo: 5 }]);
    expect(postMock).toHaveBeenCalledWith(
      `/${MENU_ID}/${SHEETS.TITLE_SET}/SAVE/call-proc`,
      expect.objectContaining({
        columnName: 'COL_A^COL_B',
        sortOrderNo: '1^5',
        activeFlag: 'Y^Y',
      })
    );
  });

  it('성공 응답(CODE=0 또는 결과 없음)이면 true', async () => {
    postMock.mockResolvedValue({ status: 200, data: { result: [{ CODE: '0' }] } });
    expect(await saveTitleSet('C', [{ name: 'COL_A' }])).toBe(true);
  });

  it('실패 응답(CODE≠0)이면 false', async () => {
    postMock.mockResolvedValue({ status: 200, data: { result: [{ CODE: '1' }] } });
    expect(await saveTitleSet('C', [{ name: 'COL_A' }])).toBe(false);
  });

  it('예외 발생 시 false', async () => {
    postMock.mockRejectedValue(new Error('network error'));
    expect(await saveTitleSet('C', [{ name: 'COL_A' }])).toBe(false);
  });
});
