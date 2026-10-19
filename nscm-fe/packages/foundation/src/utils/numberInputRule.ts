/** 숫자 컬럼 입력 제한 규칙. 값이 없는 항목은 제한하지 않는다. */
export interface NumberInputRule {
  /** true 면 음수 입력을 막는다(0 은 허용). */
  positiveOnly?: boolean;
  /** true 면 소수점 입력을 막는다. */
  integerOnly?: boolean;
  /** 허용하는 소수 자릿수 상한. integerOnly 가 켜져 있으면 무시된다. */
  decimalPlaces?: number;
}

const stripThousands = (text: string): string => text.replaceAll(',', '');

/**
 * 타이핑 중인 문자열이 규칙 위반으로 굳어지는지 판정한다.
 *
 * `-`, `1.` 처럼 아직 완성되지 않은 입력은 통과시키고, 이미 규칙을 어긴 문자('-', '.', 초과 소수 자릿수)만 거부한다.
 */
export const isTypingAllowed = (text: string, rule: NumberInputRule): boolean => {
  const value = stripThousands(text);
  if (rule.positiveOnly && value.includes('-')) return false;
  if (rule.integerOnly && value.includes('.')) return false;
  if (!rule.integerOnly && rule.decimalPlaces != null) {
    const dotIndex = value.indexOf('.');
    if (dotIndex >= 0 && value.length - dotIndex - 1 > rule.decimalPlaces) return false;
  }
  return true;
};

/**
 * 편집 종료 또는 붙여넣기로 확정될 값이 규칙을 만족하는지 판정한다.
 *
 * 빈 문자열은 값 없음이므로 통과한다. 숫자로 변환되지 않는 문자열의 거부는 Wijmo `dataType: Number` 가 맡는다.
 */
export const isValueAllowed = (text: string, rule: NumberInputRule): boolean => {
  const value = stripThousands(text).trim();
  if (value === '') return true;
  if (!isTypingAllowed(value, rule)) return false;
  if (rule.positiveOnly && Number(value) < 0) return false;
  return true;
};
