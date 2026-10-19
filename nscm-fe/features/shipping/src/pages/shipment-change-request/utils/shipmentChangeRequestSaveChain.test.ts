import { beforeEach, describe, expect, it, vi } from 'vitest';

import { apiClient } from '@foundation/apis';

import { MENU_ID, SHEETS } from '../shipment-change-request.constants';

import { runSaveChain } from './shipmentChangeRequestSaveChain';

vi.mock('@foundation/apis', () => ({ apiClient: { post: vi.fn() } }));

// 메서드를 객체에서 떼어내지 않는다(unbound-method) — 항상 `api.post` 로 접근한다.
const api = vi.mocked(apiClient);

// SSP0201 저장 실행체인(수정 + 신규 혼재) 계약 테스트. API 는 URL 로 라우팅해 mock 한다.
//
// 지키는 것:
//  (1) 변경요청번호를 **저장 1회에 1번만** 받고 수정·신규가 **같은 번호**를 쓴다(AS-IS 동일).
//      종전엔 두 체인이 각각 채번해 한 번의 저장이 서로 다른 번호로 흩어졌다.
//  (2) 신규행이 있어도 **수정행이 빠지지 않는다**. 종전 handleSave 는 신규가 있으면 신규만 하고
//      return 해서 같이 수정한 기존행이 저장되지 않았다.
//  (3) 단계 실패 시 **그 자리에서 멈춘다** — 수정이 깨지면 SAVE_NEW 를 쏘지 않는다.
//  (4) 토스트 건수는 전체 행 수가 아니라 **수정 성공 + 신규 DRAFTING 성공** 이다.
//
// 주의: DRAFTING 은 수정·신규가 **같은 URL**(main/SAVE)이다. payload 의 `changeType` 으로 가른다
//   (수정='C' 고정 / 신규='N' 고정) — 실제 SP 계약이 그렇다.

const USER = 'U1';
const REQ_NO = 'R20261012000001';

