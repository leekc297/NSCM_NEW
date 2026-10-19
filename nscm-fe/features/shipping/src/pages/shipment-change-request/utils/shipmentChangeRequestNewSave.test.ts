import { beforeEach, describe, expect, it, vi } from 'vitest';

import { apiClient } from '@foundation/apis';

import { MENU_ID, SHEETS } from '../shipment-change-request.constants';

import {
  buildNewRowSearchFilterFromRows,
  buildNewRowSearchPayload,
  fetchNewRowsForDrafting,
  isDraftingTargetsComplete,
  newRowSearchRange,
  pickNewDraftingTargets,
  pickOwnNewDraftingTargets,
} from './shipmentChangeRequestNewSave';

vi.mock('@foundation/apis', () => ({ apiClient: { post: vi.fn() } }));

// 메서드를 객체에서 떼어내지 않는다(unbound-method) — 항상 `api.post` 로 접근한다.
const api = vi.mocked(apiClient);

// SSP0201 신규행 저장 뒤 **재조회** 계약 테스트.
//
// 지키는 것 세 가지.
//
//  (1) 전용 SP(_N)를 쓴다. 메인 조회 SP 는 `CHANGE_TYPE <> 'N'` 이라 방금 만든 신규행이 없다 —
//      종전 refetchMain() 구현은 대상이 항상 0건이었고, 0건이면 실패도 0건이라 "전건 성공" 으로
//      읽혀 아무것도 만들지 않았는데 성공 토스트가 떴다.
//
//  (2) 조회 범위를 **화면 조회조건이 아니라 저장한 신규행**에서 만든다. _N 본문 실측상 살아 있는
//      조건은 사업부(823~825)와 기간(821~822)뿐이다. 화면 기간 밖에 출하일을 넣으면 0건이 되고,
//      SAVE_NEW 는 이미 성공했으므로 실패 alert 뒤 재시도 시 **중복 생성**된다.
//
//  (3) DRAFTING 대상을 **이번 저장분으로 한정**한다. _N WHERE 에 ATTRIBUTE10 조건이 없고
//      (선별은 FE 몫), 그 플래그는 그 행의 DRAFTING 이 돌 때까지 남는다(BODY 1930~1932).
//      그래서 타 사용자·이전 저장의 잔여 'I' 행이 함께 잡혀 내 changeReqNo 로 기록될 수 있었다.
//
// 본문 키·LIVE/DEAD 축은 DB 실측(ALL_ARGUMENTS + PKG_SSP0201 BODY)과 대조한 것이다.

const USER = 'U1';

/** 화면에서 넣은 신규행(저장 대상). 식별 키 = DIVISION_ID|ITEM_ID|출하일8|수량. */
const insertedRow = (over: Record<string, unknown> = {}): Record<string, unknown> => ({
  CRUD_TYPE: 'I',
  DIVISION_ID: '40',
  ITEM_ID: 'ITEM1',
  SHIPMENT_DATE: '2026-07-15',
  SHIPMENT_CONFIRM_QTY: '100',
  ...over,
});

/**
 * SEARCH_NEW 가 돌려주는 신규행(ATTRIBUTE10='I' 가 재식별 플래그).
 *   `REQUESTOR` 는 **원시 id 가 아니다** — SP BODY 760~761 이 `<사용자명>(<id>)` 로 조립한다.
 *   원시 id 로 테스트하면 실제와 다른 값으로 통과해 버리므로 실제 형태를 쓴다.
 */
const newRow = (over: Record<string, unknown> = {}): Record<string, unknown> => ({
  ATTRIBUTE10: 'I',
  CHANGE_TYPE: 'N',
  ERP_SO_NO: '',
  CONFIRM_ID: 'R001',
  REQUESTOR: `홍길동(${USER})`,
  DIVISION_ID: '40',
  ITEM_ID: 'ITEM1',
  SHIPMENT_DATE: '20260715',
  SHIPMENT_CONFIRM_QTY: '100',
  ...over,
});

