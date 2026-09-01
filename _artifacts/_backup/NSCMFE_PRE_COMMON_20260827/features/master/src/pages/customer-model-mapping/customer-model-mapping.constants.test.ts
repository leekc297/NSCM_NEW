import { describe, expect, it } from 'vitest';

import { isDivisionAllowed } from './customer-model-mapping.constants';

describe('isDivisionAllowed (컬럼 메타 Param1 허용 Division)', () => {
  const ALLOW_81_82 = '81,81_UC,81_HM,81_ST,81_HD,81_HG,82';

  it('Param1 이 비어 있으면 제한하지 않는다 (메타 미등록 = 종전 동작)', () => {
    expect(isDivisionAllowed(undefined, '40')).toBe(true);
    expect(isDivisionAllowed('', '40')).toBe(true);
    expect(isDivisionAllowed('   ', '40')).toBe(true);
  });

  it('목록에 있는 Division 만 허용한다', () => {
    expect(isDivisionAllowed(ALLOW_81_82, '81')).toBe(true);
    expect(isDivisionAllowed(ALLOW_81_82, '82')).toBe(true);
    expect(isDivisionAllowed(ALLOW_81_82, '40')).toBe(false);
  });

  it('81 하위 코드는 목록에 적힌 것만 허용한다 (토큰 정확 일치, substring 금지)', () => {
    expect(isDivisionAllowed(ALLOW_81_82, '81_HM')).toBe(true);
    expect(isDivisionAllowed('81,82', '81_HM')).toBe(false);
    expect(isDivisionAllowed('81_HM', '81')).toBe(false);
  });

  it('토큰 사이 공백은 무시한다', () => {
    expect(isDivisionAllowed(' 81 , 82 ', '82')).toBe(true);
  });

  it('행에 Division 값이 없으면 제한하지 않는다', () => {
    expect(isDivisionAllowed(ALLOW_81_82, undefined)).toBe(true);
    expect(isDivisionAllowed(ALLOW_81_82, '')).toBe(true);
  });
});
