import { describe, expect, it } from 'vitest';

import { EMPTY_LOOKUP_DETAIL_ROW, sanitizeDetailRow, toDetailSaveRow } from './lookup.utils';

type DetailRow = Parameters<typeof sanitizeDetailRow>[0];

// SP 결과의 DISPLAY_SEQ 는 Oracle NUMBER → JSON number 로 내려온다(타입 선언은 string 이지만
// 런타임 값은 숫자). 저장 payload 를 만들 때 문자열로만 다루면 하단 그리드 저장이 예외로 죽는다.
const detailRowWith = (displaySeq: unknown): DetailRow =>
  ({ ...EMPTY_LOOKUP_DETAIL_ROW, DISPLAY_SEQ: displaySeq }) as DetailRow;

describe('sanitizeDetailRow', () => {
  it('숫자 DISPLAY_SEQ 를 그대로 유지한다 (예외 없이)', () => {
    expect(sanitizeDetailRow(detailRowWith(10)).DISPLAY_SEQ).toBe(10);
  });

  it('숫자 0 은 0 으로 정규화한다', () => {
    expect(sanitizeDetailRow(detailRowWith(0)).DISPLAY_SEQ).toBe('0');
  });

  it('문자열 0 · 공백 · null · undefined 는 0 으로 정규화한다', () => {
    expect(sanitizeDetailRow(detailRowWith('0')).DISPLAY_SEQ).toBe('0');
    expect(sanitizeDetailRow(detailRowWith('   ')).DISPLAY_SEQ).toBe('0');
    expect(sanitizeDetailRow(detailRowWith(null)).DISPLAY_SEQ).toBe('0');
    expect(sanitizeDetailRow(detailRowWith(undefined)).DISPLAY_SEQ).toBe('0');
  });

  it('문자열 값은 그대로 유지한다', () => {
    expect(sanitizeDetailRow(detailRowWith('20')).DISPLAY_SEQ).toBe('20');
  });
});

describe('toDetailSaveRow', () => {
  // 편집된 행: 현재 값은 사용자가 바꾼 값, EditTracker 에는 편집 직전 값이 남아 있다.
  const editedRow = {
    ...EMPTY_LOOKUP_DETAIL_ROW,
    LOOKUP_TYPE: '1LEVEL_DEPT_ID',
    SEGMENT1: '58174290',
    SEGMENT2: '333',
    DISPLAY_SEQ: 1,
  } as unknown as DetailRow;

  it('수정한 세그먼트의 UPDATE 키는 편집 직전 값이다', () => {
    const saveRow = toDetailSaveRow(editedRow, { SEGMENT2: 'Energy Solution' });

    expect(saveRow.SEGMENT2).toBe('333');
    expect(saveRow.SEGMENT2_KEY).toBe('Energy Solution');
  });

  it('편집하지 않은 세그먼트의 UPDATE 키는 현재 값과 같다', () => {
    const saveRow = toDetailSaveRow(editedRow, { SEGMENT2: 'Energy Solution' });

    expect(saveRow.SEGMENT1_KEY).toBe('58174290');
    expect(saveRow.SEGMENT3_KEY).toBe(EMPTY_LOOKUP_DETAIL_ROW.SEGMENT3);
  });

  it('편집 기록이 없으면 다섯 세그먼트 모두 현재 값을 키로 쓴다', () => {
    const saveRow = toDetailSaveRow(editedRow);

    expect(saveRow.SEGMENT1_KEY).toBe('58174290');
    expect(saveRow.SEGMENT2_KEY).toBe('333');
  });

  it('원본이 null 이면 빈 문자열로 보낸다', () => {
    const saveRow = toDetailSaveRow(editedRow, { SEGMENT1: null });

    expect(saveRow.SEGMENT1_KEY).toBe('');
  });

  it('DISPLAY_SEQ 정규화도 함께 적용한다', () => {
    expect(toDetailSaveRow(editedRow).DISPLAY_SEQ).toBe(1);
    expect(toDetailSaveRow(detailRowWith(0)).DISPLAY_SEQ).toBe('0');
  });
});
