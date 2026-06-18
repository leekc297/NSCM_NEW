import { BUCKET_TYPE } from '../mkt-forecast-master.constants';

// AS-IS DMF0003_1_MktFcst.cs L1780 InitSpread + SetSpreadColumn
//   Bucket 별 동적 컬럼 header 생성 (Phase 3)
//   - Daily (D)   : YYYYMMDD 단위 일자 컬럼 (D_20260101 / D_20260102 / ...)
//   - Weekly (W)  : 주차 컬럼 (W_20260101 = 2026-01-01 주 시작)
//   - Monthly (M) : 월 컬럼 (M_202601 = 2026년 1월)
//
// AS-IS Div 40 (8주 관리) — Weekly Bucket 사용 시 W_tag column editable
//   8주 이내: editable / 8주 이후: read-only (Phase 6 LockRange 적용)
//
// ⚠️ UTC 일관성 (사용자 명시 요구 2026-06-07 — 동적 column 데이터 표시 fix):
//   longToPivot.ts 의 getBucketKey 가 UTC 처리 → bucketDate 도 UTC 통일 의무
//   local timezone 혼재 시 KST 자정 ↔ UTC 전일 의 yyyymmdd 키 mismatch → 동적 cell 빈 표시

const yyyymmdd = (d: Date): string => {
  const y = d.getUTCFullYear();
  const m = String(d.getUTCMonth() + 1).padStart(2, '0');
  const dd = String(d.getUTCDate()).padStart(2, '0');
  return `${y}${m}${dd}`;
};

const yyyymm = (d: Date): string => {
  const y = d.getUTCFullYear();
  const m = String(d.getUTCMonth() + 1).padStart(2, '0');
  return `${y}${m}`;
};

const parseYyyymmdd = (s: string): Date => {
  return new Date(Date.UTC(
    parseInt(s.slice(0, 4), 10),
    parseInt(s.slice(4, 6), 10) - 1,
    parseInt(s.slice(6, 8), 10),
  ));
};

// 일 단위 column key 생성 (D_YYYYMMDD)
export const generateDailyKeys = (startYyyymmdd: string, endYyyymmdd: string): string[] => {
  const start = parseYyyymmdd(startYyyymmdd);
  const end = parseYyyymmdd(endYyyymmdd);
  const keys: string[] = [];
  const cur = new Date(start);

  while (cur <= end) {
    keys.push(`D_${yyyymmdd(cur)}`);
    cur.setUTCDate(cur.getUTCDate() + 1);
  }

  return keys;
};

// 주 단위 column key 생성 (W_YYYYMMDD = 월요일)
export const generateWeeklyKeys = (startYyyymmdd: string, endYyyymmdd: string): string[] => {
  const start = parseYyyymmdd(startYyyymmdd);
  const end = parseYyyymmdd(endYyyymmdd);
  const keys: string[] = [];

  // 시작일의 월요일 (getUTCDay: 0=일, 1=월, ..., 6=토)
  const dayOfWeek = start.getUTCDay();
  const mondayOffset = dayOfWeek === 0 ? -6 : 1 - dayOfWeek;
  const cur = new Date(start);
  cur.setUTCDate(cur.getUTCDate() + mondayOffset);

  while (cur <= end) {
    keys.push(`W_${yyyymmdd(cur)}`);
    cur.setUTCDate(cur.getUTCDate() + 7);
  }

  return keys;
};

// 월 단위 column key 생성 (M_YYYYMM)
export const generateMonthlyKeys = (startYyyymmdd: string, endYyyymmdd: string): string[] => {
  const start = parseYyyymmdd(startYyyymmdd);
  const end = parseYyyymmdd(endYyyymmdd);
  const keys: string[] = [];
  const cur = new Date(Date.UTC(start.getUTCFullYear(), start.getUTCMonth(), 1));
  const endMonth = new Date(Date.UTC(end.getUTCFullYear(), end.getUTCMonth(), 1));

  while (cur <= endMonth) {
    keys.push(`M_${yyyymm(cur)}`);
    cur.setUTCMonth(cur.getUTCMonth() + 1);
  }

  return keys;
};

