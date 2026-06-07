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

const yyyymmdd = (d: Date) => {
  const y = d.getUTCFullYear();
  const m = String(d.getUTCMonth() + 1).padStart(2, '0');
  const dd = String(d.getUTCDate()).padStart(2, '0');
  return `${y}${m}${dd}`;
};

const yyyymm = (d: Date) => {
  const y = d.getUTCFullYear();
  const m = String(d.getUTCMonth() + 1).padStart(2, '0');
  return `${y}${m}`;
};

// 일 단위 column key 생성 (D_YYYYMMDD)
export function generateDailyKeys(startYyyymmdd: string, endYyyymmdd: string): string[] {
  const start = parseYyyymmdd(startYyyymmdd);
  const end = parseYyyymmdd(endYyyymmdd);
  const keys: string[] = [];
  const cur = new Date(start);

  while (cur <= end) {
    keys.push(`D_${yyyymmdd(cur)}`);
    cur.setUTCDate(cur.getUTCDate() + 1);
  }

  return keys;
}

// 주 단위 column key 생성 (W_YYYYMMDD = 월요일)
export function generateWeeklyKeys(startYyyymmdd: string, endYyyymmdd: string): string[] {
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
}

// 월 단위 column key 생성 (M_YYYYMM)
export function generateMonthlyKeys(startYyyymmdd: string, endYyyymmdd: string): string[] {
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
}

// Bucket type 별 column key 생성 entry point
export function generateBucketKeys(
  bucketType: typeof BUCKET_TYPE[keyof typeof BUCKET_TYPE],
  startYyyymmdd: string,
  endYyyymmdd: string,
): string[] {
  if (bucketType === BUCKET_TYPE.DAILY) return generateDailyKeys(startYyyymmdd, endYyyymmdd);
  if (bucketType === BUCKET_TYPE.WEEKLY) return generateWeeklyKeys(startYyyymmdd, endYyyymmdd);
  if (bucketType === BUCKET_TYPE.MONTHLY) return generateMonthlyKeys(startYyyymmdd, endYyyymmdd);
  return [];
}

// Bucket key 에서 header label 추출
export function getBucketHeader(key: string): string {
  if (key.startsWith('D_')) {
    const d = key.slice(2);
    return `${d.slice(4, 6)}/${d.slice(6, 8)}`;
  }
  if (key.startsWith('W_')) {
    const d = key.slice(2);
    return `W ${d.slice(4, 6)}/${d.slice(6, 8)}`;
  }
  if (key.startsWith('M_')) {
    const d = key.slice(2);
    return `${d.slice(0, 4)}/${d.slice(4, 6)}`;
  }
  return key;
}

// Div 40 의 8주 관리 — 8주 이내 column key 만 editable
export function getEditableWeeksFromCurrentDate(): string[] {
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
}

function parseYyyymmdd(s: string): Date {
  return new Date(Date.UTC(
    parseInt(s.slice(0, 4), 10),
    parseInt(s.slice(4, 6), 10) - 1,
    parseInt(s.slice(6, 8), 10),
  ));
}
