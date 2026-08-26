import { describe, expect, it } from 'vitest';

import dayjs from '@foundation/dayjs';

import { MSG, TAB_INDEX } from '../project-master.constants';
import type { SearchCondition, Tab1Row, Tab2Row } from '../project-master.types';

import {
  defaultRegCompRange,
  toCancelPayload,
  toConfirmPayload,
  toDisplayDate,
  toMultiParam,
  toSaveTab2Payload,
  toSopDateParam,
  validateSearch,
  ymdToDash,
} from './project-master.validate';

// ⭐ SDM5010 조회 검증·파라미터 순수함수 — P-01(Division MSG00097)/P-02(기간 필수·역전 MSG00108)/
//   P-03(3년 초과 MSG00164)/F-3(TAB1 조회조건 미소비)/UC-06(멀티 콤마·'ALL')/payload 3종(계약 ①).

const sc = (over: Partial<SearchCondition> = {}): SearchCondition => ({
  divisionId: '81',
  endCustomers: [],
  cellTypes: [],
  bizTypes: [],
  developStatuses: [],
  regCompDateFr: '20260701',
  regCompDateTo: '20260819',
  ...over,
});

describe('validateSearch — P-01/P-02/P-03 (TAB2 축)', () => {
  it('정상 조건 = ok', () => {
    expect(validateSearch(sc(), TAB_INDEX.TAB2)).toEqual({ ok: true });
  });

  it('F-3: TAB1 = 조회조건 미소비 — 항상 ok (Session 기반 재조회만)', () => {
    expect(validateSearch(sc({ divisionId: '', regCompDateFr: '' }), TAB_INDEX.TAB1)).toEqual({
      ok: true,
    });
  });

  it('P-01: division 미선택 = MSG00097 (기간보다 선행 판정)', () => {
    const v = validateSearch(sc({ divisionId: '' }), TAB_INDEX.TAB2);
    expect(v.ok).toBe(false);
    expect(v.msgId).toBe(MSG.DIVISION_REQUIRED);
  });

  it('P-02: 기간 필수 — 빈 값(한쪽/양쪽) = MSG00108 (개요 E18 필수 Y)', () => {
    expect(validateSearch(sc({ regCompDateFr: '' }), TAB_INDEX.TAB2).msgId).toBe(MSG.DATE_INVERTED);
    expect(
      validateSearch(sc({ regCompDateFr: '', regCompDateTo: '' }), TAB_INDEX.TAB2).msgId
    ).toBe(MSG.DATE_INVERTED);
  });

  it('P-02: 역전(시작 > 종료) = MSG00108', () => {
    const v = validateSearch(
      sc({ regCompDateFr: '20260820', regCompDateTo: '20260819' }),
      TAB_INDEX.TAB2
    );
    expect(v.msgId).toBe(MSG.DATE_INVERTED);
  });

  it('P-03: 3년 초과 = MSG00164 / 정확 3년 = ok (경계 포함)', () => {
    expect(
      validateSearch(sc({ regCompDateFr: '20230701', regCompDateTo: '20260702' }), TAB_INDEX.TAB2)
        .msgId
    ).toBe(MSG.RANGE_OVER_3Y);
    expect(
      validateSearch(sc({ regCompDateFr: '20230701', regCompDateTo: '20260701' }), TAB_INDEX.TAB2)
        .ok
    ).toBe(true);
  });
});