// Bucket type 별 column key 생성 entry point
export const generateBucketKeys = (
  bucketType: typeof BUCKET_TYPE[keyof typeof BUCKET_TYPE],
  startYyyymmdd: string,
  endYyyymmdd: string,
): string[] => {
  if (bucketType === BUCKET_TYPE.DAILY) return generateDailyKeys(startYyyymmdd, endYyyymmdd);
  if (bucketType === BUCKET_TYPE.WEEKLY) return generateWeeklyKeys(startYyyymmdd, endYyyymmdd);
  if (bucketType === BUCKET_TYPE.MONTHLY) return generateMonthlyKeys(startYyyymmdd, endYyyymmdd);
  return [];
};

// ⭐ 2026-06-18 사용자 명시 — 월 안 주차 인덱스 (W1/W2/W3...)
//   사용자 요구: "월이 변경되는 경우 년월별 주차 별도 표기"
//   → Weekly/Daily 의 row 1 (주차) 헤더에서 같은 달 안의 주만 같은 W 번호로 묶임.
//   같은 W 라도 다른 달에 걸치면 별도 cell (자동 — 같은 W 가 다른 ym 이면 mergeManager 가 분리).
//
// 정의: 그 달 1일이 속한 주 = W1. 그 다음 월요일부터 W2/W3/...
export const getMonthWeekIndex = (yyyymmdd: string): number => {
  const d = parseYyyymmdd(yyyymmdd);
  const firstOfMonth = new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), 1));
  // 그 달 1일의 월요일 (그 주의 시작 — 1일이 화요일이면 전달 마지막 월요일)
  const firstDow = firstOfMonth.getUTCDay();
  const firstMondayOffset = firstDow === 0 ? -6 : 1 - firstDow;
  const firstMonday = new Date(firstOfMonth);
  firstMonday.setUTCDate(firstMonday.getUTCDate() + firstMondayOffset);
  // d 의 월요일
  const dDow = d.getUTCDay();
  const dMondayOffset = dDow === 0 ? -6 : 1 - dDow;
  const dMonday = new Date(d);
  dMonday.setUTCDate(dMonday.getUTCDate() + dMondayOffset);
  const diffMs = dMonday.getTime() - firstMonday.getTime();
  const diffWeeks = Math.round(diffMs / (7 * 24 * 3600 * 1000));
  return diffWeeks + 1;
};

// Bucket key 에서 header label 추출 (Wijmo Column.header — 단일 row fallback)
//   ⚠️ MktForecastMasterGrid 는 3-row columnHeaders + formatItem 으로 직접 textContent 설정.
//      이 함수는 단일 row header 인 다른 화면용 / fallback.
export const getBucketHeader = (key: string): string => {
  if (key.startsWith('D_')) {
    const d = key.slice(2);
    return `${d.slice(0, 4)}-${d.slice(4, 6)}-${d.slice(6, 8)}`;
  }
  if (key.startsWith('W_')) {
    const d = key.slice(2);
    return `${d.slice(0, 4)}-${d.slice(4, 6)} W${getMonthWeekIndex(d)}`;
  }
  if (key.startsWith('M_')) {
    const d = key.slice(2);
    return `${d.slice(0, 4)}-${d.slice(4, 6)}`;
  }
  return key;
};

// Div 40 의 8주 관리 — 8주 이내 column key 만 editable
export const getEditableWeeksFromCurrentDate = (): string[] => {
  const now = new Date();
  const keys: string[] = [];

  // 현재 주의 월요일부터 8주 (UTC 일관성)
  const utcNow = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()));
  const dayOfWeek = utcNow.getUTCDay();
  const mondayOffset = dayOfWeek === 0 ? -6 : 1 - dayOfWeek;
  const monday = new Date(utcNow);
  monday.setUTCDate(monday.getUTCDate() + mondayOffset);

  for (let i = 0; i < 8; i++) {
    const wkStart = new Date(monday);
    wkStart.setUTCDate(wkStart.getUTCDate() + i * 7);
    keys.push(`W_${yyyymmdd(wkStart)}`);
  }

  return keys;
};
