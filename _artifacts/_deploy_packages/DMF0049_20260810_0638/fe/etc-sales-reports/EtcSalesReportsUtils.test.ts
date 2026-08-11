// ⭐ DMF0049 (Etc Sales Reports) — utils 순수함수 값 검증 (asis-coverage-check §0.4).
//   각 케이스는 AS-IS `DMF0049_Sales_ETC_Reports.cs`(1,727행) 라인을 근거로 단다.
//   ⚠ 정본 = `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0049_Sales_ETC_Reports/` (폴더단위 유일본).
import { describe, expect, it } from 'vitest';

import { BP_BASE_YM, measureCntOf, MSG, PLAN_RESULT, REPORT_TYPE } from './etc-sales-reports.constants';
import type { EtcSalesReportRow } from './etc-sales-reports.types';
import { isDiv40, isDiv81, isDiv82 } from './utils/etc-sales-reports.division';
import {
  baseYmOf,
  dynKindOf,
  evalEtcReportCell,
  existingStaticEditable,
  insertStaticEditable,
  isEditBlockedGroup,
} from './utils/etc-sales-reports.editLock';
import {
  cascadeClearColumns,
  resolveDeptIdRows,
  ROW_COMBO_IDS,
} from './utils/etc-sales-reports.gridCombos';
import { buildBulkPayload, buildEtcReportSaveRows } from './utils/etc-sales-reports.save';
import {
  validateEditGate,
  validateFind,
  validateVersionForAction,
} from './utils/etc-sales-reports.validate';

const row = (o: Record<string, unknown>): EtcSalesReportRow => o as unknown as EtcSalesReportRow;

// 편집 판정 기본 컨텍스트 — Plan / SP_W / 당해년 / 기준월 202508
const ctx = {
  divisionId: '40',
  planResult: PLAN_RESULT.PLAN,
  mdfType: REPORT_TYPE.SP_W as string,
  yyyy: '2025',
  thisMonth: '202508',
  sEditMeasure: '',
  userGroup: 'DM Administrator',
};

describe('division 분기 (40 / 81 계열 / 82)', () => {
  it('81 은 접두 매칭이라 81_UC 등 하위 코드도 포함한다', () => {
    expect(isDiv40('40')).toBe(true);
    expect(isDiv81('81')).toBe(true);
    expect(isDiv81('81_UC')).toBe(true);
    expect(isDiv82('82')).toBe(true);
    expect(isDiv81('40')).toBe(false);
  });

  it('measureCntOf — 40=3 / 81계열=2 / 그 외=1 (세트 행 수)', () => {
    expect(measureCntOf('40')).toBe(3);
    expect(measureCntOf('81')).toBe(2);
    expect(measureCntOf('81_HM')).toBe(2);
    expect(measureCntOf('82')).toBe(1);
  });
});

describe('동적 binding / 기준월', () => {
  it('M_yyyymm 만 동적으로 인식한다 (DMF0049 는 M 단일축)', () => {
    expect(dynKindOf('M_202508')).toBe('M');
    expect(dynKindOf('D_20250801')).toBeNull();
    expect(dynKindOf('ITEM_ID')).toBeNull();
  });

  it('baseYmOf — BP 는 6자리 고정 상수 / SP_W 는 조회 시점 당월 (결함② 교정)', () => {
    expect(baseYmOf(REPORT_TYPE.BP_M, '202508')).toBe(BP_BASE_YM);
    expect(BP_BASE_YM).toHaveLength(6); // AS-IS FindData L577 의 8자리는 결함
    expect(baseYmOf(REPORT_TYPE.SP_W, '202508')).toBe('202508');
  });
});

describe('G0 그룹 게이트 (AS-IS EditButton L341~345 — MSG00096)', () => {
  it('DM Planner 는 82 를 뺀 전 division 에서 편집 차단 (블랙리스트 1그룹)', () => {
    expect(isEditBlockedGroup('DM Planner', '40')).toBe(true);
    expect(isEditBlockedGroup('DM Planner', '81_UC')).toBe(true);
    expect(isEditBlockedGroup('DM Planner', '82')).toBe(false); // 82 만 허용
  });

  it('다른 그룹은 차단하지 않는다 (화이트리스트가 아니다)', () => {
    expect(isEditBlockedGroup('DM Administrator', '40')).toBe(false);
    expect(isEditBlockedGroup('DM Viewer', '40')).toBe(false);
  });

  it('G0 에 걸리면 셀 판정이 전면 잠금', () => {
    const st = evalEtcReportCell({
      ...ctx, binding: 'M_202512', row: row({ MEASURE: 'LOC' }), userGroup: 'DM Planner',
    });
    expect(st.editable).toBe(false);
  });
});

