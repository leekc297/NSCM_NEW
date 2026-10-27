import { DUMMY_CODE_PREFIX } from '../capa-line-assign.constants';
import type { ComboOption } from '../capa-line-assign.types';

/**
 * `ScpCapaBL.GetSortedCode`(ScpCapaBL.cs:81-136) 등가 — CODE 오름차순, 단 `DMY_` 접두 Dummy 는 맨 뒤.
 * design 02 §3.3 / V-19.
 */
export const sortMasterCodes = (options: ComboOption[]): ComboOption[] =>
  [...options].sort((a, b) => {
    const aDummy = a.value.startsWith(DUMMY_CODE_PREFIX);
    const bDummy = b.value.startsWith(DUMMY_CODE_PREFIX);
    if (aDummy !== bDummy) return aDummy ? 1 : -1;
    return a.value.localeCompare(b.value);
  });

const SUFFIX_C = '_C';
const SUFFIX_A = '_A';

/**
 * `clbLine` 전용 `_A`/`_C` 접미 재정렬 (AS-IS cs:1642-1702, 체크리스트 X-N).
 *
 * AS-IS 는 정렬된 목록을 훑으며 SEQ1(그룹 채번)을 매기고, 같은 base 를 가진 `_C`/`_A` 쌍에만
 * SEQ2 를 `_C`→1 / `_A`→2 로 주어 재정렬한다. **접미 쌍이 정확히 2건일 때만** 적용된다 —
 * 한쪽만 있거나 3건 이상이면 일반 정렬 그대로다. 일반 정렬로 대체할 수 없는 업무 규칙이다.
 *
 * 입력은 이미 {@link sortMasterCodes} 를 거친 목록이어야 한다(그룹 채번이 그 순서를 따른다).
 */
export const sortLineCodes = (options: ComboOption[]): ComboOption[] => {
  const baseOf = (code: string): string | null => {
    if (code.endsWith(SUFFIX_C) || code.endsWith(SUFFIX_A)) return code.slice(0, -2);
    return null;
  };

  // base 별 접미 구성원 수 — 정확히 2건(_C + _A)인 base 만 재정렬 대상이다.
  const pairCount = new Map<string, Set<string>>();
  for (const option of options) {
    const base = baseOf(option.value);
    if (base === null) continue;
    const suffixes = pairCount.get(base) ?? new Set<string>();
    suffixes.add(option.value.slice(-2));
    pairCount.set(base, suffixes);
  }

  // SEQ1 = 그룹 채번(등장 순서). 쌍이 아닌 코드는 자기 자신이 곧 그룹이다.
  const groupSeq = new Map<string, number>();
  let nextSeq = 0;
  const decorated = options.map((option, index) => {
    const base = baseOf(option.value);
    const isPair = base !== null && pairCount.get(base)?.size === 2;
    const groupKey = isPair && base !== null ? base : `#${index}`;
    if (!groupSeq.has(groupKey)) groupSeq.set(groupKey, nextSeq++);
    const seq2 = isPair ? (option.value.endsWith(SUFFIX_C) ? 1 : 2) : 0;
    return { option, seq1: groupSeq.get(groupKey) ?? 0, seq2 };
  });

  return decorated
    .sort((a, b) => (a.seq1 === b.seq1 ? a.seq2 - b.seq2 : a.seq1 - b.seq1))
    .map(entry => entry.option);
};
