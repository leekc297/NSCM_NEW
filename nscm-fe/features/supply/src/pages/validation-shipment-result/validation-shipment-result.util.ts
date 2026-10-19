import type { ComboResponse } from '@foundation/models';

// 다중 콤보 선택값(콤마 문자열) → 유효 코드 배열. ALL sentinel·빈 토큰은 무필터로 해석해 제외.
//   BOD(SCP0007) bod.util.toSelectedCodes 와 동일 규약(cross-page import 금지라 화면 로컬 복제).
const toSelectedCodes = (value: string): string[] =>
  (value ?? '')
    .split(',')
    .map(code => code.trim())
    .filter(code => code !== '' && code.toUpperCase() !== 'ALL');

// Division 종속 콤보 옵션 — rows 를 현재 선택 division 으로 client-side 필터(cascade = 재조회 아님).
//   Plant/Sales Site 콤보(BOD From/To Site)는 전체 1회 로드 후 division 으로 걸러 쓴다(BOD 화면 규약).
//   division 미선택(빈/ALL)이면 전체 노출. 행 DIVISION_ID 가 비면 필터 통과(공통 site 포함).
export const buildDivisionFilteredOptions = (
  rows: ComboResponse[] | undefined,
  divisionId: string,
  codeColumn = 'CODE',
  nameColumn = 'NAME'
): { label: string; value: string }[] => {
  const divisionCodes = toSelectedCodes(divisionId);
  const byCode = new Map<string, { label: string; value: string }>();
  for (const row of rows ?? []) {
    const code = String(row[codeColumn] ?? '').trim();
    if (code === '') continue;
    if (divisionCodes.length > 0) {
      const rowDivision = String(row.DIVISION_ID ?? '').trim();
      if (rowDivision !== '' && !divisionCodes.includes(rowDivision)) continue;
    }
    if (byCode.has(code)) continue;
    byCode.set(code, { label: String(row[nameColumn] ?? code), value: code });
  }
  return [...byCode.values()];
};
