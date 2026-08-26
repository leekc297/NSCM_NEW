import type { MENU_ID, RESPONSE_SET, SHEETS } from './project-list.constants';

// 조회조건 5종 (CF-01~05 — 개요 B11:H17): Div 단일 필수 / 고객·나의 권한·등록 상태 = 멀티(빈 배열 = ALL) /
//   등록 완료일 From~To 필수(yyyymmdd — P-10). SP 전달은 store setFilter 가 콤마 연결·'YYYY-MM-DD' 변환.
export interface SearchCondition {
  divisionId: string;
  endCustomers: string[]; // Multi — [] = 'ALL' (UC-06 콤마 다중 계약)
  dpjtAuthTypes: string[]; // Multi — lookup SPMS_DPJT_AUTH_TYPE
  dpjtRegStatuses: string[]; // Multi — lookup SPMS_DPJT_REG_STATUS
  regCompDateFr: string; // yyyymmdd (필수 — 기본 M-1)
  regCompDateTo: string; // yyyymmdd (필수 — 기본 Today)
}

// GET 커서 row (procedures.d.ts SDM1020 등재 — & { CRUD_TYPE?: string } 자동 부여)
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN, RESPONSE_SET.DATA>;

// 권한요청 체크박스 서버 원본 스냅샷 (P-12 취소 경로 판정 — 토글 최초 1회 기록, 재조회 시 폐기)
export interface ReqCheckOrigin {
  write: string;
  read: string;
}

export interface ValidationResult {
  ok: boolean;
  msgId?: string;
  detail?: string;
}
