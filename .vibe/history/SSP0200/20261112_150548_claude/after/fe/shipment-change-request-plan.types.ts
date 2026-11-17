import type { MENU_ID, SHEETS } from './shipment-change-request-plan.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반.
//   SSP0200 은 SCM_ADM_MNU_BTN_MPG_M 0행이라 생성 SSOT 에 아직 항목이 없다 -> Base index-signature 로
//   loose 해석된다(메모리 procedures-dts-base-index-fallback — 결함 아님). 05_register.sql 적용 후
//   SSOT 재생성 시 정밀 타입이 붙는다. 생성 파일은 직접 수정하지 않는다(convert-core §2.2).
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;
export type SubRow = ResponseData<MENU_ID, SHEETS.SUB>;

// 조회조건 9필드 (design 02 §1 — 필수표시 0건. AS-IS 라벨에 '*' 가 없다).
export interface SearchCondition {
  divisionId: string; // 단일, ALL 없음. 기본 = 목록 첫 행
  fromSiteIds: string[]; // 다중 + ALL
  toSiteIds: string[]; // 다중 + ALL
  status: string; // 단일 + ALL 선두, P 제외. 기본 ALL
  fromYyyymmdd: string; // Shipment Date from (SCM0001_SCP_DAY_PERIOD_GET)
  toYyyymmdd: string; // Shipment Date to
  itemId: string; // Model 다건 — 원천은 txtRequest(txtItemId 아님, F1 dead)
  erpSoNo: string; // SO No 다건
  confirmId: string; // Confirm Id 다건
  changeType: string; // AS-IS 영구 비노출(Δ1) + 'C' 고정(Δ2). 노출 배치는 04 확인필요
}

// 요청정보 폼 (design 01 §1.2 — 필수 4항목이 Request Complete 검증 대상).
//   Request No 는 런타임 상시 숨김(cs:459)이나 값은 후속 저장/삭제 payload 에 필요해 store 보관한다.
export interface RequestInfo {
  requestNo: string;
  requestor: string; // 세션 사용자명(언어별) — 읽기전용
  requestDeptName: string; // 세션 부서명 — 읽기전용
  requestDeptId: string;
  approval: string; // Approval* — 팝업 선택 또는 조회 o_rc2 자동채움(L-152)
  approvalId: string;
  appDeptName: string; // 승인부서명 — 읽기전용 파생
  appDeptId: string;
  title: string; // Title*
  changeReason: string; // Change Reason*
  reasonDetail: string; // Reason Detail*
}

// 조회 SP 2번째 커서(o_rc2) 1행 — 요청자/승인자 기본값 공급원(design 03 §4.3).
export interface RequestorRow {
  USER_ID?: string;
  USER_NAME?: string;
  USER_NAME_EN?: string;
  DEPT_ID?: string;
  DEPT_NAME_KO?: string;
  DEPT_NAME_EN?: string;
  [key: string]: unknown;
}

// 조회조건 콤보/lookup 공용 옵션.
export interface ComboOption {
  label: string;
  value: string;
}
