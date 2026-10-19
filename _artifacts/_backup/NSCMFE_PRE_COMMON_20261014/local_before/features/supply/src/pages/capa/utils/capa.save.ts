import type { EditTracker } from '@foundation/utils';

import { DATA_TABLE_ABBR, MSG } from '../capa.constants';
import type { CapaRow } from '../capa.types';

/**
 * P_SAVE_CAPA 저장 payload(03 §4.3 — AS-IS SaveData_Main cs:943~1260 1:1).
 * 저장 단위 = dirty 셀 1건 = 배열 1원소. 17 IN 을 '^' bulk 로 연결(SAVE SP 분해자, 조회 콤마와 다름).
 * dirty = 행 CRUD_TYPE(EditTracker) ∈ I/M/D ∧ 변경 셀(LANE_QTY/CONFIRM_FLAG/기간 D_/M_/Y_) ∧ 비공백 ∧ col≠REQUEST_CHK.
 * confirmFlag = 'True'→'Y' 변환(cs:1162), dataTable = 축약(C/L/LA/T/Y), 저장 성공 후 재조회 없음(dirty 리셋만).
 */
export interface CapaSaveElem {
  divisionId: string;
  companyId: string;
  siteId: string;
  plantId: string;
  factoryId: string;
  lineId: string;
  operationId: string;
  electrodeType: string;
  itemId: string;
  lossCode: string;
  dataTable: string; // 축약
  dataType: string; // 'LQ' | 'CF' | 'Y' | 'M' | 'D'
  dayName: string; // yyyymmdd/yyyymm/yyyy | 'LANE_QTY' | 'CONFIRM_FLAG'
  dayQty: string;
  laneQty: string;
  confirmFlag: string; // 'Y' | 'N'
  updateId: string;
}

const str = (v: unknown): string =>
  v === undefined || v === null
    ? ''
    : typeof v === 'string' || typeof v === 'number' || typeof v === 'boolean'
      ? String(v)
      : '';

const periodKind = (b: string): 'D' | 'M' | 'Y' | null =>
  /^D_\d{8}$/.test(b) ? 'D' : /^M_\d{6}$/.test(b) ? 'M' : /^Y_\d{4}$/.test(b) ? 'Y' : null;

const keyOf = (
  row: CapaRow,
  updateId: string
): Omit<CapaSaveElem, 'dataType' | 'dayName' | 'dayQty'> => ({
  divisionId: str(row.DIVISION_ID),
  companyId: str(row.COMPANY_ID),
  siteId: str(row.SITE_ID),
  plantId: str(row.PLANT_ID),
  factoryId: str(row.FACTORY_ID),
  lineId: str(row.LINE_ID),
  operationId: str(row.OPERATION_ID),
  electrodeType: str(row.ELECTRODE_TYPE),
  itemId: str(row.ITEM_ID),
  lossCode: str(row.LOSS_CODE),
  dataTable: DATA_TABLE_ABBR[str(row.DATA_TABLE)] ?? str(row.DATA_TABLE),
  laneQty: str(row.LANE_QTY),
  confirmFlag: str(row.CONFIRM_FLAG) === 'True' ? 'Y' : 'N',
  updateId,
});

/** dirty 셀 → 저장 원소 배열. 변경 셀은 EditTracker.getOriginalValues() 로 판정. */
export const buildSaveElems = (
  gridRows: CapaRow[],
  tracker: EditTracker<CapaRow>,
  updateId: string
): CapaSaveElem[] => {
  const elems: CapaSaveElem[] = [];
  const changed = tracker.getOriginalValues();
  for (const row of gridRows) {
    const crud = str(row.CRUD_TYPE);
    if (crud !== 'I' && crud !== 'M' && crud !== 'D') continue;
    const bindings = changed.get(row);
    if (!bindings) continue;
    const base = keyOf(row, updateId);
    for (const binding of Object.keys(bindings)) {
      if (binding === 'REQUEST_CHK') continue;
      const raw = str(row[binding]).replace(/,/g, '');
      if (binding === 'LANE_QTY') {
        if (raw === '') continue;
        elems.push({ ...base, dataType: 'LQ', dayName: 'LANE_QTY', dayQty: raw });
        continue;
      }
      if (binding === 'CONFIRM_FLAG') {
        elems.push({ ...base, dataType: 'CF', dayName: 'CONFIRM_FLAG', dayQty: base.confirmFlag });
        continue;
      }
      const kind = periodKind(binding);
      if (!kind) continue; // 기간 셀만 저장 대상
      if (raw === '') continue;
      elems.push({ ...base, dataType: kind, dayName: binding.replace(/^[DMY]_/, ''), dayQty: raw });
    }
  }
  return elems;
};