const okResponse = (rows: unknown[]) => ({ status: 200, data: { result: { o_rc1: rows } } });

beforeEach(() => {
  api.post.mockReset();
});

describe('buildNewRowSearchPayload — SEARCH_NEW 본문 계약', () => {
  it('confirmId 를 보내지 않는다 — 전용 SP 에 P_CONFIRM_ID 가 없다', () => {
    const payload = buildNewRowSearchPayload(buildNewRowSearchFilterFromRows([insertedRow()], 'KO'));
    expect(payload).not.toHaveProperty('confirmId');
  });

  it('DB 실측 11키를 모두 보낸다(그 외 키는 없다)', () => {
    const payload = buildNewRowSearchPayload(buildNewRowSearchFilterFromRows([insertedRow()], 'KO'));
    expect(Object.keys(payload).sort()).toEqual(
      [
        'changeType',
        'debugMode',
        'divisionId',
        'erpSoNo',
        'fromSite',
        'fromYyyymmdd',
        'itemId',
        'language',
        'status',
        'toSite',
        'toYyyymmdd',
      ].sort()
    );
    expect(Object.keys(payload)).toHaveLength(11);
  });

  it('debugMode 는 F 고정이다(이 feature 공통 규약)', () => {
    expect(buildNewRowSearchPayload({}).debugMode).toBe('F');
  });

  it('빈 필터여도 11키를 빈 문자열로 채운다 — 키 누락 금지', () => {
    const payload = buildNewRowSearchPayload({});
    expect(Object.keys(payload)).toHaveLength(11);
    for (const [key, value] of Object.entries(payload)) {
      if (key === 'debugMode') continue;
      expect(value, key).toBe('');
    }
  });
});

describe('newRowSearchRange — 저장한 행의 출하일 범위', () => {
  it('단일 행이면 그 날짜가 from=to 다', () => {
    expect(newRowSearchRange([insertedRow()])).toEqual({ from: '20260715', to: '20260715' });
  });

  it('여러 행이면 min~max 로 전 행을 덮는다', () => {
    const range = newRowSearchRange([
      insertedRow({ SHIPMENT_DATE: '2026-09-30' }),
      insertedRow({ SHIPMENT_DATE: '2026-07-15' }),
      insertedRow({ SHIPMENT_DATE: '2026-08-20' }),
    ]);
    expect(range).toEqual({ from: '20260715', to: '20260930' });
  });

  it('YYYYMMDD 와 YYYY-MM-DD 가 섞여도 같은 축으로 정규화한다', () => {
    const range = newRowSearchRange([
      insertedRow({ SHIPMENT_DATE: '20260715' }),
      insertedRow({ SHIPMENT_DATE: '2026-07-01' }),
    ]);
    expect(range).toEqual({ from: '20260701', to: '20260715' });
  });
});

describe('buildNewRowSearchFilterFromRows — 화면 조회조건을 쓰지 않는다', () => {
  it('화면 기간 밖의 출하일이어도 그 행을 덮는 기간으로 조회한다(중복생성 원인 차단)', () => {
    // 화면 조회기간이 2026-07-01~2026-08-31 이어도, 행 출하일이 11/20 이면 그 날짜로 조회해야 한다.
    const filter = buildNewRowSearchFilterFromRows(
      [insertedRow({ SHIPMENT_DATE: '2026-11-20' })],
      'KO'
    );
    expect(filter.fromYyyymmdd).toBe('20261120');
    expect(filter.toYyyymmdd).toBe('20261120');
  });

  it('사업부는 행에서 수집해 콤마로 잇는다(SP 가 STRING_SPLIT 한다)', () => {
    const filter = buildNewRowSearchFilterFromRows(
      [insertedRow({ DIVISION_ID: '40' }), insertedRow({ DIVISION_ID: 'EE' })],
      'KO'
    );
    expect(filter.divisionId).toBe('40,EE');
  });

  it('같은 사업부는 중복 제거한다', () => {
    const filter = buildNewRowSearchFilterFromRows([insertedRow(), insertedRow()], 'KO');
    expect(filter.divisionId).toBe('40');
  });

  it('language 는 세션값을 싣는다(라벨 조인에 쓰이는 LIVE 축이다)', () => {
    expect(buildNewRowSearchFilterFromRows([insertedRow()], 'EN').language).toBe('EN');
  });

  it('SP 가 무시하는 6키는 빈 값이다 — 화면값을 실어 좁혀진다고 오해하게 하지 않는다', () => {
    const filter = buildNewRowSearchFilterFromRows([insertedRow()], 'KO');
    expect(filter.fromSite).toBe('');
    expect(filter.toSite).toBe('');
    expect(filter.erpSoNo).toBe('');
    expect(filter.itemId).toBe('');
    expect(filter.status).toBe('');
    expect(filter.changeType).toBe('');
  });
});

