import { describe, expect, it } from 'vitest';

import { UPLOAD_HEADERS } from '../forecast-price.constants';

import {
  buildExcelFormColumns,
  buildExcelFormRows,
  dedupeHeader,
  MONTH_TOKENS,
  pickResultCursor,
  stripStar,
  UPLOAD_TOKEN_BY_COL,
} from './forecast-price.excelForm';

const meta = [
  { colNm: 'DIVISION_ID', colLblNm: 'Division*' },
  { colNm: 'END_CUSTOMER', colLblNm: 'End Customer*' },
  { colNm: 'SCM_SITE_ID', colLblNm: 'Sales Site*' },
  { colNm: 'MEASURE', colLblNm: 'Measure*' },
  { colNm: 'TEAM_ID', colLblNm: 'Team' },
  { colNm: 'TEAM_NAME_KO', colLblNm: 'Team' }, // ⚠ 실측 중복 라벨
  { colNm: 'ITEM_NAME', colLblNm: 'Model Name' },
  { colNm: 'HIDDEN_COL', colLblNm: 'Hidden', display: false },
];

describe('buildExcelFormColumns', () => {
  const cols = buildExcelFormColumns(meta);
  const headers = cols.map(c => c.header);

  it('업로드 토큰은 HEADER_CONTENT 원형 문자열을 헤더로 쓴다 (라벨의 * 를 쓰면 매핑이 깨진다)', () => {
    expect(headers).toContain('Div');
    expect(headers).toContain('End Customer');
    expect(headers).toContain('Sales Site');
    expect(headers).toContain('Measure');
    expect(headers).not.toContain('Division*');
    expect(headers).not.toContain('End Customer*');
  });

  it('M4~M16 이 말미에 붙고 UPLOAD_HEADERS 의 월 토큰과 일치한다', () => {
    expect(headers.slice(-13)).toEqual([...MONTH_TOKENS]);
    expect(MONTH_TOKENS.every(m => (UPLOAD_HEADERS as readonly string[]).includes(m))).toBe(true);
  });

  it('display=false 컬럼은 제외한다', () => {
    expect(headers).not.toContain('Hidden');
  });

  it('중복 라벨(Team/Team)은 결정적으로 유일화된다', () => {
    expect(headers).toContain('Team');
    expect(headers).toContain('Team (TEAM_NAME_KO)');
  });

  it('헤더 중복이 0 — 중복이 있으면 BE 가 뒤 컬럼으로 앞을 덮어쓴다', () => {
    expect(new Set(headers).size).toBe(headers.length);
  });

  it('토큰 매핑표는 업로드 필수 10컬럼을 덮는다', () => {
    expect(Object.keys(UPLOAD_TOKEN_BY_COL)).toHaveLength(10);
    Object.values(UPLOAD_TOKEN_BY_COL).forEach(tok =>
      expect(UPLOAD_HEADERS as readonly string[]).toContain(tok)
    );
  });
});

describe('buildExcelFormRows', () => {
  const cols = buildExcelFormColumns(meta);

  it('월 컬럼은 항상 빈칸 (입력 전용 — 사용자 확정)', () => {
    const [row] = buildExcelFormRows([{ DIVISION_ID: '40', M4: 999 }], cols);
    MONTH_TOKENS.forEach(m => expect(row[m]).toBe(''));
  });

  it('SP 값을 그대로 쓴다 (콤보 변환 없음 — SP 가 이미 검증 기대 표기로 내려준다)', () => {
    const [row] = buildExcelFormRows(
      [{ DIVISION_ID: '40', END_CUSTOMER: 'Dyson', MEASURE: 'Unit Price(LOC)' }],
      cols
    );
    expect(row.DIVISION_ID).toBe('40');
    expect(row.END_CUSTOMER).toBe('Dyson');
    expect(row.MEASURE).toBe('Unit Price(LOC)');
  });

  it('BE 가 생략한 NULL 컬럼은 빈 문자열로 채운다', () => {
    const [row] = buildExcelFormRows([{ DIVISION_ID: '40' }], cols);
    expect(row.ITEM_NAME).toBe('');
    expect(row.TEAM_ID).toBe('');
  });

  it('컬럼이 없으면 빈 행을 만든다 (메타 미적재 방어)', () => {
    expect(buildExcelFormRows([{ A: 1 }], [])).toEqual([{}]);
  });
});

describe('보조 함수', () => {
  it('stripStar 는 필수 표기만 떼고 내부 문자는 보존한다', () => {
    expect(stripStar('End Customer*')).toBe('End Customer');
    expect(stripStar('A*B')).toBe('A*B');
  });

  it('dedupeHeader 는 결정적이다', () => {
    const used = new Set(['Team']);
    expect(dedupeHeader('Team', 'TEAM_NAME_KO', used)).toBe('Team (TEAM_NAME_KO)');
    used.add('Team (TEAM_NAME_KO)');
    expect(dedupeHeader('Team', 'TEAM_NAME_KO', used)).toBe('Team (TEAM_NAME_KO)#2');
  });

  it('pickResultCursor 는 RESULT_CODE/CODE 겸용 판정', () => {
    expect(pickResultCursor(undefined).ok).toBe(true);
    expect(pickResultCursor({ RESULT_CODE: '0' }).ok).toBe(true);
    expect(pickResultCursor({ CODE: '0' }).ok).toBe(true);
    const ng = pickResultCursor({ RESULT_CODE: '1', RESULT_MSG: 'NOT_SAVABLE' });
    expect(ng.ok).toBe(false);
    expect(ng.message).toBe('NOT_SAVABLE');
  });
});
