import { describe, expect, it } from 'vitest';

import { BUCKET_TYPE } from '../business-plan.constants';
import type { BusinessPlanRow, CutoffWindow } from '../business-plan.types';

import {
  buildCutoff,
  buildValidWindow,
  dynKindOf,
  evalBizPlanDynCell,
  insertStaticEditable,
  parseDynTag,
} from './business-plan.editLock';

// ⭐ DMF0042 편집/잠금 엔진 R1~R5 — AS-IS 신정본 EditButton L582~689 / InsertRow L1218~1461 1:1.
//   특히 R4'(2026-07-21 G1 교정): Q_/Y_ 는 40+유효창+구간 내에서만 개방 — 81/82 무조건 잠금이 파리티.

const CUTOFF = buildCutoff('20260316')!; // 금주 월요일 — thisMonth 202603 / Q1 / 2026

const WINDOW_40 = buildValidWindow({
  VALID_YN: 'Y',
  START_YYYYMM: '202603',
  END_YYYYMM: '202612',
  START_YYYYQQ: '20261',
  END_YYYYQQ: '20264',
  START_YYYY: '2026',
  END_YYYY: '2026',
} as unknown as CutoffWindow)!;

const row = (over: Partial<BusinessPlanRow> = {}): BusinessPlanRow =>
  ({ EDIT_FLAG: 'Y', MEASURE: 'Business_Plan', ...over }) as BusinessPlanRow;

const evalCell = (
  binding: string,
  over: {
    row?: BusinessPlanRow;
    divisionId?: string;
    bucketType?: BUCKET_TYPE;
    window?: ReturnType<typeof buildValidWindow>;
  } = {}
) =>
  evalBizPlanDynCell({
    binding,
    row: over.row ?? row(),
    divisionId: over.divisionId ?? '40',
    bucketType: over.bucketType ?? BUCKET_TYPE.MONTHLY,
    cutoff: CUTOFF,
    window: over.window === undefined ? WINDOW_40 : over.window,
  });

describe('parseDynTag / dynKindOf — 동적 binding 해석 (SPREAD_TITLE L220/235/251 형식)', () => {
  it('Y_/Q_/M_ 3형 + 비대상', () => {
    expect(parseDynTag('Y_2026')).toEqual({ kind: 'Y', year: 2026, quarter: 0, month: 0 });
    expect(parseDynTag('Q_2026_3')).toEqual({ kind: 'Q', year: 2026, quarter: 3, month: 0 });
    expect(parseDynTag('M_202611')).toEqual({ kind: 'M', year: 2026, quarter: 4, month: 11 });
    expect(dynKindOf('B_BASE')).toBeNull();
    expect(dynKindOf('M_20261')).toBeNull(); // 자릿수 위반
  });
});

describe('R2 버킷 게이트 — 활성 버킷 축만 편집 (EditButton L582~637)', () => {
  it('Monthly 버킷 = M_ 만 편집, Q_/Y_ 잠금', () => {
    expect(evalCell('M_202606').editable).toBe(true);
    expect(evalCell('Q_2026_2').editable).toBe(false);
    expect(evalCell('Y_2026').editable).toBe(false);
  });

  it('Quarterly 버킷(40+유효창 구간 내) = Q_ 만 편집', () => {
    expect(evalCell('Q_2026_2', { bucketType: BUCKET_TYPE.QUARTERLY }).editable).toBe(true);
    expect(evalCell('M_202606', { bucketType: BUCKET_TYPE.QUARTERLY }).editable).toBe(false);
  });
});

describe('R1 행 게이트 — EDIT_FLAG × Measure (L644~)', () => {
  it("기존행 EDIT_FLAG!='Y' = 잠금", () => {
    expect(evalCell('M_202606', { row: row({ EDIT_FLAG: 'N' }) }).editable).toBe(false);
  });

  it('Insert 행(CRUD_TYPE=I)은 EDIT_FLAG 무관 통과', () => {
    expect(
      evalCell('M_202606', { row: row({ EDIT_FLAG: '', CRUD_TYPE: 'I' }) }).editable
    ).toBe(true);
  });

  it('SP 파생 measure(MKT_FCST/SalesAmt 등) = 잠금', () => {
    expect(evalCell('M_202606', { row: row({ MEASURE: 'MKT_FCST' }) }).editable).toBe(false);
    expect(evalCell('M_202606', { row: row({ MEASURE: 'SalesAmt_KRW' }) }).editable).toBe(false);
    expect(evalCell('M_202606', { row: row({ MEASURE: 'LOC' }) }).editable).toBe(true);
  });
});

describe('R3 금년 이전 잠금 + 과거(Gray) 판정 (L670~689)', () => {
  it('전년 컬럼 = 잠금 + isPast', () => {
    const st = evalCell('M_202512');
    expect(st.editable).toBe(false);
    expect(st.isPast).toBe(true);
  });

  it('금년 실적월(금주 월요일 이전) = isPast 이며 유효창 밖이면 잠금', () => {
    const st = evalCell('M_202602'); // < thisMonth 202603, 창 시작 202603
    expect(st.isPast).toBe(true);
    expect(st.editable).toBe(false);
  });
});

