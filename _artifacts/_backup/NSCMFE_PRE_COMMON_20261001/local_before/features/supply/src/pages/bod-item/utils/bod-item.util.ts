import type { ComboResponse } from '@foundation/models';

import { ALL, BOD_EXCLUDED_COLUMN, MSG } from '../bod-item.constants';

/** 'ALL'/빈 값을 sentinel 로 걸러 콤마 코드 배열만 남긴다(convert-core cascade 규약). */
export const toSelectedCodes = (value: string): string[] =>
  (value ?? '')
    .split(',')
    .map(code => code.trim())
    .filter(code => code !== '' && code.toUpperCase() !== ALL);

/**
 * Division 선택값으로 콤보 행을 client-side 필터 — AS-IS SetChangeControl()의 `DIVISION_ID IN (...)`
 * 서버 재조회를 클라 필터로 재현(02 §3, convert-core §2.6). division 미선택('ALL')이면 전체 통과.
 * From/To Site·Plan Group 공통 사용(반환에 DIVISION_ID 포함).
 */
export const buildDivisionFilteredOptions = (
  rows: ComboResponse[] | undefined,
  divisionId: string
): { label: string; value: string }[] => {
  const divisionCodes = toSelectedCodes(divisionId);
  const byCode = new Map<string, { label: string; value: string }>();
  for (const row of rows ?? []) {
    const code = String(row.CODE ?? '').trim();
    if (code === '') continue;
    if (divisionCodes.length > 0) {
      const rowDivision = String(row.DIVISION_ID ?? '').trim();
      if (rowDivision !== '' && !divisionCodes.includes(rowDivision)) continue;
    }
    if (byCode.has(code)) continue;
    byCode.set(code, { label: String(row.NAME ?? code), value: code });
  }
  return [...byCode.values()];
};

export const isBlank = (value: unknown): boolean =>
  value === null || value === undefined || String(value as string | number).trim() === '';

/** YYYYMMDD 8자리 숫자만 추출(대시 등 제거) — 8자리 아니면 undefined(미입력/부분입력). */
const toYmd8 = (value: unknown): string | undefined => {
  if (isBlank(value)) return undefined;
  const digits = String(value as string | number).replace(/\D/g, '');
  return digits.length === 8 ? digits : undefined;
};

/**
 * Excluded 저장 전 화면 고유 날짜검증 — AS-IS SaveData_Sub(cs:1114-1136)의 라이브 검증 재현(03 §4-C).
 * 저장 대상(dirty) 각 행에서 FROM > TO 역전 시 첫 위반 메시지(MSG00219) 반환 → 호출부가 저장 차단.
 * 형식검증(MSG00046)은 FPDate 셀이 구조적으로 보장하므로 여기서는 역전만 검사한다.
 * FROM/TO 중 하나라도 미입력(8자리 아님)이면 AS-IS ParseExact 실패 분기와 동일하게 비교를 건너뛴다.
 * YYYYMMDD 8자리 문자열 사전식 비교 = 시간순 비교(supply 도메인 날짜 검증 관례).
 */
export const validateExcludedDates = (
  rows: readonly WijmoRowItem[]
): { id: string; fallback: string } | null => {
  for (const row of rows) {
    const from = toYmd8(row[BOD_EXCLUDED_COLUMN.BOD_EX_FROM_YYYYMMDD]);
    const to = toYmd8(row[BOD_EXCLUDED_COLUMN.BOD_EX_TO_YYYYMMDD]);
    if (from && to && from > to) {
      return {
        id: MSG.PERIOD_REVERSED,
        fallback: '_시작일자가 종료일자보다 늦을 수 없습니다.\n\r리스트 확인 후 입력하십시오.',
      };
    }
  }
  return null;
};
