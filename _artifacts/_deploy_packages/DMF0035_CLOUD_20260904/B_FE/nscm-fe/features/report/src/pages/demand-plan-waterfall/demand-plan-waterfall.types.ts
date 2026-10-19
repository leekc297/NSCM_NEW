import type { Gubun } from './demand-plan-waterfall.constants';

/**
 * 3 GUBUN 조회조건 합집합 — GUBUN별 표시/전달 여부는 통합분석 MD §4.3 설계표 준수.
 * 멀티 항목은 카탈로그 필드(@master searchFields) 규약대로 string[] 보관,
 * SP 전달 시 'ALL'/콤마 변환(빈 배열='ALL' — 빈 문자열 전달 시 SP DELETE 전멸 함정).
 */
export interface SearchParams {
  gubun: Gubun;
  divisionId: string;
  deptIds: string[];
  endCustomers: string[];
  salesSiteIds: string[];
  plantSiteIds: string[];
  bizTypes: string[];
  itemTypes: string[];
  projectCodes: string[];
  itemIds: string[];
  owners: string[];
  /** MKT=versionNo(''=CURRENT, 비필수) / SALES·BIZ=versionType(필수) — CSV */
  version: string;
  /** AS-IS PR_GET_DAY_RANGE(6개월) 기본 — 당월 1일 ~ +6개월 말일 */
  startYyyymmdd: string;
  endYyyymmdd: string;
  bucket: string;
  /** MKT 전용 — div '81' 정확일치 시만 활성 (AS-IS .cs:350-359) */
  senderCodes: string[];
  isSumChecked: boolean;
  /** MKT·BIZ — div40 만 활성. SALES 는 AS-IS Visible=false 라 미표시('N' 고정) */
  isCellQtyChecked: boolean;
  /** BIZ 전용 — p_qty_yn */
  isQtyNotZeroChecked: boolean;
  /** 클라이언트 표시 환산 배수 (CODE=배수 '1'/'1000'/'1000000'/'100000000') */
  krw: string;
  usd: string;
  loc: string;
  qty: string;
}
