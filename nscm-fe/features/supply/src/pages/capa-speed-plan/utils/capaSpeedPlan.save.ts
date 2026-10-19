import {
  COLUMN,
  MENU_ID,
  SAVE_PERIOD_DELIMITER,
  SAVE_ROW_DELIMITER,
  type GridSheet,
} from '../capa-speed-plan.constants';
import type { Scp0105Row } from '../capa-speed-plan.types';

/**
 * SAVE payload 직렬화 — AS-IS `SetQueryInfoSave`(cs:2261~2352).
 *
 * 행 구분 `^` / 기간컬럼 내부 구분 `;`. AS-IS 는 행마다 값 뒤에 구분자를 붙이므로 **마지막에도**
 * 구분자가 남는다(trailing delimiter) — SP 의 `String_Split` 이 그 형태를 전제로 파싱하므로
 * "깔끔하게" join 으로 바꾸지 않는다.
 *
 * 세 가지 함정(03 §4.3):
 *   1. `p_electrode_type` 에 들어가는 것은 조회조건이 아니라 **행의 `ELTR_LN_TP_CD`** 다(cs:2304).
 *      GET 의 동명 파라미터와 의미가 다르다.
 *   2. `PFRSLT_QTY`(실적)는 AS-IS 가 모으기만 하고 파라미터에 넣지 않는다 — 저장 대상이 아니다.
 *   3. `*_ASSIGN_PRIORITY` 는 전송하지 않는다(cs:2316 필터). 우선순위는 읽기 전용이다.
 *
 * `p_date_column_names` 와 `p_date_column_values` 는 **토큰 수와 순서가 1:1** 이어야 한다.
 * 빈 값도 빈 토큰으로 자리를 지켜야 SP 의 `(ROW_NR, COL_NR)` unpivot 이 어긋나지 않는다.
 */

// 행 값은 인덱스 시그니처라 `unknown` 이다. 원시값만 문자열로 바꾼다 — 객체가 섞여도
//   `'[object Object]'` 가 SP 파라미터로 새지 않는다(빈 문자열 = AS-IS DBNull 과 같은 자리).
const toText = (value: unknown): string => {
  if (typeof value === 'string') return value;
  if (typeof value === 'number' || typeof value === 'boolean') return String(value);
  return '';
};

/** 변경분 행 — 공용 `EditTracker`/`GridAction` 이 찍은 `CRUD_TYPE` 만 본다(자체 상태필드 금지). */
export const pickDirtyRows = (rows: readonly Scp0105Row[]): Scp0105Row[] =>
  rows.filter(row => row.CRUD_TYPE === 'I' || row.CRUD_TYPE === 'M');

export interface SavePayloadInput {
  rows: readonly Scp0105Row[];
  /** 저장 대상 기간 컬럼명 — `*_ASSIGN_PRIORITY` 를 뺀 순서 확정 목록(spreadTitle 기준). */
  periodColumnNames: readonly string[];
  sheetName: GridSheet;
  version: string;
  versionSeq: string;
  progressStatus: string;
  userId: string;
}

