import { describe, expect, it } from 'vitest';

import { DATA_TYPE } from '../sales-reports.constants';
import type { SalesReportRow } from '../sales-reports.types';

import { dynKindOf, evalSalesReportCell, staticEditableByMeta } from './sales-reports.editLock';

const THIS_MONTH = '202607';

const cell = (params: {
  binding?: string;
  row?: SalesReportRow;
  divisionId?: string;
  dataType?: string;
}) =>
  evalSalesReportCell({
    binding: params.binding ?? 'M_202607',
    row: params.row,
    divisionId: params.divisionId ?? '40',
    dataType: params.dataType ?? DATA_TYPE.CUTOFF,
    thisMonth: THIS_MONTH,
  });

describe('dynKindOf', () => {
  it('M_yyyymm 만 동적 컬럼으로 인식 (Y_/Q_/W_/D_ 없음)', () => {
    expect(dynKindOf('M_202607')).toBe('M');
    expect(dynKindOf('W_20260701')).toBeNull();
    expect(dynKindOf('DIVISION_ID')).toBeNull();
  });
});

// TC-DMF0044-D 편집 게이트(4변수): EDIT_FLAG × Measure × Division × 시점.
describe('evalSalesReportCell', () => {
  it('정적 컬럼(binding 이 M_ 형식이 아님)은 항상 잠금', () => {
    expect(cell({ binding: 'DIVISION_ID', row: { EDIT_FLAG: 'Y' } })).toStrictEqual({
      editable: false,
      isPast: false,
    });
  });

  it('게이트0 — Data Type=ALL 은 행 상태와 무관하게 전면 차단', () => {
    const result = cell({ dataType: DATA_TYPE.ALL, row: { EDIT_FLAG: 'Y', MEASURE: 'LOC' } });
    expect(result.editable).toBe(false);
  });

  it('행 데이터 없음(row undefined) → 잠금', () => {
    expect(cell({ row: undefined }).editable).toBe(false);
  });

  it('신규 삽입행(CRUD_TYPE=I) 은 과거/미래 구분 없이 전 구간 개방', () => {
    expect(cell({ binding: 'M_202601', row: { CRUD_TYPE: 'I' } }).editable).toBe(true);
    expect(cell({ binding: 'M_202612', row: { CRUD_TYPE: 'I' } }).editable).toBe(true);
  });

  it('EDIT_FLAG=Y 행은 Division/Measure 무관 전 구간 개방', () => {
    const row: SalesReportRow = { EDIT_FLAG: 'Y', MEASURE: '기타매출' };
    expect(cell({ binding: 'M_202601', row, divisionId: '82' }).editable).toBe(true);
    expect(cell({ binding: 'M_202612', row, divisionId: '82' }).editable).toBe(true);
  });

  it('MEASURE=LOC 은 계획구간(현재월 이후)만 개방 — 과거는 잠금', () => {
    const row: SalesReportRow = { MEASURE: 'LOC' };
    expect(cell({ binding: 'M_202606', row }).editable).toBe(false); // 과거
    expect(cell({ binding: 'M_202607', row }).editable).toBe(true); // 당월
    expect(cell({ binding: 'M_202608', row }).editable).toBe(true); // 미래
  });

  it('MEASURE=LOC 은 비40 Division에서 EDIT_FLAG=Y 예외 외 전면 잠금', () => {
    const row: SalesReportRow = { MEASURE: 'LOC' };
    expect(cell({ binding: 'M_202607', row, divisionId: '81' }).editable).toBe(false);
    expect(cell({ binding: 'M_202608', row, divisionId: '82' }).editable).toBe(false);
  });

  it('RTF*/Business_Plan 은 Div40 전체 개방, 비40 은 전면 잠금', () => {
    const rtf: SalesReportRow = { MEASURE: 'RTF_SYS_RP' };
    expect(cell({ binding: 'M_202601', row: rtf, divisionId: '40' }).editable).toBe(true);
    expect(cell({ binding: 'M_202612', row: rtf, divisionId: '40' }).editable).toBe(true);
    expect(cell({ binding: 'M_202601', row: rtf, divisionId: '82' }).editable).toBe(false);

    const bp: SalesReportRow = { MEASURE: 'Business_Plan' };
    expect(cell({ binding: 'M_202601', row: bp, divisionId: '40' }).editable).toBe(true);
    expect(cell({ binding: 'M_202601', row: bp, divisionId: '82' }).editable).toBe(false);
  });

  it('기타 Measure 는 Div40 과거구간만 개방(미래 잠금), 비40 은 전면 잠금', () => {
    const row: SalesReportRow = { MEASURE: '기타매출' };
    expect(cell({ binding: 'M_202606', row, divisionId: '40' }).editable).toBe(true); // 과거
    expect(cell({ binding: 'M_202608', row, divisionId: '40' }).editable).toBe(false); // 미래
    expect(cell({ binding: 'M_202606', row, divisionId: '82' }).editable).toBe(false);
  });

  it('isPast 는 Measure 게이트와 무관하게 현재월 기준으로 산정', () => {
    expect(cell({ binding: 'M_202606', row: { MEASURE: 'LOC' } }).isPast).toBe(true);
    expect(cell({ binding: 'M_202607', row: { MEASURE: 'LOC' } }).isPast).toBe(false);
  });
});

// TC-DMF0044-E 정적 컬럼 편집 판정 — 2026-08-11 전환으로 AS-IS InsertRow 잠금 12컬럼 하드코딩
//   (insertStaticEditable / existingStaticEditable)은 폐지되고 UI Category Setup 의 INPUT_TP_CD
//   단일 원천(staticEditableByMeta)만 남았다. 공용 GridUtils.isEditableCell 과 같은 규약이다.
describe('staticEditableByMeta', () => {
  it('행이 없으면 잠금', () => {
    expect(staticEditableByMeta('O', undefined)).toBe(false);
  });

  it('EDIT_FLAG=N 행은 메타와 무관하게 전량 잠금', () => {
    expect(staticEditableByMeta('M', { EDIT_FLAG: 'N' })).toBe(false);
    expect(staticEditableByMeta('IO', { EDIT_FLAG: 'N', CRUD_TYPE: 'I' })).toBe(false);
  });

  it('M / O 는 신규행 여부와 무관하게 전 행 입력', () => {
    expect(staticEditableByMeta('M', { EDIT_FLAG: 'Y' })).toBe(true);
    expect(staticEditableByMeta('O', {})).toBe(true);
    expect(staticEditableByMeta('O', { CRUD_TYPE: 'I' })).toBe(true);
  });

  it('IM / IO 는 신규행(CRUD_TYPE=I) 에서만 입력', () => {
    expect(staticEditableByMeta('IM', { CRUD_TYPE: 'I' })).toBe(true);
    expect(staticEditableByMeta('IO', { CRUD_TYPE: 'I' })).toBe(true);
    expect(staticEditableByMeta('IM', {})).toBe(false);
    expect(staticEditableByMeta('IO', { CRUD_TYPE: 'M' })).toBe(false);
  });

  it('S 및 미지정은 편집 불가', () => {
    expect(staticEditableByMeta('S', { CRUD_TYPE: 'I' })).toBe(false);
    expect(staticEditableByMeta(undefined, { CRUD_TYPE: 'I' })).toBe(false);
  });
});

// 현재월(yyyymm)은 useSalesReportsStore.thisMonth 가 조회 시점에 1회 산출해 고정한다.
//   editLock 에 Date 기반 헬퍼(currentYyyymm)를 두면 산출 원천이 둘이 되어 경계값이 어긋나므로
//   함수 자체를 두지 않는다 - 검증 대상도 없다.
