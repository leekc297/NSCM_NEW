// DMF0044 Sales Reports — 순수 함수 값 검증 (asis-coverage-check §0.4)
//   대사표는 "누락 0"만 보증하고 **동작 동일성은 보증하지 않는다**. 이 파일이 그 축을 담당한다.
//   각 테스트는 AS-IS `DMF0044_Sales_Reports.cs`(1,483행) 라인 + 제약매트릭스 ID 를 인용한다.
import { describe, expect, it } from 'vitest';

import { DATA_TYPE, MSG } from './sales-reports.constants';
import type { SalesReportRow } from './sales-reports.types';
import { isDiv40, isDiv82 } from './utils/sales-reports.division';
import {
  dynKindOf,
  evalSalesReportCell,
  existingStaticEditable,
  insertStaticEditable,
} from './utils/sales-reports.editLock';
import { resolveDeptIdRows } from './utils/sales-reports.gridCombos';
import { buildBulkPayload, buildCutoffSaveRows, buildEtcSaveRows, isEtc } from './utils/sales-reports.save';

const THIS_MONTH = '202608';
const row = (o: Record<string, unknown>): SalesReportRow => o as unknown as SalesReportRow;

const evalCell = (o: {
  binding?: string;
  row?: SalesReportRow;
  divisionId?: string;
  dataType?: string;
}) =>
  evalSalesReportCell({
    binding: o.binding ?? 'M_202609',
    row: o.row,
    divisionId: o.divisionId ?? '40',
    dataType: o.dataType ?? DATA_TYPE.ETC,
    thisMonth: THIS_MONTH,
  });

describe('dynKindOf — 동적 컬럼 축 (AS-IS GetColumnTag L604/641/829: M_ 단일축)', () => {
  it('M_yyyymm 만 동적으로 인식한다', () => {
    expect(dynKindOf('M_202608')).toBe('M');
    // DMF0044 는 Y_/Q_/W_/D_ 축이 없다 — DMF0042(Y/Q/M)와 다른 점
    expect(dynKindOf('Y_2026')).toBeNull();
    expect(dynKindOf('W_20260801')).toBeNull();
    expect(dynKindOf('MEASURE')).toBeNull();
    expect(dynKindOf('M_2026')).toBeNull(); // 6자리 아님
  });
});