export const buildSavePayload = ({
  rows,
  periodColumnNames,
  sheetName,
  version,
  versionSeq,
  progressStatus,
  userId,
}: SavePayloadInput): Record<string, string> => {
  // 열 이름 -> 행마다 append 되는 문자열. AS-IS 변수명 순서 그대로 둬 대조가 쉽도록 한다.
  const columnOf: Record<string, string> = {
    p_division_id: COLUMN.DIVISION_ID,
    p_company_id: COLUMN.COMPANY_ID,
    p_site_id: COLUMN.SITE_ID,
    p_plant_id: COLUMN.PLANT_ID,
    p_factory_id: COLUMN.FACTORY_ID,
    p_line_id: COLUMN.LINE_ID,
    p_operation_id: COLUMN.OPERATION_ID,
    // 주의 1 — 행의 ELTR_LN_TP_CD 다(조회조건 Line Type 이 아니다).
    p_electrode_type: COLUMN.ELTR_LN_TP_CD,
    p_item_id: COLUMN.ITEM_ID,
    p_nick_name: COLUMN.NICK_NAME,
    p_capa_speed_measure: COLUMN.MSR_TP_CD,
    p_base_qty: COLUMN.BASE_QTY,
    p_ui_upd_yn: COLUMN.UI_UPD_YN,
  };

  const serialized: Record<string, string> = {};
  for (const key of Object.keys(columnOf)) serialized[key] = '';
  let dateColumnNames = '';
  let dateColumnValues = '';

  for (const row of rows) {
    for (const [param, column] of Object.entries(columnOf)) {
      serialized[param] += `${toText(row[column])}${SAVE_ROW_DELIMITER}`;
    }
    for (const name of periodColumnNames) {
      dateColumnNames += `${name}${SAVE_PERIOD_DELIMITER}`;
      dateColumnValues += `${toText(row[name])}${SAVE_PERIOD_DELIMITER}`;
    }
    dateColumnNames += SAVE_ROW_DELIMITER;
    dateColumnValues += SAVE_ROW_DELIMITER;
  }

  return {
    p_version: version,
    p_version_seq: versionSeq,
    p_prog_stat: progressStatus,
    ...serialized,
    p_date_column_names: dateColumnNames,
    p_date_column_values: dateColumnValues,
    p_program_id: MENU_ID,
    p_sheet_name: sheetName,
    // 감사 사용자 — 빈 문자열 금지(convert-core §2.5). BE 가 세션으로 덮어쓰더라도 명시한다.
    p_user_id: userId,
    debug_mode: 'F',
  };
};

export interface SaveOutcome {
  ok: boolean;
  /** 성공 시 저장 건수 문자열(`result_cnt`). */
  savedCount: string;
  /** 실패 시 `[50426]메시지` 에서 뽑은 DB 오류번호. */
  dbErrorNo: string;
  /** 실패 시 서버가 돌려준 원문 메시지. */
  message: string;
}

/**
 * 저장 응답 판정 — **false-success 차단**(03 §4.3 / V-44, convert-core §2.4).
 *
 * 성공: `result_code='S'` 단일 행.
 * 실패: 결과셋이 **2개**다 — ① `result_code='F'` ② `'[' + ERROR_NUMBER + ']' + ERROR_MESSAGE`.
 *       마지막 결과셋 문자열을 `]` 로 갈라 오류번호를 뽑는다.
 * 인터셉터가 500/403 도 resolve 하므로 호출부는 이 판정 없이 성공 toast 를 띄우면 안 된다.
 */
export const readSaveOutcome = (result: unknown): SaveOutcome => {
  const outcome: SaveOutcome = { ok: false, savedCount: '', dbErrorNo: '', message: '' };
  if (!result || typeof result !== 'object') return outcome;

  const sets = Object.values(result as Record<string, unknown>).filter(Array.isArray) as Record<
    string,
    unknown
  >[][];
  if (sets.length === 0) return outcome;

  const head = sets[0]?.[0];
  const resultCode = toText(head?.result_code ?? head?.RESULT_CODE);
  if (resultCode === 'S') {
    return {
      ok: true,
      savedCount: toText(head?.result_cnt ?? head?.RESULT_CNT),
      dbErrorNo: '',
      message: '',
    };
  }

  // 실패 — 마지막 결과셋의 첫 행 첫 값이 `[errno]message` 형태다.
  const lastRow = sets[sets.length - 1]?.[0];
  const raw = lastRow ? toText(Object.values(lastRow)[0]) : '';
  const closing = raw.indexOf(']');
  if (raw.startsWith('[') && closing > 0) {
    outcome.dbErrorNo = raw.slice(1, closing);
    outcome.message = raw.slice(closing + 1);
  } else {
    outcome.message = raw;
  }
  return outcome;
};