describe('동적 셀 편집 매트릭스 (제약매트릭스 §2~§6)', () => {
  it('정적 컬럼(M_ 아님)은 항상 잠금', () => {
    expect(evalEtcReportCell({ ...ctx, binding: 'ITEM_ID', row: row({}) }).editable).toBe(false);
  });

  it('P1 — Plan && 과거 연도는 전 구간 잠금 (L421~424 [C20201223-000448])', () => {
    const st = evalEtcReportCell({
      ...ctx, binding: 'M_202512', row: row({ MEASURE: 'LOC' }), yyyy: '2024', thisMonth: '202508',
    });
    expect(st.editable).toBe(false);
  });

  it('P2 — Plan 기준월 이전(과거)은 잠금 / P3 — 기준월 이후는 40 개방 (L417~438)', () => {
    const past = evalEtcReportCell({ ...ctx, binding: 'M_202507', row: row({ MEASURE: 'LOC' }) });
    expect(past).toEqual({ editable: false, isPast: true });
    const future = evalEtcReportCell({ ...ctx, binding: 'M_202509', row: row({ MEASURE: 'LOC' }) });
    expect(future).toEqual({ editable: true, isPast: false });
  });

  it('비40 은 MEASURE === sEditMeasure 일 때만 개방 (L427~438 §3)', () => {
    const base = { ...ctx, binding: 'M_202509', divisionId: '82', sEditMeasure: 'SalesAmt_KRW' };
    expect(evalEtcReportCell({ ...base, row: row({ MEASURE: 'SalesAmt_KRW' }) }).editable).toBe(true);
    expect(evalEtcReportCell({ ...base, row: row({ MEASURE: 'LOC' }) }).editable).toBe(false);
  });

  it('⭐ sEditMeasure 가 빈값이면 비40 은 전 Measure 잠금 — 콤보 quoting 결함의 실제 파급', () => {
    // 2026-08-10 실측: param1/param2 미따옴표 → HTTP 500 → sEditMeasure 항상 '' → 82 편집 전면 무력화
    const st = evalEtcReportCell({
      ...ctx, binding: 'M_202509', divisionId: '82', sEditMeasure: '',
      row: row({ MEASURE: 'SalesAmt_KRW' }),
    });
    expect(st.editable).toBe(false);
  });

  it('Result — R1 미래(기준월 이상) 잠금 / R2 과거는 40 개방 (L442~459)', () => {
    const base = { ...ctx, planResult: PLAN_RESULT.RESULT };
    expect(evalEtcReportCell({ ...base, binding: 'M_202509', row: row({ MEASURE: 'LOC' }) }))
      .toEqual({ editable: false, isPast: true });
    expect(evalEtcReportCell({ ...base, binding: 'M_202507', row: row({ MEASURE: 'LOC' }) }))
      .toEqual({ editable: true, isPast: false });
  });

  it('R3 — Result && BP 는 전체 잠금 (AS-IS 실질 undefined 지대 — 보수 확정 D-6)', () => {
    const st = evalEtcReportCell({
      ...ctx, planResult: PLAN_RESULT.RESULT, mdfType: REPORT_TYPE.BP_M,
      binding: 'M_201712', row: row({ MEASURE: 'LOC' }),
    });
    expect(st.editable).toBe(false);
  });
});

describe('정적 컬럼 잠금 (InsertRow L965~1024 division 분기)', () => {
  it('공통 잠금 세트는 division 무관 (MEASURE 는 세트 강제 세팅이라 선택 불가)', () => {
    for (const div of ['40', '81', '82']) {
      expect(insertStaticEditable('MEASURE', div)).toBe(false);
      expect(insertStaticEditable('T_DEPT_NAME', div)).toBe(false);
    }
  });

  it('81 계열 — FCST_TYPE / CELL_MODEL_INFO 잠금, 그 외 개방 (L983~1003)', () => {
    expect(insertStaticEditable('FCST_TYPE', '81_UC')).toBe(false);
    expect(insertStaticEditable('CELL_MODEL_INFO', '81')).toBe(false);
    expect(insertStaticEditable('ITEM_ID', '81')).toBe(true);
  });

  it('82 — ITEM_ID / CELL_MODEL_INFO 잠금 (L1004~1024). 81 과 잠금 대상이 다르다', () => {
    expect(insertStaticEditable('ITEM_ID', '82')).toBe(false);
    expect(insertStaticEditable('FCST_TYPE', '82')).toBe(true); // 81 과 반대
  });

  it('40 — SCM_SITE_ID 만 추가 잠금 (L978)', () => {
    expect(insertStaticEditable('SCM_SITE_ID', '40')).toBe(false);
    expect(insertStaticEditable('ITEM_ID', '40')).toBe(true);
  });

  it('기존행 정적 컬럼은 예외 없이 전량 잠금 (EditButton 키영역 L399~412)', () => {
    expect(existingStaticEditable()).toBe(false);
  });
});

