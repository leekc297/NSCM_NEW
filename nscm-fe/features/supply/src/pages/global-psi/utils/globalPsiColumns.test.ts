import { describe, expect, it } from 'vitest';

import type { FlexGridColumnConfig } from '@foundation/models';

import { BUCKET_CODE } from '../global-psi.constants';

import { buildPivotColumns, type CalendarCol } from './globalPsiColumns';

// 2026-01 둘째 주(W_ ISO 2) 사흘 + 주 SUM + 월 SUM 의 최소 CALENDAR 세트.
//   D_: 2026-01-05(월)/06(화)/07(수) — ISO week 2. W_202601 02 = 주 SUM. M_202601 = 월 SUM.
const CAL: CalendarCol[] = [
  { columnName: 'M_202601', columnLabel: '2026-01', smallLabel: '', largeLabel: '2026-01', sortOrder: 1 },
  { columnName: 'W_20260102', columnLabel: 'W2', smallLabel: 'W2', largeLabel: '2026-01', sortOrder: 21 },
  { columnName: 'D_20260105', columnLabel: '05', smallLabel: 'W2', largeLabel: '2026-01', sortOrder: 31 },
  { columnName: 'D_20260106', columnLabel: '06', smallLabel: 'W2', largeLabel: '2026-01', sortOrder: 32 },
  { columnName: 'D_20260107', columnLabel: '07', smallLabel: 'W2', largeLabel: '2026-01', sortOrder: 33 },
];

const headers = (c: FlexGridColumnConfig): unknown =>
  c.columns ? { header: c.header, columns: c.columns.map(headers) } : c.header;

describe('buildPivotColumns — Shipment Plan Fix 형태(월>주>일, 롤업=SUM, SUM 맨 앞)', () => {
  it('Daily + chkSum: 월>주>일 3단, W_/M_ 롤업 leaf 헤더 = SUM, SUM 이 각 블록 맨 앞', () => {
    const cols = buildPivotColumns(CAL, BUCKET_CODE.DAILY, true);
    // 월 1개 그룹.
    expect(cols).toHaveLength(1);
    expect(cols[0].header).toBe('2026-01');

    const monthChildren = cols[0].columns ?? [];
    // 월 SUM 그룹이 맨 앞(label 'SUM'), 그 뒤 주 그룹 W2.
    expect(monthChildren[0].header).toBe('SUM');
    expect(monthChildren[1].header).toBe('W2');

    // 월 SUM 그룹의 leaf = M_ 롤업, 헤더 'SUM'.
    expect(monthChildren[0].columns?.map(l => l.header)).toEqual(['SUM']);
    expect(monthChildren[0].columns?.[0].binding).toBe('M_202601');

    // 주(W2) 그룹: 주 SUM(W_) leaf 가 맨 앞 'SUM', 그 뒤 일자 05/06/07.
    expect(monthChildren[1].columns?.map(l => l.header)).toEqual(['SUM', '05', '06', '07']);
    expect(monthChildren[1].columns?.[0].binding).toBe('W_20260102');
  });

  it('Daily (chkSum off): SUM 숨김 → 월>Wxx>일 3단 유지(일자 leaf 는 주 라벨과 달라 접지 않음, Ship Plan Fix 동일)', () => {
    const cols = buildPivotColumns(CAL, BUCKET_CODE.DAILY, false);
    // D_ 만 노출. 주 그룹(W2) leaf 가 일자(05/06/07)라 주 라벨과 안 맞아 2단 접기 미발동 → 월>주>일 유지.
    expect(headers(cols[0])).toEqual({
      header: '2026-01',
      columns: [{ header: 'W2', columns: ['05', '06', '07'] }],
    });
  });

  it('Weekly: W_ 만 → 월>Wxx>SUM 3단', () => {
    const cols = buildPivotColumns(CAL, BUCKET_CODE.WEEKLY, false);
    expect(headers(cols[0])).toEqual({
      header: '2026-01',
      columns: [{ header: 'W2', columns: ['SUM'] }],
    });
  });

  it('Monthly: M_ 만 → 월>SUM 2단', () => {
    const cols = buildPivotColumns(CAL, BUCKET_CODE.MONTHLY, false);
    expect(headers(cols[0])).toEqual({ header: '2026-01', columns: ['SUM'] });
  });
});
