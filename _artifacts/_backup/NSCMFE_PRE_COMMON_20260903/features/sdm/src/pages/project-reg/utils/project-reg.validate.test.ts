import { describe, expect, it } from 'vitest';

import type { RawFlexGridColumnConfig } from '@foundation/models';

import { MSG, TAB_INDEX } from '../project-reg.constants';
import type { SearchCondition, Tab1Row } from '../project-reg.types';

import {
  toDisplayDate,
  toSavePayload,
  toSopDateParam,
  validateDuplicate,
  validateRequiredInsert,
  validateSearch,
} from './project-reg.validate';

// ⭐ SDM1010 조회/저장 FE 검증 순수함수 — P-01(division 필수)/P-02(기간)/P-03(TAB2 3년)
//   /P-04(IM 필수 MSG00113)/P-05(payload 내 논리키 중복 MSG00043) + toSavePayload(§2 단건 계약).

const sc = (over: Partial<SearchCondition> = {}): SearchCondition => ({
  divisionId: '40',
  endCustomer: 'ALL',
  dpjtAuthType: 'ALL',
  dpjtRegStatus: 'ALL',
  regCompDateFr: '20260701',
  regCompDateTo: '20260813',
  ...over,
});

describe('validateSearch — P-01/P-02/P-03', () => {
  it('정상 조건(TAB1/TAB2) = ok', () => {
    expect(validateSearch(sc(), TAB_INDEX.TAB1)).toEqual({ ok: true });
    expect(validateSearch(sc(), TAB_INDEX.TAB2)).toEqual({ ok: true });
  });

  it('P-01: TAB2 division 미선택 = MSG00097 (기간보다 선행 판정)', () => {
    const v = validateSearch(sc({ divisionId: '' }), TAB_INDEX.TAB2);
    expect(v.ok).toBe(false);
    expect(v.msgId).toBe(MSG.DIVISION_REQUIRED);
  });

  it('P-01/P-02: TAB1 = 조회조건 비노출(§1 본인 필터) — 무조건 ok (2026-08-13 전환)', () => {
    expect(validateSearch(sc({ divisionId: '' }), TAB_INDEX.TAB1)).toEqual({ ok: true });
    expect(
      validateSearch(sc({ regCompDateFr: '20260814', regCompDateTo: '20260813' }), TAB_INDEX.TAB1)
    ).toEqual({ ok: true });
  });

  it('P-02: TAB2 기간 둘 다 빈 값 = ok (전체 조회 — REG_COMP_DATE NULL 미완료 행 포함, 2026-08-13 실측 계약)', () => {
    expect(validateSearch(sc({ regCompDateFr: '', regCompDateTo: '' }), TAB_INDEX.TAB2)).toEqual({
      ok: true,
    });
  });

  it('P-02: TAB2 한쪽만 빈 값 = MSG00108 (§5 BETWEEN 한쪽 NULL = 0행 차단)', () => {
    expect(validateSearch(sc({ regCompDateFr: '' }), TAB_INDEX.TAB2).msgId).toBe(MSG.DATE_INVERTED);
    expect(validateSearch(sc({ regCompDateTo: '' }), TAB_INDEX.TAB2).msgId).toBe(MSG.DATE_INVERTED);
  });

  it('P-02: TAB2 시작일 > 종료일 = MSG00108', () => {
    const v = validateSearch(
      sc({ regCompDateFr: '20260814', regCompDateTo: '20260813' }),
      TAB_INDEX.TAB2
    );
    expect(v.ok).toBe(false);
    expect(v.msgId).toBe(MSG.DATE_INVERTED);
  });

  it('P-02: TAB2 yyyymmdd 8자리 위반(축약) = MSG00108', () => {
    expect(validateSearch(sc({ regCompDateTo: '2026081' }), TAB_INDEX.TAB2).msgId).toBe(
      MSG.DATE_INVERTED
    );
  });

  it('P-03: TAB2 만 3년 초과 차단 = MSG00715 (경계 3년 정각 = 허용)', () => {
    const over3y = { regCompDateFr: '20230101', regCompDateTo: '20260102' };
    const exact3y = { regCompDateFr: '20230101', regCompDateTo: '20260101' };
    const v = validateSearch(sc(over3y), TAB_INDEX.TAB2);
    expect(v.ok).toBe(false);
    expect(v.msgId).toBe(MSG.RANGE_OVER_3Y);
    expect(validateSearch(sc(exact3y), TAB_INDEX.TAB2)).toEqual({ ok: true });
    // TAB1 은 3년 게이트 미적용 (설계서 TAB2 한정)
    expect(validateSearch(sc(over3y), TAB_INDEX.TAB1)).toEqual({ ok: true });
  });
});

