import { CRUD_TYPE } from '@foundation/constants';
import type { ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';

import { ALL, BOD_EXCLUDED_COLUMN, MSG } from '../bod-item.constants';

/**
 * 헤더 단일행 강제(SCP0030 화면 예외) — AS-IS SCP0030_BOD_ITEM.cs:212 `SetSheetHeaderColumn(siMain, 1)`
 * 파리티. AS-IS 는 헤더 행수를 1로 명시해 소/대분류(SMALL/LARGE_CLASS)를 무시하고 전 컬럼을 1줄로 그린다.
 * TO-BE 공용 DataGrid 는 컬럼 메타의 소/대분류로 다단 헤더를 추론하는데(columnMapping.getColumnDepth),
 * 이 화면 admin 메타는 소분류가 컬럼 라벨 복사본(BOD ITEM 전열)이거나 'Excluded Date'(Excluded 의
 * From/To)로 채워져 있어 헤더가 2줄로 그려진다. admin 메타(데이터)는 그대로 두고 이 화면에서만 그룹라벨을
 * 벗겨 1줄로 렌더한다 — 공용 로직·다른 화면 무영향(화면 국소 예외).
 */
export const toSingleRowHeaderColumns = (
  columns: RawFlexGridColumnConfig[]
): RawFlexGridColumnConfig[] =>
  columns.map(column => ({ ...column, sClsLblNm: undefined, lClsLblNm: undefined }));

/**
 * DATE_TEXT(FPDateText) 컬럼값 date-only 정규화. AS-IS FPDateText 는 'YYYY-MM-DD' 텍스트이나
 * TO-BE BE 는 Oracle DATE 를 'YYYY-MM-DD HH:mm:ss' 로 내려줘 그리드에 시각이 붙는다. 앞 10자(날짜)만
 * 남긴다 — 마스크(0000-00-00)·저장 계약과도 정합(값 자체를 date-only 텍스트로 맞춘다).
 */
export const toDateOnly = (value: string): string =>
  typeof value === 'string' && value.length >= 10 ? value.slice(0, 10) : value;

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
 * YYYYMMDD 8자리 문자열이 실재하는 달력 날짜인지 검사(월 1~12, 일 1~해당월 말일, 윤년 반영).
 * FPDate 마스크(0000-00-00)는 자릿수만 보장하고 월/일 범위는 못 막아 9999-22-22 같은 값이 통과하므로,
 * Date 롤오버(예: 2월 30일 → 3월 2일)에 속지 않도록 수동 대조한다.
 */
const isValidYmd8 = (ymd8: string): boolean => {
  const year = Number(ymd8.slice(0, 4));
  const month = Number(ymd8.slice(4, 6));
  const day = Number(ymd8.slice(6, 8));
  if (month < 1 || month > 12) return false;
  const isLeap = year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0);
  const lastDay = [31, isLeap ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month - 1];
  return day >= 1 && day <= lastDay;
};

/**
 * Excluded 저장 전 화면 고유 날짜검증 — AS-IS SaveData_Sub(cs:1114-1136)의 라이브 검증 재현(03 §4-C).
 * 두 단계로 검사하고 첫 위반 메시지를 반환 → 호출부가 저장 차단:
 *   1) 형식검증(MSG.INVALID_DATE): FROM/TO 가 비어있지 않은데 유효한 YYYYMMDD 달력 날짜가 아니면 차단.
 *      FPDate 마스크는 자릿수만 보장해 9999-22-22 등 비유효 값이 통과·저장돼 조회 SP TO_DATE 에서
 *      SQL 오류를 유발하므로 저장 시점에 막는다(설계 03 §4-C 의 "FPDate 셀이 형식 보장" 전제 보정).
 *   2) 역전검증(MSG.PERIOD_REVERSED=MSG01230, AS-IS MSG00219 동일 문구): FROM > TO 차단.
 * FROM/TO 가 미입력(빈 값)이면 AS-IS ParseExact 실패 분기와 동일하게 해당 검사를 건너뛴다.
 * YYYYMMDD 8자리 문자열 사전식 비교 = 시간순 비교(supply 도메인 날짜 검증 관례).
 */
export const validateExcludedDates = (
  rows: readonly WijmoRowItem[]
): { id: string; fallback: string } | null => {
  for (const row of rows) {
    // 삭제 대상('D') 행은 날짜검증 제외 — 지우는 행의 기간은 무의미(AS-IS 도 I/M 행만 검증).
    if (row.CRUD_TYPE === CRUD_TYPE.DELETE) continue;
    // 1) 형식검증 — 비어있지 않은데 유효 달력 날짜가 아니면(자릿수 부족 또는 월/일 범위 초과) 차단.
    for (const raw of [
      row[BOD_EXCLUDED_COLUMN.BOD_EX_FROM_YYYYMMDD],
      row[BOD_EXCLUDED_COLUMN.BOD_EX_TO_YYYYMMDD],
    ]) {
      if (isBlank(raw)) continue;
      const ymd = toYmd8(raw);
      if (!ymd || !isValidYmd8(ymd)) {
        return { id: MSG.INVALID_DATE, fallback: '_유효한 날짜 형식이 아닙니다. (YYYYMMDD)' };
      }
    }
    // 2) 역전검증 — 둘 다 유효 8자리일 때만 비교.
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
