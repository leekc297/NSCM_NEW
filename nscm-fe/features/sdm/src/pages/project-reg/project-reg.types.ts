import type { MENU_ID, RESPONSE_SET, SHEETS } from './project-reg.constants';

// 조회조건 (TAB2 전용 폼) — Division*(Single)/고객/나의 권한/등록 상태/등록 완료일(From~To yyyymmdd).
//   ⭐ 신본 §5 는 등호 매칭 + 'ALL' 센티널 (콤마 다중 불가) → 콤보 3종은 단일 선택('ALL' 기본).
//   기간 기본값 = period 시트(§15 GET_PERIOD) — 둘 다 채우거나 둘 다 빈 값(전체 — 미완료 포함) 계약.
export interface SearchCondition {
  divisionId: string;
  endCustomer: string; // 'ALL' 또는 단일 코드 (§5 = 값 OR 'ALL')
  dpjtAuthType: string; // 'ALL'/ADMIN/WRITE/READ
  dpjtRegStatus: string; // 'ALL'/DRAFT/WRITING/WAITING/COMPLETE/REJECT
  regCompDateFr: string; // yyyymmdd ('' 허용 — 단 한쪽만 빈 값 금지)
  regCompDateTo: string; // yyyymmdd
}

// SP 커서 row (procedures.d.ts SDM1010 등재 — & { CRUD_TYPE?: string } 자동 부여)
export type Tab1Row = ResponseData<MENU_ID, SHEETS.TAB1, RESPONSE_SET.DATA>;
export type Tab2Row = ResponseData<MENU_ID, SHEETS.TAB2, RESPONSE_SET.DATA>;
export type OrgTreeRow = ResponseData<MENU_ID, SHEETS.POP1_TREE, RESPONSE_SET.DATA>;
export type Pop1UserRow = ResponseData<MENU_ID, SHEETS.POP1_GRID1, RESPONSE_SET.DATA>;
// §8/§9 동형 커서 — 입력(GRID2)/조회(GRID3) 리스트 공용 행 타입
export type Pop1AuthRow = ResponseData<MENU_ID, SHEETS.POP1_GRID2, RESPONSE_SET.DATA>;
export type Pop1ReqRow = ResponseData<MENU_ID, SHEETS.POP1_GRID4, RESPONSE_SET.DATA>;
export type MyWorkRow = ResponseData<MENU_ID, SHEETS.POP2_GRID5, RESPONSE_SET.DATA>;
export type PeriodRow = ResponseData<MENU_ID, SHEETS.PERIOD, RESPONSE_SET.DATA>;

// 권한관리 모달 대상 (TAB1 행에서 추출 — 신규 미저장 행은 진입 차단 P-31)
export interface AuthRegTarget {
  dpjtKey: string;
  dpjtName: string;
}

// MY_WORK 모달 대상
export interface MyWorkTarget {
  dpjtKey: string;
}

export interface ValidationResult {
  ok: boolean;
  msgId?: string;
  detail?: string;
}