describe('fetchNewRowsForDrafting — 전용 SP 호출', () => {
  it('SEARCH_NEW 엔드포인트로 평탄 객체를 POST 한다', async () => {
    api.post.mockResolvedValue(okResponse([newRow()]) as never);
    await fetchNewRowsForDrafting(buildNewRowSearchFilterFromRows([insertedRow()], 'KO'));
    expect(api.post.mock.calls).toHaveLength(1);
    const [url, body] = api.post.mock.calls[0];
    expect(url).toBe(`/${MENU_ID}/${SHEETS.MAIN}/SEARCH_NEW/call-proc`);
    // 메인 조회(SEARCH)가 아니라 전용 SP 다 — 이 구분이 이번 수정의 핵심이다.
    expect(url).not.toContain('/SEARCH/call-proc');
    expect(body).not.toHaveProperty('confirmId');
    expect(body).not.toHaveProperty('data');
  });

  it('result.o_rc1 을 행으로 돌려준다', async () => {
    api.post.mockResolvedValue(okResponse([newRow({ CONFIRM_ID: 'R1' }), newRow()]) as never);
    const { rows } = await fetchNewRowsForDrafting({});
    expect(rows).toHaveLength(2);
    expect(rows[0].CONFIRM_ID).toBe('R1');
  });

  it('403/500 은 fail 이고 행을 믿지 않는다 — 인터셉터가 resolve 하므로 여기서 걸러야 한다', async () => {
    for (const status of [403, 500]) {
      api.post.mockResolvedValue({ status, data: { result: { o_rc1: [newRow()] } } } as never);
      const { rows, outcome } = await fetchNewRowsForDrafting({});
      expect(outcome, `status ${status}`).toBe('fail');
      expect(rows, `status ${status}`).toEqual([]);
    }
  });

  it('통신 예외는 터지지 않고 fail/unknown 으로 접힌다', async () => {
    api.post.mockRejectedValue(new Error('Network Error'));
    const { rows, outcome } = await fetchNewRowsForDrafting({});
    expect(rows).toEqual([]);
    expect(outcome).not.toBe('ok');
  });
});