describe('DEPT_ID 행별 콤보 2분기 (AS-IS L1268 / L1294)', () => {
  const deptDefault = [{ CODE: 'D0', NAME: 'default' }];
  const deptByDepartment = [
    { CODE: 'T1', NAME: '팀1', DEPARTMENT_ID: '111' },
    { CODE: 'T2', NAME: '팀2', DEPARTMENT_ID: '222' },
  ];
  const src = { deptDefault, deptByDepartment };

  it('40 && 표시명 ≠ 기타 → 부모키(DEPARTMENT_ID)로 필터한 TEAM (L1268)', () => {
    const got = resolveDeptIdRows(
      row({ DEPARTMENT_ID: '111', T_DEPARTMENT_NAME: '마케팅1.미주' }), '40', src);
    expect(got).toEqual([deptByDepartment[0]]);
  });

  it("40 && 표시명 '기타' → division 단위 TEAM2 (L1294 — DMF0044 와 달리 ETC 콤보가 아니다)", () => {
    const got = resolveDeptIdRows(row({ DEPARTMENT_ID: '111', T_DEPARTMENT_NAME: '기타' }), '40', src);
    expect(got).toBe(deptDefault);
  });

  it('비40 은 부모키 필터를 하지 않는다 (AS-IS 는 40 블록 안에서만 재바인딩)', () => {
    expect(resolveDeptIdRows(row({ DEPARTMENT_ID: '111' }), '82', src)).toBe(deptDefault);
  });

  it('DEPARTMENT_ID 미입력이면 기본 목록 — 매칭 없는 부서는 빈 목록', () => {
    expect(resolveDeptIdRows(row({ DEPARTMENT_ID: '' }), '40', src)).toBe(deptDefault);
    expect(resolveDeptIdRows(row({ DEPARTMENT_ID: '999', T_DEPARTMENT_NAME: 'X' }), '40', src)).toEqual([]);
  });

  it('부모키 동반 콤보는 DMF0044_DEPARTMENT_TEAM 이다 (TEAM2 는 부모키 컬럼이 없다)', () => {
    expect(ROW_COMBO_IDS.DEPT_BY_DEPARTMENT).toBe('DMF0044_DEPARTMENT_TEAM');
  });
});

