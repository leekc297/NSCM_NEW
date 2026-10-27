import { describe, expect, it } from 'vitest';

import { firstReasonWithoutChangeRow, type GridRowData } from './shipmentChangeRequestDerive';

// C8 — 변경 없이 Change_Reason 만 입력된 행 차단(AS-IS SSP_Main_Validation cs:3265-3355, MSG00286 -> MSG01290).
//   "변경" 판정은 EditTracker 원본 대비 실제로 바뀐 바인딩에 출하필드 7종이 있는지로 한다.
//   changedBindingsOf 를 테스트가 주입하므로 EditTracker 없이 순수 로직만 검증한다.

/** 행별 변경 바인딩 맵을 받아 changedBindingsOf 리졸버로 만든다. */
const resolver = (changed: Map<GridRowData, string[]>) => (row: GridRowData) =>
  changed.get(row) ?? [];

describe('firstReasonWithoutChangeRow (C8)', () => {
  it('변경 없이 사유코드만 들어간 단독 수정행을 1-based 행번호로 반환한다', () => {
    const row: GridRowData = { CRUD_TYPE: 'M', EDIT_MAIN: 'Y', CHANGE_REASON_CODE: 'T01' };
    const changed = new Map([[row, ['CHANGE_REASON_CODE']]]);
    expect(firstReasonWithoutChangeRow([row], resolver(changed))).toBe(1);
  });

  it('출하필드 실변경이 있으면 사유가 있어도 통과(null)', () => {
    const row: GridRowData = { CRUD_TYPE: 'M', EDIT_MAIN: 'Y', CHANGE_REASON_CODE: 'T01' };
    const changed = new Map([[row, ['SHIPMENT_DATE', 'CHANGE_REASON_CODE']]]);
    expect(firstReasonWithoutChangeRow([row], resolver(changed))).toBeNull();
  });

  it('사유가 없거나 "-" 면 대상 아님(null)', () => {
    const noReason: GridRowData = { CRUD_TYPE: 'M', EDIT_MAIN: 'Y', CHANGE_REASON_CODE: '' };
    const dash: GridRowData = { CRUD_TYPE: 'M', EDIT_MAIN: 'Y', CHANGE_REASON_CODE: '-' };
    const changed = new Map([
      [noReason, [] as string[]],
      [dash, [] as string[]],
    ]);
    expect(firstReasonWithoutChangeRow([noReason, dash], resolver(changed))).toBeNull();
  });

  it('미편집 기존행은 사유가 이미 있어도 대상 아님(AS-IS M행 한정)', () => {
    // CRUD_TYPE 없음 + EDIT_MAIN 아님 = StringAction!='M' → 검사 제외.
    const row: GridRowData = { CHANGE_REASON_CODE: 'T01' };
    expect(firstReasonWithoutChangeRow([row], resolver(new Map()))).toBeNull();
  });

  it('신규행(CRUD_TYPE=I)은 제외한다', () => {
    const row: GridRowData = { CRUD_TYPE: 'I', CHANGE_REASON_CODE: 'T01' };
    expect(firstReasonWithoutChangeRow([row], resolver(new Map()))).toBeNull();
  });

  it('같은 ERP_SO_NO 그룹에 실변경 형제가 있으면 전파된 사유이므로 제외(null)', () => {
    // 형제 A 가 출하일을 바꿨고, 사유가 같은 SO 그룹 B 로 전파됐다 — B 는 막지 않는다.
    const changedSibling: GridRowData = {
      CRUD_TYPE: 'M',
      EDIT_MAIN: 'Y',
      ERP_SO_NO: 'SO1',
      CHANGE_REASON_CODE: 'T01',
    };
    const propagated: GridRowData = {
      CRUD_TYPE: 'M',
      EDIT_MAIN: 'Y',
      ERP_SO_NO: 'SO1',
      CHANGE_REASON_CODE: 'T01',
    };
    const changed = new Map([
      [changedSibling, ['SHIPMENT_DATE', 'CHANGE_REASON_CODE']],
      [propagated, ['CHANGE_REASON_CODE']],
    ]);
    expect(firstReasonWithoutChangeRow([changedSibling, propagated], resolver(changed))).toBeNull();
  });

  it('같은 SO 그룹이라도 실변경 형제가 없으면 사유만 든 행을 막는다', () => {
    const a: GridRowData = { CRUD_TYPE: 'M', EDIT_MAIN: 'Y', ERP_SO_NO: 'SO1', CHANGE_REASON_CODE: 'T01' };
    const b: GridRowData = { CRUD_TYPE: 'M', EDIT_MAIN: 'Y', ERP_SO_NO: 'SO1', CHANGE_REASON_CODE: 'T01' };
    const changed = new Map([
      [a, ['CHANGE_REASON_CODE']],
      [b, ['CHANGE_REASON_CODE']],
    ]);
    expect(firstReasonWithoutChangeRow([a, b], resolver(changed))).toBe(1);
  });

  it('실변경 행과 사유만 든 행이 섞이면 사유만 든 행(2번째)을 반환한다', () => {
    const realChange: GridRowData = { CRUD_TYPE: 'M', EDIT_MAIN: 'Y', CHANGE_REASON_CODE: 'T01' };
    const reasonOnly: GridRowData = { CRUD_TYPE: 'M', EDIT_MAIN: 'Y', CHANGE_REASON_CODE: 'T02' };
    const changed = new Map([
      [realChange, ['SHIPMENT_CONFIRM_QTY', 'CHANGE_REASON_CODE']],
      [reasonOnly, ['CHANGE_REASON_CODE']],
    ]);
    expect(firstReasonWithoutChangeRow([realChange, reasonOnly], resolver(changed))).toBe(2);
  });
});
