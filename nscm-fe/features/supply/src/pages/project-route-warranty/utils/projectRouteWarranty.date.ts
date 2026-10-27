import dayjs from '@foundation/dayjs';

// SCP0048 FROM/TO_YYYYMMDD 날짜 변환 — 이 화면만의 표시/편집 규약(설계 03 §표시 = YYYY-MM-DD).
//   admin 메타가 FPDate 라 columnMapping 이 InputDate(달력) 에디터를 붙이지만 dataType 을 비워 둬
//   (getDataType→undefined) 달력이 Date 값에 못 묶이고, 공용 getFormat 은 전역 yyyy.MM.dd(점)를
//   적용한다. GET SP 조회값은 'YYYY-MM-DD' 문자열, 편집 커밋값은 Date(InputDate) 라 그리드에서
//   섞인다. 그래서 페이지(mainRows)에서 값을 Date 로 변환하고, 그리드에서 두 컬럼의 dataType=Date +
//   format='yyyy-MM-dd' 를 명시해 (a) 달력 편집 정상 (b) 표시 YYYY-MM-DD 를 함께 해결한다
//   (precede-safety-stock-day 검증 패턴). 공용 columnMapping 수정은 범위가 너무 넓어(전 화면 날짜)
//   하지 않고 이 화면에서만 처리한다. 저장/검증은 toYmd8 로 Date·문자열을 'YYYYMMDD' 8자리로 되돌린다.

/** 그리드 표시/편집용 — 파싱되면 Date, 비거나 못 읽으면 '' (FPDate 빈 셀). */
export const toGridDate = (v: unknown): Date | '' => {
  if (v instanceof Date) return v;
  const s = typeof v === 'string' ? v.trim() : typeof v === 'number' ? String(v) : '';
  if (s === '') return '';
  // "2026-06-01" / "2026-06-01 00:00:00" / "20260601" 모두 허용.
  const d = /^\d{8}$/.test(s) ? dayjs(s, 'YYYYMMDD') : dayjs(s);
  return d.isValid() ? d.toDate() : '';
};

/** 저장/검증용 — Date·날짜문자열을 DB 저장 형태인 'YYYYMMDD' 8자리로. 못 읽으면 ''. */
export const toYmd8Date = (v: unknown): string => {
  if (v instanceof Date) return dayjs(v).format('YYYYMMDD');
  const digits = (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '').replace(
    /\D/g,
    ''
  );
  return digits.length >= 8 ? digits.slice(0, 8) : '';
};
