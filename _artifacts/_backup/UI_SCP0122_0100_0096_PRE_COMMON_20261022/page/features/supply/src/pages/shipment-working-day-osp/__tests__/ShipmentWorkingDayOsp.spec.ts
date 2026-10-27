// SCP0096 Shipment Working Day (OSP) — 단위테스트 (DoD B20 · 룰 17 9-Step ⑨).
//   대상 = 페이지 소유 순수 함수(그리드/React 미의존): dynamic-columns 파생(3SPAN 응답 행) + 상수 계약.
//   근거: AS-IS GetSpdTitle(.cs:825-838 3SPAN) → InitSpreadDateColumn(.cs:169-245 — D_ 일자열·요일색 SAT/SUN·월/주 span) · SetReNumerCellType(.cs:163 — 0~7 정수)
//   · SaveData_Main(.cs:548-556 — SAVE 컬럼 순서) · TO-BE SCM_ADM_MSG_M 실측 코드(constants MSG).
//   vitest 환경(features/supply/vitest.config.ts) include 는 src/**/*.test.ts 라 이 파일은 명시 경로로 실행한다(B20 명명 __tests__/*.spec.ts).
import { describe, expect, it } from 'vitest';

import {
  DAY_CODE,
  DAY_COLUMN_WIDTH,
  HEADER_TOTAL_HEIGHT,
  INPUT_VALUE_SET,
  MEASURE_CONST,
  MSG,
  RESPONSE_SET,
  SAVE_KEYS,
  SHEETS,
  WTD_RANGE,
} from '../shipment-working-day-osp.constants';
import { buildDynDayColumns, buildDynSumColumns } from '../shipment-working-day-osp.dynamic-columns';
import type { CalendarColumnRow } from '../shipment-working-day-osp.types';

// 3SPAN(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN) o_rc1 행 — 사내 ZIOUI1 실측(2026-10-20, '20261020'~'20261108' 호출)에서
//   10-31(토)~11-02(월) 구간을 SORT_ORDER_NO 순 그대로 발췌 + 비정상 이름 1행(방어 확인용).
const row = (
  COLUMN_NAME: string,
  COLUMN_LABEL_NAME: string,
  SMALL_CLASS_LABEL_NAME: string,
  LARGE_CLASS_LABEL_NAME: string,
  DAY_CODE: string | null,
  SORT_ORDER_NO: string
): CalendarColumnRow => ({
  COLUMN_NAME,
  COLUMN_LABEL_NAME,
  SMALL_CLASS_LABEL_NAME,
  LARGE_CLASS_LABEL_NAME,
  DAY_CODE,
  SORT_ORDER_NO,
});
const CALENDAR: CalendarColumnRow[] = [
  row('D_20261031', '31', 'W44', '2026-10', 'SAT', '2026103131'),
  row('M_202611', '2026-11', '2026-11', '2026-11', null, '2026110101'),
  row('W_20261144', 'W44', 'W44', '2026-11', null, '2026110121'),
  row('D_20261101', '01', 'W44', '2026-11', 'SUN', '2026110131'),
  row('W_20261145', 'W45', 'W45', '2026-11', null, '2026110221'),
  row('D_20261102', '02', 'W45', '2026-11', 'MON', '2026110231'),
  row('D_2026110', '0', 'W45', '2026-11', 'MON', '2026110231'), // 비정상 이름(7자리) — 건너뛰어야 함
];