describe('evalSalesReportCell — 4변수 매트릭스 (제약매트릭스 §3 / EditButton L270~372)', () => {
  it('게이트0: Data Type=ALL 이면 전면 차단 (L272~276 → MSG00681)', () => {
    const r = row({ EDIT_FLAG: 'Y', MEASURE: 'LOC' });
    expect(evalCell({ row: r, dataType: DATA_TYPE.ALL }).editable).toBe(false);
  });

  it('정적 컬럼(M_ 아님)은 항상 잠금', () => {
    expect(evalCell({ binding: 'MEASURE', row: row({ EDIT_FLAG: 'Y' }) }).editable).toBe(false);
  });

  it('신규행(CRUD_TYPE=I)은 수량 전 구간 개방', () => {
    const r = row({ CRUD_TYPE: 'I', EDIT_FLAG: 'N', MEASURE: 'ETC' });
    expect(evalCell({ row: r, binding: 'M_202601' }).editable).toBe(true); // 과거도 개방
    expect(evalCell({ row: r, binding: 'M_202612' }).editable).toBe(true);
  });

  it('A-3: EDIT_FLAG=Y 이면 measure·division 무관 전 구간 개방 (L327)', () => {
    const r = row({ EDIT_FLAG: 'Y', MEASURE: '기타' });
    expect(evalCell({ row: r, binding: 'M_202601', divisionId: '82' }).editable).toBe(true);
    expect(evalCell({ row: r, binding: 'M_202612', divisionId: '82' }).editable).toBe(true);
  });

  it('M-1: LOC 는 계획구간(현재월~)만 — 과거 잠금 (L333/337)', () => {
    const r = row({ EDIT_FLAG: 'N', MEASURE: 'LOC' });
    expect(evalCell({ row: r, binding: 'M_202607' }).editable).toBe(false); // 과거
    expect(evalCell({ row: r, binding: THIS_MONTH ? 'M_202608' : '' }).editable).toBe(true); // 당월
    expect(evalCell({ row: r, binding: 'M_202609' }).editable).toBe(true); // 미래
  });

  it('D-2/M-2: RTF·Business_Plan 은 40 만 전 구간, 비40 은 잠금 (L346/350)', () => {
    const rtf = row({ EDIT_FLAG: 'N', MEASURE: 'RTF_QTY' });
    const bp = row({ EDIT_FLAG: 'N', MEASURE: 'Business_Plan' });
    for (const r of [rtf, bp]) {
      expect(evalCell({ row: r, binding: 'M_202601', divisionId: '40' }).editable).toBe(true);
      expect(evalCell({ row: r, binding: 'M_202612', divisionId: '40' }).editable).toBe(true);
      expect(evalCell({ row: r, binding: 'M_202612', divisionId: '82' }).editable).toBe(false);
    }
  });

  it('D-3/M-3: 기타 measure 는 40 만 과거구간, 비40 은 잠금 (L358~363)', () => {
    const r = row({ EDIT_FLAG: 'N', MEASURE: '기타' });
    expect(evalCell({ row: r, binding: 'M_202607', divisionId: '40' }).editable).toBe(true); // 과거만
    expect(evalCell({ row: r, binding: 'M_202609', divisionId: '40' }).editable).toBe(false); // 미래 잠금
    expect(evalCell({ row: r, binding: 'M_202607', divisionId: '82' }).editable).toBe(false);
  });

  it('isPast 는 현재월 경계로 갈린다 (V-1 — 당월은 계획구간)', () => {
    const r = row({ EDIT_FLAG: 'Y', MEASURE: 'LOC' });
    expect(evalCell({ row: r, binding: 'M_202607' }).isPast).toBe(true);
    expect(evalCell({ row: r, binding: 'M_202608' }).isPast).toBe(false);
  });
});

describe('정적 컬럼 편집 — InsertRow 잠금 12 (L-10~L-21 / L997~L1025)', () => {
  it('신규행은 잠금 12 외 개방', () => {
    expect(insertStaticEditable('DEPARTMENT_ID')).toBe(true);
    expect(insertStaticEditable('DEPT_ID')).toBe(true);
  });

  it('잠금 12 컬럼은 신규행에서도 잠금 — MEASURE 는 강제 세팅이라 선택 불가 (M-4)', () => {
    for (const c of [
      'DEPARTMENT_NAME', 'DEPT_NAME', 'CUTOFF_YYYYMMDD', 'NICK_NAME', 'SCM_SITE_ID',
      'PROJECT_CODE', 'APPLICATION', 'BIZ_TYPE_NAME', 'BIZ_TYPE_NAME40', 'DMS_SALES',
      'DMS_CUSTOMER', 'MEASURE',
    ]) {
      expect(insertStaticEditable(c)).toBe(false);
    }
  });

  it('기존행 정적 컬럼은 예외 없이 전량 잠금 (AS-IS EditButton 키영역 LockRange)', () => {
    expect(existingStaticEditable()).toBe(false);
  });
});

describe('division 판정 (제약매트릭스 §1 — 40/82 2종, 81 분기 없음)', () => {
  it('40/82 만 구분한다', () => {
    expect(isDiv40('40')).toBe(true);
    expect(isDiv82('82')).toBe(true);
    expect(isDiv40('82')).toBe(false);
    expect(isDiv82('81')).toBe(false); // 81 은 이 화면에 분기 자체가 없다
  });
});

