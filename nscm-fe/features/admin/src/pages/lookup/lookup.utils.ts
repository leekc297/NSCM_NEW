import type { MENU_ID, RESPONSE_SET, SHEETS } from './lookup.constants';

type MasterRow = ResponseData<MENU_ID, SHEETS.LOOKUP_MASTER, RESPONSE_SET.SAVE>;
type DetailRow = ResponseData<MENU_ID, SHEETS.LOOKUP_DETAIL, RESPONSE_SET.SAVE>;

export const EMPTY_LOOKUP_MASTER_ROW = {
  LOOKUP_TYPE: '',
  DESCRIPTION: '',
  LOOKUP_GROUP: '',
  VALID_YN: 'Y',
  SEGMENT1: '',
  SEGMENT2: '',
  SEGMENT3: '',
  SEGMENT4: '',
  SEGMENT5: '',
  ATTRIBUTE1: '',
  ATTRIBUTE2: '',
  ATTRIBUTE3: '',
  ATTRIBUTE4: '',
  ATTRIBUTE5: '',
  ATTRIBUTE6: '',
  ATTRIBUTE7: '',
  ATTRIBUTE8: '',
  ATTRIBUTE9: '',
  ATTRIBUTE10: '',
  ATTRIBUTE11: '',
  ATTRIBUTE12: '',
  ATTRIBUTE13: '',
  ATTRIBUTE14: '',
  ATTRIBUTE15: '',
  CREATED_BY: '',
  CREATION_DATE: '',
  LAST_UPDATED_BY: '',
  LAST_UPDATE_DATE: '',
} as const satisfies MasterRow;

export const EMPTY_LOOKUP_DETAIL_ROW = {
  LOOKUP_TYPE: '',
  SEGMENT1: '-',
  SEGMENT2: '-',
  SEGMENT3: '-',
  SEGMENT4: '-',
  SEGMENT5: '-',
  VALID_YN: 'Y',
  ATTRIBUTE1: '',
  ATTRIBUTE2: '',
  ATTRIBUTE3: '',
  ATTRIBUTE4: '',
  ATTRIBUTE5: '',
  ATTRIBUTE6: '',
  ATTRIBUTE7: '',
  ATTRIBUTE8: '',
  ATTRIBUTE9: '',
  ATTRIBUTE10: '',
  ATTRIBUTE11: '',
  ATTRIBUTE12: '',
  ATTRIBUTE13: '',
  ATTRIBUTE14: '',
  ATTRIBUTE15: '',
  DISPLAY_SEQ: '0',
  DESCRIPTION: '',
  CREATED_BY: '',
  CREATION_DATE: '',
  LAST_UPDATED_BY: '',
  LAST_UPDATE_DATE: '',
} as const satisfies DetailRow;

export const findDuplicateMasterRow = (rows: MasterRow[]): MasterRow | null => {
  const seen = new Set<string>();
  for (const row of rows) {
    const key = `${row.LOOKUP_TYPE}||${row.SEGMENT1}||${row.SEGMENT2}||${row.SEGMENT3}||${row.SEGMENT4}||${row.SEGMENT5}`;
    if (seen.has(key)) return row;
    seen.add(key);
  }
  return null;
};

export const findDuplicateDetailRow = (rows: DetailRow[]): DetailRow | null => {
  const seen = new Set<string>();
  for (const row of rows) {
    const key = `${row.LOOKUP_TYPE}||${row.SEGMENT1}||${row.SEGMENT2}||${row.SEGMENT3}||${row.SEGMENT4}||${row.SEGMENT5}`;
    if (seen.has(key)) return row;
    seen.add(key);
  }
  return null;
};

/**
 * 저장 payload 정규화 — 비어 있거나 0 인 DISPLAY_SEQ 를 '0' 으로 채운다.
 *
 * 주의: DISPLAY_SEQ 는 타입 선언상 string 이지만 SP 결과(Oracle NUMBER)는 런타임에 number 로
 * 내려온다. 문자열 메서드(trim)를 직접 부르면 숫자 행에서 TypeError 가 나고, 그 예외가
 * onSave(클릭 핸들러) 밖으로 던져져 저장이 통째로 무반응이 된다. 반드시 String() 으로 감싼 뒤 판정한다.
 * 값 자체는 원본 타입 그대로 넘긴다 (숫자를 문자열로 바꾸지 않는다).
 */
export const sanitizeDetailRow = (row: DetailRow): DetailRow => {
  const displaySeq = row.DISPLAY_SEQ == null ? '' : String(row.DISPLAY_SEQ).trim();
  return {
    ...row,
    DISPLAY_SEQ: displaySeq === '' || displaySeq === '0' ? '0' : row.DISPLAY_SEQ,
  };
};