describe('SCP0096 dynamic-columns — AS-IS InitSpreadDateColumn ← GetSpdTitle(3SPAN) 파생(.cs:169-245)', () => {
  it('TC-SCP0096-001 [그리드] 3SPAN 행 중 D_yyyymmdd 만 일자열로, 응답 순서 그대로(W_/M_·비정상 이름 제외)', () => {
    const cols = buildDynDayColumns(CALENDAR);
    expect(cols.map(c => c.binding)).toEqual(['D_20261031', 'D_20261101', 'D_20261102']);
    expect(cols.map(c => c.yyyymmdd)).toEqual(['20261031', '20261101', '20261102']);
  });

  it('TC-SCP0096-002 [그리드] 일 leaf 라벨 = COLUMN_LABEL_NAME 그대로(앞 0 유지), 요일 = DAY_CODE (토=Blue/일=Red 근거 .cs:206-208)', () => {
    const [sat, sun, mon] = buildDynDayColumns(CALENDAR);
    expect(sat.dayLabel).toBe('31');
    expect(sat.dayCode).toBe(DAY_CODE.SAT);
    expect(sun.dayLabel).toBe('01');
    expect(sun.dayCode).toBe(DAY_CODE.SUN);
    expect(mon.dayCode).toBe('MON');
  });

  it('TC-SCP0096-003 [그리드] 월(대)·주(소) 라벨 = LARGE/SMALL_CLASS_LABEL_NAME 서버값(ISO 주차 W44/W45 — 클라 재계산 금지)', () => {
    const [sat, sun, mon] = buildDynDayColumns(CALENDAR);
    expect(sat.monthLabel).toBe('2026-10');
    expect(sun.monthLabel).toBe('2026-11');
    expect(sat.weekLabel).toBe('W44');
    expect(sun.weekLabel).toBe('W44'); // 월 경계를 걸친 같은 주 — Grid 가 월 그룹 안에서만 주차를 묶어 블록 2개가 된다(.cs:213-226)
    expect(mon.weekLabel).toBe('W45');
  });

  it('TC-SCP0096-004 [그리드] W_/M_ SUM 열 파생 — 종류·헤더 = COLUMN_LABEL_NAME. D_ 는 제외 (chkSum 비노출이라 표시는 항상 off)', () => {
    const sums = buildDynSumColumns(CALENDAR);
    expect(sums).toEqual([
      { binding: 'M_202611', kind: 'M', header: '2026-11' },
      { binding: 'W_20261144', kind: 'W', header: 'W44' },
      { binding: 'W_20261145', kind: 'W', header: 'W45' },
    ]);
  });

  it('TC-SCP0096-005 [그리드] 빈 메타면 빈 배열(조회 전 상태)', () => {
    expect(buildDynDayColumns([])).toEqual([]);
    expect(buildDynSumColumns([])).toEqual([]);
  });
});

describe('SCP0096 constants — SP/메시지 계약', () => {
  it('TC-SCP0096-006 [저장] SAVE_KEYS 순서 = PKG_SCP0096.P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP 위치 인자 1~8', () => {
    expect([...SAVE_KEYS]).toEqual([
      'divisionId',
      'plantSiteId',
      'yyyymmdd',
      'measure',
      'shipmentYn',
      'workingTimeDefault',
      'isSaveDefault',
      'userIdList',
    ]);
    expect(MEASURE_CONST).toBe('SHIPMENT WORKING DAY');
  });

  it('TC-SCP0096-007 [검증] WORKING_TIME_DEFAULT 범위 0~7 (AS-IS SetReNumerCellType .cs:163) · Input Value 는 Y/N', () => {
    expect(WTD_RANGE).toEqual({ MIN: 0, MAX: 7 });
    expect([...INPUT_VALUE_SET]).toEqual(['Y', 'N']);
  });

  it('TC-SCP0096-008 [검증] btnInput 요일별 분기 = cboDayWeek 코드.toUpperCase() 와 DAY_CODE 직접 비교 (AS-IS .cs:798)', () => {
    const mon = buildDynDayColumns(CALENDAR).filter(c => c.dayCode === 'Mon'.toUpperCase());
    expect(mon.map(c => c.binding)).toEqual(['D_20261102']);
  });

  it('TC-SCP0096-010 [그리드] 동적 헤더 원천 = 사내 배선 타이틀 시트 calendar 의 o_rc1(PROC_M OUT COL_NM) · 폭 50(.cs:203) · 헤더 총높이 48(#93)', () => {
    expect(SHEETS.CALENDAR).toBe('calendar');
    expect(RESPONSE_SET.CALENDAR).toBe('o_rc1');
    expect(Object.values(RESPONSE_SET)).not.toContain('o_rc1_columns');
    expect(DAY_COLUMN_WIDTH).toBe(50);
    expect(HEADER_TOTAL_HEIGHT).toBe(48);
  });

  it('TC-SCP0096-009 [메시지] TO-BE SCM_ADM_MSG_M 실측 코드 — AS-IS 번호 그대로 쓰지 않는다(MSG00004/00135/00134/00050 금지)', () => {
    expect(MSG.SAVED_COUNT).toBe('MSG00672');
    expect(MSG.NOT_SEARCHED).toBe('MSG00662');
    expect(MSG.NOT_EDIT_MODE).toBe('MSG01154');
    expect(MSG.NO_CELL_SELECTED).toBe('MSG01153');
    expect(MSG.DIVISION_REQUIRED).toBe('MSG00097');
    expect(MSG.INVALID_PERIOD).toBe('MSG00108');
    const forbidden = new Set(['MSG00004', 'MSG00135', 'MSG00134', 'MSG00050']);
    expect(Object.values(MSG).some(code => forbidden.has(code))).toBe(false);
  });
});
