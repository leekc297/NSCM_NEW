import type { BOH_RADIO, BUCKET_TYPE, MENU_ID, SHEETS } from './shipment-plan-electrode.constants';

// 시트별 행 타입 — 전역 ambient ResponseData<MENU_ID, SHEET, cursor> 로 유도(단일 cursor 'o_rc1').
//   미배포 MENU_ID 는 Base index-signature fallback 로 type-check 통과([[procedures-dts-base-index-fallback]]).
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN, 'o_rc1'>;
export type CalendarRow = ResponseData<MENU_ID, SHEETS.CALENDAR, 'o_rc1'>;
export type PlanDetailRow = ResponseData<MENU_ID, SHEETS.PLAN_DETAIL, 'o_rc1'>;
export type StockDetailRow = ResponseData<MENU_ID, SHEETS.STOCK_DETAIL, 'o_rc1'>;
export type ShipmentResultRow = ResponseData<MENU_ID, SHEETS.SHIPMENT_RESULT, 'o_rc1'>;
export type ExcelRow = ResponseData<MENU_ID, SHEETS.EXCEL, 'o_rc1'>;

// 하단 detail 3-sheet 전환 대상 (siSub 엑셀 양식은 업로드 전용이라 전환 목록 제외).
export type DetailSheet = SHEETS.PLAN_DETAIL | SHEETS.STOCK_DETAIL | SHEETS.SHIPMENT_RESULT;

// 활성 그리드 — Measure 설정/저장 라우팅 판정 (main pivot vs 하단 detail).
export type ActiveGrid = 'main' | 'detail';

// GET_SHEET_CALENDAR_3SPAN 이 공급하는 동적 기간칼럼 메타 (03 §2.2) — Wijmo 컬럼 재생성 입력.
export interface CalendarColumn {
  columnName: string; // [X_|Y_|Z_][D_|W_|M_]yyyyMMdd
  columnLabelName: string; // 일/주/월 leaf 라벨
  smallClassLabelName: string; // WEEK_NAME (중분류 머지헤더)
  largeClassLabelName: string; // MONTH_NAME (대분류 머지헤더)
  dayCode: string; // 요일코드(주말색 판정: 토=7 Blue / 일=1 Red 등)
  sortOrderNo: number; // ORDER BY 정렬키
}

// 조회조건 상태 (02 §3 cascade 원천값).
export interface SearchCondition {
  divisionId: string;
  companyId: string;
  fromSite: string[]; // clbFromSite 다중선택(체크리스트) — 미선택=전체. SP 전달 시 CSV join(02 §2-2 C20)
  planDateYyyymmdd: string; // 선택 Plan Date (yyyymmdd)
  isLatest: boolean; // 선택 Plan Date 가 최신(index0)인가 → realFlag/edit 가드
  bucketType: BUCKET_TYPE; // drpPeriod
  bohRadio: BOH_RADIO; // BOH 3-radio (span prefix 동시 선택)
  resultType: string[]; // clbResultType 다중선택(체크리스트) — shtShipmentResult 조회 Result Type. SP 전달 시 CSV join. 기본 P(Plan)+O(oWMS) 체크(AS-IS cs:914~915)
  chkSum: boolean; // SUM 칼럼 표시
  chkPastPeriod: boolean; // 과거기간(tag-date<planDate) 숨김
  periodFrom: string; // drpPeriod 시작(yyyymmdd)
  periodTo: string; // drpPeriod 종료(yyyymmdd)
  // 메인조회 SP(P_SSP0023_GET_SHIPMENT_PLAN) 검색 파라미터 (AS-IS FindData_Main cs:4639~4649).
  modelId: string; // txtModelId — P_MODEL_ID (저장 전 ToUpper)
  itemId: string; // txtItemId — P_ITEM_ID (btnItemId 팝업 결과)
  nickName: string; // textNickName — P_NICK_NAME (저장 전 ToUpper)
  chkMyModel: boolean; // chkMyModel — P_MY_MODEL_CHK (초기 auto-check R09)
  chkPartLeader: boolean; // chkPartLeader — P_PART_LEADER_CHK
  chkTeamLeader: boolean; // chkTeamLeader — P_TEAM_LEADER_CHK
  chkDelegateeModel: boolean; // chkDelegateeModel — P_DELEGATEE_CHK
  // 2차(상세행) 조회조건 — 하단 3-sheet 재검색용 (layoutControlGroup3, 02 §1-3). 1차와 독립 축.
  //   AS-IS FindData_Detail/Stock/Result(cs:5282~5486)가 각 상세 SP IN 으로 전달하는 컨트롤 값.
  detailModelId: string; // txtModel2 — P_MODEL_ID (PlanDetail, 저장 전 ToUpper)
  detailItemId: string; // txtItemId2 — P_ITEM_ID (btnItemId2 팝업 결과, 3-sheet 공통)
  detailNickName: string; // txtNickName2 — P_NICK_NAME (PlanDetail/StockDetail, 저장 전 ToUpper)
  detailLotId: string; // txtLotID — P_LOT_ID (StockDetail 전용)
  detailRequestor: string; // txtRequestor — P_REQUESTOR (PlanDetail, btnRequestor 팝업 결과 read-only)
  // drpPeriod2(PlanDetail)·drpPeriod3(ShipmentResult)는 AS-IS 상 별개 컨트롤로 초기값·보존이 독립.
  //   drpPeriod2: PlanDate 선택 시 from=당일 / to=기간종료.  drpPeriod3: from=오늘-9 / to=오늘-1 고정범위.
  planDetailShipFrom: string; // drpPeriod2 Text1 (yyyymmdd)
  planDetailShipTo: string; // drpPeriod2 Text2
  shipResultShipFrom: string; // drpPeriod3 Text1 (yyyymmdd)
  shipResultShipTo: string; // drpPeriod3 Text2
}

// detail bar 필드 표시 세트 (하단 시트별 조회조건 노출 제어, 03 §0).
//   각 상세 SP 가 받는 IN 집합(AS-IS FindData_Detail/Stock/Result)을 그대로 노출 플래그로 투영.
export interface DetailFieldSet {
  resultType: boolean; // clbResultType — ShipmentResult 만
  shipmentDate: boolean; // drpPeriod2/3 독립 기간 — PlanDetail/ShipmentResult (StockDetail 제외)
  newButton: boolean; // btnDetailInsert — PlanDetail 만
  model: boolean; // txtModel2 — PlanDetail 만
  material: boolean; // txtItemId2(+btnItemId2 팝업) — 3-sheet 공통
  nickName: boolean; // txtNickName2 — PlanDetail/StockDetail
  lotId: boolean; // txtLotID — StockDetail 만
  requestor: boolean; // txtRequestor(+btnRequestor 팝업) — PlanDetail 만
}
