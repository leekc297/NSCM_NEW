// SCP0100 Global PSI Report — 단위테스트 (DoD B20 · 룰 17 9-Step ⑨).
//   대상 = 페이지 소유 순수 함수(그리드/React 미의존): 조회기간 초기값(planDayRange) + 동적 기간칼럼 파생(3SPAN 응답 행) + 상수 계약.
//   근거: AS-IS SetCalendar(.cs:1317) → GetDayRange "MONTH"(.cs:1409~1423) · GetPlanEndDate(.cs:2029~2052)
//   · GetSpdTitle(.cs:1322 3SPAN) → InitSpreadDateColumn(.cs:755~794 — M_/W_ 가시성·월>주 span).
//   vitest 환경(features/supply/vitest.config.ts) include 는 src/**/*.test.ts 라 이 파일은 명시 경로로 실행한다(B20 명명 __tests__/*.spec.ts).
import { describe, expect, it } from 'vitest';

import type { RawFlexGridColumnConfig } from '@foundation/models';

import {
  BUCKET_CODE,
  MEASURE_NAME_BG,
  MSG,
  PAST_INVENTORY_MEASURES,
  PLAN_END_COL,
  PLAN_END_COMBO_ID,
  PLAN_END_DIVISION,
} from '../global-psi-report.constants';
import { isStartAfterPlan, planDayRange } from '../utils/globalPsiReportCalendar';
import {
  applySearchLevelLayout,
  buildPivotColumns,
  planStartWeekBinding,
  toCalendarCols,
} from '../utils/globalPsiReportColumns';

// 3SPAN(PKG_SCP0100.P_SCP0100_GET_SHEET_CALENDAR_3SPAN) o_rc1 — 사내 ZIOUI1 실측(2026-10-20, '20260928'~'20261018' 호출) 6행 전부.
const CALENDAR: Record<string, unknown>[] = [
  { COLUMN_NAME: 'M_202609', COLUMN_LABEL_NAME: '2026-09', SMALL_CLASS_LABEL_NAME: '2026-09', LARGE_CLASS_LABEL_NAME: '2026-09', DAY_CODE: '20260928', SORT_ORDER_NO: '2026092802' },
  { COLUMN_NAME: 'W_202640A', COLUMN_LABEL_NAME: '202640A', SMALL_CLASS_LABEL_NAME: 'W40_A', LARGE_CLASS_LABEL_NAME: '2026-09', DAY_CODE: '20260928', SORT_ORDER_NO: '2026092821' },
  { COLUMN_NAME: 'M_202610', COLUMN_LABEL_NAME: '2026-10', SMALL_CLASS_LABEL_NAME: '2026-10', LARGE_CLASS_LABEL_NAME: '2026-10', DAY_CODE: '20261001', SORT_ORDER_NO: '2026100102' },
  { COLUMN_NAME: 'W_202640B', COLUMN_LABEL_NAME: '202640B', SMALL_CLASS_LABEL_NAME: 'W40_B', LARGE_CLASS_LABEL_NAME: '2026-10', DAY_CODE: '20261001', SORT_ORDER_NO: '2026100121' },
  { COLUMN_NAME: 'W_202641', COLUMN_LABEL_NAME: '202641', SMALL_CLASS_LABEL_NAME: 'W41', LARGE_CLASS_LABEL_NAME: '2026-10', DAY_CODE: '20261005', SORT_ORDER_NO: '2026100521' },
  { COLUMN_NAME: 'W_202642', COLUMN_LABEL_NAME: '202642', SMALL_CLASS_LABEL_NAME: 'W42', LARGE_CLASS_LABEL_NAME: '2026-10', DAY_CODE: '20261012', SORT_ORDER_NO: '2026101221' },
];

