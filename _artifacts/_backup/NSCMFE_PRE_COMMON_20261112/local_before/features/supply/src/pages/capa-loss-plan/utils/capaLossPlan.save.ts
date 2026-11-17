import {
  COLUMN,
  MENU_ID,
  RATE_DIVISOR,
  SAVE_NO_RATE_CONVERT_MEASURES,
  SAVE_PERIOD_DELIMITER,
  SAVE_ROW_DELIMITER,
} from '../capa-loss-plan.constants';
import type { Scp0106Row } from '../capa-loss-plan.types';

/**
 * SAVE payload 직렬화 — AS-IS `SetQueryInfoSave`(MODEL, FORM:3078~3155) /
 * `SetQueryInfoSaveLine`(LINE, FORM:3265~3344).
 *
 * 행 구분 `^` / 기간컬럼 내부 구분 `;`. AS-IS 는 행마다 값 뒤에 구분자를 붙이므로 **마지막에도**
 * 구분자가 남는다(trailing delimiter) — SP 파싱이 그 형태를 전제하므로 "깔끔하게" join 으로
 * 바꾸지 않는다.
 *
 * **MODEL / LINE 파라미터 비대칭은 오타가 아니다 — 그대로 이식한다**(03 R-30/R-31, V-49/V-50):
 *   MODEL 23 파라미터 · `p_sheet_name = _sheet_status`(접미 **없음**) · 전송 컬럼 13종 ·
 *     `p_iprv_gol_divs_cd` 는 **빈 문자열 고정**
 *   LINE  20 파라미터 · `p_sheet_name = _sheet_name`(접미 **포함**) · 전송 컬럼 11종 ·
 *     `PFRSLT_QTY`/`BASE_QTY`/`p_iprv_gol_divs_cd` **없음** ·
 *     `ELTR_LN_TP_CD` 를 행 값이 아니라 **리터럴 `'-'`** 로 고정
 *
 * `p_date_column_names` 와 `p_date_column_values` 는 **토큰 수와 순서가 1:1** 이어야 한다.
 * 빈 값도 빈 토큰으로 자리를 지켜야 SP 의 unpivot 이 어긋나지 않는다(V-47).
 *
 * 구 `SetQueryInfoSaveLine`(FORM:3159~3264, `p_yyyymm`/`p_qty` unpivot 방식)은 `/* *\/` 주석
 * 블록이라 이식하지 않는다(R-32).
 */

// 행 값은 인덱스 시그니처라 `unknown` 이다. 원시값만 문자열로 바꾼다 — 객체가 섞여도
//   `'[object Object]'` 가 SP 파라미터로 새지 않는다(빈 문자열 = AS-IS DBNull 과 같은 자리).
const toText = (value: unknown): string => {
  if (typeof value === 'string') return value;
  if (typeof value === 'number' || typeof value === 'boolean') return String(value);
  return '';
};

/** 변경분 행 — 공용 `EditTracker`/`GridAction` 이 찍은 `CRUD_TYPE` 만 본다(자체 상태필드 금지). */
export const pickDirtyRows = (rows: readonly Scp0106Row[]): Scp0106Row[] =>
  rows.filter(row => row.CRUD_TYPE === 'I' || row.CRUD_TYPE === 'M');

/**
 * 저장 시 비율 환산 — `MSR_TP_CD` 가 제외 9종이 **아니면** `값/100` 으로 저장한다(03 §3.5, V-48).
 * 화면은 %, DB 는 비율이라 여기서만 나눈다.
 *
 * **GET 쪽 `x100` 은 SP(6시트)/뷰(CURRENT 2시트)가 이미 했으므로 화면에서 재적용하지 않는다**
 * — 재적용하면 100배 오류다(C-13). 이 파일에 `* 100` 이 없는 것이 정상이다.
 */
export const toSaveValue = (measure: string, raw: unknown): string => {
  const text = toText(raw);
  if (text === '') return '';
  if (SAVE_NO_RATE_CONVERT_MEASURES.includes(measure)) return text;
  const numeric = Number(text);
  if (!Number.isFinite(numeric)) return text;
  return String(numeric / RATE_DIVISOR);
};

export interface SavePayloadInput {
  rows: readonly Scp0106Row[];
  /** 저장 대상 기간 컬럼명 — `*_ASSIGN_PRIORITY` 를 뺀 순서 확정 목록(spreadTitle 기준). */
  periodColumnNames: readonly string[];
  /** MODEL SP 를 쓰는가(`utils/capaLossPlan.sheetKey.ts#usesModelSaveSp`). */
  isModelSave: boolean;
  /** MODEL 이면 `_sheet_status`, LINE 이면 `_sheet_name` (비대칭 — V-50). */
  sheetNameParam: string;
  version: string;
  versionSeq: string;
  progressStatus: string;
  userId: string;
}

