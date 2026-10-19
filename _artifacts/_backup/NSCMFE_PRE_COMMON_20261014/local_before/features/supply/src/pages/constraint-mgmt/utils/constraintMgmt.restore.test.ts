import { describe, expect, it } from 'vitest';

import type { SearchParamProps } from '../constraint-mgmt.types';
import { buildSearchParamsFromSaved } from './constraintMgmt.utils';

const INIT: SearchParamProps = {
  lookupType: '',
  planGroupNames: [],
  validYn: 'Y',
};

describe('buildSearchParamsFromSaved — F6 저장 조회조건 복원', () => {
  it('저장분이 없으면 init 기본값을 그대로 돌려준다', () => {
    expect(buildSearchParamsFromSaved([], INIT)).toEqual(INIT);
  });

  it('lookupType/validYn 문자열을 복원한다', () => {
    const result = buildSearchParamsFromSaved(
      [
        { paramNm: 'lookupType', paramCtn: 'PACK' },
        { paramNm: 'validYn', paramCtn: 'N' },
      ],
      INIT
    );
    expect(result.lookupType).toBe('PACK');
    expect(result.validYn).toBe('N');
  });

  it('planGroupNames 콤마 문자열을 배열로 되돌린다', () => {
    const result = buildSearchParamsFromSaved(
      [{ paramNm: 'planGroupNames', paramCtn: 'Micro_Cyl,Prismatic' }],
      INIT
    );
    expect(result.planGroupNames).toEqual(['Micro_Cyl', 'Prismatic']);
  });

  it('저장되지 않은 키는 init 기본값을 유지한다(부분 저장)', () => {
    const result = buildSearchParamsFromSaved(
      [{ paramNm: 'lookupType', paramCtn: 'PACK' }],
      INIT
    );
    // planGroupNames·validYn 은 저장 SP 가 빈 값을 skip 하거나 미저장일 수 있다.
    expect(result.planGroupNames).toEqual([]);
    expect(result.validYn).toBe('Y');
  });

  it('빈 콤마 토큰은 걸러 배열에 넣지 않는다', () => {
    const result = buildSearchParamsFromSaved(
      [{ paramNm: 'planGroupNames', paramCtn: 'A,,B,' }],
      INIT
    );
    expect(result.planGroupNames).toEqual(['A', 'B']);
  });
});