describe('SCP0100 planDayRange — AS-IS SetCalendar / GetDayRange "MONTH"(.cs:1409~1423)', () => {
  it('TC-SCP0100-001 [조회조건] 시작 = Plan Date YYYYMM + 01, 종료 = HORIZON_END_DATE', () => {
    // 사내 SCM_MST_PLAN 81/WEEKLY 실측: PLAN_NAME 20260928 → HORIZON_END_DATE 20270926
    expect(planDayRange('20260928', '20270926')).toEqual({
      fromYyyymmdd: '20260901',
      toYyyymmdd: '20270926',
    });
  });

  it('TC-SCP0100-002 [조회조건] 종료일 없음(0행) → null = 기간 유지 (UsrDateRangePicker3.InitValue("") 무변경)', () => {
    expect(planDayRange('20260928', '')).toBeNull();
    expect(planDayRange('20260928', '   ')).toBeNull();
  });

  it('TC-SCP0100-003 [조회조건] Plan Date 없음 → null (GetPlanDateYearMonth 산출 불가)', () => {
    expect(planDayRange('', '20270926')).toBeNull();
  });

  it('TC-SCP0100-004 [조회조건] 종료일 원천 계약 — 등록 콤보 SCPPlanPeriod_SCP · division 81 고정(.cs:2038) · HORIZON_END_DATE', () => {
    expect(PLAN_END_COMBO_ID).toBe('SCPPlanPeriod_SCP');
    expect(PLAN_END_DIVISION).toBe('81');
    expect(PLAN_END_COL).toBe('HORIZON_END_DATE');
  });
});

describe('SCP0100 동적 기간칼럼 — AS-IS InitSpreadDateColumn ← GetSpdTitle(3SPAN)(.cs:755~794)', () => {
  it('TC-SCP0100-005 [그리드] 3SPAN 행은 SORT_ORDER_NO 순으로 기간칼럼 메타가 된다', () => {
    expect(toCalendarCols(CALENDAR).map(c => c.columnName)).toEqual([
      'M_202609',
      'W_202640A',
      'M_202610',
      'W_202640B',
      'W_202641',
      'W_202642',
    ]);
  });

  it('TC-SCP0100-006 [그리드] Monthly = M_ 만, 월(LARGE) 그룹 아래 leaf 폭 70·n0·읽기전용', () => {
    const groups = buildPivotColumns(toCalendarCols(CALENDAR), BUCKET_CODE.MONTHLY);
    expect(groups.map(g => g.header)).toEqual(['2026-09', '2026-10']);
    const leaf = groups[0].columns?.[0].columns?.[0];
    expect(leaf?.binding).toBe('M_202609');
    expect(leaf?.width).toBe(70);
    expect(leaf?.format).toBe('n0');
    expect(leaf?.isReadOnly).toBe(true);
  });

  it('TC-SCP0100-007 [그리드] Weekly = W_ 만, 월>주 2단 span (W40_A 는 9월, W40_B·W41·W42 는 10월)', () => {
    const groups = buildPivotColumns(toCalendarCols(CALENDAR), BUCKET_CODE.WEEKLY);
    expect(groups.map(g => g.header)).toEqual(['2026-09', '2026-10']);
    expect(groups[0].columns?.map(c => c.header)).toEqual(['W40_A']);
    expect(groups[1].columns?.map(c => c.header)).toEqual(['W40_B', 'W41', 'W42']);
    expect(groups[1].columns?.[0].columns?.[0].binding).toBe('W_202640B');
  });

  it('TC-SCP0100-008 [그리드] pivot 접두(M_/W_/B_)가 아닌 행은 제외, B_ 는 가시 컬럼에서 빠진다', () => {
    const cols = toCalendarCols([
      ...CALENDAR,
      { COLUMN_NAME: 'X_202610', SORT_ORDER_NO: '1' },
      { COLUMN_NAME: 'B_202610', COLUMN_LABEL_NAME: 'BOH', LARGE_CLASS_LABEL_NAME: '2026-10', SORT_ORDER_NO: '2026100103' },
    ]);
    expect(cols.some(c => c.columnName === 'X_202610')).toBe(false);
    const bindings = buildPivotColumns(cols, BUCKET_CODE.MONTHLY).flatMap(g =>
      (g.columns ?? []).flatMap(s => (s.columns ?? [s]).map(l => l.binding))
    );
    expect(bindings).toEqual(['M_202609', 'M_202610']);
  });

  it('TC-SCP0100-009 [그리드] WEEKLY 과거구간 기준주 = Plan 시작일과 DAY_CODE 가 같은 W_ 컬럼(M_ 행 제외, .cs:999)', () => {
    const cols = toCalendarCols(CALENDAR);
    // 20260928 은 M_202609 와 W_202640A 둘 다의 DAY_CODE — 기준주는 W_ 행에서 찾는다.
    expect(planStartWeekBinding(cols, '20260928')).toBe('W_202640A');
    expect(planStartWeekBinding(cols, '20261005')).toBe('W_202641');
    expect(planStartWeekBinding(cols, '20990101')).toBe('');
  });
});

