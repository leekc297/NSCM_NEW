import {
  COLUMN,
  DATE_CELL_DELIMITER,
  MENU_ID,
  ROW_DELIMITER,
  SAVE_ITEM_ID_ASSEMBLY,
  SAVE_PROG_STAT,
} from '../capa-line-assign.constants';
import type { GridRow } from '../capa-line-assign.types';

import { isDateColumn } from './capaLineAssign.editLock';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

/**
 * `ExtractCoodeFromName(row, idColumn, nameColumn)` 등가 (AS-IS cs:4985-4989).
 * 콤보 표시값이 `"{CODE} {NAME}"` 형태라 저장 시 코드 접두를 떼고 순수 명칭만 보낸다.
 */
export const extractNameWithoutCode = (row: GridRow, idColumn: string, nameColumn: string): string => {
  const id = str(row[idColumn]);
  const name = str(row[nameColumn]);
  if (id && name.startsWith(`${id} `)) return name.slice(id.length + 1);
  if (id && name === id) return '';
  return name;
};

/**
 * 동적 기간컬럼 payload — 행 내부 `;`, 행 사이 `^` (design 03 §4.3-a 20·21번 / S-6).
 * 대상 = `M_`/`Y_` 로 시작하는 컬럼 중 `_ASSIGN_PRIORITY` 미포함분(SCP0104 는 애초에 없다).
 */
const dateCellsOf = (row: GridRow, dateBindings: string[]): { names: string; values: string } => {
  const names: string[] = [];
  const values: string[] = [];
  for (const binding of dateBindings) {
    if (!isDateColumn(binding)) continue;
    names.push(binding);
    values.push(str(row[binding]));
  }
  return {
    names: names.join(DATE_CELL_DELIMITER),
    values: values.join(DATE_CELL_DELIMITER),
  };
};

/** 파라미터별 `^` 누적기 — 행 개수·순서가 전 파라미터에서 동일해야 한다(S-5). */
const joinRows = (rows: GridRow[], select: (row: GridRow) => string): string =>
  rows.map(select).join(ROW_DELIMITER);

export interface AssignSavePayloadParams {
  rows: GridRow[];
  verId: string;
  verSeq: string;
  /** `_sheet_name` — `'ASSEMBLY'` / `'ELTR'`. */
  sheetParamName: string;
  isEltr: boolean;
  /** 현재 그리드의 동적 기간컬럼 binding 목록(SPREAD_TITLE 순서 그대로). */
  dateBindings: string[];
}

/**
 * Assign 탭 저장 payload (design 03 §4.3 (a)/(b)).
 *
 * ASSEMBLY IN 25 / ELTR IN 26(`p_lane_qty` 추가). `p_user_id` 는 BE `@LoginUser` 자동주입이라
 * 싣지 않는다(convert-core §3.5). `createdBy`/`lastUpdatedBy` 키명은 BE 가 세션 단일값으로
 * 덮어쓰므로 아예 쓰지 않는다(nscm-patterns §5-11).
 *
 * 주의(§4.3-d): 서버는 7키 중 하나라도 공백이거나 `YYYYMM` 이 비면 **에러 없이 행을 버린다**
 * (`result_code='S'` 그대로). 그래서 호출부가 `useSaveWithValidation` 을 반드시 함께 건다.
 */
