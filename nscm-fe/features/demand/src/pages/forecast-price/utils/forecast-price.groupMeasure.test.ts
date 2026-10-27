/**
 * DMF0082 — LOOKUP `GET_ADMIN_GROUP_MEASURE` 기반 편집가능 Measure 후보 판정 회귀 테스트.
 *
 * 요구 원천 = 현업 검수 40번 항목 (Current 버전 입력가능 Measure — MKT_FCST[R+P]/SCM_FCST[R+P] 는
 *   이 룩업 정보 기준 통제 / Unit Price(LOC)).
 * 룩업 실측값(Admin > Lookup 캡처 2026-08-04)을 그대로 픽스처로 쓴다.
 */
import { describe, expect, it } from 'vitest';

import { groupEditMeasures, parseGroupMeasureRow } from './forecast-price.groupMeasure';

/** 캡처 1행 = SEGMENT1~4 + Active + ATTRIBUTE(요일·시간 — 판정 미사용). */
const row = (
  groupId: string,
  measure: string,
  overrides: Record<string, unknown> = {}
): Record<string, unknown> => ({
  LOOKUP_TYPE: 'GET_ADMIN_GROUP_MEASURE',
  SEGMENT1: groupId,
  SEGMENT2: 'DMF0082',
  SEGMENT3: '40',
  SEGMENT4: measure,
  SEGMENT5: '-',
  VALID_YN: 'Y',
  ATTRIBUTE1: 'MON',
  ATTRIBUTE2: '1500',
  ATTRIBUTE3: '1830',
  ATTRIBUTE4: 'MKT_FCST',
  ...overrides,
});

/** 캡처 실측 — ADMIN 그룹은 4종 전부 보유. */
const ADMIN_ROWS = [
  row('ADMIN', 'SCM_FCST'),
  row('ADMIN', 'MKT_FCST'),
  row('ADMIN', 'LOC'),
  row('ADMIN', 'VMI_In_Req'),
  row('DM Planner', 'MKT_FCST'),
  row('DM Planner', 'LOC'),
  row('DM Planner', 'VMI_In_Req'),
];

const ctx = (authGroup: string, divisionId = '40') => ({
  authGroup,
  divisionId,
  programId: 'DMF0082',
});

describe('parseGroupMeasureRow', () => {
  it('SEGMENT 표기를 읽는다', () => {
    expect(parseGroupMeasureRow(row('ADMIN', 'SCM_FCST'))).toEqual({
      groupId: 'ADMIN',
      programId: 'DMF0082',
      divisionId: '40',
      measure: 'SCM_FCST',
      validYn: 'Y',
    });
  });

  // BE 응답이 화면 라벨로 별칭돼 내려오는 배포본 대비 (groupMeasure.ts 헤더 주석).
  it('라벨 별칭(GROUP_ID/PROGRAM_ID/DIVISION/MEASURE) 표기도 읽는다', () => {
    const parsed = parseGroupMeasureRow({
      GROUP_ID: 'DM Planner',
      PROGRAM_ID: 'DMF0082',
      DIVISION: '40',
      MEASURE: 'LOC',
    });
    expect(parsed.groupId).toBe('DM Planner');
    expect(parsed.measure).toBe('LOC');
    expect(parsed.validYn).toBe('Y'); // Active 미제공 = 유효 취급
  });
});

describe('groupEditMeasures', () => {
  it('로그인 그룹의 Measure 만 돌려준다', () => {
    expect(groupEditMeasures(ADMIN_ROWS, ctx('ADMIN'))).toEqual([
      'SCM_FCST',
      'MKT_FCST',
      'LOC',
      'VMI_In_Req',
    ]);
    // DM Planner 는 SCM_FCST 미등록 → 후보에서 빠진다.
    expect(groupEditMeasures(ADMIN_ROWS, ctx('DM Planner'))).toEqual([
      'MKT_FCST',
      'LOC',
      'VMI_In_Req',
    ]);
  });

  it('그룹 대소문자·공백은 무시한다', () => {
    expect(groupEditMeasures(ADMIN_ROWS, ctx(' admin '))).toHaveLength(4);
  });

  it('Program_Id / Division 이 다르면 제외한다', () => {
    const rows = [
      row('ADMIN', 'SCM_FCST', { SEGMENT2: 'DMF0003' }), // 다른 화면
      row('ADMIN', 'MKT_FCST', { SEGMENT3: '82' }), // 다른 division
      row('ADMIN', 'LOC'),
    ];
    expect(groupEditMeasures(rows, ctx('ADMIN', '40'))).toEqual(['LOC']);
  });

  it('공란·\'-\'·\'ALL\' 축은 제한 없음으로 본다', () => {
    const rows = [row('ALL', 'LOC', { SEGMENT2: 'ALL', SEGMENT3: '-' })];
    expect(groupEditMeasures(rows, ctx('DM ADMIN', '81'))).toEqual(['LOC']);
  });

  it('Active \'N\' 행은 제외한다', () => {
    const rows = [row('ADMIN', 'LOC', { VALID_YN: 'N' }), row('ADMIN', 'MKT_FCST')];
    expect(groupEditMeasures(rows, ctx('ADMIN'))).toEqual(['MKT_FCST']);
  });

  it('중복 Measure 는 한 번만 담는다', () => {
    const rows = [row('ADMIN', 'LOC'), row('ADMIN', 'LOC')];
    expect(groupEditMeasures(rows, ctx('ADMIN'))).toEqual(['LOC']);
  });

  // null = 판정 보류(호출측이 전체 목록 폴백 유지) / [] = 권한 없음(제한 유지).
  it('룩업 미도착·그룹 미해석은 null(보류), 그룹에 등록이 없으면 빈 배열', () => {
    expect(groupEditMeasures(undefined, ctx('ADMIN'))).toBeNull();
    expect(groupEditMeasures(ADMIN_ROWS, ctx(''))).toBeNull();
    expect(groupEditMeasures(ADMIN_ROWS, ctx('SCP Planner'))).toEqual([]);
  });
});
