import { describe, expect, it } from 'vitest';

import { validateSaveRows } from './forecast-price.validate';
import { buildWsFcstTypeSet, isAsFromSiteEditable } from './forecast-price.wsAuth';

/**
 * ② AS FROM SITE — 화면(셀 개방)과 저장(검증)이 **같은 FCST Type 집합**을 봐야 한다.
 *
 * 회귀 원천 (2026-08-06 리포트): 그리드는 CODE+NAME 을 담고 ForecastPrice.handleSave 는 CODE 만
 * 담고 있었다. FCST_TYPE 셀에 실제로 저장되는 값은 라벨(NAME)이라 컬럼은 노랗게 열리는데
 * MSG00476(AS_FROM_SITE_REQUIRED)은 영원히 안 떴다.
 */
const WS_COMBO = [
  { CODE: 'WS_C', NAME: 'WS(Chargeable)' },
  { CODE: 'WS_F', NAME: 'WS(Free)' },
  { CODE: 'AS_C', NAME: 'A/S(Chargeable)' },
  { CODE: 'AS_F', NAME: 'A/S(Free)' },
];

describe('buildWsFcstTypeSet', () => {
  it('CODE 와 NAME 을 둘 다 담는다 (어느 표기로 저장돼도 매칭)', () => {
    const set = buildWsFcstTypeSet(WS_COMBO);
    expect(set.has('WS_C')).toBe(true);
    expect(set.has('WS(Chargeable)')).toBe(true);
  });

  it('공란/미응답은 걸러낸다', () => {
    expect(buildWsFcstTypeSet(undefined).size).toBe(0);
    expect(buildWsFcstTypeSet([{ CODE: '  ', NAME: '' }]).size).toBe(0);
  });
});

describe('AS FROM SITE — 셀 개방과 저장 검증의 판정 일치', () => {
  const wsFcstTypes = buildWsFcstTypeSet(WS_COMBO);
  const asSiteNames = new Set(['AS_SITE_1']); // 비축(AS)향 사이트 — 대상 아님

  // FCST_TYPE 셀에 **라벨**이 저장된 경우 (실측 표기)
  const rowWithLabel = {
    CRUD_TYPE: 'I',
    SCM_SITE_ID: 'BMW_DE_MUC', // 고객향 (asSiteNames 에 없음)
    FCST_TYPE: 'WS(Chargeable)',
    AS_FROM_SITE: '',
    PLANT_SITE_ID: 'WA00-P',
    MEASURE: 'MKT_FCST',
    D_20260810: 100,
  } as unknown as WijmoRowItem;

  it('셀은 개방된다 (그리드 판정)', () => {
    expect(
      isAsFromSiteEditable({
        wsPlannerYn: true,
        isInsertRow: true,
        fcstType: 'WS(Chargeable)',
        wsFcstTypes,
      })
    ).toBe(true);
  });

  it('저장 검증도 같이 걸린다 — AS_FROM_SITE 공란이면 MSG00476', () => {
    expect(
      validateSaveRows([rowWithLabel], ['D_20260810'], '', {
        wsPlannerYn: true,
        divisionId: '81',
        wsFcstTypes,
        asSiteNames,
      })
    ).toBe('AS_FROM_SITE_REQUIRED');
  });

  // ⭐ 2026-08-06 실측: 조회 커서가 AS FROM SITE 빈값을 '-' 로 내려주고 handleInsert 가 시드 복사한다.
  //   `=== ''` 만 보던 검증이 여기서 통째로 빠져나가 MSG00476 이 안 떴다.
  it('커서 placeholder \'-\' 도 공란으로 본다', () => {
    const dashRow = { ...rowWithLabel, AS_FROM_SITE: '-' } as unknown as WijmoRowItem;
    expect(
      validateSaveRows([dashRow], ['D_20260810'], '', {
        wsPlannerYn: true,
        divisionId: '81',
        wsFcstTypes,
        asSiteNames,
      })
    ).toBe('AS_FROM_SITE_REQUIRED');
  });

  it('FCST_TYPE 이 CODE(WS)로 저장된 행도 동일하게 걸린다', () => {
    const codeRow = { ...rowWithLabel, FCST_TYPE: 'WS_C' } as unknown as WijmoRowItem;
    expect(
      validateSaveRows([codeRow], ['D_20260810'], '', {
        wsPlannerYn: true,
        divisionId: '81',
        wsFcstTypes,
        asSiteNames,
      })
    ).toBe('AS_FROM_SITE_REQUIRED');
  });

  it('AS_FROM_SITE 를 채우면 통과한다', () => {
    const filled = { ...rowWithLabel, AS_FROM_SITE: 'WA00-P' } as unknown as WijmoRowItem;
    expect(
      validateSaveRows([filled], ['D_20260810'], '', {
        wsPlannerYn: true,
        divisionId: '81',
        wsFcstTypes,
        asSiteNames,
      })
    ).toBeNull();
  });

  it('비축(AS)향 사이트 행은 검증 대상이 아니다', () => {
    const asSiteRow = { ...rowWithLabel, SCM_SITE_ID: 'AS_SITE_1' } as unknown as WijmoRowItem;
    expect(
      validateSaveRows([asSiteRow], ['D_20260810'], '', {
        wsPlannerYn: true,
        divisionId: '81',
        wsFcstTypes,
        asSiteNames,
      })
    ).toBeNull();
  });
});
