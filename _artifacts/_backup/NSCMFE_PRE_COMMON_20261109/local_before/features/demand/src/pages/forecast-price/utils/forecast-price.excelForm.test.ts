/**
 * DMF0082 Excel Form(양식) 회귀 테스트.
 *   [E20260907-XLSMONTH] 월 토큰(M0~M12)·빈칸 규약
 *   [E20260921-XLSFORMASIS] 양식 컬럼 = admin 메타 주도 (AS-IS DMF0020 파리티)
 *
 * 요구 원천(2026-09-07 현업 버그): 양식 기간이 주간(SP WEEK_LIST)으로 조회되던 것을 월간으로,
 *   AS-IS DMF0020(M0~M12 = 당월~+12) 파리티. 사용자 결정 2026-09-07.
 * ⭐ 업로드 저장 계약: 파일 기간 헤더는 반드시 'M0'..'M12' 원형이어야 한다 — 저장 SP
 *   (P_DMF0082_GET_EXCEL_UPLOAD_DATA)가 HEADER_CONTENT('...|M0|..|M12')로 ATTRIBUTE 에 위치 매핑하고,
 *   월 창(당월 ~ 당월+12)에 M0→당월 ... M12→당월+12 를 붙여 적재한다. 날짜 헤더는 이 매핑을 깨
 *   NO_TARGET_ROW 로 실패한다(2026-08-20 주간 회귀의 뿌리).
 */
import { describe, expect, it } from 'vitest';

import type { RawFlexGridColumnConfig } from '@foundation/models';

import {
  buildExcelFormColumns,
  buildExcelFormRows,
  FALLBACK_TEMPLATE_COLUMNS,
  MONTH_TOKENS,
  monthTokenLabel,
  TEMPLATE_META_SHEET,
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

describe('buildExcelFormColumns — admin 메타 주도 (E20260921-XLSFORMASIS)', () => {
  /** admin `/admin/menu/DMF0082/column` (sheetNm='Sales Price Template') 응답 모사 —
   *  사내 실측 19행(Div/Team/End Customer/Project Code/Currency/Model + M0~M12). */
  const meta = (): RawFlexGridColumnConfig[] =>
    [
      { colNm: 'DIVISION_ID', colLblNm: 'Div', colWth: 50 },
      { colNm: 'DEPT_NAME', colLblNm: 'Team', colWth: 180 },
      { colNm: 'END_CUSTOMER', colLblNm: 'End Customer', colWth: 150 },
      { colNm: 'PROJECT_CODE', colLblNm: 'Project Code', colWth: 100 },
      { colNm: 'CURRENCY', colLblNm: 'Currency', colWth: 80 },
      { colNm: 'ITEM_ID', colLblNm: 'Model', colWth: 150 },
      ...MONTH_TOKENS.map(t => ({ colNm: t, colLblNm: t, colWth: 40 })),
    ] as RawFlexGridColumnConfig[];

  it('메타 시트명은 AS-IS DMF0020 원본명을 그대로 쓴다 (룰 #91 SHEET_NAME 불변)', () => {
    expect(TEMPLATE_META_SHEET).toBe('Sales Price Template');
  });

  it('메타 19행 그대로 19컬럼을 만들고 순서·헤더가 AS-IS HEADER_CONTENT 와 1:1', () => {
    const cols = buildExcelFormColumns(meta());
    expect(cols).toHaveLength(19);
    expect(cols.map(c => c.header).join('|')).toBe(
      'Div|Team|End Customer|Project Code|Currency|Model|M0|M1|M2|M3|M4|M5|M6|M7|M8|M9|M10|M11|M12'
    );
    // 행 객체 접근 키 = SP 커서 컬럼명
    expect(cols.slice(0, 6).map(c => c.key)).toEqual([
      'DIVISION_ID',
      'DEPT_NAME',
      'END_CUSTOMER',
      'PROJECT_CODE',
      'CURRENCY',
      'ITEM_ID',
    ]);
  });

  it('메타의 M0~M12 는 isMonth 로 판정된다 (구 컬럼은 아님)', () => {
    const cols = buildExcelFormColumns(meta());
    expect(cols.filter(c => c.isMonth).map(c => c.header)).toEqual([...MONTH_TOKENS]);
    expect(cols.find(c => c.key === 'DIVISION_ID')?.isMonth).toBe(false);
  });

  it('메타 폭(colWth)을 그대로 싣는다 — 미리보기 그리드 폭 원천', () => {
    const cols = buildExcelFormColumns(meta());
    expect(cols.find(c => c.key === 'DEPT_NAME')?.width).toBe(180);
    expect(cols.find(c => c.key === 'M0')?.width).toBe(40);
  });

  it('메타 미적재(빈 배열/undefined)면 폴백 6컬럼 + M0~M12 로 양식이 비지 않는다', () => {
    for (const arg of [undefined, null, [] as RawFlexGridColumnConfig[]]) {
      const cols = buildExcelFormColumns(arg);
      expect(cols).toHaveLength(FALLBACK_TEMPLATE_COLUMNS.length + MONTH_TOKENS.length);
      expect(cols.map(c => c.header).join('|')).toBe(
        'Div|Team|End Customer|Project Code|Currency|Model|M0|M1|M2|M3|M4|M5|M6|M7|M8|M9|M10|M11|M12'
      );
    }
  });

  it('메타에 월 컬럼이 없는 구 세대여도 M0~M12 를 보충한다', () => {
    const noMonth = meta().filter(m => !/^M\d+$/.test(String(m.colNm)));
    const cols = buildExcelFormColumns(noMonth);
    expect(cols.filter(c => c.isMonth).map(c => c.header)).toEqual([...MONTH_TOKENS]);
  });

  it('visible=false 메타 컬럼은 양식에서 제외한다', () => {
    const m = meta();
    m[2].visible = false; // End Customer
    const cols = buildExcelFormColumns(m);
    expect(cols.find(c => c.key === 'END_CUSTOMER')).toBeUndefined();
    expect(cols).toHaveLength(18);
  });
});

describe('buildExcelFormRows — M0~M12 는 조회해도 항상 빈칸', () => {
  it('SP 가 월 값을 내려도 무시하고 빈칸, 그 외 컬럼은 SP 값을 싣는다', () => {
    const cols = buildExcelFormColumns();
    // 구 SP(LOC 단가 프리필) 응답을 모사 — 사용자 지시 2026-09-21 "M0~M12 는 빈칸"
    const out = buildExcelFormRows([{ DIVISION_ID: '81', DEPT_NAME: '마케팅3팀', M0: 12345 }], cols);
    expect(out[0].M0).toBe('');
    expect(out[0].M12).toBe('');
    expect(out[0].DIVISION_ID).toBe('81');
    expect(out[0].DEPT_NAME).toBe('마케팅3팀');
  });
});
