import { describe, expect, it } from 'vitest';

import { DIVISION_TYPE, SHOP_GROUP_ID } from '../capa-speed-plan.constants';
import type { ComboRow } from '../capa-speed-plan.types';

import {
  buildAssemblyLineTypeOptions,
  buildOperationOptions,
  buildProgressStatusOptions,
  buildSiteOptions,
  deriveCurrProgressStatus,
  expandMultiSelect,
} from './capaSpeedPlan.combos';

/**
 * design 02_search-combo §6 F-07·F-10·F-17 검증 축 + AS-IS 후처리 필터 파리티.
 *
 * `CODE <> '-'` 는 AS-IS 가 **일부 축에만** 건다(`ScpCapaBL.cs` 실측):
 *   `GetFilterSite`(:154) · `GetFilterCompany`(:178) · `GetFilterPlant`(:202) ·
 *   `GetFilterFactory`(:251) · `GetFilterLine`(:300) 5축에만 있고
 *   `GetFilterOperation`(:327~) / `GetFilterElectrodeType`(:370~) 에는 없다.
 */

const masterRow = (patch: Partial<ComboRow> = {}): ComboRow =>
  ({
    DIVISION_ID: '81',
    SITE_ID: 'S1',
    SITE_NAME: 'S1 Site One',
    COMPANY_ID: 'C1',
    PLANT_ID: 'P1',
    PLANT_NAME: 'P1 Plant One',
    FACTORY_ID: 'F1',
    FACTORY_NAME: 'F1 Building One',
    LINE_ID: 'L1',
    LINE_NAME: 'L1 Line One',
    OPERATION_ID: 'A5000',
    OPERATION_NAME: 'A5000 Assembly',
    ELTR_LN_TP_CD: 'Anode',
    ELTR_LN_TP_NM: 'Anode',
    SHOP_GROUP_ID: 'A',
    DISPLAY_SEQ: '1',
    ...patch,
  }) as ComboRow;

describe('Line Type(ASSEMBLY) — 코드 \'-\' 를 후보로 유지한다 (AS-IS GetFilterElectrodeType 파리티)', () => {
  it('Module/Pack 은 \'-\' 하나뿐이어도 후보가 1건이어야 한다 (제외하면 조회가 0건이 된다)', () => {
    const rows = [
      masterRow({ SHOP_GROUP_ID: 'P', OPERATION_ID: 'P1000', ELTR_LN_TP_CD: '-', ELTR_LN_TP_NM: '-' }),
    ];
    const options = buildAssemblyLineTypeOptions({
      rows,
      divisionId: '81',
      shopGroupId: SHOP_GROUP_ID[DIVISION_TYPE.MODULE_PACK],
    });
    expect(options.map(option => option.value)).toEqual(['-']);
    // 후보가 살아 있으므로 서버로 'NONE' 이 나가지 않는다.
    expect(expandMultiSelect('ALL', options)).toBe('-');
  });

  it('Cell 은 \'-\' 와 실코드가 함께 후보에 남는다', () => {
    const rows = [
      masterRow({ ELTR_LN_TP_CD: '-', ELTR_LN_TP_NM: '-' }),
      masterRow({ ELTR_LN_TP_CD: 'Anode', ELTR_LN_TP_NM: 'Anode', DISPLAY_SEQ: '2' }),
    ];
    const options = buildAssemblyLineTypeOptions({
      rows,
      divisionId: '81',
      shopGroupId: SHOP_GROUP_ID[DIVISION_TYPE.CELL],
    });
    expect(options.map(option => option.value)).toEqual(['-', 'Anode']);
  });
});

describe('Operation — 코드 \'-\' 를 후보로 유지하고 Formation(AFFFF) 만 제외한다', () => {
  it('\'-\' 는 남고 \'AFFFF\' 는 빠진다', () => {
    const rows = [
      masterRow({ OPERATION_ID: '-', OPERATION_NAME: '- Dash' }),
      masterRow({ OPERATION_ID: 'AFFFF', OPERATION_NAME: 'AFFFF Formation', DISPLAY_SEQ: '2' }),
      masterRow({ DISPLAY_SEQ: '3' }),
    ];
    const options = buildOperationOptions({ rows, divisionId: '81', shopGroupId: 'A' });
    expect(options.map(option => option.value)).toEqual(['-', 'A5000']);
  });
});

