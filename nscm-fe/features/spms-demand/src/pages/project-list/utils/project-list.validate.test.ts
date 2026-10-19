import { describe, expect, it } from 'vitest';

import { MSG } from '../project-list.constants';
import type { MainRow, SearchCondition } from '../project-list.types';

import {
  defaultRegCompDates,
  toBulkReqPayload,
  toDisplayDate,
  toMultiParam,
  toReqPayload,
  toSopDateParam,
  validateSearch,
  ymdToDash,
} from './project-list.validate';

// ⭐ SDM1020 조회 검증·파라미터 순수함수 — P-09(Division 필수 MSG00097)/P-10(등록 완료일 필수·역전
//   MSG00108)/UC-06(멀티 콤마·'ALL' 센티널)/toReqPayload(BTN_REQ 13키 단건 계약 — D4 'M' 행 승계).

const sc = (over: Partial<SearchCondition> = {}): SearchCondition => ({
  divisionId: '81',
  endCustomers: 'ALL',
  dpjtAuthTypes: 'ALL',
  dpjtRegStatuses: 'ALL',
  regCompDateFr: '20260701',
  regCompDateTo: '20260819',
  ...over,
});

describe('validateSearch — P-09/P-10', () => {
  it('정상 조건 = ok', () => {
    expect(validateSearch(sc())).toEqual({ ok: true });
  });

  it('P-09: division 미선택 = MSG00097 (기간보다 선행 판정)', () => {
    const v = validateSearch(sc({ divisionId: '' }));
    expect(v.ok).toBe(false);
    expect(v.msgId).toBe(MSG.DIVISION_REQUIRED);
  });

  it('P-10: 등록 완료일 필수 — 빈 값(한쪽/양쪽) = MSG00108 (SDM1010 TAB2 와 달리 전체 조회 불허 — 개요 E17 Y)', () => {
    expect(validateSearch(sc({ regCompDateFr: '' })).msgId).toBe(MSG.DATE_INVERTED);
    expect(validateSearch(sc({ regCompDateTo: '' })).msgId).toBe(MSG.DATE_INVERTED);
    expect(validateSearch(sc({ regCompDateFr: '', regCompDateTo: '' })).msgId).toBe(
      MSG.DATE_INVERTED
    );
  });

  it('P-10: 시작일 > 종료일 = MSG00108', () => {
    const v = validateSearch(sc({ regCompDateFr: '20260820', regCompDateTo: '20260819' }));
    expect(v.ok).toBe(false);
    expect(v.msgId).toBe(MSG.DATE_INVERTED);
  });

  it('P-10: yyyymmdd 8자리 위반(축약) = MSG00108', () => {
    expect(validateSearch(sc({ regCompDateTo: '2026081' })).msgId).toBe(MSG.DATE_INVERTED);
  });
});

describe('toMultiParam — UC-06 (콤마 다중 · ALL 센티널)', () => {
  it('빈 선택 = "ALL" (SP 무필터 OR 단락)', () => {
    expect(toMultiParam('')).toBe('ALL');
    expect(toMultiParam('   ')).toBe('ALL');
  });

  it('선택값 = 콤마 연결 (UF_FX_STRING_SPLIT 테이블화 계약)', () => {
    expect(toMultiParam('A')).toBe('A');
    expect(toMultiParam('A,B,C')).toBe('A,B,C');
  });
});

describe('ymdToDash — 조회 SP TO_DATE(SUBSTR(p,1,10),"YYYY-MM-DD") 계약', () => {
  it('yyyymmdd → YYYY-MM-DD / 비정형 = ""', () => {
    expect(ymdToDash('20260819')).toBe('2026-08-19');
    expect(ymdToDash('')).toBe('');
    expect(ymdToDash('2026-08-19')).toBe('');
  });
});

describe('toSopDateParam / toDisplayDate — 날짜 변환', () => {
  it('SOP_DATE → "YYYY-MM-DD 00:00:00" (SP TO_DATE HH24:MI:SS 마스크) / 빈 값 = ""', () => {
    expect(toSopDateParam('20261001')).toBe('2026-10-01 00:00:00');
    expect(toSopDateParam('2026-10-01T00:00:00')).toBe('2026-10-01 00:00:00');
    expect(toSopDateParam('')).toBe('');
    expect(toSopDateParam(null)).toBe('');
  });

  it('표시 = YYYY.MM.DD (ISO 직렬화·yyyymmdd 양쪽) / 파싱 불가 = 원문 유지', () => {
    expect(toDisplayDate('2026-08-19T00:00:00')).toBe('2026.08.19');
    expect(toDisplayDate('20260819')).toBe('2026.08.19');
    expect(toDisplayDate('')).toBe('');
  });
});

