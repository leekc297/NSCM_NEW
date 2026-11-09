import type { MENU_ID, SHEETS } from './shipment-request-electrode.constants';

/** 조회조건 스토어 shape — design 02 §1/§5 TO-BE 매핑 그대로. */
export interface SearchParamProps {
  divisionId: string;
  companyId: string;
  plantSiteIds: string[]; // clbPlantSite 다중(체크리스트) — 전체선택 시 'ALL'
  planDate: string; // cboPlanDate 선택 CODE(PLAN_START_YYYYMMDD)
  bucketType: 'D' | 'W' | 'M'; // cboBucketType (BUCKET_TYPE) — Daily/Weekly/Monthly
  cellTypes: string[]; // clbCellType 다중
  myModelChk: boolean;
  partLeaderChk: boolean;
  teamLeaderChk: boolean;
  delegateModelChk: boolean;
  modelId: string; // txtModelId(1차, FindData_Main 전용)
  itemId: string; // txtItemId(1차)
  nickName: string; // textNickName(1차)
  fromYyyymmdd: string; // drpPeriod From
  toYyyymmdd: string; // drpPeriod To
  // 2차 조회조건(usrLayoutControl3, btnSearch 스코프 — 상세/재고 그리드 전용)
  modelId2: string;
  itemId2: string;
  nickName2: string;
  requestor: string;
  lotId: string;
  fromYyyymmdd2: string;
  toYyyymmdd2: string;
  // 그리드 토글(조회조건 아님 — SearchArea 밖 배치, design 02 §5)
  pastPeriodChecked: boolean; // chkPastPeriod
  sumChecked: boolean; // chkSum
}

// 그리드 행 — procedures.d.ts(SSOT) 기반(shipment-master-electrode MainRow 선례 1:1). PKG_SSP0022
//   미배포(design 00 §0)라 generated response 는 design 02/03 소비부 역산치이나, 타입 SSOT 는
//   procedures.d.ts 하나로 유지한다(중복 인터페이스 금지 — WijmoRowItem 제약도 여기서 자동 만족).

/** siMain(spdMain) 행 — 34 정적칼럼 + 동적 pivot 칼럼(X_/Y_/Z_ × D_/W_/M_ × yyyyMMdd, index signature). */
export type ShipmentPsiRow = ResponseData<MENU_ID, SHEETS.MAIN>;

/** siDetail.shtRequestDetail 행 — 31칼럼, 유일한 편집 대상. */
export type RequestDetailRow = ResponseData<MENU_ID, SHEETS.REQUEST_DETAIL>;

/** siDetail.shtStockDetail 행 — 29칼럼, 읽기전용. */
export type StockDetailRow = ResponseData<MENU_ID, SHEETS.STOCK_DETAIL>;

/** siSub.shtRequestDetail_Excel 행 — 9칼럼, 다운로드 전용(편집 UI 없음). */
export type RequestDetailExcelRow = ResponseData<MENU_ID, SHEETS.REQUEST_DETAIL_EXCEL>;

/** SSP0022_BodItemPopup 원천 행(P_SSP0022_GET_ITEM_POPUP) — ITEM_ID 더블클릭/붙여넣기 팝업(design 01 §5b#1,#15). */
export type BodItemPopupRow = ResponseData<MENU_ID, SHEETS.BOD_ITEM_POPUP>;

/** 동적 pivot 컬럼 태그 파싱 결과(design 03 §2.2 정규식). */
export interface DynamicColumnTag {
  bohMode: 'X' | 'Y' | 'Z';
  bucket: 'D' | 'W' | 'M';
  yyyymmdd: string;
}
