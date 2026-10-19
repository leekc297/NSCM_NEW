// ⭐ DMF0021 editLock/validate/division/gridCombos — AS-IS 산식 1:1 값 검증 (2026-08-12 신설).
//   근거: 제약매트릭스_상세.md §1.3/§3/§4 + E20260331(ETC 한정·81 RTF 확장) +
//   통합테스트 사전점검 1st No.59(TEXT=ETC)/61-④(Team 잠금)/57 계보(merge Insert 제외).
import { describe, expect, it } from 'vitest';

import { BUCKET_TYPE } from '../sales-plan.constants';
import type { SalesPlanRow } from '../sales-plan.types';

import { requiredFieldsFor } from './sales-plan.division';
import {
  addMonths,
  buildCutoff,
  evalSalesPlanDynCell,
  insertStaticEditable,
  parseWeekTag,
} from './sales-plan.editLock';
import { applyMeasureSwitch } from './sales-plan.gridCombos';

const CAL = { THIS_YYYYMM: '202608', THIS_YYYYMMWW: 'W_20260833' } as never;
const cutoff = buildCutoff(CAL);
const AUTH_BOTH = { salesAmtLoc: true, rtfSysRp: true };

const row = (over: Record<string, unknown> = {}): SalesPlanRow =>
  ({
    MEASURE: 'SalesAmt_LOC',
    FCST_TYPE: 'ETC',
    SALES_PLAN_ADJUST_YN: 'N_Y',
    ...over,
  }) as never;

const evalCell = (binding: string, r: SalesPlanRow, div = '81', bucket = BUCKET_TYPE.MONTHLY) =>
  evalSalesPlanDynCell({
    binding,
    row: r,
    divisionId: div,
    bucketType: bucket,
    cutoff,
    auth: AUTH_BOTH,
  });

describe('editLock — 기간 cutoff (제약매트릭스 §1.3/§4.1)', () => {
  it('M_: 40=당월 포함(≥) / 비40=익월부터(＞) — AS-IS L771~794', () => {
    expect(evalCell('M_202608', row(), '40').editable).toBe(true); // 40 당월
    expect(evalCell('M_202608', row(), '81').editable).toBe(false); // 81 당월 잠금
    expect(evalCell('M_202609', row(), '81').editable).toBe(true); // 81 익월
    expect(evalCell('M_202607', row(), '40').editable).toBe(false); // 과거
  });
  it('W_: 당주부터(≥) 전 사업부 공통 — AS-IS L806~819', () => {
    expect(evalCell('W_20260833', row(), '81', BUCKET_TYPE.WEEKLY).editable).toBe(true);
    expect(evalCell('W_20260832', row(), '81', BUCKET_TYPE.WEEKLY).editable).toBe(false);
  });
  it('Catch_Up = M+3 이후만 (40 전용) — AS-IS L990~1037', () => {
    const cu = row({ MEASURE: 'Catch_Up', FCST_TYPE: 'MPS' });
    expect(addMonths('202608', 3)).toBe('202611');
    expect(evalCell('M_202611', cu, '40').editable).toBe(true);
    expect(evalCell('M_202610', cu, '40').editable).toBe(false);
    expect(evalCell('M_202611', cu, '81').editable).toBe(false); // 40 전용
  });
  it('RTF_SYS_RP + Monthly = 당월 잠금(M+1부터) — AS-IS L1066~1080', () => {
    const rtf = row({ MEASURE: 'RTF_SYS_RP', FCST_TYPE: 'MPS' });
    expect(evalCell('M_202608', rtf, '40').editable).toBe(false);
    expect(evalCell('M_202609', rtf, '40').editable).toBe(true);
  });
});

describe('editLock — measure 게이트 (E20260331)', () => {
  it('SalesAmt_LOC 편집 = FCST_TYPE=ETC 행만 — AS-IS L968', () => {
    expect(evalCell('M_202609', row({ FCST_TYPE: 'MPS' })).editable).toBe(false);
    expect(evalCell('M_202609', row({ FCST_TYPE: 'ETC' })).editable).toBe(true);
  });
  it('RTF_SYS_RP = 40·81 만 (82 는 권한 있어도 잠금) — AS-IS L1041~1045', () => {
    const rtf = row({ MEASURE: 'RTF_SYS_RP', FCST_TYPE: 'MPS' });
    expect(evalCell('M_202609', rtf, '81').editable).toBe(true);
    expect(evalCell('M_202609', rtf, '81_UC').editable).toBe(true); // startsWith('81')
    expect(evalCell('M_202609', rtf, '82').editable).toBe(false);
  });
  it('기존 행 SALES_PLAN_ADJUST_YN≠N_Y = 잠금 — AS-IS L963', () => {
    expect(evalCell('M_202609', row({ SALES_PLAN_ADJUST_YN: 'N' })).editable).toBe(false);
  });
});