describe('Site — 상위 4축은 반대로 \'-\' 를 제외하고, shop group 스코프를 지킨다 (F-10)', () => {
  it('SITE_ID=\'-\' 는 후보에서 빠진다 (AS-IS GetFilterSite 의 CODE <> \'-\')', () => {
    const rows = [
      masterRow({ SITE_ID: '-', SITE_NAME: '- Dash' }),
      masterRow({ SITE_ID: 'S2', SITE_NAME: 'S2 Site Two' }),
    ];
    const options = buildSiteOptions({ rows, divisionId: '81', shopGroupId: 'A' });
    expect(options.map(option => option.value)).toEqual(['S2']);
  });

  it('Cell 과 Module/Pack 의 Site 목록이 달라야 한다 (같으면 F-10 실패)', () => {
    const rows = [
      masterRow({ SITE_ID: 'S_A', SITE_NAME: 'S_A Cell Site', SHOP_GROUP_ID: 'A' }),
      masterRow({ SITE_ID: 'S_P', SITE_NAME: 'S_P Pack Site', SHOP_GROUP_ID: 'P' }),
    ];
    const cell = buildSiteOptions({
      rows,
      divisionId: '81',
      shopGroupId: SHOP_GROUP_ID[DIVISION_TYPE.CELL],
    });
    const pack = buildSiteOptions({
      rows,
      divisionId: '81',
      shopGroupId: SHOP_GROUP_ID[DIVISION_TYPE.MODULE_PACK],
    });
    expect(cell.map(option => option.value)).toEqual(['S_A']);
    expect(pack.map(option => option.value)).toEqual(['S_P']);
  });
});

describe('deriveCurrProgressStatus — 버전 행 부재 시 \'0\'(Current)', () => {
  it('행을 못 찾으면 AS-IS 초기값 \'0\' 을 돌려준다 (cs:1051)', () => {
    expect(deriveCurrProgressStatus(undefined, '81', '202509', '1')).toBe('0');
    expect(deriveCurrProgressStatus([], '81', '202509', '1')).toBe('0');
  });

  it('행이 있으면 그 PROG_STAT 을 쓴다', () => {
    const rows = [
      { DIVISION_ID: '81', CODE: '202509', VER_SEQ: '1', PROG_STAT: '1' } as unknown as ComboRow,
    ];
    expect(deriveCurrProgressStatus(rows, '81', '202509', '1')).toBe('1');
  });
});

describe('Status 3중 필터 (F-07)', () => {
  const statusRows = ['-', '0', '1', '2'].map(
    code => ({ CODE: code, NAME: `name-${code}` }) as unknown as ComboRow
  );

  it('curr=\'0\'(Current) → \'0\' 만 남는다', () => {
    expect(buildProgressStatusOptions(statusRows, '0').map(option => option.value)).toEqual(['0']);
  });

  it('curr=\'1\'(1st Cutoff) → \'1\' 만 남는다 (\'0\' 제외 · \'2\' 제외 · \'-\' 제외)', () => {
    expect(buildProgressStatusOptions(statusRows, '1').map(option => option.value)).toEqual(['1']);
  });

  it('curr=\'-\'(Pre) → \'-\' 가 살아남는다', () => {
    expect(buildProgressStatusOptions(statusRows, '-').map(option => option.value)).toEqual(['-']);
  });

  it('\'2\'(2nd Cutoff)는 어떤 기준값에서도 노출되지 않는다', () => {
    for (const curr of ['-', '0', '1', '2']) {
      expect(buildProgressStatusOptions(statusRows, curr).map(option => option.value)).not.toContain(
        '2'
      );
    }
  });
});

describe('expandMultiSelect — 다중선택 payload (F-17)', () => {
  it('후보 0건이면 \'NONE\'', () => {
    expect(expandMultiSelect('ALL', [])).toBe('NONE');
  });

  it('무선택/전체선택이면 후보 전체를 \',\' 로 잇는다', () => {
    const candidates = [
      { label: 'a', value: 'A' },
      { label: 'b', value: 'B' },
    ];
    expect(expandMultiSelect('ALL', candidates)).toBe('A,B');
    expect(expandMultiSelect('', candidates)).toBe('A,B');
  });

  it('일부 선택이면 그 값을 그대로 보낸다', () => {
    expect(expandMultiSelect('A', [{ label: 'a', value: 'A' }])).toBe('A');
  });
});
