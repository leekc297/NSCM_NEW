// @vitest-environment node
/**
 * DMF0003 MKT FCST utils 단위테스트 — AS-IS 산식 1:1 대사 (2026-08-12 신설, 게이트 §9)
 *
 * 원천: 정본 `GSCM.DM.Forms.UIL/Plan/DMF0003_MktFcst/DMF0003_MktFcst.cs` (7,143줄 전량 Read)
 *   + `Doc/화면분석서/DMF0003_MktFcst_제약매트릭스_상세.md` 제약 ID(CB·CE·CG 계열).
 */
import { describe, expect, it } from 'vitest';

import {
  buildDuplicateKey,
  divisionKindOf,
  isEditableDivision,
  isSspSyncTarget,
  requiresPlantSite,
  usesProjectKeys,
} from './mkt-fcst.division';
import { buildEditCutoff, dynKindOf, thisWeekMondayYmd } from './mkt-fcst.editLock';
import { buildSavePayload, buildUnfoldRows } from './mkt-fcst.save';
import { parseSspSyncMap, sspSyncStateOf } from './mkt-fcst.sspSync';

describe('division 축 (CB-04 / CH-04~06 — .cs Substring(0,2)=="81" || =="82")', () => {
  it('divisionKindOf — 40 / 81 계열 / 82 3분기 (D40/D81/D82)', () => {
    expect(divisionKindOf('40')).toBe('D40');
    expect(divisionKindOf('81')).toBe('D81');
    expect(divisionKindOf('81_UC')).toBe('D81');
    expect(divisionKindOf('82')).toBe('D82');
  });

  it('usesProjectKeys — 81*/82 만 Project 키 (40 은 Customer40 계열)', () => {
    expect(usesProjectKeys('81')).toBe(true);
    expect(usesProjectKeys('81_HM')).toBe(true);
    expect(usesProjectKeys('82')).toBe(true);
    expect(usesProjectKeys('40')).toBe(false);
  });

  it('requiresPlantSite — 81* 만 (.cs L5417 "40, 82은 해당없음")', () => {
    expect(requiresPlantSite('81')).toBe(true);
    expect(requiresPlantSite('81_ST')).toBe(true);
    expect(requiresPlantSite('82')).toBe(false);
    expect(requiresPlantSite('40')).toBe(false);
  });

  it('isSspSyncTarget — 40 × MKT_FCST_RP 만 (.cs L3703·4496)', () => {
    expect(isSspSyncTarget('40', 'MKT_FCST_RP')).toBe(true);
    expect(isSspSyncTarget('40', 'BNPIn')).toBe(false);
    expect(isSspSyncTarget('81', 'MKT_FCST_RP')).toBe(false);
  });

  it('isEditableDivision — 메타 집합 구동 (CA-02, DM_UI_EDITABLE_DIVISION)', () => {
    const set = new Set(['82']);
    expect(isEditableDivision('82', set)).toBe(true);
    expect(isEditableDivision('40', set)).toBe(false);
    expect(isEditableDivision('81', set)).toBe(false);
  });

  it('buildDuplicateKey — division 분기 키 (CG-02, 81*=9키/82·40=8키 .cs L4262~4302)', () => {
    const row81 = {
      DIVISION_ID: '81', PROJECT_CODE: 'P1', SCM_SITE_ID: 'S1', ITEM_ID: 'I1',
      DOM_EXP: 'E', FCST_TYPE: 'MPS', INCOTERMS: 'FOB', MEASURE: 'MKT_FCST_RP',
      PLANT_SITE_ID: 'PL1',
    };
    const k81 = buildDuplicateKey(row81, '81');
    expect(k81).toContain('PL1'); // 81 은 PlantSite 포함
    const k82 = buildDuplicateKey({ ...row81, DIVISION_ID: '82' }, '82');
    expect(k82).not.toContain('PL1'); // 82 는 PlantSite 제외
    // 키가 같으면 중복 판정 동일
    expect(buildDuplicateKey(row81, '81')).toBe(buildDuplicateKey({ ...row81 }, '81'));
  });
});

describe('editLock 축 (CB-101~104 — 버킷×시점)', () => {
  it('dynKindOf — M_/W_/D_ 판별', () => {
    expect(dynKindOf('M_202608')).toBe('M');
    expect(dynKindOf('W_2026081')).toBe('W');
    expect(dynKindOf('D_20260812')).toBe('D');
    expect(dynKindOf('MEASURE')).toBe(null);
  });

  it('thisWeekMondayYmd — 당주 월요일 (.cs L953 AddDays(Monday-DayOfWeek))', () => {
    // 2026-08-12(수) → 2026-08-10(월)
    expect(thisWeekMondayYmd(new Date(2026, 7, 12))).toBe('20260810');
    // 일요일은 **전주** 월요일 (C# DayOfWeek.Sunday=0 → +(1-0)=+1 이 아니라 JS 구현은 -6)
    expect(thisWeekMondayYmd(new Date(2026, 7, 16))).toBe('20260810');
    // 월요일은 그 날
    expect(thisWeekMondayYmd(new Date(2026, 7, 10))).toBe('20260810');
  });

  it('buildEditCutoff — O_RC2/O_RC3 없이도 기본 cutoff 산출(관대)', () => {
    const c = buildEditCutoff(null, null, new Date(2026, 7, 12), ['W_2026081', 'W_2026082']);
    expect(c.today).toBe('20260812');
    expect(c.month).toBe('202608');
    expect(c.div40MonthCutoff).toBe(null);
  });
});

