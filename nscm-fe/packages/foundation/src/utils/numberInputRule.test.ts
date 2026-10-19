import { describe, expect, it } from 'vitest';

import { isTypingAllowed, isValueAllowed } from './numberInputRule';

describe('isTypingAllowed', () => {
  it('규칙이 없으면 모두 통과한다', () => {
    expect(isTypingAllowed('-1.234', {})).toBe(true);
  });

  it('positiveOnly 는 음수 부호를 거부한다', () => {
    expect(isTypingAllowed('-', { positiveOnly: true })).toBe(false);
    expect(isTypingAllowed('-5', { positiveOnly: true })).toBe(false);
    expect(isTypingAllowed('5', { positiveOnly: true })).toBe(true);
  });

  it('integerOnly 는 소수점을 거부한다', () => {
    expect(isTypingAllowed('1.', { integerOnly: true })).toBe(false);
    expect(isTypingAllowed('12', { integerOnly: true })).toBe(true);
    expect(isTypingAllowed('-12', { integerOnly: true })).toBe(true);
  });

  it('decimalPlaces 는 초과 자릿수만 거부하고 미완성 입력은 통과시킨다', () => {
    const rule = { decimalPlaces: 2 };
    expect(isTypingAllowed('1.', rule)).toBe(true);
    expect(isTypingAllowed('1.23', rule)).toBe(true);
    expect(isTypingAllowed('1.234', rule)).toBe(false);
  });

  it('integerOnly 가 켜져 있으면 decimalPlaces 는 무시한다', () => {
    expect(isTypingAllowed('1.2', { integerOnly: true, decimalPlaces: 2 })).toBe(false);
  });

  it('천단위 콤마는 자릿수 계산에서 제외한다', () => {
    expect(isTypingAllowed('1,234.5', { decimalPlaces: 1 })).toBe(true);
  });
});

describe('isValueAllowed', () => {
  it('빈 문자열은 통과한다', () => {
    expect(isValueAllowed('', { positiveOnly: true, integerOnly: true })).toBe(true);
    expect(isValueAllowed('  ', { positiveOnly: true })).toBe(true);
  });

  it('BOD PRIORITY 규칙(양수 정수)', () => {
    const rule = { positiveOnly: true, integerOnly: true };
    expect(isValueAllowed('0', rule)).toBe(true);
    expect(isValueAllowed('10', rule)).toBe(true);
    expect(isValueAllowed('-1', rule)).toBe(false);
    expect(isValueAllowed('1.5', rule)).toBe(false);
    expect(isValueAllowed('5.', rule)).toBe(false);
  });

  it('positiveOnly 는 0 을 허용한다', () => {
    expect(isValueAllowed('0', { positiveOnly: true })).toBe(true);
    expect(isValueAllowed('-0.1', { positiveOnly: true })).toBe(false);
  });

  it('decimalPlaces 경계', () => {
    expect(isValueAllowed('1.25', { decimalPlaces: 2 })).toBe(true);
    expect(isValueAllowed('1.255', { decimalPlaces: 2 })).toBe(false);
  });
});
