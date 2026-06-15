import type { MktFcstRow } from '../mkt-forecast-master.types';

// PIVOT row (wide format) → SP P_SAVE 호출용 long format 변환
// AS-IS DMF0003_SAVE_MKT_FCST 호출 시 row 별 YYYYMMDD + QTY 쌍으로 펼침
//
// 각 PIVOT row (D_/W_/M_YYYYMMDD column 다수) → 각 cell 의 YYYYMMDD + QTY 로 펼침

interface LongOutputRow {
  yyyymmdd: string;
  qty: number;
  // 메타 cols 그대로 전달
  DIVISION_ID: string;
  PROJECT_CODE: string;
  SCM_SITE_ID: string;
  PLANT_SITE_ID: string;
  ITEM_ID: string;
  DOM_EXP: string;
  FCST_TYPE: string;
  INCOTERMS: string;
  MEASURE: string;
}

// Bucket key (D_/W_/M_YYYYMMDD) 에서 YYYYMMDD 추출
const bucketKeyToYyyymmdd = (key: string): string => {
  if (key.startsWith('D_') || key.startsWith('W_')) {
    return key.slice(2);
  }
  if (key.startsWith('M_')) {
    return `${key.slice(2)}01`; // M_YYYYMM → YYYYMM01
  }
  return '';
};

// wide row → long format (cellEditEnded 시 modified bucket cell 만 추출)
export const wideToLong = (row: MktFcstRow): LongOutputRow[] => {
  const result: LongOutputRow[] = [];

  // bucket cell key 추출 (D_/W_/M_YYYYMMDD 형식)
  const bucketKeys = Object.keys(row).filter(k => /^[DWM]_\d{6,8}$/.test(k));

  for (const k of bucketKeys) {
    const qty = row[k];
    if (qty === undefined || qty === '' || qty === null) continue;

    const yyyymmdd = bucketKeyToYyyymmdd(k);
    if (!yyyymmdd) continue;

    result.push({
      yyyymmdd,
      qty: Number(qty ?? 0),
      DIVISION_ID: String(row.DIVISION_ID ?? ''),
      PROJECT_CODE: String(row.PROJECT_CODE ?? ''),
      SCM_SITE_ID: String(row.SCM_SITE_ID ?? ''),
      PLANT_SITE_ID: String(row.PLANT_SITE_ID ?? ''),
      ITEM_ID: String(row.ITEM_ID ?? ''),
      DOM_EXP: String(row.DOM_EXP ?? ''),
      FCST_TYPE: String(row.FCST_TYPE ?? ''),
      INCOTERMS: String(row.INCOTERMS ?? ''),
      MEASURE: String(row.MEASURE ?? ''),
    });
  }

  return result;
};
