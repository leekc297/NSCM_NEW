import type { ActiveGrid, MENU_ID, RESPONSE_SET, SHEETS } from './lookup.constants';

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

const SEGMENT_FIELDS = ['SEGMENT1', 'SEGMENT2', 'SEGMENT3', 'SEGMENT4', 'SEGMENT5'] as const;

type SegmentKeyField = `${(typeof SEGMENT_FIELDS)[number]}_KEY`;

export type DetailSaveRow = DetailRow & Partial<Record<SegmentKeyField, string>>;

/**
 * 저장 payload 한 행 — 정규화 + UPDATE 대상 식별용 원본 세그먼트 값(SEGMENT1_KEY~5) 부착.
 *
 * Lookup Values 의 행 식별자는 LOOKUP_TYPE + SEGMENT1~5 다. 그래서 세그먼트를 수정한 뒤
 * 바뀐 값만 보내면 UPDATE 가 찾는 행이 없어 0건으로 끝나고, 오류도 없이 조용히 사라진다.
 * AS-IS(SCM0003_Lookup.cs "UPDATE용 KEY" 숨김 컬럼)는 바뀐 값과 원래 값을 함께 보내
 * 원래 값으로 대상을 찾고 바뀐 값을 쓴다. 그 규약을 그대로 따른다.
 *
 * 원본 값은 EditTracker 가 셀별로 보관한 편집 직전 값이다. 기록이 없는 셀은 편집된 적이
 * 없다는 뜻이므로 현재 값이 곧 원본이다. 조회 SP(P_SYS0010_GET_LOOKUP_MASTER_DETAIL)는
 * SEGMENT*_KEY 를 내려주지 않으므로 원본은 클라이언트에서만 알 수 있다.
 *
 * 주의: 현재 P_SYS0010_SAVE_LOOKUP_MASTER_DETAIL 의 V_SEGMENT1_KEY~5 선언이 주석 처리돼 있어
 * 이 값이 무시된다. SP 에서 주석을 풀고 UPDATE 의 WHERE 에 쓰기 전까지 세그먼트 수정은
 * 반영되지 않는다 (다른 컬럼 수정은 정상).
 */
export const toDetailSaveRow = (
  row: DetailRow,
  originalValues?: Record<string, WijmoPrimitive>
): DetailSaveRow => {
  const segmentKeys = {} as Record<SegmentKeyField, string>;
  SEGMENT_FIELDS.forEach(field => {
    const hasOriginal = originalValues != null && field in originalValues;
    const original = hasOriginal ? originalValues[field] : row[field];
    segmentKeys[`${field}_KEY`] = original == null ? '' : String(original);
  });

  return { ...sanitizeDetailRow(row), ...segmentKeys };
};

export interface SaveTarget {
  /** 저장할 영역 — 'main' 상단(Lookup Type) / 'sub' 하단(Lookup Values) */
  target: ActiveGrid;
  /** 저장 대상이 아닌 영역에도 변경분이 남는가 (사용자에게 알려야 한다) */
  otherHasChanges: boolean;
}

/**
 * 저장 대상 영역 판정 — 포커스가 아니라 변경분이 있는 영역을 고른다.
 *
 * 종전에는 포커스(activeGrid)만 봤다. 하단에 행을 넣은 뒤 상단을 한 번 클릭하고 저장하면
 * 상단이 대상이 되어, 상단에 변경이 없으면 "수정한 내용이 없습니다"가 뜨고 하단 신규행은
 * 그대로 남았다. 상단에 변경이 있었다면 상단만 저장되고 하단이 남는, 더 알아채기 어려운
 * 쪽으로 흘렀다.
 *
 * 입력은 CRUD_TYPE 이 붙은 행 수다. 그 값이 곧 그리드 행 앞의 상태 표시(I/M/D)라,
 * 화면에 표시가 보이는 영역이 저장 대상이 된다.
 *
 * 양쪽 다 변경분이 있으면 한 번에 한 영역만 저장된다(저장 SP 가 시트별로 갈린다). 이때만
 * 포커스를 쓰고, otherHasChanges 로 남는 쪽이 있음을 알린다.
 *
 * 둘 다 없으면 상단을 대상으로 돌려준다 — 저장 경로가 그대로 진행돼 "수정한 내용이 없습니다"가
 * 뜬다. 실제로 저장할 것이 없으므로 맞는 결과다.
 */
export const pickSaveTarget = (
  masterDirtyCount: number,
  detailDirtyCount: number,
  activeGrid: ActiveGrid
): SaveTarget => {
  if (masterDirtyCount > 0 && detailDirtyCount > 0) {
    return { target: activeGrid, otherHasChanges: true };
  }
  if (detailDirtyCount > 0) return { target: 'sub', otherHasChanges: false };
  return { target: 'main', otherHasChanges: false };
};
