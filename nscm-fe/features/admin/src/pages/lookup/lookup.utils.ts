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

export const sanitizeDetailRow = (row: DetailRow): DetailRow => ({
  ...row,
  DISPLAY_SEQ:
    String(row.DISPLAY_SEQ) === '0' || row.DISPLAY_SEQ?.trim() === '' || row.DISPLAY_SEQ == null
      ? '0'
      : row.DISPLAY_SEQ,
});
