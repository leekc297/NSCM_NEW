import type { BUCKET_TYPE, MENU_ID, SHEETS } from './shipment-plan.constants';

// Main(PSI) 행 — 서버 wide pivot (base + D_/W_/M_ 동적 키)
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN, 'o_rc1'>;
// 3단 헤더 캘린더 메타 행
export type CalendarRow = ResponseData<MENU_ID, SHEETS.CALENDAR, 'o_rc1'>;
// Shipment Plan Detail 행
export type PlanDetailRow = ResponseData<MENU_ID, SHEETS.PLAN_DETAIL, 'o_rc1'>;
// Hold stock 행
export type HoldStockRow = ResponseData<MENU_ID, SHEETS.HOLD_STOCK, 'o_rc1'>;

// 조회조건 (usrLayoutControl2 1차 + usrLayoutControl3 2차 — design 02 §1 20건)
export interface SearchCondition {
  divisionId: string; // clbDivision_ID (단일, 자동선택 없음 — 02 §4.3)
  companyId: string; // clbCompany_ID (단일, sUserCompany_NM 매칭 기본값)
  plantSiteIds: string[]; // clbPlantSite (다중)
  model: string; // txtModel2 (2차 Detail bar Model, 팝업 btnItemID2 — 01 §1 좌표 실측)
  bucketType: BUCKET_TYPE; // cboBucketType
  chkSum: boolean; // chkSum (W_/M_ Sum 컬럼 표시)
  chkTotPsi: boolean; // chkTotPSI (SEQ<12/21 행 필터 + 재조회)
  planDate: string; // cboPlanDate CODE(yyyymmdd)
  periodFrom: string; // drpPeriod (표시전용 — planDate 파생 FROM_DATE)
  periodTo: string; // drpPeriod (TO_DATE1)
  period2From: string; // drpPeriod2 (편집 — drpPeriod 범위로 무메시지 clamp, buttonGuard #37)
  period2To: string;
  itemId: string; // txtItemId (1차 row2 Model, 팝업 btnItemId — Main 조회 P_ITEM_ID)
  productLevel11: string[]; // clbProductLevel11 (row1)
  productLevel12: string[]; // clbProductLevel12 (row2, 동일 결과셋 재사용)
  requestorId: string; // txtRequestor 대응 코드(UserInfoPopup 반환 UserID — 저장/조회 파라미터)
  requestorName: string; // txtRequestor 표시명(세션 언어별)
  resultTypes: string[]; // clbResultType (Shipment Result 전용)
  period3From: string; // drpPeriod3 (Shipment Date — 기본 오늘-9~오늘-1)
  period3To: string;
  boxId: string; // txtBoxID (MES Stock Detail 전용)
}

// 활성 그리드 포인터 (AS-IS fps — sticky, 01 R5)
export type ActiveGrid = 'main' | 'detail';

// Main BOH_QTY 더블클릭 드릴다운 파라미터 (03 §3-D)
export interface DrilldownParams {
  sheet: SHEETS;
  itemId: string;
  fromSite: string;
}
