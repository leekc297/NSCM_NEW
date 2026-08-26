/** SAVE SP 결과 판정. ok=false 면 message 를 그대로 사용자에게 보여준다(SP 문구 passthrough). */
export interface SaveResultCheck {
  ok: boolean;
  message: string;
}

type ProcResult = Record<string, unknown>;

/** OUT 커서를 대소문자 무시로 찾는다 — BE 매핑에 따라 P_MESSAGE_CURSOR / p_message_cursor 로 갈린다. */
const findCursor = (result: ProcResult, name: string): Record<string, unknown>[] | undefined => {
  const key = Object.keys(result).find(k => k.toLowerCase() === name.toLowerCase());
  const rows = key ? result[key] : undefined;
  return Array.isArray(rows) ? (rows as Record<string, unknown>[]) : undefined;
};

/** 셀 값 → 표시 문자열. 문자열/숫자만 취한다(객체가 섞여도 '[object Object]' 가 새어나가지 않게). */
const toText = (value: unknown): string => {
  if (typeof value === 'string') return value.trim();
  if (typeof value === 'number' || typeof value === 'boolean') return String(value);
  return '';
};

/**
 * 첫 행의 첫 번째 비어있지 않은 값.
 * SP 의 오류 커서는 `SELECT '필수 입력값을 확인하세요.' FROM DUAL` 처럼 리터럴을 그대로 열어
 * 컬럼명이 고정이 아니다(별칭 없음). 그래서 컬럼명이 아니라 값으로 읽는다.
 */
const firstText = (rows: Record<string, unknown>[] | undefined): string => {
  const row = rows?.[0];
  if (!row) return '';
  for (const value of Object.values(row)) {
    const text = toText(value);
    if (text) return text;
  }
  return '';
};

/**
 * Sales Site 저장 결과 — DMF0008_SAVE_SALES_SITE_EDI_REPAIR.
 *
 * OUT 은 `p_message_cursor` 하나뿐이고 성패와 무관하게 프로시저 끝에서 항상 열린다
 * (`SELECT v_result_message AS RESULT_MSG FROM DUAL`).
 *   - 성공: v_result_message 가 NULL 인 채로 내려온다.
 *   - 검증 실패(e_invalid_data → ROLLBACK): '필수 입력값을 확인하세요.' / 'Div 입력값을 확인하세요.' /
 *     'Sales Site 입력값을 확인하세요.' / 'Sold-To 입력값을 확인하세요.' / 'Rep Ship-To 입력값을 확인하세요.' /
 *     'Customer Active 입력값을 확인하세요.'
 *   - 예외(WHEN OTHERS → ROLLBACK): '[SQLCODE]SQLERRM'
 *
 * 커서를 못 찾으면(BE 매핑 변경 등) 성공으로 본다 — HTTP 레벨 code 판정이 앞단에서 이미 걸러낸다.
 */
export const checkSalesSiteSaveResult = (result: ProcResult): SaveResultCheck => {
  const message = firstText(findCursor(result, 'p_message_cursor'));
  if (!message || message.toUpperCase() === 'SUCCESS') return { ok: true, message: '' };
  return { ok: false, message };
};

// 검증 실패 문구가 담기는 커서들 — O_RC1 필수값 / O_RC2 Div / O_RC3 Project Code / O_RC4 Sales Site /
//   O_RC5 Model, O_RC6 은 WHEN OTHERS 의 '[SQLCODE]SQLERRM'. 실패 시 O_RESULT_CURSOR 는 열리지 않는다.
const SSPM_MESSAGE_CURSORS = ['O_RC1', 'O_RC2', 'O_RC3', 'O_RC4', 'O_RC5', 'O_RC6'];

/**
 * SSPM 저장 결과 — DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR.
 *
 * 성공만 `O_RESULT_CURSOR` 로 온다 (`RESULT_CODE='1'`, `ERR_EVENT='SUCCESS'`).
 * 실패는 위 SSPM_MESSAGE_CURSORS 중 하나에 문구가 담기고 O_RESULT_CURSOR 자체가 없다.
 * 그래서 "RESULT_CODE 가 1 인가" 를 기준으로 판정한다 — 커서가 없으면 실패다.
 */
export const checkSspmSaveResult = (result: ProcResult): SaveResultCheck => {
  const row = findCursor(result, 'O_RESULT_CURSOR')?.[0];
  const code = toText(row?.RESULT_CODE) || toText(row?.result_code);
  if (code === '1') return { ok: true, message: '' };

  for (const name of SSPM_MESSAGE_CURSORS) {
    const message = firstText(findCursor(result, name));
    if (message) return { ok: false, message };
  }
  // 코드도 1 이 아니고 문구 커서도 비었을 때 — SP 가 결과행에 넣어준 값이라도 살린다.
  return { ok: false, message: toText(row?.RESULT_MSG) || toText(row?.ERR_EVENT) };
};