describe('save 축 (E04-2/CE-06 — buildUnfoldRows/buildSavePayload .cs SetSaveData L5395~5522 1:1)', () => {
  const baseRow = {
    CRUD_TYPE: 'I',
    DIVISION_ID: '82', PROJECT_CODE: 'P1', SCM_SITE_ID: 'S1', ITEM_ID: 'I1',
    DOM_EXP: 'E', FCST_TYPE: 'MPS', INCOTERMS: 'FOB', MEASURE: 'MKT_FCST_RP',
    PLANT_SITE_ID: '', AS_FROM_SITE: '',
    D_20260810: 10, D_20260811: '', D_20260812: 5,
  };

  it('신규 행 — 값 있는 D_ 셀만 unfold (activeFlag I)', () => {
    const rows = buildUnfoldRows({
      insertedRows: [baseRow as never],
      editedChanges: new Map(),
      divisionId: '82',
      createdBy: 'tester',
    });
    expect(rows).toHaveLength(2); // 10·5 만 — 빈 셀 skip
    expect(rows[0].activeFlag).toBe('I');
    expect(rows.map(r => r.yyyymmdd).sort()).toEqual(['20260810', '20260812']);
  });

  it('AS_FROM_SITE — 행 컬럼 값 직접 + ","→"^" (CE-06 — .cs L2297·L2401)', () => {
    const r = { ...baseRow, AS_FROM_SITE: 'A002-W,HQ05-W' };
    const rows = buildUnfoldRows({
      insertedRows: [r as never],
      editedChanges: new Map(),
      divisionId: '82',
      createdBy: 'tester',
    });
    expect(rows[0].asFromSite).toBe('A002-W^HQ05-W');
  });

  it('buildSavePayload — 16키 ^delim + bucket/authority 단일값 (.cs L2424~2439)', () => {
    const rows = buildUnfoldRows({
      insertedRows: [baseRow as never],
      editedChanges: new Map(),
      divisionId: '82',
      createdBy: 'tester',
    });
    const p = buildSavePayload(rows, 'WEEKLY', 'DM Planner');
    expect(p).not.toBeNull();
    expect(p!.activeFlag).toBe('I^I');
    expect(p!.bucket).toBe('WEEKLY');
    expect(p!.authority).toBe('DM Planner');
    expect(p!.yyyymmdd.split('^')).toHaveLength(2);
  });

  it('빈 목록 → null (MSG00034 경로 — 저장 대상 없음)', () => {
    expect(buildSavePayload([], 'WEEKLY', 'X')).toBe(null);
  });

  it('수정 행 — EditTracker 변경 D_ 만 unfold (activeFlag M, 빈 셀=0 클리어 의도)', () => {
    const mRow = { ...baseRow, CRUD_TYPE: undefined, D_20260810: '' } as Record<string, unknown>;
    const rows = buildUnfoldRows({
      insertedRows: [],
      editedChanges: new Map([[mRow, { D_20260810: 10 }]]) as never,
      divisionId: '82',
      createdBy: 'tester',
    });
    expect(rows).toHaveLength(1);
    expect(rows[0].activeFlag).toBe('M');
    expect(rows[0].qty).toBe('0'); // 빈 셀 = 0 으로 클리어
  });
});

describe('SSP 동기화 축 (CI-01/CG-04 — ATTR1 파싱 .cs L2186~2213)', () => {
  it('parseSspSyncMap — "일자/구분^…" → Map (A=all, P=partial)', () => {
    const row = { ATTR1: '20260810/A^20260812/P' } as never;
    const m = parseSspSyncMap(row, '40');
    expect(sspSyncStateOf(m, 'D_20260810')).toBe('A');
    expect(sspSyncStateOf(m, 'D_20260812')).toBe('P');
    expect(sspSyncStateOf(m, 'D_20260811')).toBe(null);
  });

  it('40/82 외 division 은 빈 Map (.cs sDivision=="40"||"82" 분기)', () => {
    const row = { ATTR1: '20260810/A' } as never;
    const m = parseSspSyncMap(row, '81');
    expect(sspSyncStateOf(m, 'D_20260810')).toBe(null);
  });
});
