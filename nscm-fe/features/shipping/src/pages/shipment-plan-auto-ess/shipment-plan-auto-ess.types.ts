import type { BUCKET_TYPE, MENU_ID, SHEETS } from './shipment-plan-auto-ess.constants';

// Main(PSI) 행 — 서버 wide pivot (base + D_/W_/M_ 동적 키)
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN, 'o_rc1'>;
// 3단 헤더 캘린더 메타 행
export type CalendarRow = ResponseData<MENU_ID, SHEETS.CALENDAR, 'o_rc1'>;
// Shipment Plan Detail 행
export type PlanDetailRow = ResponseData<MENU_ID, SHEETS.PLAN_DETAIL, 'o_rc1'>;

// 조회조건 (usrLayoutControl2 1차 + usrLayoutControl3 2차 — design 02 §1)
export interface SearchCondition {
  divisionId: string; // clbDivision_ID (단일, 자동선택 없음 — 02 §4.3)
  companyId: string; // clbCompany_ID (단일, 세션 사용자 company 기본값)
  plantSiteIds: string[]; // clbPlantSite (다중, From Site)
  model: string; // txtModel2 (2차 Detail bar Model, 팝업 btnItemID2 — 01 §1)
  bucketType: BUCKET_TYPE; // cboBucketType
  chkSum: boolean; // chkSum (W_/M_ Sum 컬럼 표시)
  planDate: string; // cboPlanDate CODE(yyyymmdd)
  periodFrom: string; // drpPeriod (표시전용 — planDate 파생 FROM_DATE)
  periodTo: string; // drpPeriod (TO_DATE1)
  period2From: string; // drpPeriod2 (Shipment Date, PlanDetail 전용 — 범위 이탈 무메시지 clamp, 02 §3 #37)
  period2To: string;
  itemId: string; // txtItemId (1차 Model, 팝업 btnItemId — Main 조회 P_ITEM_ID)
  requestorId: string; // txtRequestor 대응 코드(UserInfoPopup 반환 UserID)
  requestorName: string; // txtRequestor 표시명(세션 언어별)
  resultTypes: string[]; // clbResultType (Shipment Result 전용)
  period3From: string; // drpPeriod3 (Shipment Date — 기본 오늘-9~오늘-1)
  period3To: string;
  boxId: string; // txtBoxID (MES Stock Detail 전용)
}

// 활성 그리드 포인터 (AS-IS fps — 01 R5)
export type ActiveGrid = 'main' | 'detail';