describe('resolveDeptIdRows — DEPT_ID 후보 3분기 (M-6 / L990·L1180·L1195)', () => {
  const src = {
    deptDefault: [{ CODE: 'T2', NAME: 'TEAM2' }],
    deptByDepartment: [
      { CODE: 'A1', NAME: '팀A', DEPARTMENT_ID: 'D1' },
      { CODE: 'B1', NAME: '팀B', DEPARTMENT_ID: 'D2' },
    ],
    deptEtc: [{ CODE: 'E1', NAME: '기타팀' }],
  };

  it('DEPARTMENT_ID 미입력 → TEAM2 (AS-IS InsertRow L990, Param1="")', () => {
    expect(resolveDeptIdRows(row({}), src)).toEqual(src.deptDefault);
    expect(resolveDeptIdRows(row({ DEPARTMENT_ID: '   ' }), src)).toEqual(src.deptDefault);
  });

  it("DEPARTMENT_ID='기타' → ETC_SALE_RESULT_TYPE_40 (AS-IS L1195)", () => {
    expect(resolveDeptIdRows(row({ DEPARTMENT_ID: '기타' }), src)).toEqual(src.deptEtc);
  });

  it('그 외 → DEPARTMENT_TEAM 을 부모키로 필터 (AS-IS L1180 UPPER_DEPT_ID=@Param1)', () => {
    const got = resolveDeptIdRows(row({ DEPARTMENT_ID: 'D2' }), src);
    expect(got).toHaveLength(1);
    expect(got[0].CODE).toBe('B1');
  });

  it('매칭 없는 부서는 빈 목록 — 잘못된 팀이 섞이지 않는다', () => {
    expect(resolveDeptIdRows(row({ DEPARTMENT_ID: 'ZZZ' }), src)).toHaveLength(0);
  });
});