describe('cascade clear 매트릭스 (AS-IS L1276~1287 · L1331~1405)', () => {
  const FULL5 = ['ITEM_ID', 'NICK_NAME', 'END_CUST_REPORT', 'CUST_REPORT', 'PRODUCT_GROUP'];

  it('DEPARTMENT_ID 변경은 division 40 에서만 동작한다 (L1265 · 블록 끝 주석 L1326)', () => {
    expect(cascadeClearColumns('DEPARTMENT_ID', row({ CRUD_TYPE: 'I' }), '82')).toEqual([]);
    expect(cascadeClearColumns('DEPARTMENT_ID', row({ CRUD_TYPE: 'I' }), '81')).toEqual([]);
  });

  it("DEPARTMENT_ID · 40 — 'M' 이면서 ≠기타 는 CUST_REPORT 만 (L1276~1279)", () => {
    expect(cascadeClearColumns(
      'DEPARTMENT_ID', row({ CRUD_TYPE: 'M', T_DEPARTMENT_NAME: '마케팅1.미주' }), '40'))
      .toEqual(['CUST_REPORT']);
  });

  it("DEPARTMENT_ID · 40 — 'M' 이면서 '기타' 는 clear 없음 (L1306~1309 콤보만 dtNull)", () => {
    expect(cascadeClearColumns(
      'DEPARTMENT_ID', row({ CRUD_TYPE: 'M', T_DEPARTMENT_NAME: '기타' }), '40')).toEqual([]);
  });

  it("DEPARTMENT_ID · 40 — 'M' 이 아니면 표시명 무관 5컬럼 (L1281~1287 · L1316~1320)", () => {
    expect(cascadeClearColumns('DEPARTMENT_ID', row({ CRUD_TYPE: 'I' }), '40')).toEqual(FULL5);
    expect(cascadeClearColumns(
      'DEPARTMENT_ID', row({ CRUD_TYPE: 'I', T_DEPARTMENT_NAME: '기타' }), '40')).toEqual(FULL5);
  });

  it("DEPT_ID — DEPARTMENT_ID 있고 'M' 이면 clear 없음 (L1344~1352 콤보만 재설정)", () => {
    expect(cascadeClearColumns('DEPT_ID', row({ CRUD_TYPE: 'M', DEPARTMENT_ID: '111' }), '40'))
      .toEqual([]);
  });

  it("DEPT_ID — DEPARTMENT_ID 있고 'M' 이 아니면 5컬럼 (L1374~1378)", () => {
    expect(cascadeClearColumns('DEPT_ID', row({ CRUD_TYPE: 'I', DEPARTMENT_ID: '111' }), '40'))
      .toEqual(FULL5);
  });

  it('DEPT_ID — DEPARTMENT_ID 공란이면 3컬럼뿐 (L1398~1400: ITEM_ID·NICK_NAME 은 건드리지 않는다)', () => {
    expect(cascadeClearColumns('DEPT_ID', row({ CRUD_TYPE: 'I', DEPARTMENT_ID: '' }), '40'))
      .toEqual(['END_CUST_REPORT', 'CUST_REPORT', 'PRODUCT_GROUP']);
    expect(cascadeClearColumns('DEPT_ID', row({ CRUD_TYPE: 'M', DEPARTMENT_ID: '' }), '40'))
      .toEqual(['CUST_REPORT']);
  });

  it('DEPT_ID 변경은 division 무관 (DEPARTMENT_ID 와 다른 지점)', () => {
    expect(cascadeClearColumns('DEPT_ID', row({ CRUD_TYPE: 'I', DEPARTMENT_ID: '111' }), '82'))
      .toEqual(FULL5);
  });

  it('그 외 컬럼은 clear 없음', () => {
    expect(cascadeClearColumns('ITEM_ID', row({ CRUD_TYPE: 'I' }), '40')).toEqual([]);
  });
});

