import type { MENU_ID, RESPONSE_SET, SHEETS } from './project-master.constants';

// 조회조건 6종 (CF-01~06 — 개요 B11:H18): Div 단일 필수(MyDivision) / 고객·Cell 유형·Biz Type·
//   개발 현황 = 멀티(빈 배열 = 'ALL' — UC-06 콤마 다중 계약) / 등록 완료일 From~To(yyyymmdd —
//   실필터 축 = REG_COMP_DATE, F-2 확정. 기본 M-1~Today).
//   ⭐ 조회조건 소비 = TAB2 전용 (F-3 — TAB1 SP 는 Session 4종만).
export interface SearchCondition {
  divisionId: string;
  endCustomers: string[]; // Multi — [] = 'ALL' (EndCustomerByDivision — 사업부 종속 CF-02)
  cellTypes: string[]; // Multi — lookup SPMS_CELL_TYPE (CF-03 — 설계 원문 비종속 F-17)
  bizTypes: string[]; // Multi — DmBizType (CF-04 — 조회조건은 설계서 기재, 그리드 셀만 BizTypeByDivision)
  developStatuses: string[]; // Multi — lookup SPMS_DPJT_DEVELOP_STATUS (CF-05)
  regCompDateFr: string; // yyyymmdd (필수 — 기본 M-1 시작, E01-2)
  regCompDateTo: string; // yyyymmdd (필수 — 기본 Today)
}

// GET 커서 row (procedures.d.ts SDM5010 등재 — & { CRUD_TYPE?: string } 자동 부여)
export type Tab1Row = ResponseData<MENU_ID, SHEETS.TAB1, RESPONSE_SET.DATA>;
export type Tab2Row = ResponseData<MENU_ID, SHEETS.TAB2, RESPONSE_SET.DATA>;
export type PeriodRow = ResponseData<MENU_ID, SHEETS.PERIOD, RESPONSE_SET.DATA>;

export interface ValidationResult {
  ok: boolean;
  msgId?: string;
  detail?: string;
}