const URL = {
  reqNo: `/${MENU_ID}/${SHEETS.MAIN}/REQ_NO/call-proc`,
  saveNew: `/${MENU_ID}/${SHEETS.MAIN}/SAVE_NEW/call-proc`,
  searchNew: `/${MENU_ID}/${SHEETS.MAIN}/SEARCH_NEW/call-proc`,
  drafting: `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
};

const SESSION = { userId: USER, userDeptId: '', language: 'KO' };

type Row = Record<string, unknown>;

/** 수정행 — CRUD_TYPE 'M', SO 없음이라 행마다 1묶음. */
const modifyRow = (over: Row = {}): Row => ({
  CRUD_TYPE: 'M',
  CHANGE_TYPE: 'C',
  DIVISION_ID: '40',
  CONFIRM_ID: 'C001',
  ERP_SO_NO: '',
  ITEM_ID: 'MOD1',
  SHIPMENT_DATE: '2026-07-20',
  SHIPMENT_CONFIRM_QTY: '50',
  EDIT_MAIN: 'Y',
  ...over,
});

/** 신규행 — CRUD_TYPE 'I'. ERP_SO_NO 가 없어 수정 묶음에 섞이지 않는다. */
const insertRow = (over: Row = {}): Row => ({
  CRUD_TYPE: 'I',
  DIVISION_ID: '40',
  ITEM_ID: 'NEW1',
  SHIPMENT_DATE: '2026-08-10',
  SHIPMENT_CONFIRM_QTY: '100',
  ...over,
});

/** SEARCH_NEW 가 돌려줄 행 — 위 신규행과 식별키가 맞아야 대상으로 잡힌다. */
const fetchedNewRow = (over: Row = {}): Row => ({
  ATTRIBUTE10: 'I',
  CHANGE_TYPE: 'N',
  ERP_SO_NO: '',
  CONFIRM_ID: 'R001',
  REQUESTOR: `홍길동(${USER})`,
  DIVISION_ID: '40',
  ITEM_ID: 'NEW1',
  SHIPMENT_DATE: '20260810',
  SHIPMENT_CONFIRM_QTY: '100',
  ...over,
});

const cursor = (rows: unknown[]) => ({ status: 200, data: { result: { o_rc1: rows } } });

interface ApiConfig {
  changeReqNo?: string;
  /** 수정 DRAFTING 의 RESULT_CODE. 'S' 가 아니면 실패. */
  modifyCode?: string;
  /** SAVE_NEW(CONFIRM_NEW) 의 RESULT_CODE. */
  confirmNewCode?: string;
  /** SEARCH_NEW 결과 행. */
  searchNewRows?: Row[];
  /** 신규 DRAFTING 의 RESULT_CODE. */
  newDraftingCode?: string;
}

let calls: { url: string; body: Row }[] = [];

const setupApi = (cfg: ApiConfig = {}) => {
  const {
    changeReqNo = REQ_NO,
    modifyCode = 'S',
    confirmNewCode = 'S',
    searchNewRows = [fetchedNewRow()],
    newDraftingCode = 'S',
  } = cfg;

  api.post.mockImplementation(((url: string, body: Row) => {
    calls.push({ url, body });
    if (url === URL.reqNo) {
      return Promise.resolve(cursor([{ RESULT_CODE: 'S', CHANGE_REQ_NO: changeReqNo }]));
    }
    if (url === URL.saveNew) return Promise.resolve(cursor([{ RESULT_CODE: confirmNewCode }]));
    if (url === URL.searchNew) return Promise.resolve(cursor(searchNewRows));
    if (url === URL.drafting) {
      // 수정='C' / 신규='N' — 같은 URL 이라 payload 로 가른다.
      const code = body.changeType === 'N' ? newDraftingCode : modifyCode;
      return Promise.resolve(cursor([{ RESULT_CODE: code }]));
    }
    throw new Error(`unexpected url: ${url}`);
  }) as never);
};

const urlsCalled = () => calls.map(c => c.url);
const countOf = (url: string) => calls.filter(c => c.url === url).length;
const draftingCalls = (kind: 'C' | 'N') =>
  calls.filter(c => c.url === URL.drafting && c.body.changeType === kind);

beforeEach(() => {
  calls = [];
  api.post.mockReset();
});

describe('runSaveChain — 수정 + 신규 혼재', () => {
  it('REQ_NO 는 1번만 호출하고 두 저장이 같은 changeReqNo 를 쓴다', async () => {
    setupApi();
    const chain = await runSaveChain([modifyRow(), insertRow()], SESSION);

    expect(chain.ok).toBe(true);
    expect(countOf(URL.reqNo)).toBe(1);
    expect(chain.changeReqNo).toBe(REQ_NO);
    // 수정 DRAFTING 과 신규 DRAFTING 이 동일 번호를 싣는다.
    expect(draftingCalls('C')[0].body.changeReqNo).toBe(REQ_NO);
    expect(draftingCalls('N')[0].body.changeReqNo).toBe(REQ_NO);
  });

  it('토스트 건수는 수정 성공 + 신규 DRAFTING 성공 이다(전체 행 수가 아니다)', async () => {
    setupApi();
    const chain = await runSaveChain([modifyRow(), insertRow()], SESSION);
    expect(chain.modifiedCount).toBe(1);
    expect(chain.createdCount).toBe(1);
    expect(chain.savedCount).toBe(2);
  });

  it('신규행이 있어도 수정행이 빠지지 않는다(종전 결함)', async () => {
    setupApi();
    await runSaveChain([modifyRow(), insertRow()], SESSION);
    // 종전 handleSave 는 신규만 하고 return 해서 이 호출이 아예 없었다.
    expect(draftingCalls('C')).toHaveLength(1);
    expect(draftingCalls('N')).toHaveLength(1);
  });

  it('순서는 REQ_NO -> 수정 DRAFTING -> SAVE_NEW -> SEARCH_NEW -> 신규 DRAFTING 이다', async () => {
    setupApi();
    await runSaveChain([modifyRow(), insertRow()], SESSION);
    expect(urlsCalled()).toEqual([
      URL.reqNo,
      URL.drafting, // 수정
      URL.saveNew,
      URL.searchNew,
      URL.drafting, // 신규
    ]);
  });

  it('신규행은 수정 묶음에 섞이지 않는다 — 한 행이 두 번 전송되지 않는다', async () => {
    setupApi();
    await runSaveChain([modifyRow(), insertRow()], SESSION);
    // 수정 DRAFTING 은 1건이고 그 confirmId 는 수정행 것이다(신규행이 묶음에 안 들어갔다).
    expect(draftingCalls('C')).toHaveLength(1);
    expect(draftingCalls('C')[0].body.confirmId).toBe('C001');
    // SAVE_NEW 는 신규행만 싣는다(1토큰).
    expect(String(calls.find(c => c.url === URL.saveNew)?.body.itemId)).toBe('NEW1');
  });

  it('수정 2 + 신규 2 면 건수가 4다', async () => {
    setupApi({
      searchNewRows: [
        fetchedNewRow({ ITEM_ID: 'NEW1', CONFIRM_ID: 'R001' }),
        fetchedNewRow({ ITEM_ID: 'NEW2', CONFIRM_ID: 'R002' }),
      ],
    });
    const chain = await runSaveChain(
      [
        modifyRow({ CONFIRM_ID: 'C001' }),
        modifyRow({ CONFIRM_ID: 'C002' }),
        insertRow({ ITEM_ID: 'NEW1' }),
        insertRow({ ITEM_ID: 'NEW2' }),
      ],
      SESSION
    );
    expect(chain.ok).toBe(true);
    expect(chain.modifiedCount).toBe(2);
    expect(chain.createdCount).toBe(2);
    expect(chain.savedCount).toBe(4);
  });
});

describe('runSaveChain — 수정 실패 시 멈춘다', () => {
  it('수정이 실패하면 SAVE_NEW 를 호출하지 않는다', async () => {
    setupApi({ modifyCode: 'X' });
    const chain = await runSaveChain([modifyRow(), insertRow()], SESSION);

    expect(chain.ok).toBe(false);
    expect(chain.failedStage).toBe('modify');
    expect(chain.failedCode).toBe('X');
    expect(countOf(URL.saveNew)).toBe(0);
    expect(countOf(URL.searchNew)).toBe(0);
    expect(draftingCalls('N')).toHaveLength(0);
  });

  it('수정 실패도 nothingToSend 가 아니다 — 호출부가 재조회해야 한다', async () => {
    // 재조회는 화면(runSave)이 하고, 그 분기 축이 이 플래그다.
    setupApi({ modifyCode: 'X' });
    const chain = await runSaveChain([modifyRow(), insertRow()], SESSION);
    expect(chain.nothingToSend).toBe(false);
  });

  it('수정 2건 중 첫 건이 실패하면 둘째 묶음도 보내지 않는다', async () => {
    setupApi({ modifyCode: 'F' });
    const chain = await runSaveChain(
      [modifyRow({ CONFIRM_ID: 'C001' }), modifyRow({ CONFIRM_ID: 'C002' })],
      SESSION
    );
    expect(chain.ok).toBe(false);
    expect(draftingCalls('C')).toHaveLength(1);
    expect(chain.modifiedCount).toBe(0);
  });
});

describe('runSaveChain — 채번 실패', () => {
  it('REQ_NO 가 빈 값이면 저장 호출이 0번이다', async () => {
    setupApi({ changeReqNo: '' });
    const chain = await runSaveChain([modifyRow(), insertRow()], SESSION);

    expect(chain.ok).toBe(false);
    expect(chain.failedStage).toBe('reqNo');
    expect(countOf(URL.drafting)).toBe(0);
    expect(countOf(URL.saveNew)).toBe(0);
    expect(countOf(URL.searchNew)).toBe(0);
    // 채번 호출 자체만 나갔다.
    expect(urlsCalled()).toEqual([URL.reqNo]);
  });

  it('채번 HTTP 실패도 저장을 시작하지 않는다', async () => {
    api.post.mockImplementation(((url: string, body: Row) => {
      calls.push({ url, body });
      return Promise.resolve({ status: 500, data: {} });
    }) as never);
    const chain = await runSaveChain([modifyRow()], SESSION);
    expect(chain.failedStage).toBe('reqNo');
    expect(urlsCalled()).toEqual([URL.reqNo]);
  });
});

describe('runSaveChain — 수정만 / 신규만 (같은 함수가 처리한다)', () => {
  it('수정만 있으면 수정 DRAFTING 만 돈다', async () => {
    setupApi();
    const chain = await runSaveChain([modifyRow()], SESSION);

    expect(chain.ok).toBe(true);
    expect(chain.modifiedCount).toBe(1);
    expect(chain.createdCount).toBe(0);
    expect(chain.savedCount).toBe(1);
    expect(urlsCalled()).toEqual([URL.reqNo, URL.drafting]);
    expect(countOf(URL.saveNew)).toBe(0);
  });

  it('신규만 있으면 신규 체인만 돈다', async () => {
    setupApi();
    const chain = await runSaveChain([insertRow()], SESSION);

    expect(chain.ok).toBe(true);
    expect(chain.modifiedCount).toBe(0);
    expect(chain.createdCount).toBe(1);
    expect(chain.savedCount).toBe(1);
    expect(urlsCalled()).toEqual([URL.reqNo, URL.saveNew, URL.searchNew, URL.drafting]);
    expect(draftingCalls('C')).toHaveLength(0);
  });

  it('신규만 있을 때도 채번 번호를 신규 DRAFTING 에 싣는다', async () => {
    setupApi();
    await runSaveChain([insertRow()], SESSION);
    expect(draftingCalls('N')[0].body.changeReqNo).toBe(REQ_NO);
  });
});

describe('runSaveChain — 신규 단계 실패', () => {
  it('CONFIRM_NEW 가 N(Model 미조회)이면 SEARCH_NEW 를 호출하지 않는다', async () => {
    setupApi({ confirmNewCode: 'N' });
    const chain = await runSaveChain([insertRow()], SESSION);
    expect(chain.failedStage).toBe('new');
    expect(chain.failedCode).toBe('N');
    expect(countOf(URL.searchNew)).toBe(0);
  });

  it('SEARCH_NEW 가 0건이면 DRAFTING 을 시작하지 않는다', async () => {
    setupApi({ searchNewRows: [] });
    const chain = await runSaveChain([insertRow()], SESSION);
    expect(chain.failedStage).toBe('new');
    expect(draftingCalls('N')).toHaveLength(0);
  });

  it('신규가 실패해도 앞서 성공한 수정 건수는 유지해 보고한다', async () => {
    setupApi({ confirmNewCode: 'F' });
    const chain = await runSaveChain([modifyRow(), insertRow()], SESSION);
    expect(chain.ok).toBe(false);
    expect(chain.failedStage).toBe('new');
    expect(chain.modifiedCount).toBe(1); // 이미 저장됐다 — 재조회로 화면에 반영돼야 한다
    expect(draftingCalls('C')).toHaveLength(1);
  });
});

describe('runSaveChain — 보낼 것이 없을 때', () => {
  it('CHANGE_TYPE P 행만 변경했으면 nothingToSend 이고 호출이 0번이다', async () => {
    setupApi();
    const chain = await runSaveChain([modifyRow({ CHANGE_TYPE: 'P' })], SESSION);

    expect(chain.nothingToSend).toBe(true);
    expect(chain.ok).toBe(false);
    expect(calls).toHaveLength(0); // 채번조차 하지 않는다
  });

  it('CRUD_TYPE 없이 EDIT_MAIN 만 Y 인 행도 보낼 것이 없다', async () => {
    setupApi();
    const chain = await runSaveChain([modifyRow({ CRUD_TYPE: '' })], SESSION);
    expect(chain.nothingToSend).toBe(true);
    expect(calls).toHaveLength(0);
  });
});
