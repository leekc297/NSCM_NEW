/**
 * AS From Site 컬럼 편집 활성 판정 (통합테스트 1st No.63 ①②)
 *
 * AS-IS `DMF0003_MktFcst.cs` [E20260211-001189] 계약 1:1 이식.
 *   - Sales Site 변경 핸들러 : L3444~3510
 *   - FCST Type 변경 핸들러  : L3556~3600
 *
 * 세 축이 **모두** 성립할 때만 활성이다.
 *   ① division 이 `81*` 또는 `82`            (.cs L3445 `Substring(0,2)=="81" || =="82"`)
 *   ② Sales Site 가 **AS(비축)향이 아님**     (.cs `dtAsSalesSite.Select("Name = '<SCM_SITE_ID>'")` 미매칭)
 *   ③ FCST Type 이 **W/S 계열**              (.cs `GetLookupValues("FCST_TYPE","DM Planner (W/S)")`
 *                                            = `UP_FX_GetCommonDataList_DM` L72~79 = `SALES_TYPE_CODE2`)
 *
 * ⚠ AS-IS Paste 경로(.cs L6530)만 기준 목록이 `EDIT_MODE`(= SALES_TYPE_CODE2 ∪ SALES_TYPE_CODE2_ADD,
 *   Recall·RMA 2종 추가)로 더 넓다. TO-BE 는 beginningEdit/pastingCell 이 한 핸들러를 공유하므로
 *   **셀 입력 경로 기준(4종)** 을 채택한다 — 요구 원문(No.63)이 셀 입력 시나리오다.
 */
export interface AsFromSiteRow {
  DIVISION_ID?: unknown;
  SCM_SITE_ID?: unknown;
  FCST_TYPE?: unknown;
}

export interface AsFromSiteContext {
  /** `AS_FROM_SITE` 콤보의 NAME 집합 (= AS(비축)향 사이트 명). AS-IS 는 NAME 만 대조한다. */
  asSiteNames: ReadonlySet<string>;
  /** `FcstTypeWs` 콤보의 CODE 집합 (SALES_TYPE_CODE2 = WS/WSF/AS/ASF). */
  wsFcstTypes: ReadonlySet<string>;
  /** 행에 DIVISION_ID 가 없을 때 쓰는 조회조건 division. */
  fallbackDivisionId?: string;
}

/** 원시값만 채택 — 객체는 빈 문자열로 관대 통과 (`comboCellStr` 와 동일 규약). */
const str = (v: unknown): string =>
  typeof v === 'string' ? v.trim() : typeof v === 'number' ? String(v) : '';

export const isAsFromSiteEditable = (row: AsFromSiteRow, ctx: AsFromSiteContext): boolean => {
  const div = str(row.DIVISION_ID) || str(ctx.fallbackDivisionId);
  if (!(div.startsWith('81') || div === '82')) return false; // ①
  const site = str(row.SCM_SITE_ID);
  if (site && ctx.asSiteNames.has(site)) return false; // ② 비축향 → 비활성
  const fcstType = str(row.FCST_TYPE);
  return !!fcstType && ctx.wsFcstTypes.has(fcstType); // ③ 고객향 + W/S 계열만 활성
};
