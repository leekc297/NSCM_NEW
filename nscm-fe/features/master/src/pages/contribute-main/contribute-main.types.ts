/**
 * DMF0043 Contribute_Main — 타입 정의
 */
import type { EDIT_FLAG } from './contribute-main.constants';

export type EditFlag = (typeof EDIT_FLAG)[keyof typeof EDIT_FLAG];

/**
 * 메인 그리드 행 — AS-IS spdMain ContributeMain sheet
 *
 * 데이터 형식: **long-format** (PivotGrid 가 client-side 에서 PIVOT 수행 — 룰 27 §C).
 * SP `P_DMF0043_GET_CONTRIBUTE_MAIN_DATA` (standalone stub, 2026-05-29 임시) 가 반환.
 * AS-IS DM_MST_CONTRIBUTE_RATIO_DTL JOIN DM_MST_CONTRIBUTE_VER + SCM_MST_DIVISION + SCM_MST_CUSTOMER.
 *
 * 6개 고정 컬럼 (AS-IS .cs DefColumns): 부문 / 팀 / 고객군 / 판매처 / 제품군 / 형태
 * PIVOT 2단: 대상년월 (상) × 해외법인 (하), 값 SUM(CONTRIBUTION_RATIO)
 */
export interface ContributeMainRow {
  /* AS-IS SP wide-format (PIVOT 결과) — BE 가 6개 고정 분류 키 + 동적 PIVOT 컬럼 ("M#YYYYMM#OS_CORP_CD") 반환.
     FE 는 첫 row 의 keys 로 PIVOT 컬럼 동적 생성 (AS-IS CreateSheetHeaderColumn 동등). */
  DIVISION_ID?: string;          // SITE_ITEM.DIVISION_ID (사업부 short code '40')
  DIVISION_NM?: string;          // SCM_MST_DIVISION.DIVISION_NAME
  DEPARTMENT_ID?: string;        // 부문급 부서 (TEAM.UPPER_DEPT_ID, SSO 8자리)
  DEPARTMENT_NM?: string;        // 부문급 부서명
  DEPT_ID?: string;              // 부서 (TEAM.DEPT_ID)
  DEPT_NM?: string;              // 부서명
  END_CUST_REPORT?: string;      // 고객군 (CUST_GROUP)
  SOLDTO_CUST_REPORT?: string;   // 판매처 (CUST_GROUP_DTL)
  SOLDTO_CUST_REPORT_NM?: string; // 판매처 라벨 (SCM_MST_CUSTOMER.SOLDTO_DESCRIPTION)
  PRODUCT_GROUP?: string;        // 제품군 (FORECAST_INFO_PRODUCT_GROUP)
  DM_BIZ_TYPE?: string;          // 형태 (FORECAST_INFO_BIZ_TYPE)
  EDIT_FLAG?: EditFlag;
  DISCARD?: 'Y' | 'N';
  CRUD_TYPE?: 'C' | 'U' | 'D';
  /* 동적 PIVOT 컬럼 — "M#YYYYMM#OS_CORP_CD": number (CONTRIBUTION_RATIO) */
  [key: string]: unknown;
}

/** 조회조건 — yearId 는 AS-IS usrYear.SelectedValue 인 VER_SEQ (DM_MST_CONTRIBUTE_VER.VER_SEQ) */
export interface ContributeMainSearchParams {
  yearId: string;              // = VER_SEQ (콤보 옵션 NAME2 = "YYYY(VERSION_NM)")
  isYearByYear: boolean;       // chkYear
  isMismatch: boolean;          // usrDiscard
  isHistory: boolean;           // usrHis
}

/** ContributeRate 모달 행 */
export interface ContributeRateRow {
  EDIT_FLAG?: EditFlag;
  VER_SEQ?: string;
  YYYY?: string;
  VERSION_NM?: string;
  VALID_YN?: 'Y' | 'N';
  DESCRIPTION?: string;
  CRUD_TYPE?: 'C' | 'U' | 'D';
}
