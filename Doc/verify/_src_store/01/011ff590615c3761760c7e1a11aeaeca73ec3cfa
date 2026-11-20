import type { ClipboardEvent } from 'react';

/**
 * 멀티라인 붙여넣기 → 쉼표구분 토큰열 공통 유틸.
 *
 * AS-IS GSCM 공통 컨트롤 `UsrMultiLineEditor`(돋보기와 별개의 드롭다운 토글) 등가 기능이다.
 * AS-IS 는 드롭다운 멀티라인 박스(textBox2)의 각 줄을 단일 입력박스(textBox1)로 재조립할 때
 * `strLine.Trim().Length > 0` 인 줄만 `,` 로 조인했다. TO-BE 는 드롭다운 UI 없이 input 의
 * paste 를 가로채 동일 변환을 수행한다(그리드/엑셀 셀 복사 → `A,B,C` 멀티값 입력).
 *
 * 특정 화면(Model/Nickname·Material 등 멀티값 조회조건)에만 선택 적용한다 — 모든 입력에 거는
 * 전역 동작이 아니다.
 */

/** 붙여넣기 텍스트가 멀티라인(개행 포함)인지. 단일값·이미 쉼표인 값은 false → 기본 붙여넣기에 맡긴다. */
export const isMultilinePaste = (text: string): boolean => /[\r\n]/.test(text);

/**
 * 멀티라인 텍스트를 쉼표구분 문자열로 변환한다(AS-IS UsrMultiLineEditor 등가).
 * - 개행 `\r\n` / `\r` / `\n` 모두를 구분자로 분리(엑셀·그리드 클립보드는 CRLF)
 * - 각 줄 trim 후 공백/빈 줄 제거(끝 개행에서 생기는 trailing 쉼표 방지)
 * - 쉼표로 join (탭은 줄 안에 그대로 둔다 — AS-IS 는 줄만 분리)
 */
export const multilinePasteToCsv = (text: string): string =>
  text
    .split(/\r\n|\r|\n/)
    .map(line => line.trim())
    .filter(line => line.length > 0)
    .join(',');

/**
 * 현재값의 selection 구간([start, end))을 CSV 치환 결과로 대체한 새 값.
 * 기존값 중간 삽입·끝 이어붙이기·선택영역 교체를 모두 자연스럽게 처리한다.
 */
export const spliceMultilinePaste = (
  current: string,
  pasted: string,
  selStart: number,
  selEnd: number,
): string => {
  const start = Number.isFinite(selStart) ? selStart : current.length;
  const end = Number.isFinite(selEnd) ? selEnd : current.length;
  return current.slice(0, start) + multilinePasteToCsv(pasted) + current.slice(end);
};

/**
 * input 의 `onPaste` 핸들러 팩토리. 멀티라인일 때만 기본 붙여넣기를 막고 CSV 치환값을 commit 한다.
 * 화면은 `inputProps={{ onPaste: createMultilinePasteHandler(() => value, next => setValue(next)) }}`
 * 한 줄로 적용한다(대문자 InputProps 는 endAdornment 용 — 네이티브 input 에는 소문자 inputProps).
 *
 * @param getCurrent 현재 입력값(최신값을 읽도록 getter 로 받는다)
 * @param commit     CSV 치환된 새 값을 반영(화면별 setSearchParams 등 — nickName 리셋 같은 부수효과 포함)
 */
export const createMultilinePasteHandler =
  (getCurrent: () => string, commit: (next: string) => void) =>
  (e: ClipboardEvent<HTMLInputElement>): void => {
    const text = e.clipboardData.getData('text');
    if (!isMultilinePaste(text)) return;
    e.preventDefault();
    const el = e.currentTarget;
    commit(spliceMultilinePaste(getCurrent(), text, el.selectionStart ?? 0, el.selectionEnd ?? 0));
  };
