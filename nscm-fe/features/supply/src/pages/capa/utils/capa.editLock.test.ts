import { describe, expect, it } from 'vitest';

import dayjs from '@foundation/dayjs';
import type { ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';
import { buildLeafColumnDataMap } from '@foundation/utils';

import type { CapaRow } from '../capa.types';

import {
  buildPlannerAuth,
  type EditContext,
  hasRowEditAuth,
  isCellEditable,
  type PlannerAuth,
  toUserAuth,
} from './capa.editLock';

// AS-IS EditButton(cs:578-598): LINE ASSIGN 행은 LaneQtyOfLineAssign 콤보를 7키로 좁혀 후보가 있을 때만 LANE_QTY 를 연다.

const LANE_ATTRIBUTE2 =
  'DIVISION_ID:DIVISION_ID,COMPANY_ID:COMPANY_ID,SITE_ID:SITE_ID,LINE_ID:LINE_ID,OPERATION_ID:OPERATION_ID,ELECTRODE_TYPE:ELECTRODE_TYPE,ITEM_ID:ITEM_ID';

const key = (patch: Record<string, string> = {}) => ({
  DIVISION_ID: '81',
  COMPANY_ID: 'C1',
  SITE_ID: 'S1',
  LINE_ID: 'L1',
  OPERATION_ID: 'E2000',
  ELECTRODE_TYPE: 'A',
  ITEM_ID: 'I1',
  ...patch,
});

const COMBO_ROWS: ComboResponse[] = [
  { CODE: '1', NAME: '1', ...key() },
  { CODE: '2', NAME: '2', ...key() },
  { CODE: '3', NAME: '3', ...key({ ITEM_ID: 'I2' }) },
];

const laneRow = (patch: Record<string, unknown> = {}): CapaRow =>
  ({
    ...key(),
    EDITORBLE_YN: 'Y',
    LOSS_CODE: 'LA001',
    CATEGORY_ID: 'LINE ASSIGN',
    USER_ID_1: 'u1',
    ...patch,
  }) as unknown as CapaRow;

const ctxWith = (count: number): EditContext => ({
  isCurrentVersion: true,
  userId: 'u1',
  groups: ['X'],
  laneQtyCandidateCountOf: () => count,
});

describe('isCellEditable — LANE_QTY 후보 수 게이트', () => {
  it('후보 0건이면 권한 행이어도 잠금', () => {
    expect(isCellEditable(laneRow(), 'LANE_QTY', ctxWith(0))).toBe(false);
  });

  it('후보 1건 이상이면 개방', () => {
    expect(isCellEditable(laneRow(), 'LANE_QTY', ctxWith(1))).toBe(true);
  });

  it('LINE ASSIGN 이 아닌 행은 후보가 있어도 잠금', () => {
    expect(isCellEditable(laneRow({ CATEGORY_ID: 'YIELD' }), 'LANE_QTY', ctxWith(3))).toBe(false);
  });

  it('권한이 없으면 후보가 있어도 잠금', () => {
    expect(isCellEditable(laneRow({ USER_ID_1: 'other' }), 'LANE_QTY', ctxWith(3))).toBe(false);
  });
});

describe('LANE_QTY 후보 수 원천 — 컬럼 dataMap(ATTRIBUTE2 7키)', () => {
  const column: RawFlexGridColumnConfig = {
    colNm: 'LANE_QTY',
    colLblNm: 'Lane',
    display: true,
    dataMap: COMBO_ROWS,
    attribute2: LANE_ATTRIBUTE2,
  };
  const countOf = (row: CapaRow): number =>
    buildLeafColumnDataMap(column)?.getDisplayValues(row).length ?? 0;

  it('7키가 일치하는 행만 센다(AS-IS DataTable.Select 와 동일)', () => {
    expect(countOf(laneRow())).toBe(2);
    expect(countOf(laneRow({ ITEM_ID: 'I2' }))).toBe(1);
  });

  it('키가 하나라도 다르면 0건', () => {
    expect(countOf(laneRow({ ITEM_ID: 'NONE' }))).toBe(0);
    expect(countOf(laneRow({ OPERATION_ID: 'E1000' }))).toBe(0);
  });

  it('콤보 응답이 비어 있으면 dataMap 이 없어 0건', () => {
    expect(buildLeafColumnDataMap({ ...column, dataMap: [] })).toBeUndefined();
  });
});

describe('세션 보유 그룹(session.groups — USER_GR_NM) 기준 판정', () => {
  const ctxGroups = (groups: string[]): EditContext => ({
    isCurrentVersion: true,
    userId: 'nobody',
    groups,
    laneQtyCandidateCountOf: () => 0,
  });

  it('보유 그룹 중 하나라도 SCM PI Admin 이면 담당자가 아니어도 편집 권한', () => {
    expect(hasRowEditAuth(laneRow(), ctxGroups(['SCM PI Admin']))).toBe(true);
    expect(hasRowEditAuth(laneRow(), ctxGroups(['DM Viewer', 'SCM PI Admin']))).toBe(true);
  });

  it('SCM PI Admin 이 없고 담당자도 아니면 편집 권한 없음', () => {
    expect(hasRowEditAuth(laneRow(), ctxGroups(['DM Viewer', 'SCP Planner']))).toBe(false);
    expect(hasRowEditAuth(laneRow(), ctxGroups([]))).toBe(false);
  });

  it('userAuth — 우선 그룹이 있으면 그 값(대소문자 무시, System Administrator → ADMIN)', () => {
    expect(toUserAuth(['SCM PI Admin'])).toBe('SCM PI Admin');
    expect(toUserAuth(['DM Viewer', 'FP Viewer', 'Guest', 'SCM Viewer', 'SCP Planner'])).toBe('SCP Planner');
    expect(toUserAuth(['DM Viewer', 'System Administrator'])).toBe('ADMIN');
    expect(toUserAuth(['scm pi admin'])).toBe('SCM PI Admin');
  });

  it('userAuth — 우선 그룹이 없으면 첫 그룹, 그룹이 없으면 빈 값', () => {
    expect(toUserAuth(['DM Viewer', 'Guest'])).toBe('DM Viewer');
    expect(toUserAuth([])).toBe('');
    expect(toUserAuth(undefined)).toBe('');
  });
});

describe('승인 Planner 판정(buildPlannerAuth — PlannerTypeLogic cs:499-561)', () => {
  const auth = (gr: string, div = '81', res = 'APPROVED') => ({
    USER_GR_ID: gr,
    APPROVAL_RESULT: res,
    DIVISION_ID: div,
  });
  const fpRow = { DIVISION_ID: '81', PLANT_ID: 'NA00', FACTORY_ID: 'EA', SHOP_GROUP_ID: 'e', MENU_AUTHORITY_ID: 'PLANNER', APPROVAL_FLAG: 'Y' };

  it('SCP·FP 둘 다 승인이면 Super', () => {
    const p = buildPlannerAuth([auth('SCP Planner'), auth('FP Planner')], [], ['SCP Planner'], [], '81');
    expect(p).toMatchObject({ super: true, scpSide: false, fpSide: false });
  });

  it('CAPA Planner 승인은 SCP Planner 와 같게 본다', () => {
    const p = buildPlannerAuth([auth('CAPA Planner'), auth('FP Planner')], [], [], [], '81');
    expect(p.super).toBe(true);
  });

  it('SCP 만 승인 + 보유 그룹 SCP Planner → ③', () => {
    const p = buildPlannerAuth([auth('SCP Planner')], [], ['DM Viewer', 'SCP Planner'], [], '81');
    expect(p).toMatchObject({ super: false, scpSide: true, fpSide: false });
  });

  it('승인 Division 이 다르거나 미승인이면 None', () => {
    expect(buildPlannerAuth([auth('SCP Planner', '40')], [], ['SCP Planner'], [], '81').scpSide).toBe(false);
    expect(buildPlannerAuth([auth('SCP Planner', '81', 'REQUEST')], [], ['SCP Planner'], [], '81').scpSide).toBe(false);
  });

  it('Side 이면 보유 그룹 전체로 ③·④ 를 함께 판정한다', () => {
    const p = buildPlannerAuth([auth('FP Planner')], [], ['SCP Planner', 'FP Planner'], [], '81');
    expect(p).toMatchObject({ super: false, scpSide: true, fpSide: true });
  });

  it('FP 인스턴스 = PLANNER·Y·조회 Division 만, SHOP_GROUP_ID 대문자', () => {
    const p = buildPlannerAuth([], [fpRow, { ...fpRow, DIVISION_ID: '40', PLANT_ID: 'NJ01' }, { ...fpRow, APPROVAL_FLAG: 'N', PLANT_ID: 'X' }], [], [], '81');
    expect([...p.fpCategoryIds]).toEqual(['NA00_EA_E']);
  });
});

describe('갈래 ②③④ 편집 범위(GoEdit cs:1015-1510)', () => {
  const today = dayjs();
  const D_TODAY = `D_${today.format('YYYYMMDD')}`;
  const M_FAR = `M_${today.add(6, 'month').format('YYYYMM')}`;
  const planner = (patch: Partial<PlannerAuth>): PlannerAuth => ({
    super: false,
    scpSide: false,
    fpSide: false,
    operGroupList: ['E2000'],
    fpCategoryIds: new Set(['NA00_EA_E']),
    ...patch,
  });
  const ctxP = (p: PlannerAuth, laneCount = 1): EditContext => ({
    isCurrentVersion: true,
    userId: 'nobody',
    groups: [],
    laneQtyCandidateCountOf: () => laneCount,
    planner: p,
  });
  const row = (patch: Record<string, unknown> = {}): CapaRow =>
    ({
      ...key(),
      PLANT_ID: 'NA00',
      FACTORY_ID: 'EA',
      OPERATION_GROUP_NAME: 'Electrode',
      EDITORBLE_YN: 'Y',
      LOSS_CODE: 'LA001',
      CATEGORY_ID: 'LINE ASSIGN',
      DATA_TABLE: 'SCM_ITEM_LINE_ASSIGN_M',
      ROW_RANKING: '1',
      USER_ID_1: 'u1',
      ...patch,
    }) as unknown as CapaRow;
  const tactRow = (patch: Record<string, unknown> = {}) =>
    row({ CATEGORY_ID: 'TACT TIME', LOSS_CODE: 'LA002', DATA_TABLE: 'SCM_TACT_TIME_M', ...patch });

  it('planner 없음(None) — 담당자가 아니면 전 칸 잠금', () => {
    expect(isCellEditable(row(), M_FAR, ctxP(planner({})))).toBe(false);
    expect(isCellEditable(row(), 'CONFIRM_FLAG', ctxP(planner({})))).toBe(false);
  });

  it('② Super — 메인·서브 공정 무관 개방, CONFIRM 은 열쇠 첫 행(ROW_RANKING 1)만', () => {
    const ctx = ctxP(planner({ super: true }));
    expect(isCellEditable(row({ OPERATION_ID: 'A3000' }), M_FAR, ctx)).toBe(true);
    expect(isCellEditable(row(), 'CONFIRM_FLAG', ctx)).toBe(true);
    expect(isCellEditable(row({ ROW_RANKING: '2' }), 'CONFIRM_FLAG', ctx)).toBe(false);
    expect(isCellEditable(row(), 'LANE_QTY', ctx)).toBe(true);
    expect(isCellEditable(row({ OPERATION_ID: 'E1000' }), 'LANE_QTY', ctx)).toBe(false);
  });

  it('② Super — FP 인스턴스 해당 행은 TACT D_ 잠금, 아니면 개방', () => {
    const ctx = ctxP(planner({ super: true }));
    expect(isCellEditable(tactRow(), D_TODAY, ctx)).toBe(false);
    expect(isCellEditable(tactRow(), M_FAR, ctx)).toBe(true);
    expect(isCellEditable(tactRow({ PLANT_ID: 'ZZ00' }), D_TODAY, ctx)).toBe(true);
  });

  it('③ SCP Side — LocationGroupByCapa 공정만, TACT D_ 잠금, LANE 개방', () => {
    const ctx = ctxP(planner({ scpSide: true }));
    expect(isCellEditable(row({ OPERATION_ID: 'A3000' }), M_FAR, ctx)).toBe(false);
    expect(isCellEditable(row(), M_FAR, ctx)).toBe(true);
    expect(isCellEditable(row(), 'LANE_QTY', ctx)).toBe(true);
    expect(isCellEditable(tactRow(), D_TODAY, ctx)).toBe(false);
    expect(isCellEditable(tactRow(), M_FAR, ctx)).toBe(true);
  });

  it('④ FP Side — FP 인스턴스 행만(공정 무관), LANE 잠금, TACT D_ 잠금', () => {
    const ctx = ctxP(planner({ fpSide: true }));
    expect(isCellEditable(row({ OPERATION_ID: 'A3000' }), M_FAR, ctx)).toBe(true);
    expect(isCellEditable(row({ PLANT_ID: 'ZZ00' }), M_FAR, ctx)).toBe(false);
    expect(isCellEditable(row(), 'LANE_QTY', ctx)).toBe(false);
    expect(isCellEditable(row(), 'CONFIRM_FLAG', ctx)).toBe(true);
    expect(isCellEditable(tactRow(), D_TODAY, ctx)).toBe(false);
  });

  it('④ FP 인스턴스가 없으면(bFP_Instance=false) 열지 않는다', () => {
    const ctx = ctxP(planner({ fpSide: true, fpCategoryIds: new Set() }));
    expect(isCellEditable(row(), M_FAR, ctx)).toBe(false);
  });

  it('③+④ 합집합 — LANE 은 ③ 이 열고, 담당자(①)이면 TACT D_ 도 열린다', () => {
    const ctx = ctxP(planner({ scpSide: true, fpSide: true }));
    expect(isCellEditable(row(), 'LANE_QTY', ctx)).toBe(true);
    expect(isCellEditable(row({ OPERATION_ID: 'A3000' }), 'LANE_QTY', ctx)).toBe(false);
    const owner = { ...ctx, userId: 'u1' };
    expect(isCellEditable(tactRow(), D_TODAY, owner)).toBe(true);
  });

  it('전제(Virtual Plant · 근무 달력 경계 · 손실 D_)는 갈래와 무관하게 유지', () => {
    const ctx = ctxP(planner({ super: true }));
    expect(isCellEditable(row({ PLANT_TYPE: 'VIRTUAL' }), M_FAR, ctx)).toBe(false);
    expect(isCellEditable(row({ DATA_TABLE: 'SCM_LOSS_M' }), D_TODAY, ctx)).toBe(false);
    const thisMonth = `M_${today.format('YYYYMM')}`;
    expect(isCellEditable(row({ DATA_TABLE: 'SCM_WORK_CALENDAR_M' }), thisMonth, ctx)).toBe(false);
  });
});
