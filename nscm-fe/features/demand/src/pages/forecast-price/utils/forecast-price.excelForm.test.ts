/**
 * DMF0082 Excel Form(양식) 월 토큰(M0~M12)·빈칸 규약 회귀 테스트. [E20260907-XLSMONTH]
 *
 * 요구 원천(2026-09-07 현업 버그): 양식 기간이 주간(SP WEEK_LIST)으로 조회되던 것을 월간으로,
 *   AS-IS DMF0020(M0~M12 = 당월~+12) 파리티. 사용자 결정 2026-09-07.
 * ⭐ 업로드 저장 계약: 파일 기간 헤더는 반드시 'M0'..'M12' 원형이어야 한다 — 저장 SP
 *   (P_DMF0082_GET_EXCEL_UPLOAD_DATA)가 HEADER_CONTENT('...|M0|..|M12')로 ATTRIBUTE 에 위치 매핑하고,
 *   월 창(당월 ~ 당월+12)에 M0→당월 ... M12→당월+12 를 붙여 적재한다. 날짜 헤더는 이 매핑을 깨
 *   NO_TARGET_ROW 로 실패한다(2026-08-20 주간 회귀의 뿌리).
 */
import { describe, expect, it } from 'vitest';

import {
  buildExcelFormColumns,
  buildExcelFormRows,
  MONTH_TOKENS,
  monthTokenLabel,
} from './forecast-price.excelForm';

describe('MONTH_TOKENS / monthTokenLabel — M0~M12 = 당월 ~ 당월+12', () => {
  it('M0~M12 13개월 토큰을 순서대로 제공한다', () => {
    expect(MONTH_TOKENS).toEqual([
      'M0',
      'M1',
      'M2',
      'M3',
      'M4',
      'M5',
      'M6',
      'M7',
      'M8',
      'M9',
      'M10',
      'M11',
      'M12',
    ]);
  });

  it('M{n} 라벨 = 당월 +n 개월(YYYY-MM). 예: 2026-09 기준 M0=2026-09, M12=2027-09', () => {
    const today = new Date(2026, 8, 7); // 2026-09
    expect(monthTokenLabel('M0', today)).toBe('2026-09');
    expect(monthTokenLabel('M1', today)).toBe('2026-10');
    expect(monthTokenLabel('M12', today)).toBe('2027-09');
  });

  it('연말 경계에서도 월이 올바르게 넘어간다', () => {
    const today = new Date(2026, 10, 15); // 2026-11
    expect(monthTokenLabel('M2', today)).toBe('2027-01'); // +2
    expect(monthTokenLabel('M12', today)).toBe('2027-11'); // +12
  });
});

describe('buildExcelFormColumns / buildExcelFormRows — M0~M12 컬럼·빈칸', () => {
  it('토큰 10 + 정보성 2 뒤에 M0~M12 (header=토큰 원형, isMonth) 13개가 붙는다', () => {
    const cols = buildExcelFormColumns();
    const monthCols = cols.filter(c => c.isMonth);
    expect(monthCols.map(c => c.header)).toEqual([...MONTH_TOKENS]);
    expect(cols.find(c => c.key === 'DIVISION_ID')?.header).toBe('Div');
    expect(cols.find(c => c.key === 'PROJECT_NAME')?.isMonth).toBe(false);
  });

  it('월 버킷 셀은 SP 값이 있어도 항상 빈칸, 토큰 셀은 SP 값을 싣는다', () => {
    const cols = buildExcelFormColumns();
    // SP 가 (구 방식으로) 월 컬럼 값을 내려도 무시하고 빈칸이어야 한다
    const out = buildExcelFormRows([{ DIVISION_ID: '81', M0: 12345 }], cols);
    expect(out[0].M0).toBe('');
    expect(out[0].DIVISION_ID).toBe('81');
  });
});
