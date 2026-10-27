import { describe, expect, it } from 'vitest';

import { checkShipmentDateInPeriod } from './useShipmentChangeRequestValidation';

// C7 — 저장 시 출하일이 조회구간 Period[from,to] 밖이면 차단(AS-IS SSP_Main_Validation cs:3173-3178/
//   3383-3388, MSG00359 -> MSG01353). 순수 함수라 hook 렌더 없이 직접 검증한다.

const row = (shipmentDate: string) => ({ SHIPMENT_DATE: shipmentDate });

describe('checkShipmentDateInPeriod (C7)', () => {
  const FROM = '20261001';
  const TO = '20261031';

  it('조회구간 안이면 위반 아님(false)', () => {
    expect(checkShipmentDateInPeriod([row('2026-10-15')], FROM, TO)).toBe(false);
  });

  it('From 이전이면 위반(true)', () => {
    expect(checkShipmentDateInPeriod([row('2026-09-30')], FROM, TO)).toBe(true);
  });

  it('To 이후면 위반(true)', () => {
    expect(checkShipmentDateInPeriod([row('2026-11-01')], FROM, TO)).toBe(true);
  });

  it('경계값(From·To 당일)은 포함(inclusive, false)', () => {
    expect(checkShipmentDateInPeriod([row('2026-10-01'), row('2026-10-31')], FROM, TO)).toBe(false);
  });

  it('Period from/to 미확보 시 검증 생략(false)', () => {
    expect(checkShipmentDateInPeriod([row('2026-09-01')], '', TO)).toBe(false);
    expect(checkShipmentDateInPeriod([row('2026-12-01')], FROM, '')).toBe(false);
  });

  it('파싱 불가 출하일은 건너뛴다(C7 대상 아님, false)', () => {
    expect(checkShipmentDateInPeriod([row(''), row('N/A')], FROM, TO)).toBe(false);
  });

  it('yyyyMMdd·yyyy-MM-dd 형식 모두 파싱한다', () => {
    expect(checkShipmentDateInPeriod([row('20260930')], FROM, TO)).toBe(true);
    expect(checkShipmentDateInPeriod([row('20261015')], FROM, TO)).toBe(false);
  });

  it('여러 행 중 하나라도 구간 밖이면 위반(true)', () => {
    const rows = [row('2026-10-10'), row('2026-10-20'), row('2026-11-05')];
    expect(checkShipmentDateInPeriod(rows, FROM, TO)).toBe(true);
  });
});
