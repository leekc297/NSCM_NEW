import { describe, expect, it } from 'vitest';

import { validateSaveRows, type SaveValidationContext } from './forecast-price.validate';

// 저장 전 검증 — 특히 V3(신규행 중복, MSG00260) 판정 범위.
//   실시간 중복검사(#10)가 2026-08-11 제거되면서 중복 판정은 이 함수 단독 경로가 됐다.

const DAY = 'D_20260810';
const DAY_COLUMNS = [DAY];

/** 키 10종을 채운 행 1건. overrides 로 키 일부만 바꿔 중복/비중복을 만든다. */
const row = (overrides: Record<string, unknown> = {}): WijmoRowItem =>
  ({
    DIVISION_ID: '40',
    PROJECT_CODE: '',
    END_CUSTOMER: 'IM',
    SCM_SITE_ID: 'IM_US_TXT',
    ITEM_ID: 'APCCA2791A',
    DOM_EXP: 'E',
    FCST_TYPE: 'MPS',
    INCOTERMS: 'FCA',
    MEASURE: 'MKT_FCST',
    CELL_PROD_SITE_ID: 'Common',
    PLANT_SITE_ID: '',
    [DAY]: 10,
    ...overrides,
  }) as unknown as WijmoRowItem;

const insertRow = (overrides: Record<string, unknown> = {}): WijmoRowItem =>
  row({ CRUD_TYPE: 'I', ...overrides });

describe('validateSaveRows — V3 신규행 중복(MSG00260)', () => {
  it('신규행끼리 키가 같으면 DUP_NEW_ROW', () => {
    expect(validateSaveRows([insertRow(), insertRow()], DAY_COLUMNS)).toBe('DUP_NEW_ROW');
  });

  it('신규행 키가 서로 다르면 통과', () => {
    expect(
      validateSaveRows([insertRow(), insertRow({ MEASURE: 'SCM_FCST' })], DAY_COLUMNS)
    ).toBeNull();
  });

  // Insert 는 포커스 행의 키 10종을 그대로 복제하므로(handleInsert), 기존 행과의 중복이 기본 시나리오다.
  it('신규행이 조회된 기존 행과 키가 같으면 DUP_NEW_ROW', () => {
    expect(validateSaveRows([row(), insertRow()], DAY_COLUMNS)).toBe('DUP_NEW_ROW');
  });

  it('기존 행이 삭제 표시(D)면 같은 키 신규행을 허용한다 — 지우고 다시 넣는 흐름', () => {
    expect(validateSaveRows([row({ CRUD_TYPE: 'D' }), insertRow()], DAY_COLUMNS)).toBeNull();
  });

  it('기존 행과 키가 하나라도 다르면 통과', () => {
    expect(validateSaveRows([row(), insertRow({ INCOTERMS: 'DAP' })], DAY_COLUMNS)).toBeNull();
  });

  // Oracle CHAR 컬럼은 뒤에 공백이 붙어 내려올 수 있다 — 시드 복제본과 문자열이 어긋나면 안 된다.
  it('앞뒤 공백은 무시하고 같은 키로 본다', () => {
    expect(validateSaveRows([row({ SCM_SITE_ID: 'IM_US_TXT ' }), insertRow()], DAY_COLUMNS)).toBe(
      'DUP_NEW_ROW'
    );
  });

  // 판정 키는 save.ts duplicateKeyOf 단독 — AS_FROM_SITE 가 키에 들어간다.
  //   화면 전용 키를 따로 두면 저장 키와 갈려 중복이 조용히 통과한다 (2026-08-05 NICK_NAME 사고).
  it('AS_FROM_SITE 만 다르면 별개 행으로 통과한다', () => {
    expect(
      validateSaveRows(
        [row({ AS_FROM_SITE: 'WA00-81-AS' }), insertRow({ AS_FROM_SITE: '' })],
        DAY_COLUMNS
      )
    ).toBeNull();
  });

  // PlantSite 는 81 계열만 키에 포함 (AS-IS L4907 / 40·82 는 제외).
  it('40 은 PLANT_SITE_ID 만 달라도 같은 키 = DUP_NEW_ROW', () => {
    expect(
      validateSaveRows(
        [row({ PLANT_SITE_ID: 'WA00-P' }), insertRow({ PLANT_SITE_ID: 'WA01-P' })],
        DAY_COLUMNS
      )
    ).toBe('DUP_NEW_ROW');
  });

  it('81 은 PLANT_SITE_ID 가 다르면 별개 행으로 통과', () => {
    expect(
      validateSaveRows(
        [
          row({ DIVISION_ID: '81', PLANT_SITE_ID: 'WA00-P' }),
          insertRow({ DIVISION_ID: '81', PLANT_SITE_ID: 'WA01-P' }),
        ],
        DAY_COLUMNS
      )
    ).toBeNull();
  });
});

