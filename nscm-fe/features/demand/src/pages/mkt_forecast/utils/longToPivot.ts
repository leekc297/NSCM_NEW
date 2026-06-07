import type { MktFcstRow } from '../mkt-forecast-master.types';

// SP DMF0003_GET_MKT_FCST_DATA 결과 = long format
// FE 측 wide format (PIVOT) 변환 — 동적 컬럼 D_/W_/M_YYYYMMDD 별 QTY 누적

type LongRow = {
  DIVISION_ID?: string;
  END_CUSTOMER?: string;
  SCM_SITE_ID?: string;
  PLANT_SITE_ID?: string;
  PROJECT_CODE?: string;
  PROJECT_CODE_NAME?: string;
  PROJECT_OWNER?: string;
  ITEM_ID?: string;
  NICK_NAME?: string;
  INCOTERMS?: string;
  FCST_TYPE?: string;
  DOM_EXP?: string;
  MEASURE?: string;
  YYYYMMDD?: string;
  QTY?: number;
  [key: string]: string | number | undefined;
};

// Group key — 9 unique key (사용자 명시 sort 일치)
// 같은 9-key combination 의 row 들이 같은 pivot row 로 묶이고 YYYYMMDD 별 QTY 가 bucket cell 에 채워짐
function getGroupKey(row: LongRow): string {
  return [
    row.DIVISION_ID ?? '',
    row.SCM_SITE_ID ?? '',
    row.PLANT_SITE_ID ?? '',
    row.PROJECT_CODE ?? '',
    row.ITEM_ID ?? '',
    row.DOM_EXP ?? '',
    row.FCST_TYPE ?? '',
    row.INCOTERMS ?? '',
    row.MEASURE ?? '',
  ].join('|');
}

// Bucket key (D_/W_/M_) 생성 — UTC 일관성
function getBucketKey(yyyymmdd: string, bucketType: 'D' | 'W' | 'M'): string {
  if (bucketType === 'D') return `D_${yyyymmdd}`;
  if (bucketType === 'M') return `M_${yyyymmdd.slice(0, 6)}`;

  // Weekly — 해당 주의 월요일 yyyymmdd
  const yyyy = parseInt(yyyymmdd.slice(0, 4), 10);
  const mm = parseInt(yyyymmdd.slice(4, 6), 10) - 1;
  const dd = parseInt(yyyymmdd.slice(6, 8), 10);
  const d = new Date(Date.UTC(yyyy, mm, dd));
  const dayOfWeek = d.getUTCDay();
  const mondayOffset = dayOfWeek === 0 ? -6 : 1 - dayOfWeek;
  d.setUTCDate(d.getUTCDate() + mondayOffset);
  const my = d.getUTCFullYear();
  const mmth = String(d.getUTCMonth() + 1).padStart(2, '0');
  const md = String(d.getUTCDate()).padStart(2, '0');
  return `W_${my}${mmth}${md}`;
}

// long → wide PIVOT
//   - 첫 row 메타 cols 명시적 복사 (DIVISION_ID, END_CUSTOMER 등 — 자동 spread 가 BE 측 case 변경 시 누락 회피)
//   - 같은 group 의 row 의 YYYYMMDD 별 QTY 를 bucket cell 에 누적
export function longToPivot(
  longRows: LongRow[],
  bucketType: 'D' | 'W' | 'M',
): MktFcstRow[] {
  const grouped = new Map<string, MktFcstRow>();

  for (const row of longRows) {
    const key = getGroupKey(row);
    let pivotRow = grouped.get(key);

    if (!pivotRow) {
      // 메타 cols 명시적 복사 — BE 측 column case 변경 시 누락 회피
      pivotRow = {
        DIVISION_ID: row.DIVISION_ID ?? '',
        END_CUSTOMER: row.END_CUSTOMER ?? '',
        SCM_SITE_ID: row.SCM_SITE_ID ?? '',
        PLANT_SITE_ID: row.PLANT_SITE_ID ?? '',
        PROJECT_CODE: row.PROJECT_CODE ?? '',
        PROJECT_CODE_NAME: row.PROJECT_CODE_NAME ?? '',
        PROJECT_OWNER: row.PROJECT_OWNER ?? '',
        ITEM_ID: row.ITEM_ID ?? '',
        NICK_NAME: row.NICK_NAME ?? '',
        INCOTERMS: row.INCOTERMS ?? '',
        FCST_TYPE: row.FCST_TYPE ?? '',
        DOM_EXP: row.DOM_EXP ?? '',
        MEASURE: row.MEASURE ?? '',
        // 나머지 cols 도 복사
        ...row,
      } as unknown as MktFcstRow;
      grouped.set(key, pivotRow);
    }

    if (row.YYYYMMDD && row.QTY !== undefined) {
      const bucketKey = getBucketKey(row.YYYYMMDD, bucketType);
      const existing = ((pivotRow as Record<string, unknown>)[bucketKey] as number | undefined) ?? 0;
      (pivotRow as Record<string, unknown>)[bucketKey] = existing + Number(row.QTY ?? 0);
    }
  }

  return Array.from(grouped.values());
}
