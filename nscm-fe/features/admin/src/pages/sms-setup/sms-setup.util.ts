import { CRUD_TYPE } from '@foundation/constants';

import { CYCLE, SMS_CONTENT_MAX_BYTES } from './sms-setup.constants';

/**
 * 저장 대상 행 선별 — 편집 흔적의 단일 출처는 **CRUD_TYPE(I/M/D)** 이다.
 * Insert(F8) `GridAction.addRow` 는 `CRUD_TYPE:'I'`, Delete(F9) `GridAction.removeRow` 는 'D',
 * 셀 편집은 `EditTracker.storeChange` 가 'M' 을 찍는다(되돌리면 undefined 로 해제).
 * 화면 전용 상태 필드를 따로 두면 이 흔적을 못 읽어 Save 가 조용히 0건으로 끝난다.
 */
export const pickChangedRows = <T extends WijmoRowItem>(rows?: T[]): T[] =>
  rows?.filter(row => !!row.CRUD_TYPE) ?? [];

/** '^' 구분 bulk payload — AS-IS CString.AppendString 과 동일 규약 (SYS0017 mail-setup.util 과 동일 규약) */
export const joinBulk = (values: (string | undefined | null)[]) =>
  values.map(value => value ?? '').join('^');

/** UTF-8 바이트 길이 (AS-IS Encoding.Default.GetByteCount 대응) */
export const getByteLength = (text: string) => new globalThis.TextEncoder().encode(text).length;

export const isOverSmsContentLimit = (text: string) =>
  getByteLength(text) >= SMS_CONTENT_MAX_BYTES;

/** 모듈 키(MODULE_CODE/SUB_MODULE_CODE) 편집 가능 여부 — 신규 행(F8 Insert)만 가능, 기존 행은 잠금
 * (AS-IS SYS0017 Mail_Setup 과 동일 D4 규칙: Edit 진입 시 기존 행의 모듈 키만 재잠금). */
export const canEditModuleKey = (row: { CRUD_TYPE?: string }) => row.CRUD_TYPE === CRUD_TYPE.INSERT;

/** Language(LANGUAGE_CODE) 편집 가능 여부 — 신규 행(F8 Insert)만 가능, 기존 행은 잠금(AS-IS
 * SprMessage_CellClick cs:1082-1085: strState !== "I" 이면 편집 취소). DB 컬럼 메타(inputTpCd=IM)가
 * 이미 같은 규칙을 적용하지만, 메타가 잘못 등록되는 사고(SCM0007 20개 컬럼 IM 오적재 사례)에 대비해
 * 화면 레벨 방어선을 canEditModuleKey 와 동일 패턴으로 둔다. */
export const canEditLanguageCode = (row: { CRUD_TYPE?: string }) => row.CRUD_TYPE === CRUD_TYPE.INSERT;

/** Sub2(발송 시각, SEND_TIME_TEXT) 편집 가능 여부 — Main 이 월/주 주기일 때만 편집 가능(GC3: DAY/RT
 * 는 비활성). validateCyclePeriod 가 MONTH/WEEK 에서만 SEND_TIME_TEXT 를 요구하는 것과 동일 기준. */
export const canEditSendTime = (cycleClassCode?: string) =>
  cycleClassCode === CYCLE.MONTH || cycleClassCode === CYCLE.WEEK;

/**
 * 주기별 하위 항목 필수 검증 — Category(main)는 SYS0017 과 동일 공유 SP·컬럼(CYCLE_CLASS_CODE 등)을
 * 사용하므로 검증 규칙도 동일하게 적용한다. 통과 시 undefined, 위반 시 메시지 ID.
 */
export const validateCyclePeriod = (row: {
  CYCLE_CLASS_CODE?: string;
  DETAIL_CLASS_CODE?: string;
  SEND_TIME_TEXT?: string;
}) => {
  const cycle = row.CYCLE_CLASS_CODE ?? '';
  if (!cycle) return 'MSG00697';

  if (cycle === 'MONTH' || cycle === 'WEEK') {
    return row.DETAIL_CLASS_CODE && row.SEND_TIME_TEXT ? undefined : 'MSG00695';
  }
  return row.DETAIL_CLASS_CODE ? undefined : 'MSG00696';
};

/**
 * 그리드 전체(삭제 표시 행 제외) 대상 키 중복 판정 — AS-IS ChkCategoryValidation/ChkMsgValidation 의
 * 동일 CATEGORY_DESC / LANGUAGE_CODE 중복 검사(MSG00060)와 동일 규약.
 */
export const hasDuplicate = <T extends WijmoRowItem>(
  rows: T[],
  getKey: (row: T) => string | undefined
): boolean => {
  const seen = new Set<string>();
  for (const row of rows) {
    if (row.CRUD_TYPE === CRUD_TYPE.DELETE) continue;
    const key = getKey(row);
    if (!key) continue;
    if (seen.has(key)) return true;
    seen.add(key);
  }
  return false;
};
