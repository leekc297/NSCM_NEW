import type { MENU_ID, SHEETS } from './shipment-change-history.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. GET SP Table[0] 반환 47컬럼(design 03 §1/§4.1).
//   SSP0019 는 generated procedures.d.ts 에 아직 없어(PKG_SSP0019 미배포) Base index-signature 로 loose
//   해석된다(자매 SCP0033/SSP0012 와 동일 — 생성 SSOT 파일은 건드리지 않는다, convert-core §2.2 Hard Boundary /
//   메모리 procedures-dts-base-index-fallback: 미배포 MENU_ID 는 type-check 통과, 오탐 아님).
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// 조회조건 (Form 입력 상태 — design 02 §1, 10조건):
//   Division/FromSite/ToSite/Incoterms/TransMode(다중) + ShipmentDate(range) + Model/SoNo/ConfirmId(텍스트) + Current(토글).
//   cascade 1단계(Division->4자식, 재조회 방식, EE 조건분기). 필수 조회조건 = 기간(Check_PeriodDate, design 02 §4).
export interface SearchCondition {
  divisionIds: string[]; // clbDivision 다중 (MyDivisionInEE_SCP + FE code!=='EE' 필터). 콤마 join
  fromSiteIds: string[]; // clbFromSite 다중 (EE 분기 동적 comboId)
  toSiteIds: string[]; // clbToSite 다중 (EE 분기 동적 comboId)
  incoterms: string[]; // clbIncomterms 다중 (ssp0019_Incoterms_SCP)
  transModes: string[]; // clbTransportMode 다중 (ssp0019_TransportMode_SCP)
  fromDate: string; // drpPeriod From (YYYYMMDD). 기본 오늘 기준 1개월
  toDate: string; // drpPeriod To (YYYYMMDD)
  itemId: string; // txtItemId 텍스트 (Model, 콤마 다중입력 + 팝업 채움)
  soNo: string; // txtSoNo 텍스트 (콤마 다중입력)
  confirmId: string; // txtConfirmId 텍스트 (콤마 다중입력)
  chkCurrent: boolean; // Current 체크박스 — 그리드 행표시 토글(클라, 서버 재조회 없음)
}

// SCM0002 Item by Division 팝업 반환 행 (design 02 §4.6 — Model 선택). ItemID -> Model 텍스트.
export interface PopupRow {
  ITEM_ID?: string;
  NICK_NAME?: string;
  MODEL_ID?: string;
  DIVISION_ID?: string;
}