describe('SAVE payload 조립 (AS-IS SaveData L633~915 — 단일 SP 35키)', () => {
  const base = {
    DIVISION_ID: '82', DATA_SEQ: '120', DEPARTMENT_ID: '111', DEPARTMENT_NAME: '마케팅',
    DEPT_ID: '222', CUST_REPORT: 'IM', END_CUST_REPORT: 'IM', PRODUCT_GROUP: '원통형',
    ITEM_ID: 'MCC1', CURRENCY: 'USD', COMPANY_ID: 'HQ00',
  };

  it('세트 × 채택월 × 세트내 행으로 전개 — measure/qty 는 k 행 값, identity 는 세트 첫 행', () => {
    // ⚠ 81 계열로 둔다 — 40·82 는 아래 '전 월 수집' 분기가 걸려 행 수가 달라진다(그건 별도 케이스).
    const r1 = row({ ...base, DIVISION_ID: '81', MEASURE: 'LOC', M_202508: 10 });
    const r2 = row({ ...base, DIVISION_ID: '81', MEASURE: 'SalesAmt_LOC', M_202508: 20, DEPT_ID: '999' });
    const res = buildEtcReportSaveRows({
      targets: [{ setRows: [{ row: r1, changes: { M_202508: 10 } }, { row: r2 }], isInsert: false }],
      versionNo: 'V1', resultMonth: '', monthBindings: ['M_202508', 'M_202509'],
    });
    expect(res.error).toBeUndefined();
    expect(res.rows).toHaveLength(2);
    expect(res.rows.map(x => [x.measure, x.qty])).toEqual([['LOC', '10'], ['SalesAmt_LOC', '20']]);
    // identity 는 세트 첫 행 — 두 번째 행의 DEPT_ID('999')가 새어나오면 안 된다
    expect(res.rows.every(x => x.deptId === '222')).toBe(true);
    expect(res.rows.every(x => x.yyyymmdd === '202508')).toBe(true);
  });

  it('82 && 수정행 → 변경 안 한 달까지 전 월 수집 (AS-IS L741~744)', () => {
    const r = row({ ...base, MEASURE: 'LOC', M_202508: 10, M_202509: 0 });
    const res = buildEtcReportSaveRows({
      targets: [{ setRows: [{ row: r, changes: { M_202508: 10 } }], isInsert: false }],
      versionNo: 'V1', resultMonth: '', monthBindings: ['M_202508', 'M_202509'],
    });
    expect(res.rows.map(x => x.yyyymmdd)).toEqual(['202508', '202509']);
  });

  it('81 계열 수정행은 전 월 수집 대상이 아니다 — 변경 월만 (40·82 만 확장)', () => {
    const r = row({ ...base, DIVISION_ID: '81', MEASURE: 'LOC', M_202508: 10, M_202509: 0 });
    const res = buildEtcReportSaveRows({
      targets: [{ setRows: [{ row: r, changes: { M_202508: 10 } }], isInsert: false }],
      versionNo: 'V1', resultMonth: '', monthBindings: ['M_202508', 'M_202509'],
    });
    expect(res.rows.map(x => x.yyyymmdd)).toEqual(['202508']);
  });

  it('신규 세트는 값이 있는 월만 수집하고 activeFlag=I (dataSeq 는 행값 그대로)', () => {
    const r = row({ ...base, DATA_SEQ: '', MEASURE: 'LOC', M_202508: 5, M_202509: '' });
    const res = buildEtcReportSaveRows({
      targets: [{ setRows: [{ row: r }], isInsert: true }],
      versionNo: 'V1', resultMonth: '', monthBindings: ['M_202508', 'M_202509'],
    });
    expect(res.rows).toHaveLength(1);
    expect(res.rows[0].activeFlag).toBe('I');
    expect(res.rows[0].dataSeq).toBe('');
    expect(res.rows[0].departmentEditFlag).toBe('true'); // 신규 + 부서 입력됨 (L766~773)
  });

  it('변경 셀이 없으면 그 세트는 통째로 건너뛴다', () => {
    const r = row({ ...base, MEASURE: 'LOC' });
    const res = buildEtcReportSaveRows({
      targets: [{ setRows: [{ row: r, changes: {} }], isInsert: false }],
      versionNo: 'V1', resultMonth: '', monthBindings: ['M_202508'],
    });
    expect(res.rows).toHaveLength(0);
  });

  it('Department 미입력이면 MSG00429 로 차단 (AS-IS L748 MSG00002 재매핑)', () => {
    const r = row({ ...base, DEPARTMENT_ID: '', DEPARTMENT_NAME: '', MEASURE: 'LOC' });
    const res = buildEtcReportSaveRows({
      targets: [{ setRows: [{ row: r, changes: { M_202508: 1 } }], isInsert: false }],
      versionNo: 'V1', resultMonth: '', monthBindings: ['M_202508'],
    });
    expect(res.rows).toHaveLength(0);
    expect(res.error?.msgId).toBe(MSG.REQUIRED_FIELD);
    expect(res.error?.detail).toBe('Department');
  });

  it("buildBulkPayload — 키별로 '^' 결합 / 0건이면 null", () => {
    const rows = [
      { a: '1', b: 'x' } as never,
      { a: '2', b: 'y' } as never,
    ];
    expect(buildBulkPayload(rows)).toEqual({ a: '1^2', b: 'x^y' });
    expect(buildBulkPayload([])).toBeNull();
  });
});

describe('검증 게이트 (validate)', () => {
  it('조회 전 버전 필수 = MSG00283 / 저장·팝업 = MSG00688 (AS-IS 00281 재매핑)', () => {
    expect(validateFind('')).toEqual({ ok: false, msgId: MSG.REQUIRE_VERSION_FIND });
    expect(validateFind('  ')).toEqual({ ok: false, msgId: MSG.REQUIRE_VERSION_FIND });
    expect(validateFind('V1')).toEqual({ ok: true });
    expect(validateVersionForAction('')).toEqual({ ok: false, msgId: MSG.REQUIRE_VERSION_ACTION });
  });

  it('편집 게이트는 G0 판정을 그대로 쓴다 (MSG00096)', () => {
    expect(validateEditGate('DM Planner', '40')).toEqual({ ok: false, msgId: MSG.NO_PERMISSION });
    expect(validateEditGate('DM Planner', '82')).toEqual({ ok: true });
  });
});