/** LINE SAVE 는 행 값을 무시하고 이 리터럴을 보낸다 — "ui 요구사항에서는 배제"(R-31). */
const LINE_ELTR_LN_TP_CD_LITERAL = '-';

export const buildSavePayload = ({
  rows,
  periodColumnNames,
  isModelSave,
  sheetNameParam,
  version,
  versionSeq,
  progressStatus,
  userId,
}: SavePayloadInput): Record<string, string> => {
  // 파라미터 -> 행에서 읽을 컬럼. AS-IS 변수 순서 그대로 둬 대조가 쉽도록 한다.
  //   MODEL 만 `p_pfrslt_qty`/`p_base_qty` 를 보낸다(LINE 은 파라미터 자체가 없다).
  const columnOf: Record<string, string> = {
    p_division_id: COLUMN.DIVISION_ID,
    p_company_id: COLUMN.COMPANY_ID,
    p_site_id: COLUMN.SITE_ID,
    p_plant_id: COLUMN.PLANT_ID,
    p_factory_id: COLUMN.FACTORY_ID,
    p_line_id: COLUMN.LINE_ID,
    p_operation_id: COLUMN.OPERATION_ID,
    // 파라미터명은 `p_electrode_type` 이다 — 행에서 읽는 컬럼명(`ELTR_LN_TP_CD`)과 다르다.
    //   AS-IS 저장부도 `("p_electrode_type", ELTR_LN_TP_CD)` 로 둘을 분리한다
    //   (`SCP0106_CAPA_Loss_Plan.cs:3142` MODEL / `:3335` LINE). AS-IS SP 실측상
    //   `SCP0106_SAVE_CAPA_LOSS_PLAN_{MODEL,LINE}_*` 에 `@p_electrode_type` 가 11번 파라미터로 있고
    //   `p_eltr_ln_tp_cd` 라는 파라미터는 없다 — 컬럼명으로 보내면 바인딩되지 않는다.
    p_electrode_type: COLUMN.ELTR_LN_TP_CD,
    p_nick_name: COLUMN.NICK_NAME,
    p_measure_group: COLUMN.MEASURE_GROUP,
    p_measure: COLUMN.MEASURE,
    ...(isModelSave
      ? { p_pfrslt_qty: COLUMN.PFRSLT_QTY, p_base_qty: COLUMN.BASE_QTY }
      : {}),
  };

  const serialized: Record<string, string> = {};
  for (const key of Object.keys(columnOf)) serialized[key] = '';
  let dateColumnNames = '';
  let dateColumnValues = '';

  for (const row of rows) {
    const measure = toText(row[COLUMN.MEASURE]);
    for (const [param, column] of Object.entries(columnOf)) {
      let cell: string;
      if (!isModelSave && column === COLUMN.ELTR_LN_TP_CD) {
        cell = LINE_ELTR_LN_TP_CD_LITERAL;
      } else if (column === COLUMN.PFRSLT_QTY || column === COLUMN.BASE_QTY) {
        // 실적/기준 수량도 measure 기준 비율 환산 대상이다(§3.5 `PFRSLT_NVL`/`BASE_NVL`).
        cell = toSaveValue(measure, row[column]);
      } else {
        cell = toText(row[column]);
      }
      serialized[param] += `${cell}${SAVE_ROW_DELIMITER}`;
    }
    for (const name of periodColumnNames) {
      dateColumnNames += `${name}${SAVE_PERIOD_DELIMITER}`;
      dateColumnValues += `${toSaveValue(measure, row[name])}${SAVE_PERIOD_DELIMITER}`;
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
    // MODEL 전용 — AS-IS 가 **항상 빈 문자열**을 넘기고 SP 쪽 JOIN 도 주석 처리다(R-30).
    //   값을 채우면 AS-IS 에 없던 필터가 생긴다. LINE 은 파라미터 자체가 없다.
    ...(isModelSave ? { p_iprv_gol_divs_cd: '' } : {}),
    p_program_id: MENU_ID,
    p_sheet_name: sheetNameParam,
    // 감사 사용자 — 빈 문자열 금지(convert-core §2.5). BE 가 세션으로 덮어쓰더라도 명시한다.
    p_user_id: userId,
    debug_mode: 'F',
  };
};

export interface SaveOutcome {
  ok: boolean;
  /** 성공 시 저장 건수 문자열(`result_cnt`). */
  savedCount: string;
  /** 실패 시 `[50xxx]메시지` 에서 뽑은 DB 오류번호. */
  dbErrorNo: string;
  /** 실패 시 서버가 돌려준 원문 메시지. */
  message: string;
}

/**
 * 저장 응답 판정 — **false-success 차단**(03 R-23/R-24, V-46, convert-core §2.4).
 *
 * 성공: `result_code='S'` 단일 행.
 * 실패: 결과셋이 2개다 — (1) `result_code='F'` (2) `'[' + ERROR_NUMBER + ']' + ERROR_MESSAGE`.
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
