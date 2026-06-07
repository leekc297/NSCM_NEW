import type { CrudType, MktFcstRow } from '../mkt-forecast-master.types';

// CRUD_TYPE marker — cellEditEnded cascade 의 핵심
// (룰 07 §2.10 + hook modal-callback-cascade-check)
//
// AS-IS DMF0003_1_MktFcst.cs L3136 spdMain_Changed:
//   - 셀 변경 시 EditFlag 컬럼에 'U' (Update) 마킹
//   - 신규 행 (Insert) 은 EditFlag = 'I'
//   - 삭제 행 은 EditFlag = 'D' (실제 row 는 grid 에 유지, save 시 SP 에 'D' 전달)
//
// TO-BE: SP DMF0003_SAVE_MKT_FCST 의 P_ACTIVE_FLAG ('I'/'U'/'D') 로 매핑
//   - I : 신규 추가 row (handleInsert)
//   - U : 기존 row cell 편집 (cellEditEnded)
//   - D : 삭제 표시 row (handleDelete)

export function markRowAsInserted(row: Partial<MktFcstRow>): MktFcstRow {
  return { ...row, EDIT_FLAG: 'I' as CrudType } as MktFcstRow;
}

export function markRowAsUpdated(row: MktFcstRow): MktFcstRow {
  // 이미 'I' 마킹된 row 는 'I' 유지 (신규 row 의 cell 편집)
  if (row.EDIT_FLAG === 'I') return row;
  return { ...row, EDIT_FLAG: 'U' as CrudType };
}

export function markRowAsDeleted(row: MktFcstRow): MktFcstRow {
  return { ...row, EDIT_FLAG: 'D' as CrudType };
}

export function isModifiedRow(row: MktFcstRow): boolean {
  return row.EDIT_FLAG === 'I' || row.EDIT_FLAG === 'U' || row.EDIT_FLAG === 'D';
}

export function getModifiedRows(rows: MktFcstRow[]): MktFcstRow[] {
  return rows.filter(isModifiedRow);
}

// P_ACTIVE_FLAG SP 호출 매핑 — CRUD_TYPE → 'I'/'U'/'D'
export function toActiveFlag(row: MktFcstRow): 'I' | 'U' | 'D' {
  if (row.EDIT_FLAG === 'I') return 'I';
  if (row.EDIT_FLAG === 'D') return 'D';
  return 'U';
}