/**
 * 저장 전 셀 값검증(03 §3.1·§5-5 — GAP-01). 실패 시 첫 위반 1건 반환(null=통과).
 *   - E2000 공정 LINE ASSIGN 행 LANE_QTY 공백 → MSG00337 (cs:1020~1025)
 *   - LINE ASSIGN(LA001) 행 dirty priority(기간) 셀: 정수 아님 → MSG00107 / 1~9 범위 밖 → MSG00203
 *   - YIELD(LA003) 행 dirty 셀: ≤1 → MSG00193 / >100 → MSG00072
 * MSG00107 만 TO-BE 실재(재사용), 나머지는 t() fallback(convert-core §2.3 — 임의 INSERT 금지).
 */
export interface CapaSaveViolation {
  code: string; // TO-BE MSG 코드
  fallback: string; // t() defaultValue(AS-IS 소스 문구)
  args: string[]; // {0}/{1} 치환값
  binding: string;
  row: CapaRow;
}

const periodKindV = (b: string): boolean => /^[DMY]_\d{4,8}$/.test(b);

export const validateSave = (
  gridRows: CapaRow[],
  tracker: EditTracker<CapaRow>
): CapaSaveViolation | null => {
  const changed = tracker.getOriginalValues();
  for (const row of gridRows) {
    const crud = str(row.CRUD_TYPE);
    if (crud !== 'I' && crud !== 'M' && crud !== 'D') continue;
    const bindings = changed.get(row);
    if (!bindings) continue;
    const category = str(row.CATEGORY_ID);
    const loss = str(row.LOSS_CODE);
    // E2000 공정 LINE ASSIGN 행 LANE_QTY 필수.
    if (
      category === 'LINE ASSIGN' &&
      str(row.OPERATION_ID) === 'E2000' &&
      'LANE_QTY' in bindings &&
      str(row.LANE_QTY).trim() === ''
    ) {
      return {
        code: MSG.LANE_QTY_REQUIRED,
        fallback: '_Lane QTY value is required.',
        args: [],
        binding: 'LANE_QTY',
        row,
      };
    }
    for (const binding of Object.keys(bindings)) {
      if (binding === 'REQUEST_CHK' || !periodKindV(binding)) continue;
      const raw = str(row[binding]).replace(/,/g, '').trim();
      if (raw === '') continue;
      const val = Number(raw);
      if (!Number.isFinite(val)) continue;
      if (loss === 'LA001') {
        if (!Number.isInteger(val))
          return { code: MSG.PRIORITY_INTEGER, fallback: '_Priority is a positive integer.', args: [], binding, row };
        if (val < 1 || val > 9)
          return { code: MSG.PRIORITY_RANGE, fallback: '_Enter a number between {0} and {1}.', args: ['1', '9'], binding, row };
      } else if (loss === 'LA003') {
        if (val <= 1)
          return { code: MSG.YIELD_MIN, fallback: '_Only values greater than {1} can be entered.', args: ['', '1'], binding, row };
        if (val > 100)
          return { code: MSG.YIELD_MAX, fallback: '_Only values less than or equal to {0}.', args: ['100'], binding, row };
      }
    }
  }
  return null;
};

/** 17 IN '^' bulk payload — PROC_M COL_NM 기준(키 이름 매칭이라 나열 순서 무관). sesUserId 는 BE 세션 주입. */
export const buildSavePayload = (elems: CapaSaveElem[]): Record<string, string> => ({
  divisionId: elems.map(e => e.divisionId).join('^'),
  companyId: elems.map(e => e.companyId).join('^'),
  siteId: elems.map(e => e.siteId).join('^'),
  plantId: elems.map(e => e.plantId).join('^'),
  factoryId: elems.map(e => e.factoryId).join('^'),
  lineId: elems.map(e => e.lineId).join('^'),
  operationId: elems.map(e => e.operationId).join('^'),
  electrodeType: elems.map(e => e.electrodeType).join('^'),
  itemId: elems.map(e => e.itemId).join('^'),
  lossCode: elems.map(e => e.lossCode).join('^'),
  dataTable: elems.map(e => e.dataTable).join('^'),
  dataType: elems.map(e => e.dataType).join('^'),
  dayName: elems.map(e => e.dayName).join('^'),
  dayQty: elems.map(e => e.dayQty).join('^'),
  laneQty: elems.map(e => e.laneQty).join('^'),
  confirmFlag: elems.map(e => e.confirmFlag).join('^'),
  updateId: elems.map(e => e.updateId).join('^'),
});
