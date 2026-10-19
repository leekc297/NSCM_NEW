import type { BUCKET_TYPE, MENU_ID, SHEETS } from './shipment-plan-mobility-it.constants';

// master(PSI) 행 — 서버 wide pivot (base 프레임 + D_/W_/M_/B_ 동적 키)
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN, 'o_rc1'>;
// 3단 헤더 캘린더 메타 행
export type CalendarRow = ResponseData<MENU_ID, SHEETS.CALENDAR, 'o_rc1'>;
// Shipment Confirm Detail(shtDetail) 행
export type ConfirmDetailRow = ResponseData<MENU_ID, SHEETS.CONFIRM_DETAIL, 'o_rc1'>;
// Hold stock 행
export type HoldStockRow = ResponseData<MENU_ID, SHEETS.HOLD_STOCK, 'o_rc1'>;

// 활성 master 시트 — Plant Site/PlanDate/ResultType cascade 트리거(searchParams 바깥, design 02 §3).
export type MainSheet = 'main' | 'packer';
// 활성 그리드 포인터 (AS-IS fps — Save/Insert/Measure 라우팅용)
export type ActiveGrid = 'main' | 'detail';

// 조회조건 (usrLayoutControl2 1차 + usrLayoutControl3 2차 — design 02 §1 21행)
export interface SearchCondition {
  // Division 은 상수 FIXED_DIVISION('40'). 검색 파라미터 전달용으로만 보관.
  plantSiteIds: string[]; // clbPlantSite (다중, 활성시트별 comboId 스왑)
  bucketType: BUCKET_TYPE; // cboBucketType
  chkSum: boolean; // chkSum (W_/M_ Sum 컬럼 표시)
  planDate: string; // cboPlanDate CODE(yyyymmdd)
  periodFrom: string; // drpPeriod (GetDayRange 파생)
  periodTo: string;
  period2From: string; // drpPeriod2 (detail)
  period2To: string;
  period3From: string; // drpPeriod3 (ShipmentResult — 오늘-9~오늘-1)
  period3To: string;
  itemId: string; // txtItemId (1차 Item, 팝업 btnItemId)
  model: string; // txtModel2 (2차 detail Model, 팝업 btnItemID2)
  lotId: string; // txtLotID
  requestorId: string; // txtRequestor UserID (UserInfoPopup 반환)
  requestorName: string; // txtRequestor 표시명
  resultTypes: string[]; // clbResultType (시트별 클라 행제거)
  // 모델 필터 체크박스 4종 → 검색 SP p_*Chk(Y/N)
  chkMyModel: boolean;
  chkPartLeader: boolean;
  chkTeamLeader: boolean;
  chkDelegateeModel: boolean;
}
