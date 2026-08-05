import { CYCLE, CYCLE_DETAIL_PARENT, MAIL_CONTENT_MAX_BYTES } from './mail-setup.constants';
import type { ComboOption } from './mail-setup.types';

/** '^' 구분 bulk payload — AS-IS CString.AppendString 과 동일 규약 */
export const joinBulk = (values: (string | undefined | null)[]) =>
  values.map(value => value ?? '').join('^');

/** UTF-8 바이트 길이 (AS-IS Encoding.Default.GetByteCount 대응) */
export const getByteLength = (text: string) => new globalThis.TextEncoder().encode(text).length;

export const isOverMailContentLimit = (text: string) =>
  getByteLength(text) >= MAIL_CONTENT_MAX_BYTES;

/** Sub1 콤보 = 주기(Main) 종속 */
export const filterCycleDetail = (options: ComboOption[], parentCode?: string) =>
  options.filter(option => option.PARENT_CODE === parentCode);

/**
 * Sub2(발송 시각) 콤보 부모 결정 — AS-IS: Sub1 이 월(M*)·주(W*) 상세면 시각(DAY) 목록,
 * 그 외(일 주기의 상세)는 분(HOUR) 목록.
 */
export const resolveSendTimeParent = (detailClassCode?: string) => {
  const code = detailClassCode ?? '';
  return code.startsWith('M') || code.startsWith('W')
    ? CYCLE_DETAIL_PARENT.HOUR_LIST
    : CYCLE_DETAIL_PARENT.MINUTE_LIST;
};

/** Sub2 편집 가능 여부 — 실시간(RT) 주기는 시각 지정 없음 */
export const canEditSendTime = (cycleClassCode?: string) => cycleClassCode !== CYCLE.REAL_TIME;

/** Sub3(분) 편집 가능 여부 — 월·주 주기에서만 */
export const canEditSendMinTime = (cycleClassCode?: string) =>
  cycleClassCode === CYCLE.MONTH || cycleClassCode === CYCLE.WEEK;

/** 주기별 하위 항목 필수 검증 — 통과 시 undefined, 위반 시 메시지 ID */
export const validateCyclePeriod = (row: {
  CYCLE_CLASS_CODE?: string;
  DETAIL_CLASS_CODE?: string;
  SEND_TIME_TEXT?: string;
}) => {
  const cycle = row.CYCLE_CLASS_CODE ?? '';
  if (!cycle) return 'MSG00697';

  if (cycle === CYCLE.MONTH || cycle === CYCLE.WEEK) {
    return row.DETAIL_CLASS_CODE && row.SEND_TIME_TEXT ? undefined : 'MSG00695';
  }
  return row.DETAIL_CLASS_CODE ? undefined : 'MSG00696';
};

export const createEmptyCategory = (): Record<string, string> => ({
  USE_TYPE_CODE: '',
  MODULE_CODE: '',
  SUB_MODULE_CODE: '',
  CATEGORY_ID: '',
  CATEGORY_DESC: '',
  CYCLE_CLASS_CODE: '',
  DETAIL_CLASS_CODE: '',
  SEND_TIME_TEXT: '',
  SEND_MIN_TIME_TEXT: '',
  ACTIVE_FLAG: 'Y',
});

/** PopSQL 8분할 텍스트 결합 (AS-IS TEXT1~TEXT8) */
export const joinSqlText = (row?: Record<string, string>) => {
  if (!row) return '';
  return [1, 2, 3, 4, 5, 6, 7, 8].map(index => row[`TEXT${index}`] ?? '').join('');
};
