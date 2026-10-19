import { describe, expect, it } from 'vitest';

import type { PlanControlRow } from '../plan-control.types';

import {
  buildDivisionOptions,
  isPreStepCompleted,
  resolvePlanStartYyyymmdd,
  resolveSaveMessage,
  resolveSavePlanId,
} from './planControl.activity';

// AS-IS 순수 로직 4종의 파리티 검증.
//   X12 CheckPreStepCompleted(cs:1186-1258) / SAVE planId 치환(cs:719-726) /
//   저장 성공 문구 분기(cs:756-781) / F01 Division 교집합(cs:183-196) / F07 planStart 소스 분기.
const row = (patch: Record<string, unknown>) => patch as unknown as PlanControlRow;

describe('isPreStepCompleted (X12)', () => {
  const rows = [
    row({ OPMZ_ACTV_CD: 'A001', OPTION_YN: '', OPMZ_ACTV_RUN_STAT_CD: 'C' }),
    row({ OPMZ_ACTV_CD: 'A002', OPTION_YN: '', OPMZ_ACTV_RUN_STAT_CD: 'C' }),
    row({ OPMZ_ACTV_CD: 'A003', OPTION_YN: '', OPMZ_ACTV_RUN_STAT_CD: 'W' }),
    row({ OPMZ_ACTV_CD: 'A004', OPTION_YN: 'Y', OPMZ_ACTV_RUN_STAT_CD: '' }),
    row({ OPMZ_ACTV_CD: 'A006', OPTION_YN: '', OPMZ_ACTV_RUN_STAT_CD: '' }),
  ];

  it('첫 행은 기억한 선행 상태가 공백이라 항상 false', () => {
    expect(isPreStepCompleted(rows, 'A001')).toBe(false);
  });

  it('직전 필수 Activity 가 완료(C)면 true', () => {
    expect(isPreStepCompleted(rows, 'A002')).toBe(true);
  });

  it('직전 필수 Activity 가 미완료면 false', () => {
    expect(isPreStepCompleted(rows, 'A004')).toBe(false);
  });

  it('OPTION_YN=Y 행은 선행 판정에서 제외된다 — A006 의 선행은 A004 가 아니라 A003(W)', () => {
    expect(isPreStepCompleted(rows, 'A006')).toBe(false);
  });

  it('OPTION_YN=Y 행을 건너뛴 결과가 완료면 true', () => {
    const passing = [
      row({ OPMZ_ACTV_CD: 'A003', OPTION_YN: '', OPMZ_ACTV_RUN_STAT_CD: 'C' }),
      row({ OPMZ_ACTV_CD: 'A004', OPTION_YN: 'Y', OPMZ_ACTV_RUN_STAT_CD: 'E' }),
      row({ OPMZ_ACTV_CD: 'A006', OPTION_YN: '', OPMZ_ACTV_RUN_STAT_CD: '' }),
    ];
    expect(isPreStepCompleted(passing, 'A006')).toBe(true);
  });

  it('목록에 없는 actvCd 는 false', () => {
    expect(isPreStepCompleted(rows, 'A009')).toBe(false);
  });
});

describe('resolveSavePlanId', () => {
  it('독립 실행(INDP_YN=\'Y\')은 \'-\' 를 보낸다', () => {
    expect(resolveSavePlanId(row({ OPMZ_PLAN_ID_INDP_YN: 'Y', OPMZ_PLAN_ID: 'P123' }))).toBe('-');
  });

  it('비독립은 행의 Plan ID 를 그대로 보낸다', () => {
    expect(resolveSavePlanId(row({ OPMZ_PLAN_ID_INDP_YN: 'N', OPMZ_PLAN_ID: 'P123' }))).toBe('P123');
  });
});

describe('resolveSaveMessage', () => {
  // 반환값은 문구가 아니라 MSG 코드다(iter-2 에 SCM_ADM_MSG_M + locales 양쪽 신규 등록).
  it('CONFIRM_YN=\'Y\' 면 Confirmed(MSG01465)', () => {
    expect(resolveSaveMessage(row({ CONFIRM_YN: 'Y', OPMZ_ACTV_CD: 'A001' }))).toBe('MSG01465');
  });

  it('A003/A004/A005/A009 는 Executed(MSG01466)', () => {
    for (const actvCd of ['A003', 'A004', 'A005', 'A009']) {
      expect(resolveSaveMessage(row({ CONFIRM_YN: '', OPMZ_ACTV_CD: actvCd }))).toBe('MSG01466');
    }
  });

  it('A006 은 Released(MSG01467)', () => {
    expect(resolveSaveMessage(row({ CONFIRM_YN: '', OPMZ_ACTV_CD: 'A006' }))).toBe('MSG01467');
  });

  it('그 외(A002 비Confirm)는 문구가 없다 — AS-IS 도 빈 문자열', () => {
    expect(resolveSaveMessage(row({ CONFIRM_YN: '', OPMZ_ACTV_CD: 'A002' }))).toBe('');
  });
});

describe('resolvePlanStartYyyymmdd (F07)', () => {
  const sc = { divisionId: '81_UC', planGroupId: 'PG1', planDateCode: '20260824', planDate: '20260926' };

  it('일단위 모드는 DatePicker 값', () => {
    expect(resolvePlanStartYyyymmdd(sc, true)).toBe('20260926');
  });

  it('주단위 모드는 콤보 CODE', () => {
    expect(resolvePlanStartYyyymmdd(sc, false)).toBe('20260824');
  });

  it('하이픈이 섞여 들어와도 8자리로 정규화한다', () => {
    expect(resolvePlanStartYyyymmdd({ ...sc, planDate: '2026-09-26' }, true)).toBe('20260926');
  });
});

describe('buildDivisionOptions (F01)', () => {
  const divisions = [
    { CODE: '81', NAME: '81 Automotive Battery' },
    { CODE: 'EE', NAME: 'EE Electrode' },
    { CODE: '82', NAME: '82 ESS Battery' },
  ] as unknown as Parameters<typeof buildDivisionOptions>[0];

  it('Plan Group 을 보유한 Division 만 남긴다', () => {
    const options = buildDivisionOptions(divisions, [{ DIVISION_ID: '81' }, { DIVISION_ID: 'EE' }]);
    expect(options.map(option => option.value)).toEqual(['81', 'EE']);
  });

  it('두 원천 중 하나라도 도착 전이면 빈 배열(후보를 성급히 넓히지 않는다)', () => {
    expect(buildDivisionOptions(undefined, [{ DIVISION_ID: '81' }])).toEqual([]);
    expect(buildDivisionOptions(divisions, undefined)).toEqual([]);
  });
});
