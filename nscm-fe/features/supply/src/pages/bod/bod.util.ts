import type { ComboResponse } from '@foundation/models';

import { BOD_COLUMN } from './bod.constants';

/**
 * 'ALL' / 빈 값을 sentinel 로 걸러 콤마 코드 배열만 남긴다.
 * cascade-combo-filter.md §2.2 — 'ALL' sentinel 처리 의무.
 */
const toSelectedCodes = (value: string): string[] =>
  (value ?? '')
    .split(',')
    .map(code => code.trim())
    .filter(code => code !== '' && code.toUpperCase() !== 'ALL');

/**
 * Division 선택값으로 From/To Site·Customer 등 콤보 행을 client-side 필터링.
 * AS-IS SetChangeControl()(SCP0007_BOD.cs L238-253) — `DIVISION_ID IN (...)` 서버 재조회를
 * client-side 필터(cascade-combo-filter.md §4)로 재현. Map dedup(§3, 복합키 없이 CODE 단일 — 이
 * 화면은 division 별로 같은 CODE 가 겹치는 사례가 없어 CODE 단일 키로 충분).
 *
 * divisionIds 가 비어있거나(ALL) 전부이면 전체 통과.
 */
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

const isBlankValue = (value: unknown): boolean =>
  value === null || value === undefined || String(value as string | number).trim() === '';

/** UTF-8 바이트 길이 — mail-setup.util.ts getByteLength 와 동일 방식(TextEncoder). */
const getByteLength = (text: string): number => new globalThis.TextEncoder().encode(text).length;

/** 'yyyy-MM-dd' 문자열을 로컬 자정 Date 로 변환 — `new Date(str)` 의 UTC 파싱으로 인한 요일 오차 방지. */
const parseLocalDate = (value: string): Date | undefined => {
  const [y, m, d] = value.split('-').map(Number);
  if (!y || !m || !d) return undefined;
  return new Date(y, m - 1, d);
};

const toYyyyMmDd = (date: Date): string =>
  `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;

export interface BodSaveValidationError {
  id: string;
  fallback: string;
  params?: string[];
}

/**
 * 저장 전 행 단위 업무 검증 — AS-IS SaveData_Main(SCP0007_BOD.cs L677-782) 중 필수값(공통
 * checkRequiredOfSpread 로 이미 커버되는 항목 제외) 이외의 BOD 고유 규칙만 이식한다.
 * 첫 위반 1건만 반환(AS-IS 도 위반 즉시 return). Monday/Sunday 위반 시 AS-IS 처럼 해당 셀 값을
 * 자동 보정(가까운 월/일요일)하고 실패를 반환 — 사용자가 보정된 값을 보고 다시 저장해야 한다.
 *
 * From/To Site 동일 검증은 AS-IS 원본이 전체 행 누적 문자열 비교(L774)라 사실상 "누적된 모든 행이
 * From=To 일 때만" 걸리는 legacy 특이동작이다. 메시지 의도(MSG00253)에 맞춰 행 단위로 해석해
 * 포팅한다.
 */
export const validateBodRows = (rows: WijmoRowItem[]): BodSaveValidationError | null => {
  for (const row of rows) {
    const beforeLeadTime = row[BOD_COLUMN.BEFORE_LEAD_TIME];
    if (isBlankValue(beforeLeadTime) || Number(beforeLeadTime) < 0) {
      return { id: 'MSG00085', fallback: '_{0} 이상의 값만 입력 가능합니다.', params: ['ExFactory(LeadTime) : 0'] };
    }

    const afterLeadTime = row[BOD_COLUMN.AFTER_LEAD_TIME];
    if (isBlankValue(afterLeadTime) || Number(afterLeadTime) < 0) {
      return { id: 'MSG00085', fallback: '_{0} 이상의 값만 입력 가능합니다.', params: ['Additional Lead Time : 0'] };
    }

    const remarks = String(row[BOD_COLUMN.REMARKS] ?? '');
    if (getByteLength(remarks) >= 150) {
      return { id: 'MSG00165', fallback: '_입력할 수 있는 자리수를 초과하였습니다.' };
    }

    const fromValue = row[BOD_COLUMN.FROM_YYYYMMDD];
    const toValue = row[BOD_COLUMN.TO_YYYYMMDD];
    const fromDate = isBlankValue(fromValue) ? undefined : parseLocalDate(String(fromValue));
    const toDate = isBlankValue(toValue) ? undefined : parseLocalDate(String(toValue));

    if (fromDate && toDate) {
      if (fromDate.getTime() > toDate.getTime()) {
        return {
          id: 'MSG00219',
          fallback: '_시작일자가 종료일자보다 늦을 수 없습니다.\n\r리스트 확인 후 입력하십시오.',
        };
      }

      if (fromDate.getDay() !== 1 /* Monday */) {
        const monday = new Date(fromDate);
        monday.setDate(fromDate.getDate() - ((fromDate.getDay() + 6) % 7));
        row[BOD_COLUMN.FROM_YYYYMMDD] = toYyyyMmDd(monday);
        return { id: 'MSG00355', fallback: '_{0}기간을 다시 선택하여 주십시오.({1})', params: ['FROM', 'Monday'] };
      }

      if (toDate.getDay() !== 0 /* Sunday */) {
        const sunday = new Date(toDate);
        sunday.setDate(toDate.getDate() + (7 - toDate.getDay()));
        row[BOD_COLUMN.TO_YYYYMMDD] = toYyyyMmDd(sunday);
        return { id: 'MSG00355', fallback: '_{0}기간을 다시 선택하여 주십시오.({1})', params: ['TO', 'Sunday'] };
      }
    }

    const fromSite = row[BOD_COLUMN.FROM_SITE_CODE];
    const toSite = row[BOD_COLUMN.TO_SITE_CODE];
    if (!isBlankValue(fromSite) && fromSite === toSite) {
      return { id: 'MSG00253', fallback: '_From Site와 To Site는 동일할 수 없습니다.' };
    }
  }

  return null;
};
