import { describe, expect, it } from 'vitest';

import { deriveOperationIdByRack, deriveSiteSelection } from './lineMasterDerive';

// design 03_grid-columns §3.1 의 파생 규칙을 검증 축으로 삼는다.
//   #5 SCM_SITE_ID 선택 -> SITE_DESCRIPTION/OPERATION_ID (cs:775~776) / #6 RACK_YN -> OPERATION_ID '_R1' 접미사(cs:795).
//   AS-IS 근거는 lineMasterDerive.ts 머리말의 cs 라인 주석 참조.

describe('deriveSiteSelection — SCM_SITE_ID 콤보 선택 파생 (design 03 §3.1 #5)', () => {
  it('콤보행 CODE/NAME/OPERATION_ID 를 SCM_SITE_ID/SITE_DESCRIPTION/OPERATION_ID 로 옮긴다', () => {
    const d = deriveSiteSelection({ CODE: 'P123', NAME: 'Ochang Plant', OPERATION_ID: 'OP01' });
    expect(d.SCM_SITE_ID).toBe('P123');
    expect(d.SITE_DESCRIPTION).toBe('Ochang Plant');
    expect(d.OPERATION_ID).toBe('OP01');
  });

  it('빈 값도 그대로 전달한다 — 임의 폴백 금지 (convert-core §2.4)', () => {
    const d = deriveSiteSelection({ CODE: '', NAME: '', OPERATION_ID: '' });
    expect(d.SCM_SITE_ID).toBe('');
    expect(d.SITE_DESCRIPTION).toBe('');
    expect(d.OPERATION_ID).toBe('');
  });
});

describe('deriveOperationIdByRack — RACK_YN 접미사 파생 (design 03 §3.1 #6, cs:795)', () => {
  it('RACK_YN=\'Y\' 이면 \'_R1\' 접미사를 붙인다', () => {
    expect(deriveOperationIdByRack('OP01', 'Y')).toBe('OP01_R1');
  });

  it('RACK_YN=\'N\' 이면 접미사 없는 원본을 돌려준다', () => {
    expect(deriveOperationIdByRack('OP01', 'N')).toBe('OP01');
  });

  it('이미 \'_R1\' 이 붙은 값에 다시 \'Y\' 를 줘도 중복 부착하지 않는다', () => {
    expect(deriveOperationIdByRack('OP01_R1', 'Y')).toBe('OP01_R1');
  });

  it('\'_R1\' 이 붙은 값에 \'N\' 을 주면 접미사를 제거한다 (Rack 해제)', () => {
    expect(deriveOperationIdByRack('OP01_R1', 'N')).toBe('OP01');
  });

  it('\'Y\'/\'N\' 외의 값은 \'N\' 과 동일하게 접미사 없는 원본을 돌려준다', () => {
    expect(deriveOperationIdByRack('OP01', '')).toBe('OP01');
    expect(deriveOperationIdByRack('OP01_R1', '')).toBe('OP01');
  });

  it('빈 기준값이면 빈 문자열 (접미사만 남기지 않는다)', () => {
    expect(deriveOperationIdByRack('', 'N')).toBe('');
    // 빈 기준값 + 'Y' 는 접미사만 남으므로 데이터 결함 — 실제로 SCM_SITE_ID 선택 전에는 RACK 파생이 안 돈다.
    expect(deriveOperationIdByRack('', 'Y')).toBe('_R1');
  });
});
