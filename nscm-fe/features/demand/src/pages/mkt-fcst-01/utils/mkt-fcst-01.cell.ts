// 타입 안전 cell 값 → string (no-base-to-string 회피 — 객체는 ''). SP 컬럼은 string/number 만.
export const toCellStr = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// [DMF0003_01] Prod. Country 의 N/A(Skip) 번호.
export const PRDN_CTRY_NA = '99';
// Prod. Country Option 의 N/A — 룩업 PRDN_CTRY_OPT 코드(AND · OR · N/A).
export const PRDN_CTRY_OPT_NA = 'N/A';

// Prod. Country 셀 값 정리 — 쉼표로 나눠 공백 제거 · 중복 제거 · 번호순(2,1 → 1,2).
//   팝업 선택과 셀 직접 입력이 같은 값을 넣도록 둘 다 이 함수를 쓴다. 저장 프로시저의 값 정리와 같은 규칙.
//   목록에 없는 번호와 99 를 다른 번호와 섞은 값은 고치지 않는다 — 저장 프로시저가 막는다.
export const normalizePrdnCtry = (value: string): string =>
  [
    ...new Set(
      value
        .split(',')
        .map(v => v.trim())
        .filter(Boolean)
    ),
  ]
    .sort((a, b) => Number(a) - Number(b) || a.localeCompare(b))
    .join(',');