describe('저장 이원화 (E04-1/E04-2 — Data Type 라우팅)', () => {
  const base = {
    DIVISION_ID: '40', DEPARTMENT_ID: 'D1', DEPARTMENT_NAME: '부서1', DEPT_ID: 'T1',
    MEASURE: 'ETC', CURRENCY: 'KRW', M_202608: 10, M_202609: '',
  };

  it('isEtc 가 Data Type 을 라우팅한다', () => {
    expect(isEtc(DATA_TYPE.ETC)).toBe(true);
    expect(isEtc(DATA_TYPE.CUTOFF)).toBe(false);
    expect(isEtc(DATA_TYPE.ALL)).toBe(false);
  });

  // ⭐ 2026-08-10 정정 — AS-IS `.cs` 원문 재대조로 기대값을 바로잡았다.
  //   한 셀 변경 = **2 엔트리**(L601 measure=i / L638 measure=i+1, 수량은 각자 행 값).
  //   cellModelInfo/cellModel 은 **행 i 의 CELL_MODEL_INFO/CELL_MODEL 컬럼**(L607·L608 / L643·L644)이며
  //   짝 행 MEASURE·수량이 아니다. 잘못 넣으면 SAVE SP 의 MERGE ON 3키(FORECAST_INFO_CELL_MODEL /
  //   ATTRIBUTE3)가 어긋나 UPDATE 대신 중복 INSERT 가 된다(2026-08-10 원장 실증).
  it('ETC: 한 셀 변경 = 세트 2엔트리(행 i / i+1 measure·수량), 식별정보는 행 i (L566~694 i+=2)', () => {
    const r = row({ ...base, CELL_MODEL_INFO: '21700M53F', CELL_MODEL: 'CM-1' });
    const pair = row({ ...base, MEASURE: 'ETC_MODEL', M_202608: 7 });
    const res = buildEtcSaveRows({
      targets: [{ row: r, changes: { M_202608: 10 }, pair, isSetHead: true }],
      versionNo: 'V1',
    });
    expect(res.error).toBeUndefined();
    expect(res.rows).toHaveLength(2);
    expect(res.rows[0]).toMatchObject({
      activeFlag: 'M', measure: base.MEASURE, yyyymmdd: '202608', qty: '10',
      cellModelInfo: '21700M53F', cellModel: 'CM-1', versionNo: 'V1',
    });
    expect(res.rows[1]).toMatchObject({
      activeFlag: 'M', measure: 'ETC_MODEL', yyyymmdd: '202608', qty: '7',
      cellModelInfo: '21700M53F', cellModel: 'CM-1', versionNo: 'V1',
    });
    // identity 는 양쪽 모두 행 i 값 (AS-IS 는 두 블록 다 GetValue(i, …))
    expect(res.rows[1].deptId).toBe(res.rows[0].deptId);
  });

  it('ETC: 세트 파트너에서 변경이 나도 세트는 1회만 펼쳐진다 (중복 전송 방지)', () => {
    const head = row(base);
    const partner = row({ ...base, MEASURE: 'ETC_MODEL', M_202608: 7 });
    const res = buildEtcSaveRows({
      targets: [
        { row: partner, changes: { M_202608: 7 }, pair: head, isSetHead: false },
        { row: head, changes: {}, pair: partner, isSetHead: true },
      ],
      versionNo: 'V1',
    });
    expect(res.rows).toHaveLength(2); // 4 가 아니다
    expect(res.rows.map(x => x.measure)).toEqual([base.MEASURE, 'ETC_MODEL']);
  });

  it('ETC: Department 미입력이면 MSG00429 로 차단 (AS-IS L572)', () => {
    const r = row({ ...base, DEPARTMENT_ID: '', DEPARTMENT_NAME: '' });
    const res = buildEtcSaveRows({ targets: [{ row: r, changes: { M_202608: 1 } }], versionNo: 'V1' });
    expect(res.rows).toHaveLength(0);
    expect(res.error?.msgId).toBe(MSG.REQUIRED_FIELD);
    expect(res.error?.detail).toBe('Department');
  });

  it('ETC: 신규행은 activeFlag=I', () => {
    const r = row({ ...base, CRUD_TYPE: 'I' });
    const res = buildEtcSaveRows({ targets: [{ row: r }], versionNo: 'V1' });
    // 신규행은 값이 있는 M_ 셀 전량 수집 (M_202609 는 '' 라 제외)
    expect(res.rows).toHaveLength(1);
    expect(res.rows[0].activeFlag).toBe('I');
  });

  it('Cutoff: 신규행은 수집하지 않는다 (Insert 는 ETC 전용 — L973)', () => {
    const r = row({ ...base, CRUD_TYPE: 'I' });
    const res = buildCutoffSaveRows({ targets: [{ row: r, changes: { M_202608: 1 } }], versionNo: 'V1' });
    expect(res.rows).toHaveLength(0);
  });

  it("Cutoff: 수정행은 activeFlag='M' 고정 (L771~946)", () => {
    const r = row(base);
    const res = buildCutoffSaveRows({ targets: [{ row: r, changes: { M_202608: 10 } }], versionNo: 'V1' });
    expect(res.rows).toHaveLength(1);
    expect(res.rows[0].activeFlag).toBe('M');
    expect(res.rows[0].yyyymmdd).toBe('202608');
  });

  it("Cutoff: cutoffYyyymmdd 는 활성 경로에서 빈 문자열 (V-9 정책① 파리티)", () => {
    const res = buildCutoffSaveRows({
      targets: [{ row: row(base), changes: { M_202608: 1 } }], versionNo: 'V1',
    });
    expect(res.rows[0].cutoffYyyymmdd).toBe('');
  });
});

describe("buildBulkPayload — '^' delim 다건 (PROC_M COL_NM 키)", () => {
  it('키별로 행 값을 ^ 로 잇는다', () => {
    const payload = buildBulkPayload([
      { activeFlag: 'M', qty: '1' },
      { activeFlag: 'I', qty: '2' },
    ]);
    expect(payload).toEqual({ activeFlag: 'M^I', qty: '1^2' });
  });

  it('0건이면 null — 호출측이 저장 자체를 건너뛴다', () => {
    expect(buildBulkPayload([])).toBeNull();
  });
});