describe('editLock — 버킷 상호배제 (§4.2)', () => {
  it('Monthly 버킷 = W_ 잠금 / Weekly 버킷 = M_ 잠금 / D_ 상시 잠금', () => {
    expect(evalCell('W_20260834', row(), '81', BUCKET_TYPE.MONTHLY).editable).toBe(false);
    expect(evalCell('M_202609', row(), '81', BUCKET_TYPE.WEEKLY).editable).toBe(false);
    expect(evalCell('D_20260812', row(), '81', BUCKET_TYPE.WEEKLY).editable).toBe(false);
  });
  it('Daily 버킷 = 전 잠금 (MSG00361 축)', () => {
    expect(evalCell('D_20260901', row(), '81', BUCKET_TYPE.DAILY).editable).toBe(false);
    expect(evalCell('M_202609', row(), '81', BUCKET_TYPE.DAILY).editable).toBe(false);
  });
});

describe('insertStaticEditable — No.61-④ Team 전 Div 잠금 (통합테스트 1st)', () => {
  it('DEPT_ID = 40 포함 전 Div false', () => {
    expect(insertStaticEditable('DEPT_ID', row(), '40')).toBe(false);
    expect(insertStaticEditable('DEPT_ID', row(), '81')).toBe(false);
    expect(insertStaticEditable('DEPT_ID', row(), '82')).toBe(false);
  });
  it('MEASURE = 40 & 후보 2건+ 만 콤보 / PLANT_SITE = 전 Div 잠금 / 참조컬럼 = 붕괴 규칙 false', () => {
    // 40 이라도 measureInfo 후보가 1건 이하면 콤보 안 열림 (2026-09-03 — 현재 SalesAmt_LOC 1건).
    expect(insertStaticEditable('MEASURE', row(), '40', 1)).toBe(false);
    expect(insertStaticEditable('MEASURE', row(), '40', 0)).toBe(false);
    // 후보가 2건 이상으로 늘면 다시 콤보 개방 (데이터 종속).
    expect(insertStaticEditable('MEASURE', row(), '40', 2)).toBe(true);
    // 81 은 후보 수와 무관하게 항상 고정.
    expect(insertStaticEditable('MEASURE', row(), '81', 2)).toBe(false);
    // PLANT_SITE_ID = 표시 전용 — AS-IS InsertRow L3023 무조건 잠금, 81 unlock(L4581)은
    //   그리드 Division 셀 변경 전용 경로라 신규행에서 도달하지 않는다 (2026-09-01 정정).
    expect(insertStaticEditable('PLANT_SITE_ID', row(), '81')).toBe(false);
    expect(insertStaticEditable('PLANT_SITE_ID', row(), '40')).toBe(false);
    expect(insertStaticEditable('PLANT_SITE_ID', row(), '82')).toBe(false);
    expect(insertStaticEditable('PROJECT_NAME', row(), '81')).toBe(false);
  });
});

describe('requiredFieldsFor — No.59 TEXT=ETC 한정 + No.61-④ Team 해제', () => {
  const cols = (div: string, measure: string, fcst: string) =>
    requiredFieldsFor(div, measure, fcst).map(f => f.col);
  it('81 TEXT 필수 = FCST_TYPE=ETC 행만 (RTF 행 면제 — 오발동 정정)', () => {
    expect(cols('81', 'SalesAmt_LOC', 'ETC')).toContain('TEXT');
    expect(cols('81', 'RTF_SYS_RP', 'MPS')).not.toContain('TEXT');
    expect(cols('81', 'RTF_SYS_RP', 'RMA')).not.toContain('TEXT');
  });
  it('Team(DEPT_ID) 필수 해제 — 전 Div (입력 불가 컬럼)', () => {
    expect(cols('40', 'SalesAmt_LOC', 'ETC')).not.toContain('DEPT_ID');
    expect(cols('40', 'Catch_Up', 'MPS')).not.toContain('DEPT_ID');
  });
  it('40 Catch_Up = DomExp/FcstType/Incoterms 필수 유지 — AS-IS L2231~2233', () => {
    const c = cols('40', 'Catch_Up', 'MPS');
    expect(c).toEqual(expect.arrayContaining(['DOM_EXP', 'FCST_TYPE', 'INCOTERMS']));
  });
});

describe('applyMeasureSwitch — CC-12/20 DEPT_ID clear (R6)', () => {
  it('Catch_Up 전환: FCST_TYPE 개방 + ITEM/DEPT_ID clear + 기간 입력 소거', () => {
    const r = row({ DEPT_ID: 'T1', ITEM_ID: 'X', M_202609: 5 }) as Record<string, unknown>;
    applyMeasureSwitch(r as never, 'Catch_Up', ['M_202609']);
    expect(r.FCST_TYPE).toBe('');
    expect(r.DEPT_ID).toBe('');
    expect(r.ITEM_ID).toBe('');
    expect(r.M_202609).toBeNull();
  });
  it('SalesAmt_LOC 복귀: FCST_TYPE=ETC 고정 + DEPT_ID clear', () => {
    const r = row({ DEPT_ID: 'T1', FCST_TYPE: 'MPS' }) as Record<string, unknown>;
    applyMeasureSwitch(r as never, 'SalesAmt_LOC', []);
    expect(r.FCST_TYPE).toBe('ETC');
    expect(r.DEPT_ID).toBe('');
  });
});

describe('parseWeekTag — 사전식 비교 오류 방지', () => {
  it('yyyymm+ISO주차 튜플 파싱', () => {
    expect(parseWeekTag('W_20260833')).toEqual({ ym: '202608', wk: 33 });
    expect(parseWeekTag('M_202608')).toBeNull();
  });
});
