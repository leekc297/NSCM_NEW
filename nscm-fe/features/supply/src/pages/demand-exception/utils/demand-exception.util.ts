import dayjs from '@foundation/dayjs';

/**
 * FROM/TO_YYYYMMDD 날짜 변환 헬퍼 — 그리드 셀을 FPDate 달력으로 편집하고 'yyyy-MM-dd' 로 표시하려면
 * 값이 Date 여야 한다(셀값이 문자열이면 InputDate 가 비어 뜸 — DemandExceptionGrid dataType=Date 와 짝).
 *
 * GET SP 가 TO_DATE 로 내려주고 BE Jackson 이 'yyyy-MM-dd HH:mm:ss' 로 직렬화해 조회값은
 * "2026-06-01 00:00:00" 문자열이다. 신규행 기본값은 '' 이고, 편집 후엔 Date(InputDate 커밋)다.
 * 세 형태를 모두 받아 (표시/편집용) Date 또는 (저장/비교용) 'YYYYMMDD' 8자리로 정규화한다.
 * 형제 SCP0127/SCP0128 safety-stock.util.ts 와 동형.
 */

// unknown → 문자열(객체는 '' — no-base-to-string 회피, 날짜 필드는 string|number|Date 만 온다).
const asStr = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

/** 그리드 표시/편집용 — 파싱되면 Date, 비거나 못 읽으면 '' (FPDate 빈 셀). */
export const toGridDate = (v: unknown): Date | '' => {
  if (v instanceof Date) return v;
  const s = asStr(v).trim();
  if (s === '') return '';
  // "2026-06-01 00:00:00" / "2026-06-01" / "20260601" 모두 허용.
  const d = /^\d{8}$/.test(s) ? dayjs(s, 'YYYYMMDD') : dayjs(s);
  return d.isValid() ? d.toDate() : '';
};

/** 저장/비교용 — Date·날짜문자열을 DB 저장 형태인 'YYYYMMDD' 8자리로. 못 읽으면 ''. */
export const toYmd8 = (v: unknown): string => {
  if (v instanceof Date) return dayjs(v).format('YYYYMMDD');
  return asStr(v)
    .replace(/\D/g, '')
    .slice(0, 8);
};