// 81 계열은 PlantSite 가 키 차원이자 필수 입력 — 두 검증이 짝을 이룬다.
const ctx81: SaveValidationContext = {
  wsPlannerYn: true,
  divisionId: '81',
  wsFcstTypes: new Set(['WS(Chargeable)', 'WS_C']),
  asSiteNames: new Set(['WA00-81-AS']),
};

describe('validateSaveRows — V0 AS FROM SITE 필수(MSG00476)', () => {
  const base = {
    DIVISION_ID: '81',
    PLANT_SITE_ID: 'WA00-P',
    SCM_SITE_ID: 'CUST-SITE', // asSiteNames 에 없음 = 고객향
    FCST_TYPE: 'WS(Chargeable)',
  };

  it('고객향 사이트 + W/S FcstType + AS FROM SITE 공란 = AS_FROM_SITE_REQUIRED', () => {
    expect(
      validateSaveRows([insertRow({ ...base, AS_FROM_SITE: '' })], DAY_COLUMNS, '', ctx81)
    ).toBe('AS_FROM_SITE_REQUIRED');
  });

  // 조회 커서가 빈값을 '-' 로 내려주고 handleInsert 가 그대로 시드 복사한다 (wsAuth.isAsFromSiteBlank).
  it('커서 placeholder 하이픈도 공란으로 본다', () => {
    expect(
      validateSaveRows([insertRow({ ...base, AS_FROM_SITE: '-' })], DAY_COLUMNS, '', ctx81)
    ).toBe('AS_FROM_SITE_REQUIRED');
  });

  it('값이 있으면 통과', () => {
    expect(
      validateSaveRows([insertRow({ ...base, AS_FROM_SITE: 'WA00-81-AS' })], DAY_COLUMNS, '', ctx81)
    ).toBeNull();
  });

  it('비축향 사이트 자신은 대상이 아니다', () => {
    expect(
      validateSaveRows(
        [insertRow({ ...base, SCM_SITE_ID: 'WA00-81-AS', AS_FROM_SITE: '' })],
        DAY_COLUMNS,
        '',
        ctx81
      )
    ).toBeNull();
  });

  // ctx 미지정 = 콤보 미도착/테스트 경로 → 관대 통과 (잘못된 차단 금지).
  it('ctx 없이 호출하면 검증을 생략한다', () => {
    expect(validateSaveRows([insertRow({ ...base, AS_FROM_SITE: '' })], DAY_COLUMNS)).toBeNull();
  });
});