// SetLayout(.cs:1490-1542) — Search Level 별 Product Level 표시. 메타 3컬럼 + 기타 1컬럼으로 판정.
const LEVEL_COLS: RawFlexGridColumnConfig[] = ['CELL_GROUP', 'PRODUCT_LEVEL1', 'PRODUCT_LEVEL2', 'PRODUCT_LEVEL3'].map(
  colNm => ({ colNm, colLblNm: colNm, visible: true })
);
const visibleOf = (cols: RawFlexGridColumnConfig[]) => cols.filter(c => c.visible !== false).map(c => c.colNm);

describe('SCP0100 SetLayout — Search Level 별 Product Level 표시(.cs:1490-1542)', () => {
  it('TC-SCP0100-010 [그리드] CELL_GROUP(default) = Product Level 1~3 전부 숨김', () => {
    expect(visibleOf(applySearchLevelLayout(LEVEL_COLS, 'CELL_GROUP', false))).toEqual(['CELL_GROUP']);
  });

  it('TC-SCP0100-011 [그리드] CELL_GROUP_DETAIL=L1·L2 / PRODUCT_LEVEL1=L1 / PRODUCT_LEVEL2=L2 / PRODUCT_LEVEL3=L1·L2·L3', () => {
    expect(visibleOf(applySearchLevelLayout(LEVEL_COLS, 'CELL_GROUP_DETAIL', false))).toEqual([
      'CELL_GROUP',
      'PRODUCT_LEVEL1',
      'PRODUCT_LEVEL2',
    ]);
    expect(visibleOf(applySearchLevelLayout(LEVEL_COLS, 'PRODUCT_LEVEL1', false))).toEqual(['CELL_GROUP', 'PRODUCT_LEVEL1']);
    expect(visibleOf(applySearchLevelLayout(LEVEL_COLS, 'PRODUCT_LEVEL2', false))).toEqual(['CELL_GROUP', 'PRODUCT_LEVEL2']);
    expect(visibleOf(applySearchLevelLayout(LEVEL_COLS, 'PRODUCT_LEVEL3', false))).toEqual([
      'CELL_GROUP',
      'PRODUCT_LEVEL1',
      'PRODUCT_LEVEL2',
      'PRODUCT_LEVEL3',
    ]);
  });

  it('TC-SCP0100-012 [그리드] Detail 모드 = 사용자 정의 컬럼 기준(변경 없음)', () => {
    expect(applySearchLevelLayout(LEVEL_COLS, 'CELL_GROUP', true)).toBe(LEVEL_COLS);
  });
});

describe('SCP0100 SetBackColor / 기간 검증 계약', () => {
  it('TC-SCP0100-013 [그리드] 배경색 키 = SHEET_MEASURE 실측 명칭(.cs:922-940) — 공백·괄호 포함', () => {
    for (const name of ['VMI Inventory', 'Char. Available', 'Form. Progress', 'Cell Inventory(Pack)', 'DIO', 'RTF', 'Production(PKG)']) {
      expect(MEASURE_NAME_BG[name]).toBeTruthy();
    }
    expect(MEASURE_NAME_BG.VMI).toBeUndefined();
  });

  it('TC-SCP0100-014 [그리드] WEEKLY 과거재고 은색 대상 = case 7종(.cs:1055-1061), AS/Cell Inventory(Pack) 제외', () => {
    expect(PAST_INVENTORY_MEASURES.size).toBe(7);
    expect(PAST_INVENTORY_MEASURES.has('AS Inventory')).toBe(false);
    expect(PAST_INVENTORY_MEASURES.has('Cell Inventory(Pack)')).toBe(false);
  });

  it('TC-SCP0100-015 [조회조건] 시작일 > Plan 시작일만 위반(.cs:2013) · 메시지 MSG01186', () => {
    expect(isStartAfterPlan('20261001', '20260928')).toBe(true);
    expect(isStartAfterPlan('20260928', '20260928')).toBe(false);
    expect(isStartAfterPlan('20260901', '20260928')).toBe(false);
    expect(isStartAfterPlan('', '20260928')).toBe(false);
    expect(MSG.PLAN_DATE_RANGE).toBe('MSG01186');
  });
});
