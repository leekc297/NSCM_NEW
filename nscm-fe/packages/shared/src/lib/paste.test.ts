import { describe, expect, it } from 'vitest';

import { isMultilinePaste, multilinePasteToCsv, spliceMultilinePaste } from './paste';

describe('isMultilinePaste', () => {
  it('개행이 없으면 false(단일값·이미 쉼표인 값은 기본 붙여넣기)', () => {
    expect(isMultilinePaste('MCCH114030D3')).toBe(false);
    expect(isMultilinePaste('A,B,C')).toBe(false);
  });

  it('CRLF/LF/CR 어느 개행이든 true', () => {
    expect(isMultilinePaste('A\r\nB')).toBe(true);
    expect(isMultilinePaste('A\nB')).toBe(true);
    expect(isMultilinePaste('A\rB')).toBe(true);
  });
});

describe('multilinePasteToCsv — AS-IS UsrMultiLineEditor 등가', () => {
  it('엑셀/그리드 CRLF + 끝 개행 → trailing 쉼표 없이 조인', () => {
    expect(multilinePasteToCsv('A\r\nB\r\nC\r\n')).toBe('A,B,C');
  });

  it('LF 전용 개행도 동일 처리', () => {
    expect(multilinePasteToCsv('A\nB\nC')).toBe('A,B,C');
  });

  it('공백/빈 줄은 제거하고 각 줄 trim', () => {
    expect(multilinePasteToCsv(' A \r\n\r\n  \r\nB ')).toBe('A,B');
  });

  it('탭은 줄 안에 그대로 둔다(AS-IS 는 줄만 분리)', () => {
    expect(multilinePasteToCsv('A\tX\r\nB\tY')).toBe('A\tX,B\tY');
  });

  it('단일 줄은 그대로', () => {
    expect(multilinePasteToCsv('MCCH114030D3')).toBe('MCCH114030D3');
  });
});

describe('spliceMultilinePaste — selection 구간 치환', () => {
  it('빈 입력에 붙여넣기(커서 0,0)', () => {
    expect(spliceMultilinePaste('', 'A\r\nB\r\n', 0, 0)).toBe('A,B');
  });

  it('기존값 끝에 이어붙이기', () => {
    expect(spliceMultilinePaste('X', 'A\nB', 1, 1)).toBe('XA,B');
  });

  it('선택 영역을 교체', () => {
    // 'OLD' 전체(0..3) 선택 후 붙여넣기
    expect(spliceMultilinePaste('OLD', 'A\nB', 0, 3)).toBe('A,B');
  });

  it('중간 삽입', () => {
    expect(spliceMultilinePaste('XZ', 'A\nB', 1, 1)).toBe('XA,BZ');
  });
});