describe('pickOwnNewDraftingTargets — 이번 저장분으로 한정', () => {
  it('내가 넣은 행만 가져간다', () => {
    const inserted = [insertedRow()];
    expect(pickOwnNewDraftingTargets([newRow()], inserted, USER)).toHaveLength(1);
  });

  it('다른 사용자의 잔여 I 행은 제외한다(REQUESTOR 축)', () => {
    const targets = pickOwnNewDraftingTargets(
      [newRow(), newRow({ REQUESTOR: '임꺽정(U2)', CONFIRM_ID: 'R999' })],
      [insertedRow()],
      USER
    );
    expect(targets).toHaveLength(1);
    expect(targets[0].CONFIRM_ID).toBe('R001');
  });

  it('REQUESTOR 가 이름(아이디) 표시문자열이어도 내 행을 알아본다 — 원시 id 비교가 아니다', () => {
    // SP BODY 760~761 실측 형태. `=== userId` 로 비교하면 여기서 전건 탈락한다.
    for (const requestor of [`홍길동(${USER})`, `Hong Gildong(${USER})`]) {
      const targets = pickOwnNewDraftingTargets([newRow({ REQUESTOR: requestor })], [insertedRow()], USER);
      expect(targets, requestor).toHaveLength(1);
    }
  });

  it('REQUESTOR 가 NULL/빈 값(사용자 마스터 조인 미스)이면 키 대조만으로 통과시킨다', () => {
    // NVL2 양쪽이 NULL 이면 컬럼 전체가 NULL 로 온다 — 그 계정의 저장을 막아선 안 된다.
    for (const requestor of ['', null, undefined]) {
      const targets = pickOwnNewDraftingTargets([newRow({ REQUESTOR: requestor })], [insertedRow()], USER);
      expect(targets, String(requestor)).toHaveLength(1);
    }
  });

  it('아이디가 다른 사용자의 부분문자열이어도 오인하지 않는다', () => {
    // 'U1' 과 'U10' — 괄호까지 포함해 비교하므로 'U10' 행이 'U1' 로 잡히지 않는다.
    const targets = pickOwnNewDraftingTargets([newRow({ REQUESTOR: '다른이(U10)' })], [insertedRow()], USER);
    expect(targets).toHaveLength(0);
  });

  it('이전 저장의 잔여 I 행(키 불일치)은 제외한다', () => {
    // DRAFTING 전에 끊긴 이전 저장분 — 같은 사업부·기간에 ATTRIBUTE10='I' 로 남아 있다.
    const targets = pickOwnNewDraftingTargets(
      [newRow(), newRow({ ITEM_ID: 'STALE-ITEM', CONFIRM_ID: 'R900' })],
      [insertedRow()],
      USER
    );
    expect(targets).toHaveLength(1);
    expect(targets[0].ITEM_ID).toBe('ITEM1');
  });

  it('같은 키가 조회에 더 많이 와도 내가 넣은 개수까지만 가져간다(다중도 상한)', () => {
    // 내가 1건 넣었는데 동일 키 'I' 행이 2건 있으면 1건만 — 나머지는 남의 것이거나 잔여다.
    const targets = pickOwnNewDraftingTargets(
      [newRow({ CONFIRM_ID: 'R001' }), newRow({ CONFIRM_ID: 'R002' })],
      [insertedRow()],
      USER
    );
    expect(targets).toHaveLength(1);
  });

  it('같은 키를 2건 넣었으면 2건 가져간다', () => {
    const targets = pickOwnNewDraftingTargets(
      [newRow({ CONFIRM_ID: 'R001' }), newRow({ CONFIRM_ID: 'R002' })],
      [insertedRow(), insertedRow()],
      USER
    );
    expect(targets).toHaveLength(2);
  });

  it('출하일 표기(YYYYMMDD vs YYYY-MM-DD)가 달라도 같은 행으로 대조한다', () => {
    const targets = pickOwnNewDraftingTargets(
      [newRow({ SHIPMENT_DATE: '2026-07-15' })],
      [insertedRow({ SHIPMENT_DATE: '20260715' })],
      USER
    );
    expect(targets).toHaveLength(1);
  });

  it('userId 가 비면(세션 유실) 키 대조만 적용한다 — 전건 탈락시키지 않는다', () => {
    const targets = pickOwnNewDraftingTargets([newRow({ REQUESTOR: '' })], [insertedRow()], '');
    expect(targets).toHaveLength(1);
  });

  it('AS-IS 기본 선별도 그대로 적용된다(ATTRIBUTE10 / CHANGE_TYPE P / ERP_SO_NO)', () => {
    const inserted = [insertedRow()];
    expect(pickOwnNewDraftingTargets([newRow({ ATTRIBUTE10: '' })], inserted, USER)).toHaveLength(0);
    expect(pickOwnNewDraftingTargets([newRow({ CHANGE_TYPE: 'P' })], inserted, USER)).toHaveLength(0);
    expect(pickOwnNewDraftingTargets([newRow({ ERP_SO_NO: 'SO1' })], inserted, USER)).toHaveLength(0);
  });
});