export const buildAssignSavePayload = (
  params: AssignSavePayloadParams
): Record<string, string> => {
  const { rows, verId, verSeq, sheetParamName, isEltr, dateBindings } = params;
  const dateCells = rows.map(row => dateCellsOf(row, dateBindings));

  const payload: Record<string, string> = {
    p_version: verId, //  1
    p_version_seq: verSeq, //  2
    p_prog_stat: SAVE_PROG_STAT, //  3 상수 '0' — SP 본문 미참조(cs:5011)
    p_division_id: joinRows(rows, row => str(row[COLUMN.DIVISION_ID])), //  4
    p_company_id: joinRows(rows, row => str(row[COLUMN.COMPANY_ID])), //  5
    p_site_id: joinRows(rows, row => str(row[COLUMN.SITE_ID])), //  6
    p_plant_id: joinRows(rows, row => str(row[COLUMN.PLANT_ID])), //  7
    p_factory_id: joinRows(rows, row => str(row[COLUMN.FACTORY_ID])), //  8
    p_line_id: joinRows(rows, row => str(row[COLUMN.LINE_ID])), //  9
    p_operation_id: joinRows(rows, row => str(row[COLUMN.OPERATION_ID])), // 10
    p_electrode_type: joinRows(rows, row => str(row[COLUMN.ELTR_LN_TP_CD])), // 11
    // 12-16 명칭 다발 — 코드 접두 제거본
    p_site_name: joinRows(rows, row => extractNameWithoutCode(row, COLUMN.SITE_ID, COLUMN.SITE_NAME)),
    p_company_name: joinRows(rows, row =>
      extractNameWithoutCode(row, COLUMN.COMPANY_ID, COLUMN.COMPANY_NAME)
    ),
    p_plant_name: joinRows(rows, row =>
      extractNameWithoutCode(row, COLUMN.PLANT_ID, COLUMN.PLANT_NAME)
    ),
    p_factory_name: joinRows(rows, row =>
      extractNameWithoutCode(row, COLUMN.FACTORY_ID, COLUMN.FACTORY_NAME)
    ),
    p_line_name: joinRows(rows, row => extractNameWithoutCode(row, COLUMN.LINE_ID, COLUMN.LINE_NAME)),
  };

  // ELTR 전용 — `p_line_name` 과 `p_valid_yn` 사이(임시테이블 P16=lane_qty, P17=valid_yn).
  if (isEltr) payload.p_lane_qty = joinRows(rows, row => str(row[COLUMN.LANE_QTY]));

  payload.p_valid_yn = joinRows(rows, row => str(row[COLUMN.VALID_YN])); // 17
  // 18 ASSEMBLY 는 전건 '-' 하드코딩(cs:4991). ELTR 은 ITEM_ID 가 주키다.
  payload.p_item_id = isEltr
    ? joinRows(rows, row => str(row[COLUMN.ITEM_ID]))
    : rows.map(() => SAVE_ITEM_ID_ASSEMBLY).join(ROW_DELIMITER);
  // 19 ELTR 은 SP 가 '-' 로 덮어쓰지만 AS-IS 도 값을 보낸다 — 원문 유지(U-9).
  payload.p_nick_name = joinRows(rows, row => str(row[COLUMN.NICK_NAME]));
  payload.p_date_column_names = dateCells.map(cell => cell.names).join(ROW_DELIMITER); // 20
  payload.p_date_column_values = dateCells.map(cell => cell.values).join(ROW_DELIMITER); // 21
  payload.p_program_id = MENU_ID; // 22
  payload.p_sheet_name = sheetParamName; // 23
  payload.debug_mode = 'F'; // 25 (24 = p_user_id, BE 주입)

  return payload;
};

/** `SOP_DT` 는 그리드에 `YYYY-MM-DD` 로 있고 저장은 `YYYYMMDD` 8자리다(cs:5194-5204 / S-8). */
export const toSopDate = (value: unknown): string => {
  const digits = str(value).replace(/-/g, '');
  return digits.length >= 8 ? digits.slice(0, 8) : '';
};

export interface SopSavePayloadParams {
  rows: GridRow[];
  verId: string;
  verSeq: string;
  /** `'SOP_' + _sheet_name`. */
  sheetParamName: string;
}

/**
 * SOP 탭 저장 payload — IN 16 (design 03 §4.3 (c)).
 * Assign 과 달리 **명칭 다발을 보내지 않는다**.
 */
export const buildSopSavePayload = (params: SopSavePayloadParams): Record<string, string> => {
  const { rows, verId, verSeq, sheetParamName } = params;
  return {
    p_version: verId, //  1
    p_version_seq: verSeq, //  2
    p_division_id: joinRows(rows, row => str(row[COLUMN.DIVISION_ID])), //  3
    p_company_id: joinRows(rows, row => str(row[COLUMN.COMPANY_ID])), //  4
    p_site_id: joinRows(rows, row => str(row[COLUMN.SITE_ID])), //  5
    p_plant_id: joinRows(rows, row => str(row[COLUMN.PLANT_ID])), //  6
    p_factory_id: joinRows(rows, row => str(row[COLUMN.FACTORY_ID])), //  7
    p_line_id: joinRows(rows, row => str(row[COLUMN.LINE_ID])), //  8
    p_operation_id: joinRows(rows, row => str(row[COLUMN.OPERATION_ID])), //  9
    p_electrode_type: joinRows(rows, row => str(row[COLUMN.ELTR_LN_TP_CD])), // 10
    p_valid_yn: joinRows(rows, row => str(row[COLUMN.VALID_YN])), // 11
    p_sop_dt: joinRows(rows, row => toSopDate(row[COLUMN.SOP_DT])), // 12
    p_program_id: MENU_ID, // 13
    p_sheet_name: sheetParamName, // 14
    debug_mode: 'F', // 16 (15 = p_user_id, BE 주입)
  };
};
