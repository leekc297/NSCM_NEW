import { describe, expect, it } from 'vitest';

import { buildBulkActionPayload, buildBulkSavePayload } from './bulk-save';

// ⭐ SPMS 표준 벌크 payload 계약 (SDM1010 확정 표준의 단일 원천 검증):
//   N행 → '^' 조인 1건 / 빈 값 = ' '(공백 센티널 — 빈 토큰 행밀림 방지) /
//   DATE 컬럼 = 'YYYY-MM-DD HH:mm:ss' / keys 외 필드는 '' 로 비운다.

interface Row extends Record<string, unknown> {
  CRUD_TYPE: string;
  DPJT_KEY: string;
  DIVISION_ID: string;
  SOP_DATE: string;
  DIVISION_NAME: string;
}

const row = (over: Partial<Row> = {}): Row => ({
  CRUD_TYPE: 'C',
  DPJT_KEY: 'TEMP_1_000001',
  DIVISION_ID: '81',
  SOP_DATE: '2026-10-01T00:00:00',
  DIVISION_NAME: '81 Automotive Battery',
  ...over,
});

describe('buildBulkSavePayload — 저장 표준 payload', () => {
  it('빈 rows = 빈 배열', () => {
    expect(buildBulkSavePayload([], ['DPJT_KEY'])).toEqual([]);
  });

  it('N행을 컬럼별 \'^\' 조인 1건으로 접는다', () => {
    const result = buildBulkSavePayload(
      [row(), row({ DPJT_KEY: 'TEMP_2_000001', DIVISION_ID: '82' })],
      ['CRUD_TYPE', 'DPJT_KEY', 'DIVISION_ID']
    );
    expect(result).toHaveLength(1);
    expect(result[0].CRUD_TYPE).toBe('C^C');
    expect(result[0].DPJT_KEY).toBe('TEMP_1_000001^TEMP_2_000001');
    expect(result[0].DIVISION_ID).toBe('81^82');
  });

  it('빈 값/null = \' \' 공백 센티널 (\'^\' 파서 빈 토큰 행밀림 방지 — \'\' 금지)', () => {
    const result = buildBulkSavePayload(
      [row({ DIVISION_ID: '' }), row({ DIVISION_ID: null as never })],
      ['DIVISION_ID']
    );
    expect(result[0].DIVISION_ID).toBe(' ^ ');
  });

  it('DATE 컬럼 = \'YYYY-MM-DD HH:mm:ss\' 변환 / 파싱 불가 값은 원문 유지', () => {
    const result = buildBulkSavePayload(
      [row(), row({ SOP_DATE: 'not-a-date' }), row({ SOP_DATE: '' })],
      ['SOP_DATE'],
      ['SOP_DATE']
    );
    expect(result[0].SOP_DATE).toBe('2026-10-01 00:00:00^not-a-date^ ');
  });

  it('keys 외 필드는 \'\' 로 비운다 (SP 미소비 값 Payload 노출 방지)', () => {
    const result = buildBulkSavePayload([row()], ['DPJT_KEY']);
    expect(result[0].DIVISION_NAME).toBe('');
    expect(result[0].SOP_DATE).toBe('');
  });
});

describe('buildBulkActionPayload — 버튼 액션 표준 payload', () => {
  it('빈 rows = 빈 배열', () => {
    expect(buildBulkActionPayload([], ['DPJT_KEY'])).toEqual([]);
  });

  it('키 컬럼만 \'^\' 조인, 나머지는 rows[0] 승계', () => {
    const result = buildBulkActionPayload(
      [row(), row({ DPJT_KEY: 'TEMP_2_000001', DIVISION_ID: '82', DIVISION_NAME: 'other' })],
      ['DIVISION_ID', 'DPJT_KEY']
    );
    expect(result).toHaveLength(1);
    expect(result[0].DIVISION_ID).toBe('81^82');
    expect(result[0].DPJT_KEY).toBe('TEMP_1_000001^TEMP_2_000001');
    expect(result[0].DIVISION_NAME).toBe('81 Automotive Battery');
    expect(result[0].CRUD_TYPE).toBe('C');
  });
});