describe("R4' 버킷축별 유효구간 (G1 교정 — 신정본 L582~637/L1406~1461)", () => {
  it('M_: 40+유효창 = 구간 밖 잠금 / 구간 내 개방', () => {
    expect(evalCell('M_202603').editable).toBe(true); // 창 시작월
    expect(evalCell('M_202612').editable).toBe(true); // 창 종료월
  });

  it('M_: 비40 = 유효창 게이트 미적용(전면 개방 — L588 else 없음)', () => {
    expect(evalCell('M_202606', { divisionId: '81', window: null }).editable).toBe(true);
    expect(evalCell('M_202606', { divisionId: '82', window: null }).editable).toBe(true);
  });

  it("Q_/Y_: 비40 또는 무효창 = 무조건 잠금 (81/82 직접입력 불가 파리티 — 구 '통과' 구현은 승계 오류)", () => {
    expect(
      evalCell('Q_2026_2', { divisionId: '81', window: null, bucketType: BUCKET_TYPE.QUARTERLY })
        .editable
    ).toBe(false);
    expect(
      evalCell('Y_2026', { divisionId: '82', window: null, bucketType: BUCKET_TYPE.YEARLY })
        .editable
    ).toBe(false);
    // 40 이라도 VALID_YN='N' 창 = 잠금
    const invalidWin = { ...WINDOW_40, validYn: false };
    expect(
      evalCell('Q_2026_2', { window: invalidWin, bucketType: BUCKET_TYPE.QUARTERLY }).editable
    ).toBe(false);
  });

  it("Q_: 'yyyyq' 5자 고정폭 구간 비교 (SP L1094 REPLACE 형식)", () => {
    const narrow = { ...WINDOW_40, startYyyyqq: '20262', endYyyyqq: '20263' };
    expect(
      evalCell('Q_2026_1', { window: narrow, bucketType: BUCKET_TYPE.QUARTERLY }).editable
    ).toBe(false); // 20261 < 20262
    expect(
      evalCell('Q_2026_2', { window: narrow, bucketType: BUCKET_TYPE.QUARTERLY }).editable
    ).toBe(true);
  });
});

describe('R5 Insert 행 정적 컬럼 화이트리스트 (InsertRow L1218~1409 — division별 개방)', () => {
  const r = row({ CRUD_TYPE: 'I' });

  it('division별 콤보 컬럼 스왑 (40 ↔ 81/82)', () => {
    expect(insertStaticEditable('DEPT_ID40', r, '40')).toBe(true);
    expect(insertStaticEditable('DEPT_ID', r, '40')).toBe(false);
    expect(insertStaticEditable('DEPT_ID', r, '81')).toBe(true);
    expect(insertStaticEditable('END_CUSTOMER40', r, '40')).toBe(true);
    expect(insertStaticEditable('END_CUSTOMER', r, '82')).toBe(true);
    expect(insertStaticEditable('SCM_SITE_ID81', r, '81')).toBe(true);
    expect(insertStaticEditable('SCM_SITE_ID81', r, '40')).toBe(false);
  });

  it('81 계열 하위 사업부(81_UC 등)도 81 로 판정 (startsWith — === 비교 금지)', () => {
    expect(insertStaticEditable('PLANT_SITE_ID', r, '81_UC')).toBe(true);
    expect(insertStaticEditable('SCM_SITE_ID81', r, '81_HD')).toBe(true);
  });

  it('82 전용(UNIT_ENERGY/ITEM_USE/INCOTERMS82) + FCST_TYPE 은 82 제외', () => {
    expect(insertStaticEditable('UNIT_ENERGY', r, '82')).toBe(true);
    expect(insertStaticEditable('INCOTERMS82', r, '82')).toBe(true);
    expect(insertStaticEditable('INCOTERMS', r, '82')).toBe(false);
    expect(insertStaticEditable('FCST_TYPE', r, '82')).toBe(false);
    expect(insertStaticEditable('FCST_TYPE', r, '40')).toBe(true);
  });

  it('팝업 셀(PROJECT/ITEM)·메타·파생 컬럼 = 잠금 (dblclick 모달 전용/R5 붕괴 규칙)', () => {
    expect(insertStaticEditable('PROJECT_CODE', r, '81')).toBe(false);
    expect(insertStaticEditable('ITEM_ID', r, '81')).toBe(false);
    expect(insertStaticEditable('MEASURE', r, '40')).toBe(false);
    expect(insertStaticEditable('EDIT_FLAG', r, '40')).toBe(false);
  });

  it('CURRENCY = 전 division 개방 (CURRENCY_LIST 콤보 L1184)', () => {
    expect(insertStaticEditable('CURRENCY', r, '40')).toBe(true);
    expect(insertStaticEditable('CURRENCY', r, '82')).toBe(true);
  });
});