const col = (colNm: string, colLblNm?: string): RawFlexGridColumnConfig =>
  ({ colNm, colLblNm, inputTpCd: 'IM' }) as unknown as RawFlexGridColumnConfig;

const row = (over: Record<string, unknown> = {}): Tab1Row =>
  ({
    CRUD_TYPE: 'C',
    DPJT_KEY: '',
    DPJT_CODE: '',
    DPJT_SEQ: '',
    DIVISION_ID: '40',
    DPJT_CLASS: 'CLS1',
    DPJT_CLASS_NAME: 'Class 1',
    END_CUSTOMER: 'CUST1',
    DPJT_NAME: 'PJT-A',
    CELL_TYPE: 'CT1',
    STACK_METHOD: 'SM1',
    BIZ_TYPE: 'CELL',
    SOP_DATE: '',
    SOP_PLANT_ID: '',
    ...over,
  }) as unknown as Tab1Row;

describe('validateRequiredInsert — P-04 (IM 누락 = MSG00113 + 컬럼 라벨 detail)', () => {
  const required = [col('DPJT_CLASS_NAME', 'Project Class'), col('END_CUSTOMER', 'Customer'), col('DPJT_NAME', 'Project Name')];

  it('전 필수값 기입 = ok', () => {
    expect(validateRequiredInsert([row()], required)).toEqual({ ok: true });
  });

  it('IM 누락(빈 문자열) = MSG00113 + 누락 컬럼 라벨', () => {
    const v = validateRequiredInsert([row({ END_CUSTOMER: '' })], required);
    expect(v.ok).toBe(false);
    expect(v.msgId).toBe(MSG.REQUIRED_COLUMN);
    expect(v.detail).toBe('Customer');
  });

  it('공백만 입력·null 도 누락 판정 / 라벨 미등재 시 colNm fallback', () => {
    expect(validateRequiredInsert([row({ DPJT_NAME: '   ' })], required).msgId).toBe(
      MSG.REQUIRED_COLUMN
    );
    const v = validateRequiredInsert([row({ DPJT_CLASS_NAME: null })], [col('DPJT_CLASS_NAME')]);
    expect(v.ok).toBe(false);
    expect(v.detail).toBe('DPJT_CLASS_NAME');
  });

  it('신규행 0건·필수 컬럼 0건 = ok (검증 대상 없음)', () => {
    expect(validateRequiredInsert([], required)).toEqual({ ok: true });
    expect(validateRequiredInsert([row({ DPJT_NAME: '' })], [])).toEqual({ ok: true });
  });
});

describe('validateDuplicate — P-05 (논리키 DIVISION_ID+DPJT_CLASS+END_CUSTOMER+DPJT_NAME)', () => {
  it('payload 내 논리키 중복 = MSG00043', () => {
    const v = validateDuplicate([row(), row()]);
    expect(v.ok).toBe(false);
    expect(v.msgId).toBe(MSG.DUPLICATE);
  });

  it('논리키 1요소만 달라도 중복 아님', () => {
    expect(validateDuplicate([row(), row({ DPJT_NAME: 'PJT-B' })])).toEqual({ ok: true });
    expect(validateDuplicate([row(), row({ END_CUSTOMER: 'CUST2' })])).toEqual({ ok: true });
    expect(validateDuplicate([row(), row({ DPJT_CLASS: 'CLS2' })])).toEqual({ ok: true });
    expect(validateDuplicate([row(), row({ DIVISION_ID: '81' })])).toEqual({ ok: true });
  });

  it('삭제(\'D\') 행은 중복 판정 제외 — 삭제 후 동일키 재등록 허용', () => {
    expect(validateDuplicate([row({ CRUD_TYPE: 'D' }), row({ CRUD_TYPE: 'M' })])).toEqual({
      ok: true,
    });
  });
});

