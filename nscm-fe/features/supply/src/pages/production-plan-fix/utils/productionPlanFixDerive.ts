// SCP0024 pivot 파생 산식 (design 03 §2.2 — Prod Plan 행 D_ QTY 편집 시 상위 W_/M_ SUM 롤업 재집계).
//   순수 함수로 분리해 단위 테스트로 산식을 검증한다(그리드 cellEditEnded 핸들러가 호출).
//   SCP0013 과 달리 W_ 편집→D_ 분배는 없다 — 편집 band 가 D_ × Prod Plan 뿐이고 W_/M_ 는 SUM 롤업(읽기전용).

// 숫자 파싱 — 공백/빈값/파싱실패 = null.
export const toNum = (v: unknown): number | null => {
  if (v === undefined || v === null || v === '') return null;
  const n = typeof v === 'number' ? v : typeof v === 'string' ? Number(v.replace(/,/g, '')) : NaN;
  return Number.isFinite(n) ? n : null;
};

// QTY 는 정수(반올림) — design 03 §2.2 GET SP ROUND(SUM(...)). Fix Reason 행은 텍스트라 대상 아님.
export const roundQty = (n: number): number => Math.round(n);

// ISO 8601 주차 (월요일 기준) — 3단 헤더 주 span 라벨/그룹핑용 (자매 SCP0013 isoWeek 동일).
export const isoWeek = (yyyymmdd: string): number => {
  const d = new Date(
    Date.UTC(+yyyymmdd.slice(0, 4), +yyyymmdd.slice(4, 6) - 1, +yyyymmdd.slice(6, 8))
  );
  const day = d.getUTCDay() || 7;
  d.setUTCDate(d.getUTCDate() + 4 - day);
  const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
  return Math.ceil(((d.getTime() - yearStart.getTime()) / 86400000 + 1) / 7);
};

// 하위 D_ 셀 합계 — D_ 편집 시 상위 W_/M_ SUM 롤업 재집계(design 03 §2.2 W_/M_=일자 QTY 의 SUM 롤업).
export const sumValues = (values: unknown[]): number =>
  roundQty(values.reduce<number>((acc, v) => acc + (toNum(v) ?? 0), 0));
