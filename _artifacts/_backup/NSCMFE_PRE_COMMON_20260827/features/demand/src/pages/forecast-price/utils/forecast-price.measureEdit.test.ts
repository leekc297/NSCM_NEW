import { describe, expect, it } from 'vitest';

import { isMeasureEditableByAuth } from './forecast-price.wsAuth';

// 현업 검수 41번 "Current 버전에서 입력 가능 Measure" 매트릭스 1:1.
//   MKT_FCST[R+P] / SCM_FCST[R+P] / Unit Price(LOC) — GET_ADMIN_GROUP_MEASURE 룩업 기준 통제
//   AS_In_Req  — 81, 81_JV, 82 Div 에서만 DM Planner(W/S) 권한일 때
//   VMI_In_Req — 40, 82 Div 에서만 권한과 무관하게 Sales Site VMI='Y' 일 때

const base = {
  divisionId: '40',
  wsPlannerYn: false,
  measureAuth: {} as Record<string, boolean>,
  vmiProvided: false,
  isInsertRow: false,
};

describe('isMeasureEditableByAuth — 그룹 룩업 통제 measure', () => {
  it.each(['MKT_FCST', 'SCM_FCST', 'LOC'])('%s 는 룩업이 막지 않으면 편집 가능', measure => {
    expect(isMeasureEditableByAuth({ ...base, measure })).toBe(true);
  });

  it.each(['MKT_FCST', 'SCM_FCST', 'LOC'])('%s 는 룩업이 EDIT_FLAG=N 이면 차단', measure => {
    expect(isMeasureEditableByAuth({ ...base, measure, measureAuth: { [measure]: false } })).toBe(
      false
    );
  });

  it('통제 대상 밖 measure 는 항상 read-only', () => {
    expect(isMeasureEditableByAuth({ ...base, measure: 'MKT_FCST_PP' })).toBe(false);
  });
});

describe('isMeasureEditableByAuth — AS_In_Req (81/81_JV/82 + W/S 전용)', () => {
  it.each(['81', '81_JV', '82'])('%s + W/S 이면 편집 가능', divisionId => {
    expect(
      isMeasureEditableByAuth({ ...base, measure: 'AS_In_Req', divisionId, wsPlannerYn: true })
    ).toBe(true);
  });

  it.each(['81', '81_JV', '82'])('%s 라도 W/S 가 아니면 차단', divisionId => {
    expect(
      isMeasureEditableByAuth({ ...base, measure: 'AS_In_Req', divisionId, wsPlannerYn: false })
    ).toBe(false);
  });

  it('40 은 W/S 권한이 있어도 차단', () => {
    expect(
      isMeasureEditableByAuth({
        ...base,
        measure: 'AS_In_Req',
        divisionId: '40',
        wsPlannerYn: true,
      })
    ).toBe(false);
  });

  it('그룹 룩업(measureAuth)과 무관하게 W/S·division 만으로 결정한다', () => {
    expect(
      isMeasureEditableByAuth({
        ...base,
        measure: 'AS_In_Req',
        divisionId: '81',
        wsPlannerYn: true,
        measureAuth: { AS_In_Req: false },
      })
    ).toBe(true);
  });
});

describe('isMeasureEditableByAuth — VMI_In_Req (40/82 + VMI=Y, 권한 무관)', () => {
  const vmi = { measure: 'VMI_In_Req', vmiProvided: true };

  it.each(['40', '82'])('%s + VMI_YN=Y 이면 편집 가능', divisionId => {
    expect(isMeasureEditableByAuth({ ...base, ...vmi, divisionId, vmiYn: 'Y' })).toBe(true);
  });

  it.each(['40', '82'])('%s 라도 VMI_YN=N 이면 차단', divisionId => {
    expect(isMeasureEditableByAuth({ ...base, ...vmi, divisionId, vmiYn: 'N' })).toBe(false);
  });

  it('81 계열은 VMI_YN=Y 여도 차단', () => {
    expect(isMeasureEditableByAuth({ ...base, ...vmi, divisionId: '81', vmiYn: 'Y' })).toBe(false);
  });

  it('권한(measureAuth)이 N 이어도 VMI=Y 면 열린다 — "권한과 무관하게"', () => {
    expect(
      isMeasureEditableByAuth({
        ...base,
        ...vmi,
        divisionId: '40',
        vmiYn: 'Y',
        measureAuth: { VMI_In_Req: false },
      })
    ).toBe(true);
  });

  // VMI_YN 컬럼을 관리자가 화면에서 내리면 조회 커서에서도 통째로 빠진다 — 그때 잠그면 기존 동작 퇴행.
  it('VMI_YN 컬럼이 조회에 없으면(vmiProvided=false) 사업부 게이트만 적용', () => {
    expect(
      isMeasureEditableByAuth({ ...base, measure: 'VMI_In_Req', divisionId: '40' })
    ).toBe(true);
    expect(
      isMeasureEditableByAuth({ ...base, measure: 'VMI_In_Req', divisionId: '81' })
    ).toBe(false);
  });

  it('컬럼은 오는데 값을 못 구한 신규행은 통과 / 조회행은 차단', () => {
    expect(
      isMeasureEditableByAuth({ ...base, ...vmi, divisionId: '40', vmiYn: '', isInsertRow: true })
    ).toBe(true);
    expect(
      isMeasureEditableByAuth({ ...base, ...vmi, divisionId: '40', vmiYn: '', isInsertRow: false })
    ).toBe(false);
  });
});