describe('isDraftingTargetsComplete — 0건·부분누락을 성공으로 보지 않는다', () => {
  it('SEARCH_NEW 결과가 빈 배열이면 실패다(종전 false-success 지점)', () => {
    const targets = pickOwnNewDraftingTargets([], [insertedRow()], USER);
    expect(targets).toHaveLength(0);
    expect(isDraftingTargetsComplete(targets, 1)).toBe(false);
  });

  it('신규 2행 저장인데 대상이 1행만 조회되면 실패다(부분 누락)', () => {
    const inserted = [insertedRow({ ITEM_ID: 'A' }), insertedRow({ ITEM_ID: 'B' })];
    const targets = pickOwnNewDraftingTargets([newRow({ ITEM_ID: 'A' })], inserted, USER);
    expect(targets).toHaveLength(1);
    expect(isDraftingTargetsComplete(targets, 2)).toBe(false);
  });

  it('신규 2행 저장에 대상 2행이면 성공이다', () => {
    const inserted = [insertedRow({ ITEM_ID: 'A' }), insertedRow({ ITEM_ID: 'B' })];
    const targets = pickOwnNewDraftingTargets(
      [newRow({ ITEM_ID: 'A' }), newRow({ ITEM_ID: 'B' })],
      inserted,
      USER
    );
    expect(isDraftingTargetsComplete(targets, 2)).toBe(true);
  });

  it('타 사용자 유령 행으로 건수가 채워지지 않는다 — 한정 전에는 통과했던 구멍이다', () => {
    const inserted = [insertedRow({ ITEM_ID: 'A' }), insertedRow({ ITEM_ID: 'B' })];
    const fetched = [newRow({ ITEM_ID: 'A' }), newRow({ ITEM_ID: 'A', REQUESTOR: '임꺽정(U2)' })];
    // 한정 없이 세면 2건이라 통과한다.
    expect(pickNewDraftingTargets(fetched)).toHaveLength(2);
    // 한정하면 1건 — 제대로 실패한다.
    const targets = pickOwnNewDraftingTargets(fetched, inserted, USER);
    expect(targets).toHaveLength(1);
    expect(isDraftingTargetsComplete(targets, 2)).toBe(false);
  });

  it('메인 조회 결과(CHANGE_TYPE != N, ATTRIBUTE10 없음)를 넣으면 0건이 된다', () => {
    // 종전 버그 재현: 메인 조회 SP 는 CHANGE_TYPE <> 'N' 이라 신규행이 없고 ATTRIBUTE10 도 안 실린다.
    const mainRows = [
      { CHANGE_TYPE: 'C', CONFIRM_ID: 'C1', ERP_SO_NO: '' },
      { CHANGE_TYPE: 'C', CONFIRM_ID: 'C2', ERP_SO_NO: '' },
    ];
    const targets = pickOwnNewDraftingTargets(mainRows, [insertedRow(), insertedRow()], USER);
    expect(targets).toHaveLength(0);
    expect(isDraftingTargetsComplete(targets, 2)).toBe(false);
  });

  it('SEARCH_NEW 가 fail 이면 대상을 0건으로 접어 실패가 된다', async () => {
    api.post.mockResolvedValue({ status: 500, data: {} } as never);
    const { rows, outcome } = await fetchNewRowsForDrafting({});
    const targets = outcome === 'fail' ? [] : pickOwnNewDraftingTargets(rows, [insertedRow()], USER);
    expect(isDraftingTargetsComplete(targets, 1)).toBe(false);
  });
});
