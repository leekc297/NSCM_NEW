// AS-IS DMF0020_SalesFuturePrice.cs expressions.md (2 SUM 헤더) + 동적 컬럼 / 머지 / Visible / EditFlag 7건 = 9건
//   E1, E2: SetSpreadHeaderSpan (L645/L673) — SUM Large/Small group header
//   E3:     SetSpreadColumn (L701, 706) — 동적 시간축 컬럼 AddNumColumn
//   E4:     cboBucketType_SelectedIndexChanged — W_/M_ Tag Visible Toggle
//   E5:     ColumnHeaderSpan(0) — YYYY-MM 머지 (Row 0)
//   E6:     ColumnHeaderSpan(1) — WEEK_NAME (Row 1)
//   E7:     allowMerging Cells + groupKeyOf 동시 선택
//   E8:     btnTemplate.Visible = (div==81) — ESS 사업부만 표시 (.cs L205, L2581)
//   E9:     DataModel.Changed → row.CRUD_TYPE='U' (FlexGrid cellEditEnded)

import { useMemo } from 'react';

import { BUCKET_TYPE, DIVISION } from '../sales-future-price.constants';
import type { SearchCondition, SpreadTitleDateRow } from '../sales-future-price.types';

// E8 — Division 별 표시 컬럼/버튼 권한
//   40 (Mobility): END_CUSTOMER40 사용 / btnTemplate 비표시
//   81 (ESS)     : PLANT_SITE_ID 표시 / NEW_FLAG 표시 / btnTemplate 표시
//   82 (Power)   : INCOTERMS/FCST/DOM_EXP/CURRENCY lock 별도 동작
export interface DivisionRole {
  isMobility: boolean;
  isEss: boolean;
  isPower: boolean;
  showPlantSite: boolean;
  showNewFlag: boolean;
  showTemplate: boolean;
  showEndCustomer40: boolean;
}

export const useDivisionRole = (divisionId: string): DivisionRole => useMemo(() => {
  const prefix = divisionId.slice(0, 2);
  const isEss = prefix === DIVISION.ESS;
  const isPower = divisionId === DIVISION.POWER;
  const isMobility = divisionId === DIVISION.MOBILITY;
  return {
    isMobility,
    isEss,
    isPower,
    showPlantSite: isEss,
    showNewFlag: isEss,
    showTemplate: isEss,  // AS-IS L205, L2581 — btnTemplate.Visible = (div==81)
    showEndCustomer40: isMobility,
  };
}, [divisionId]);

// E3, E4, E5, E6 — 동적 시간축 컬럼 + 3단 헤더 트리 (DMF0020_GET_SPREAD_TITLE_DATE 결과 기반)
//   AS-IS L701/L706 AddNumColumn + L712/L720/L726 ColumnHeaderSpan(0) + L731 ColumnHeaderSpan(1)
export interface HeaderDay {
  binding: string;     // W_20260511 or M_202605
  label: string;       // MMDD
}
export interface HeaderWeek {
  key: string;         // WEEK_NAME
  label: string;
  days: HeaderDay[];
}
export interface HeaderYearMonth {
  key: string;         // BASIS_YYYYMM
  label: string;       // YYYY-MM
  weeks: HeaderWeek[];
}

export const buildHeaderTree = (
  titleDate: SpreadTitleDateRow[] | undefined,
  bucketType: SearchCondition['bucketType'],
): HeaderYearMonth[] => {
  if (!titleDate || titleDate.length === 0) return [];

  const isWeekly = bucketType === BUCKET_TYPE.WEEKLY;

  // 1) bucketType 에 맞는 컬럼만 (E4 — W_/M_ Visible toggle)
  const filtered = titleDate.filter(t =>
    isWeekly ? t.BASIS_START_DATE2.startsWith('W_') : t.BASIS_START_DATE2.startsWith('M_'),
  );

  // 2) YYYY-MM 그룹 (E5) → WEEK_NAME (E6) → DAY 트리
  const ymMap = new Map<string, HeaderYearMonth>();
  for (const t of filtered) {
    const ymKey = t.BASIS_YYYYMM ?? '';
    const ymLabel = `${t.YER}-${t.MON}`;
    let ym = ymMap.get(ymKey);
    if (!ym) {
      ym = { key: ymKey, label: ymLabel, weeks: [] };
      ymMap.set(ymKey, ym);
    }
    const wKey = isWeekly ? (t.WEEK_NAME ?? '') : ymKey;
    let w = ym.weeks.find(x => x.key === wKey);
    if (!w) {
      w = { key: wKey, label: isWeekly ? (t.WEEK_NAME ?? '') : (t.MON ?? ''), days: [] };
      ym.weeks.push(w);
    }
    w.days.push({ binding: t.BASIS_START_DATE2, label: t.MMDD });
  }
  return Array.from(ymMap.values());
};