describe('파라미터 순수함수 — UC-06/CF-09/E01-2', () => {
  it('toMultiParam: 빈 배열 = "ALL" 센티널 / 값 = 콤마 연결 (빈 요소 소거)', () => {
    expect(toMultiParam([])).toBe('ALL');
    expect(toMultiParam(['A', '', 'B'])).toBe('A,B');
  });

  it("ymdToDash: yyyymmdd → 'YYYY-MM-DD' / 비형식 = ''", () => {
    expect(ymdToDash('20260819')).toBe('2026-08-19');
    expect(ymdToDash('2026-08')).toBe('');
  });

  it("toSopDateParam: 임의 날짜 표현 → 'YYYY-MM-DD 00:00:00' / 빈 값 = '' ('-' 센티널 금지)", () => {
    expect(toSopDateParam('20261001')).toBe('2026-10-01 00:00:00');
    expect(toSopDateParam('2026-10-01T00:00:00')).toBe('2026-10-01 00:00:00');
    expect(toSopDateParam('')).toBe('');
    expect(toSopDateParam(null)).toBe('');
  });

  it("toDisplayDate: DATE 원형 → 'YYYY.MM.DD' / 파싱 불가 = 원문 유지", () => {
    expect(toDisplayDate('2026-08-19T00:00:00')).toBe('2026.08.19');
    expect(toDisplayDate('n/a')).toBe('n/a');
  });

  it('defaultRegCompRange: YMD_FR 앵커 = fr 그대로 + to = Today (dayjs 병행 — E01-2)', () => {
    const r = defaultRegCompRange('20260701');
    expect(r.fr).toBe('20260701');
    expect(r.to).toBe(dayjs().format('YYYYMMDD'));
  });

  it('defaultRegCompRange: 앵커 미수신 = 클라이언트 전월 1일 폴백', () => {
    const r = defaultRegCompRange(undefined);
    expect(r.fr).toBe(dayjs().subtract(1, 'month').startOf('month').format('YYYYMMDD'));
  });
});

describe('payload 빌더 — 계약 ① (PROC_M COL_NM · sesUserId BE주입 제외)', () => {
  const tab1Row = (over: Record<string, unknown> = {}): Tab1Row =>
    ({
      DPJT_KEY: 'PJT001_000002',
      DPJT_CODE: 'MC2501',
      DPJT_SEQ: 2,
      DPJT_KEY_PARENT: 'PJT001_000001',
      DIVISION_ID: '81',
      DPJT_CLASS: 'CLASS_A',
      END_CUSTOMER: 'EC01',
      DPJT_NAME: 'Test Project',
      CELL_TYPE: 'ALS',
      STACK_METHOD: 'STK',
      BIZ_TYPE: 'CELL',
      SOP_DATE: '2026-10-01T00:00:00',
      SOP_PLANT_ID: 'PLT1',
      NOTE: 'memo',
      ...over,
    }) as unknown as Tab1Row;

  it('toConfirmPayload: 14키 — 키 4종 커서 실값 + 편집값 9종 + sopDate 변환 + note (E05→E06)', () => {
    expect(toConfirmPayload(tab1Row())).toEqual({
      dpjtKey: 'PJT001_000002',
      dpjtCode: 'MC2501',
      dpjtSeq: '2',
      dpjtKeyParent: 'PJT001_000001',
      divisionId: '81',
      dpjtClass: 'CLASS_A',
      endCustomer: 'EC01',
      dpjtName: 'Test Project',
      cellType: 'ALS',
      stackMethod: 'STK',
      bizType: 'CELL',
      sopDate: '2026-10-01 00:00:00',
      sopPlantId: 'PLT1',
      note: 'memo',
    });
  });

  it("toCancelPayload: 4키 — note = 현재 행 내용 전달 (P-10). NULL 필드 = ''", () => {
    expect(toCancelPayload(tab1Row({ NOTE: null, DPJT_KEY_PARENT: null }))).toEqual({
      divisionId: '81',
      dpjtKey: 'PJT001_000002',
      dpjtKeyParent: '',
      note: '',
    });
  });

  it("toSaveTab2Payload: 4키 — activeFlag 'M' 고정(P-13) + disabled 서버 문자열 그대로(계약 ⑥)", () => {
    const row = {
      DPJT_KEY: 'PJT001_000001',
      DPJT_DEVELOP_STATUS: 'DEV',
      DISABLE_YN: 'CHECKED',
    } as unknown as Tab2Row;
    expect(toSaveTab2Payload(row)).toEqual({
      activeFlag: 'M',
      dpjtKey: 'PJT001_000001',
      dpjtDevelopStatus: 'DEV',
      disabled: 'CHECKED',
    });
  });
});
