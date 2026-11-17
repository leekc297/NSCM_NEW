import { ALL, DUMMY_CODE_PREFIX, EMPTY_CODE } from '../capa-line-assign.constants';
import type { ComboOption, ComboRow } from '../capa-line-assign.types';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

/** `'ALL'` 이거나 선택 0건이면 필터를 걸지 않는다(= 상위 단계 결과 전부). */
export const pickedSet = (selected: string[]): Set<string> | null => {
  if (selected.includes(ALL)) return null;
  const picked = selected.filter(code => code && code !== ALL);
  return picked.length === 0 ? null : new Set(picked);
};

export const inSet = (set: Set<string> | null, value: string): boolean => !set || set.has(value);

/** 마스터 축별 distinct — `DBUtils.GetDistinctTable(CODE, NAME)` + `DeleteEmptyName` 등가. */
export const distinctByCode = (
  rows: ComboRow[],
  idKey: string,
  nameKey: string,
  accept: (row: ComboRow) => boolean
): ComboOption[] => {
  const seen = new Map<string, string>();
  for (const row of rows) {
    if (!accept(row)) continue;
    const code = str(row[idKey]);
    const name = str(row[nameKey]);
    // `CODE <> '-'` + 공백 제거(ScpCapaBL `DeleteEmptyName`) — design 02 §3.3.
    if (!code || code === EMPTY_CODE || !name) continue;
    if (!seen.has(code)) seen.set(code, name);
  }
  return [...seen.entries()].map(([value, label]) => ({ value, label }));
};

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
 * `clbLine` 전용 정렬 (AS-IS `RefreshLine` cs:1662-1699 충실 재현, 체크리스트 X-N).
 *
 * AS-IS 는 {@link sortMasterCodes} 결과(CODE 오름차순, `DMY_` 더미 맨 뒤)를 훑으며 각 코드의
 * **base = CODE 에서 마지막 2글자를 뗀 값**을 구하고, `CODE LIKE '%base%'`(base 를 부분
 * 문자열로 포함, `_` 는 SQL 단일문자 와일드카드) 매칭 코드가 **전체에서 정확히 2건**이면 그
 * 코드를 "쌍 그룹" 으로 본다. 쌍 그룹이면:
 *   - 접미 `_C` → (SEQ1=그룹채번, SEQ2=1) / `_A` → (SEQ1=그룹채번, SEQ2=2) ⇒ `_C` 가 `_A` 앞.
 *   - 접미가 `_C`/`_A` 가 **아니면 SEQ 미부여(NULL)** ⇒ 최종 정렬에서 **맨 앞으로 뜬다.**
 *     예: `E5DP1`/`E5DP2` 는 base `E5D` 가 서로를 포함해 쌍 그룹(count==2)이 되지만 접미가
 *     `P1`/`P2` 라 NULL → 목록 최상단. **AS-IS 실측 순서다** — 일반 정렬로는 재현 불가(V-19).
 * 쌍 그룹이 아니면 SEQ1 을 1씩 올려 부여한다. 최종 정렬 = `SEQ1,SEQ2 ASC`(문자열 컬럼, NULL 우선).
 *
 * `_cd`(그룹 채번)는 AS-IS 와 동일하게 10 에서 시작하고 SEQ 는 **문자열로 비교**한다(그룹 90개
 * 미만이면 숫자 정렬과 동일 — AS-IS DataView 문자열 컬럼 정렬 동작까지 보존). 입력은 이미
 * {@link sortMasterCodes} 를 거친 목록이어야 한다(그룹 채번이 그 순서를 따른다).
 */
export const sortLineCodes = (options: ComboOption[]): ComboOption[] => {
  const values = options.map(option => option.value);

  // `CODE LIKE '%base%'` 매칭 건수 — `_` 는 임의 1글자, 나머지는 리터럴(base 에 `%` 는 없다).
  const likeCount = (base: string): number => {
    const pattern = new RegExp(base.replace(/[.*+?^${}()|[\]\\]/g, '\\$&').replace(/_/g, '.'));
    return values.reduce((count, value) => (pattern.test(value) ? count + 1 : count), 0);
  };

  let cd = 10;
  let prevBase: string | null = null;
  const decorated = options.map((option, index) => {
    const code = option.value;
    const base = code.slice(0, -2); // CODE 에서 마지막 2글자 제거(AS-IS Substring(0, len-2))
    let seq1: string | null;
    let seq2: string | null;
    if (likeCount(base) === 2) {
      const suffix = code.slice(-2);
      if (prevBase !== base) cd++;
      if (suffix === SUFFIX_C) {
        seq1 = String(cd);
        seq2 = '1';
      } else if (suffix === SUFFIX_A) {
        seq1 = String(cd);
        seq2 = '2';
      } else {
        seq1 = null; // AS-IS: SEQ 미부여 → NULL 우선으로 최상단
        seq2 = null;
      }
    } else {
      cd++;
      seq1 = String(cd);
      seq2 = '1';
    }
    prevBase = base;
    return { option, seq1, seq2, index };
  });

  // AS-IS DataView "SEQ1,SEQ2 ASC": NULL 우선 → 문자열 SEQ1 → 문자열 SEQ2 → 입력순(안정).
  return decorated
    .sort((a, b) => {
      if (a.seq1 === null || b.seq1 === null) {
        if (a.seq1 === b.seq1) return a.index - b.index;
        return a.seq1 === null ? -1 : 1;
      }
      if (a.seq1 !== b.seq1) return a.seq1 < b.seq1 ? -1 : 1;
      if (a.seq2 !== b.seq2) return (a.seq2 ?? '') < (b.seq2 ?? '') ? -1 : 1;
      return a.index - b.index;
    })
    .map(entry => entry.option);
};
