import type { MENU_ID, SHEETS } from './shipment-request-pack.constants';

/** 조회조건 스토어 shape — design 02 §1/§5 TO-BE 매핑 그대로. */
export interface SearchParamProps {
  divisionId: string; // cboDivision — 고정값 "40", disabled
  teamIds: string[]; // clbTeam 다중(ALL)
  endCustomerIds: string[]; // clbCustomer 다중(ALL)
  salesSiteIds: string[]; // clbSalesSite 다중(ALL)
  plantSiteIds: string[]; // clbPlantSite 다중(ALL) — Division 1단 독립 cascade
  bucketType: 'Daily' | 'Weekly' | 'Monthly'; // cboBucketType — 초기값 Daily
  fromYyyymmdd: string; // drpPeriod From(메인 그리드 조회기간)
  toYyyymmdd: string; // drpPeriod To
  projectCode: string; // txtProject(팝업 SCM0002_ProjectbyDivisionPopupEx)
  modelId: string; // txtItemId(팝업 SSP0026_ItembyDivisionPopup, plantSite 기준)
  // 상세검색 서브패널(usrLayoutControl3, btnSearch 스코프 — spdDetail 전용)
  fromYyyymmdd2: string; // drpPeriod2 "Shipment Date"
  toYyyymmdd2: string;
  modelId2: string; // txtItemld2(팝업, salesSite 기준)
  nickName2: string; // textNickName2 — Request Detail 활성 시트에서만 노출(R15)
  lotId: string; // txtLotID — §2.9 dead parameter, AS-IS 그대로 미반영
  requestor: string; // txtRequestor.Text(이름 문자열 — ID 아님, §4.6 주의)
}

// 그리드 행 — procedures.d.ts(SSOT) 기반. PKG_SSP0026 핵심 조회/저장 SP 7건 미배포(goal.md ②)라
//   response 는 design 02/03 소비부 역산치이며 SP 실측 대사가 아니다(convert-sp 후속 재검증 필수).

/** spdMain "Pack Biz" 행 — 19 정적칼럼 + 동적 pivot(D_/W_/M_ × yyyyMMdd, index signature). */
export type PackRow = ResponseData<MENU_ID, SHEETS.PACK>;

/** spdMain "Cell Biz" 행 — 17 정적칼럼 + 동적 pivot, dtPgmAuthId 권한자만 탭 노출. */
export type CellRow = ResponseData<MENU_ID, SHEETS.CELL>;

/** spdDetail "Shipment Request Detail" 행 — 편집 대상(EditFlag 기준 화이트리스트). */
export type RequestDetailRow = ResponseData<MENU_ID, SHEETS.REQUEST_DETAIL>;

/** spdDetail "Shipment Result Detail" 행 — 읽기전용(Edit 진입 자체 차단, MSG00109). */
export type ResultDetailRow = ResponseData<MENU_ID, SHEETS.RESULT_DETAIL>;

/** spdSub "Shipment Request Detail Excel" 행 — 엑셀 폼다운로드 전용. */
export type RequestDetailExcelRow = ResponseData<MENU_ID, SHEETS.REQUEST_DETAIL_EXCEL>;

/** 동적 pivot 컬럼 태그 파싱 결과(constants DYNAMIC_COLUMN_TAG_PATTERN). */
export interface DynamicColumnTag {
  bucket: 'D' | 'W' | 'M';
  yyyymmdd: string;
}

/** 활성 그리드 — Save/btnMeasure 라우팅 기준(01_layout.md R12/R13). */
export type ActiveGrid = 'spdMain' | 'spdDetail' | null;

/** spdMain 활성 시트 — Pack Biz ↔ Cell Biz 토글(R14, 엑셀버튼·하단영역 연동). */
export type ActiveMainSheet = 'pack' | 'cell';

/** spdDetail 활성 시트 — Request ↔ Result Detail 토글(R15, 보조조건 4필드 연동). */
export type ActiveDetailSheet = 'requestDetail' | 'resultDetail';
