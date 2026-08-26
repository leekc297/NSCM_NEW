/**
 * 문자열 유틸리티
 */

export const capitalize = (str: string): string => {
  return str.charAt(0).toUpperCase() + str.slice(1);
};

export const kebabCase = (str: string): string => {
  return str.replace(/([a-z0-9]|(?=[A-Z]))([A-Z])/g, '$1-$2').toLowerCase();
};

export const camelCase = (str: string): string => {
  return str.replace(/-([a-z])/g, (g) => g[1].toUpperCase());
};

/**
 * unknown 값을 표시·비교용 문자열로 안전 변환.
 *
 * 왜 필요한가 — SP 커서 행의 값 타입은 `unknown`(또는 WijmoPrimitive) 이라 `String(v ?? '')` 를 쓰면
 * 린트 규칙 `no-base-to-string` 이 막는다. 객체가 흘러들어오면 실제로 `'[object Object]'` 가
 * 화면과 저장 payload 에 그대로 박히기 때문이다(규칙의 취지).
 * 이 함수는 **원시값만 문자열로 바꾸고 그 외(객체/함수/심볼/null/undefined)는 빈 문자열**로 떨군다.
 *
 * ⚠ 숫자 `0` 과 `false` 는 `'0'`·`'false'` 로 남는다 — "값 없음"과 구분해야 하는 자리에서는
 *   빈 문자열 비교가 아니라 `v == null` 로 판정할 것.
 */
export const safeString = (v: unknown): string => {
  if (typeof v === 'string') return v;
  if (typeof v === 'number' || typeof v === 'boolean' || typeof v === 'bigint') return String(v);
  return '';
};
