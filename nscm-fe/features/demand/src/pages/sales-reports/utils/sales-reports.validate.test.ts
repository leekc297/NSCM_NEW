import { describe, expect, it } from 'vitest';

import { DATA_TYPE, MSG } from '../sales-reports.constants';

import {
  validateFind,
  validateNoPending,
  validateNotAll,
  validateVersionForAction,
} from './sales-reports.validate';

// TC-DMF0044-B / VALIDATION 버전 게이트 — 조회 전 버전 미선택 MSG00283.
describe('validateFind', () => {
  it('버전 미선택(공백) 조회는 MSG00283 차단', () => {
    expect(validateFind('')).toStrictEqual({ ok: false, msgId: MSG.REQUIRE_VERSION_FIND });
    expect(validateFind('   ')).toStrictEqual({ ok: false, msgId: MSG.REQUIRE_VERSION_FIND });
  });

  it('버전 채택 후에는 통과', () => {
    expect(validateFind('20260701_01')).toStrictEqual({ ok: true });
  });
});

// VALIDATION 편집·저장 게이트 — 저장/팝업(Exchange·Textbox) 진입 전 버전 필수 MSG00688.
describe('validateVersionForAction', () => {
  it('버전 미선택 시 저장·팝업 진입 MSG00688 차단', () => {
    expect(validateVersionForAction('')).toStrictEqual({
      ok: false,
      msgId: MSG.REQUIRE_VERSION_ACTION,
    });
  });

  it('버전 존재 시 통과', () => {
    expect(validateVersionForAction('20260701_01')).toStrictEqual({ ok: true });
  });
});

// TC-DMF0044-D / VALIDATION — Data Type=ALL 편집·저장 전면 차단 MSG00681.
describe('validateNotAll', () => {
  it('ALL 조회 상태는 차단', () => {
    expect(validateNotAll(DATA_TYPE.ALL)).toStrictEqual({ ok: false, msgId: MSG.ALL_BLOCK });
  });

  it('Cutoff(1)/ETC(2) 는 통과', () => {
    expect(validateNotAll(DATA_TYPE.CUTOFF)).toStrictEqual({ ok: true });
    expect(validateNotAll(DATA_TYPE.ETC)).toStrictEqual({ ok: true });
  });
});

// VALIDATION — Edit 중 Exchange 팝업 진입 차단 MSG00680.
describe('validateNoPending', () => {
  it('pending 변경 존재 시 차단', () => {
    expect(validateNoPending(true)).toStrictEqual({ ok: false, msgId: MSG.PENDING_BLOCK });
  });

  it('pending 없으면 통과', () => {
    expect(validateNoPending(false)).toStrictEqual({ ok: true });
  });
});