describe('defaultRegCompDates — P-27 기본 M-1(한 달 전 같은 날)~Today', () => {
  it('fr = 오늘 - 1개월 / to = 오늘 (둘 다 yyyymmdd)', () => {
    const { fr, to } = defaultRegCompDates();
    expect(/^\d{8}$/.test(fr)).toBe(true);
    expect(/^\d{8}$/.test(to)).toBe(true);
    expect(fr < to).toBe(true);
  });
});

describe('toReqPayload — BTN_REQ 13키 단건 계약 (계약 ① · D4)', () => {
  const row = {
    CRUD_TYPE: 'M',
    DPJT_KEY: 'PJT2600001_000001',
    DPJT_CODE: 'PJT2600001',
    DPJT_SEQ: 1,
    DIVISION_ID: '81',
    DPJT_CLASS: 'CLASS_A',
    END_CUSTOMER: 'EC01',
    DPJT_NAME: 'Test Project',
    CELL_TYPE: 'ALS',
    STACK_METHOD: 'STK',
    BIZ_TYPE: 'CELL',
    SOP_DATE: '2026-10-01T00:00:00',
    SOP_PLANT_ID: 'PLT1',
  } as unknown as MainRow;

  it('PROC_M COL_NM 13키 — activeFlag = 행 CRUD_TYPE 승계("M") · sopDate 마스크 변환 · 키 실값', () => {
    expect(toReqPayload(row)).toEqual({
      activeFlag: 'M',
      dpjtKey: 'PJT2600001_000001',
      dpjtCode: 'PJT2600001',
      dpjtSeq: '1',
      divisionId: '81',
      dpjtClass: 'CLASS_A',
      endCustomer: 'EC01',
      dpjtName: 'Test Project',
      cellType: 'ALS',
      stackMethod: 'STK',
      bizType: 'CELL',
      sopDate: '2026-10-01 00:00:00',
      sopPlantId: 'PLT1',
    });
  });

  it('누락 필드 = "" (행 토큰 단계 — 벌크 접기에서 " " 센티널로 치환된다)', () => {
    const p = toReqPayload({ CRUD_TYPE: 'M' } as unknown as MainRow);
    expect(p.dpjtKey).toBe('');
    expect(p.sopDate).toBe('');
  });
});

describe('toBulkReqPayload — SPMS 표준 "^" 벌크 1건 (lib/bulk-save 승계)', () => {
  const row = (over: Record<string, unknown> = {}): MainRow =>
    ({
      CRUD_TYPE: 'M',
      DPJT_KEY: 'PJT2600001_000001',
      DPJT_CODE: 'PJT2600001',
      DPJT_SEQ: 1,
      DIVISION_ID: '81',
      DPJT_CLASS: 'CLASS_A',
      END_CUSTOMER: 'EC01',
      DPJT_NAME: 'Test Project',
      CELL_TYPE: 'ALS',
      STACK_METHOD: 'STK',
      BIZ_TYPE: 'CELL',
      SOP_DATE: '2026-10-01T00:00:00',
      SOP_PLANT_ID: 'PLT1',
      ...over,
    }) as unknown as MainRow;

  it('N행 = 키별 \'^\' 조인 1건 (SP REGEXP_SUBSTR 벌크 파서 계약)', () => {
    const p = toBulkReqPayload([row(), row({ DPJT_KEY: 'K2', DIVISION_ID: '82' })]);
    expect(p.activeFlag).toBe('M^M');
    expect(p.dpjtKey).toBe('PJT2600001_000001^K2');
    expect(p.divisionId).toBe('81^82');
    expect(p.sopDate).toBe('2026-10-01 00:00:00^2026-10-01 00:00:00');
  });

  it('빈 값 = " " 공백 센티널 — [^\\^]+ 빈 토큰 행밀림 방지', () => {
    const p = toBulkReqPayload([row({ SOP_DATE: '', END_CUSTOMER: null }), row()]);
    expect(p.sopDate).toBe(' ^2026-10-01 00:00:00');
    expect(p.endCustomer).toBe(' ^EC01');
  });

  it('단건 = 조인 없는 1행 문자열 (기존 단건 호출과 동일 형태 — SP 1행 호환)', () => {
    const p = toBulkReqPayload([row()]);
    expect(p.dpjtKey).toBe('PJT2600001_000001');
    expect(p.sopDate).toBe('2026-10-01 00:00:00');
  });
});