describe('validateSaveRows — V0-2 Plant Site 필수(MSG00429)', () => {
  it('81 계열 신규행에 PLANT_SITE_ID 공란이면 PLANT_SITE_REQUIRED', () => {
    expect(
      validateSaveRows(
        [insertRow({ DIVISION_ID: '81', PLANT_SITE_ID: '', SCM_SITE_ID: 'WA00-81-AS' })],
        DAY_COLUMNS,
        '',
        ctx81
      )
    ).toBe('PLANT_SITE_REQUIRED');
  });

  // AS FROM SITE 안내(MSG00476)를 먼저 보여주는 순서는 의도된 것 (2026-07-31 요건 승계).
  it('AS FROM SITE 와 둘 다 공란이면 AS_FROM_SITE_REQUIRED 가 먼저 뜬다', () => {
    expect(
      validateSaveRows(
        [
          insertRow({
            DIVISION_ID: '81',
            PLANT_SITE_ID: '',
            SCM_SITE_ID: 'CUST-SITE',
            FCST_TYPE: 'WS(Chargeable)',
            AS_FROM_SITE: '',
          }),
        ],
        DAY_COLUMNS,
        '',
        ctx81
      )
    ).toBe('AS_FROM_SITE_REQUIRED');
  });

  it('40·82 는 대상이 아니다', () => {
    const ctx82: SaveValidationContext = { ...ctx81, divisionId: '82' };
    expect(
      validateSaveRows(
        [insertRow({ DIVISION_ID: '82', PLANT_SITE_ID: '', SCM_SITE_ID: 'WA00-81-AS' })],
        DAY_COLUMNS,
        '',
        ctx82
      )
    ).toBeNull();
  });
});

describe('validateSaveRows — V2 M+4 동결 반영', () => {
  const M4_DAY = 'D_20260610'; // 202606
  const OPEN_DAY = 'D_20261110'; // 202611
  const CUTOFF = '202609'; // M+3 기준월 — 이하 잠금

  // 동결 구간에만 값이 있는 신규행은 저장 rows 가 0건이 된다 (buildSaveRows 와 같은 범위).
  //   검증이 이를 통과시키면 사용자는 '저장 성공'을 보는데 아무것도 안 들어간다.
  it('동결 구간에만 값이 있으면 QTY_PRICE_REQUIRED', () => {
    const r = insertRow({ MEASURE: 'MKT_FCST', [M4_DAY]: 10, [OPEN_DAY]: 0 });
    expect(validateSaveRows([r], [M4_DAY, OPEN_DAY], CUTOFF, undefined, 'M')).toBe(
      'QTY_PRICE_REQUIRED'
    );
  });

  it('개방 구간에 값이 있으면 통과', () => {
    const r = insertRow({ MEASURE: 'MKT_FCST', [M4_DAY]: 0, [OPEN_DAY]: 10 });
    expect(validateSaveRows([r], [M4_DAY, OPEN_DAY], CUTOFF, undefined, 'M')).toBeNull();
  });

  // M+4 동결은 Monthly 한정 (현업 검수 40번) — Weekly/Daily 는 편집이 열리므로 저장/검증도 열려야 한다.
  it('Daily 버킷에서는 동결 구간 값도 인정한다', () => {
    const r = insertRow({ MEASURE: 'MKT_FCST', [M4_DAY]: 10, [OPEN_DAY]: 0 });
    expect(validateSaveRows([r], [M4_DAY, OPEN_DAY], CUTOFF, undefined, 'D')).toBeNull();
  });

  it('Weekly 버킷에서는 동결 구간 값도 인정한다', () => {
    const r = insertRow({ MEASURE: 'MKT_FCST', [M4_DAY]: 10, [OPEN_DAY]: 0 });
    expect(validateSaveRows([r], [M4_DAY, OPEN_DAY], CUTOFF, undefined, 'W')).toBeNull();
  });

  it('M+4 대상이 아닌 measure(LOC)는 동결 구간 값도 인정한다', () => {
    const r = insertRow({ MEASURE: 'LOC', CURRENCY: 'KRW', [M4_DAY]: 10, [OPEN_DAY]: 0 });
    expect(validateSaveRows([r], [M4_DAY, OPEN_DAY], CUTOFF, undefined, 'M')).toBeNull();
  });

  // cutoff 미수신은 fail-open — GET drop1 이 늦을 때 전 구간을 잠그면 화면을 못 쓴다.
  it('cutoff 미수신이면 동결 판정을 건너뛴다', () => {
    const r = insertRow({ MEASURE: 'MKT_FCST', [M4_DAY]: 10, [OPEN_DAY]: 0 });
    expect(validateSaveRows([r], [M4_DAY, OPEN_DAY], '', undefined, 'M')).toBeNull();
  });
});
