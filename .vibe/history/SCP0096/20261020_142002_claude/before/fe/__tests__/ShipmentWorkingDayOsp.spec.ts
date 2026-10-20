// SCP0096 Shipment Working Day (OSP) — 단위테스트 (DoD B20 · 룰 17 9-Step ⑨).
//   대상 = 페이지 소유 순수 함수(그리드/React 미의존): dynamic-columns 파생 + 상수 계약.
//   근거: AS-IS InitSpreadDateColumn(.cs:166-243 — D_ 일자열·요일색 SAT/SUN·월/주 span) · SetReNumerCellType(.cs:163 — 0~7 정수)
//   · SaveData_Main(.cs:548-556 — SAVE 컬럼 순서) · TO-BE SCM_ADM_MSG_M 실측 코드(constants MSG).
//   vitest 환경(features/supply/vitest.config.ts) include 는 src/**/*.test.ts 라 이 파일은 명시 경로로 실행한다(B20 명명 __tests__/*.spec.ts).
import { describe, expect, it } from 'vitest';

import {
  INPUT_VALUE_SET,
  MEASURE_CONST,
  MSG,
  SAVE_KEYS,
  WEEKDAY_CODE_TO_INDEX,
  WTD_RANGE,
} from '../shipment-working-day-osp.constants';
import { buildDynDayColumns, buildDynSumColumns } from '../shipment-working-day-osp.dynamic-columns';
import type { DynColumnMeta } from '../shipment-working-day-osp.types';

// GET O_RC1 의 o_rc1_columns 사이드카 모양 — 정적 6 + D_ 일자(2026-10-31 금 ~ 2026-11-02 일) + SUM 열 + hidden B_
const META: DynColumnMeta[] = [
  { name: 'DIVISION_ID', type: 'VARCHAR2' },
  { name: 'PLANT_SITE_ID', type: 'VARCHAR2' },
  { name: 'PLANT_SITE_NAME', type: 'VARCHAR2' },
  { name: 'WORKING_TIME_DEFAULT', type: 'NUMBER' },
  { name: 'LAST_INPUT_DATE', type: 'VARCHAR2' },
  { name: 'MEASURE', type: 'VARCHAR2' },
  { name: 'D_20261031', type: 'VARCHAR2' },
  { name: 'D_20261101', type: 'VARCHAR2' },
  { name: 'D_20261102', type: 'VARCHAR2' },
  { name: 'W_202644', type: 'NUMBER' },
  { name: 'M_202611', type: 'NUMBER' },
  { name: 'B_20261102', type: 'VARCHAR2' },
  { name: 'D_2026110', type: 'VARCHAR2' }, // 비정상 alias(7자리) — 건너뛰어야 함
];

describe('SCP0096 dynamic-columns — AS-IS InitSpreadDateColumn 파생(.cs:166-243)', () => {
  it('TC-SCP0096-001 [그리드] D_yyyymmdd 만 일자열로 뽑고 정적·SUM·B_·비정상 alias 는 제외한다', () => {
    const cols = buildDynDayColumns(META);
    expect(cols.map(c => c.binding)).toEqual(['D_20261031', 'D_20261101', 'D_20261102']);
    expect(cols.map(c => c.yyyymmdd)).toEqual(['20261031', '20261101', '20261102']);
  });

  it('TC-SCP0096-002 [그리드] 일 leaf 라벨은 앞 0 제거한 일(DD), 요일은 0=일~6=토 (토=Blue/일=Red 근거 .cs:208)', () => {
    const [sat, sun, mon] = buildDynDayColumns(META);
    expect(sat.dayLabel).toBe('31');
    expect(sat.weekday).toBe(6); // 2026-10-31 토
    expect(sun.dayLabel).toBe('1');
    expect(sun.weekday).toBe(0); // 2026-11-01 일
    expect(mon.weekday).toBe(1); // 2026-11-02 월
  });

  it('TC-SCP0096-003 [그리드] 월(대)·주(소) 그룹 키 — 월이 바뀌면 monthKey 가 바뀌고 주차는 월 내 1~7일 단위', () => {
    const [sat, sun] = buildDynDayColumns(META);
    expect(sat.monthKey).toBe('202610');
    expect(sun.monthKey).toBe('202611');
    expect(sat.weekKey).toBe('202610-W5'); // 31일 → ceil(31/7)=5
    expect(sun.weekKey).toBe('202611-W1');
  });

  it('TC-SCP0096-004 [그리드] W_/M_ SUM 열 파생 — 종류·헤더(월은 yyyy-mm). D_/B_ 는 제외 (chkSum 비노출이라 표시는 항상 off)', () => {
    const sums = buildDynSumColumns(META);
    expect(sums).toEqual([
      { binding: 'W_202644', kind: 'W', header: '202644' },
      { binding: 'M_202611', kind: 'M', header: '2026-11' },
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

  it('TC-SCP0096-008 [검증] 요일 코드 → dayjs day() 인덱스 (btnInput 요일별 분기 .cs:797)', () => {
    expect(WEEKDAY_CODE_TO_INDEX).toEqual({ Sun: 0, Mon: 1, Tue: 2, Wed: 3, Thu: 4, Fri: 5, Sat: 6 });
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
