import { describe, expect, it } from 'vitest';

import { sessionTimeZone } from './sessionTimeZone';

// FN_MULTY_TIME 본문 30행이 `NVL(P_TIME_ZONE,'AS054')` 이고 Oracle 에서 빈 문자열은 NULL 이다.
//   그래서 "값이 없으면 빈 문자열" 이 종전 하드코딩(`timeZone: ''` = 한국 기준)과 동일 동작이다.
//   undefined 를 그대로 흘리면 payload 에 `timeZone: undefined` 가 실려 JSON 직렬화에서 키가
//   사라지고 SP 바인딩이 깨지므로, 반드시 문자열로 떨어뜨린다.

describe('sessionTimeZone', () => {
  it('세션의 tmzCd 를 그대로 보낸다', () => {
    expect(sessionTimeZone({ tmzCd: 'AM073' })).toBe('AM073');
    expect(sessionTimeZone({ tmzCd: 'AS054' })).toBe('AS054');
    expect(sessionTimeZone({ tmzCd: 'AS055' })).toBe('AS055');
    expect(sessionTimeZone({ tmzCd: 'EU042' })).toBe('EU042');
  });

  it('lookup 에 새 코드가 추가돼도 FE 가 막지 않는다(화이트리스트 없음)', () => {
    // FN_MULTY_TIME 은 offset 을 SCM_ADM_LOOKUP_MASTER_DETAIL 에서 읽는 데이터 구동이라
    //   코드 추가가 FE 변경 없이 동작해야 한다.
    expect(sessionTimeZone({ tmzCd: 'EU999' })).toBe('EU999');
  });

  it('값이 없으면 빈 문자열 — SP 가 AS054(한국)로 처리하는 종전 동작', () => {
    expect(sessionTimeZone({ tmzCd: '' })).toBe('');
    expect(sessionTimeZone(undefined)).toBe('');
    expect(sessionTimeZone({} as { tmzCd: string })).toBe('');
  });

  it('undefined 를 반환하지 않는다 — payload 키가 사라지면 SP 바인딩이 깨진다', () => {
    expect(typeof sessionTimeZone(undefined)).toBe('string');
    expect(typeof sessionTimeZone({} as { tmzCd: string })).toBe('string');
  });
});