describe('toSavePayload — §2 SAVE 단건 payload (PROC_M COL_NM 13키 — sesUserId BE주입)', () => {
  it('신규 \'C\' → activeFlag \'I\' + 서버 채번 계약 (dpjtKey/dpjtCode \'\'·dpjtSeq \'1\' — §2 I)', () => {
    const p = toSavePayload(
      row({ DPJT_KEY: 'STALE', DPJT_CODE: 'STALE', DPJT_SEQ: '9', SOP_DATE: '' })
    );
    expect(p).toEqual({
      activeFlag: 'I',
      dpjtKey: '',
      dpjtCode: '',
      dpjtSeq: '1',
      divisionId: '40',
      dpjtClass: 'CLS1',
      endCustomer: 'CUST1',
      dpjtName: 'PJT-A',
      cellType: 'CT1',
      stackMethod: 'SM1',
      bizType: 'CELL',
      sopDate: '',
      sopPlantId: '',
    });
  });

  it('M/D = 커서 수신 DPJT_KEY·DPJT_CODE·DPJT_SEQ 실값 그대로 (빈 값 = 서버 가드 EVENT=0 — 2026-08-13 실측)', () => {
    const m = toSavePayload(
      row({
        CRUD_TYPE: 'M',
        DPJT_KEY: 'TEMP_X_000001',
        DPJT_CODE: 'TEMP_X',
        DPJT_SEQ: 1, // 커서 NUMBER 수신 대응
      })
    );
    expect(m.activeFlag).toBe('M');
    expect(m.dpjtKey).toBe('TEMP_X_000001');
    expect(m.dpjtCode).toBe('TEMP_X');
    expect(m.dpjtSeq).toBe('1');
    const d = toSavePayload(row({ CRUD_TYPE: 'D', DPJT_KEY: 'K', DPJT_CODE: 'C', DPJT_SEQ: '1' }));
    expect(d.activeFlag).toBe('D');
    expect(d.dpjtSeq).toBe('1');
  });

  it('sopDate = \'YYYY-MM-DD 00:00:00\' 변환 (§2 TO_DATE 마스크) — 에디터 표시 포맷·ISO·YYYYMMDD 전부', () => {
    expect(toSavePayload(row({ SOP_DATE: '8/31/2026' })).sopDate).toBe('2026-08-31 00:00:00');
    expect(toSavePayload(row({ SOP_DATE: '2026-08-31T00:00:00' })).sopDate).toBe(
      '2026-08-31 00:00:00'
    );
    expect(toSavePayload(row({ SOP_DATE: '20260831' })).sopDate).toBe('2026-08-31 00:00:00');
    // 빈 값 = '' (단건 호출이라 안전 — '-' 금지: TO_DATE 파싱 오류 §0.2)
    expect(toSavePayload(row({ SOP_DATE: '' })).sopDate).toBe('');
  });
});

describe('toSopDateParam / toDisplayDate — 날짜 경계 순수함수', () => {
  it('toSopDateParam — null/빈 값/파싱 불가 = "" (센티널 금지)', () => {
    expect(toSopDateParam(null)).toBe('');
    expect(toSopDateParam('')).toBe('');
    expect(toSopDateParam('not-a-date')).toBe('');
  });

  it('toDisplayDate — DATE 원형(ISO)·YYYYMMDD → \'YYYY.MM.DD\' (계약 결정 8)', () => {
    expect(toDisplayDate('2026-07-01T00:00:00')).toBe('2026.07.01');
    expect(toDisplayDate('20260701')).toBe('2026.07.01');
    expect(toDisplayDate(new Date(2026, 6, 1))).toBe('2026.07.01');
    expect(toDisplayDate('')).toBe('');
    expect(toDisplayDate(null)).toBe('');
  });
});
