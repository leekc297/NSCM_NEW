import { describe, expect, it } from 'vitest';

import { parseSetPriceResult } from './business-plan.api';

// SET_PRICE = P_DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV (2026-08-24 OUT 커서 3종 개편).
//   o_rc1          : 성공 메시지 (s_flag<>'CALL' AND v_log_message IS NULL 일 때만 OPEN — 미오픈 = null)
//   o_rc2          : '[' || sqlcode || ']' || v_log_message (항상 OPEN. 정상 = '[]')
//   o_result_cursor: CODE/MSG/EVENT (CODE '0' = 성공, EVENT = N_LOG_COUNT)
//   주의: o_rc1·o_rc2 는 SELECT 에 alias 가 없어 컬럼명이 표현식 원문이다 — 이름으로 읽으면 안 되고
//        첫 컬럼 값으로 읽어야 한다. 아래 키는 Oracle 이 실제로 돌려주는 형태를 흉내낸 것.
const OK_MESSAGE = 'Sales Price Recalculation is Complete';
const RC1_COL = '\'SALESPRICERECALCULATIONISCOMPLETE\'';
const RC2_COL = '\'[\'||TO_CHAR(V_SQL_CODE)||\']\'||V_LOG_MESSAGE';

describe('parseSetPriceResult', () => {
  it('정상 — o_rc1 성공 메시지를 passthrough 하고 EVENT 를 건수로 준다', () => {
    const res = parseSetPriceResult({
      DATARESULT: [],
      o_rc1: [{ [RC1_COL]: OK_MESSAGE }],
      o_rc2: [{ [RC2_COL]: '[]' }],
      o_result_cursor: [{ CODE: '0', MSG: 'SUCCESS', EVENT: '1234' }],
    });
    expect(res).toEqual({ ok: true, message: OK_MESSAGE, count: 1234 });
  });

  it('커서 이름 대문자 등록도 동일하게 읽는다 (COL_NM 대소문자 불확정)', () => {
    const res = parseSetPriceResult({
      O_RC1: [{ [RC1_COL]: OK_MESSAGE }],
      O_RC2: [{ [RC2_COL]: '[]' }],
      O_RESULT_CURSOR: [{ CODE: '0', MSG: 'SUCCESS', EVENT: '0' }],
    });
    expect(res.ok).toBe(true);
    expect(res.message).toBe(OK_MESSAGE);
  });

  it('o_rc2 에 로그 메시지가 실리면 실패 — sqlcode 를 포함해 그대로 올린다', () => {
    const res = parseSetPriceResult({
      o_rc1: null,
      o_rc2: [{ [RC2_COL]: '[-1400]ORA-01400: cannot insert NULL' }],
      o_result_cursor: [{ CODE: '0', MSG: 'SUCCESS', EVENT: '0' }],
    });
    expect(res.ok).toBe(false);
    expect(res.message).toBe('[-1400]ORA-01400: cannot insert NULL');
  });

  it('o_result_cursor CODE 가 0 이 아니면 실패 — MSG 를 올린다', () => {
    const res = parseSetPriceResult({
      o_rc1: null,
      o_rc2: [{ [RC2_COL]: '[]' }],
      o_result_cursor: [{ CODE: '9', MSG: 'FAIL', EVENT: '0' }],
    });
    expect(res.ok).toBe(false);
    expect(res.message).toBe('FAIL');
  });

  it('o_rc1 미오픈(s_flag=\'CALL\') — 성공이지만 메시지는 없다', () => {
    const res = parseSetPriceResult({
      o_rc2: [{ [RC2_COL]: '[]' }],
      o_result_cursor: [{ CODE: '0', MSG: 'SUCCESS', EVENT: '7' }],
    });
    expect(res).toEqual({ ok: true, count: 7 });
  });

  it('빈 sqlcode 대괄호만 있는 로그는 오류가 아니다', () => {
    expect(parseSetPriceResult({ o_rc2: [{ [RC2_COL]: '[0]' }] }).ok).toBe(true);
    expect(parseSetPriceResult({ o_rc2: [{ [RC2_COL]: '  []  ' }] }).ok).toBe(true);
  });

  it('커서가 통째로 비어도 성공으로 본다 (SP 무응답 방어)', () => {
    expect(parseSetPriceResult(undefined)).toEqual({ ok: true });
    expect(parseSetPriceResult({ DATARESULT: [] })).toEqual({ ok: true });
  });

  it('o_rc1 이 먼저 오든 나중에 오든 결과가 같다 (BE HashMap 키 순서 비결정)', () => {
    const cursors = {
      o_result_cursor: [{ CODE: '0', MSG: 'SUCCESS', EVENT: '3' }],
      o_rc2: [{ [RC2_COL]: '[]' }],
      o_rc1: [{ [RC1_COL]: OK_MESSAGE }],
      DATARESULT: [],
    };
    expect(parseSetPriceResult(cursors)).toEqual({ ok: true, message: OK_MESSAGE, count: 3 });
  });
});
