export const MENU_ID = 'SCP0129' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Master.UIL SCP0129_DemandException (단일 FpSpread spdMain, 단일 SheetView):
//   설계 근거: .atlas/gscm-design/SCP0129/design/00_checklist.md ~ 03_grid-columns.md,
//   convert-flow/goal.md·plan.md
//   - GET SP  : SCP0129_GET_DEMAND_EXCEPTION (16컬럼) — PKG_SCP0129 미배포(convert-sp 후속)
//   - SAVE SP : SCP0129_SAVE_DEMAND_EXCEPTION (현재값 9 + user 1 + PRE_* 7 = 19파라미터,
//     surrogate PK 없는 복합키 UPDATE 패턴) — 미배포
//   - 조회조건 8개 중 Division 만 데이터소스 확정. Site/PlanGroup/Stage/ValidYn 4개는 AS-IS 원본
//     소스·AS-IS DB 둘 다 확보 실패로 데이터소스 미확정 — UI 골격만 노출(SafetyStock(SCP0128)
//     선례와 동일 처리, __asis-mapping__.md 참조).
export enum SHEETS {
  MAIN = 'main',
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

/**
 * 조회조건 콤보 SQL_ID — design/02_search-combo.md §2·§5 실측 확정분만 배선한다.
 *
 * DIVISION: SP직접 SQL_ID, AS-IS `BLUtils.GetDivision(false,"")` ↔ SCP0122 선례로 확정(§2-1,
 *   EE 포함 유지 — WithoutEE 아님).
 * Site/PlanGroup/Stage/ValidYn: design/02_search-combo.md §2-2~2-5 전부 "확인 필요"(dtScmSiteAll/
 *   dtPlanGroupAll/dtStageAll/cboValid 최초 공급원 미확정 — AS-IS `.cs` 원본·AS-IS MSSQL 둘 다
 *   이 세션에서 확보 실패). convert-core §2.3 준수 — 확인 없이 임의 comboId 배선 금지. 데이터소스
 *   확정 전까지 UI 골격만 노출(SafetyStockForm 선례와 동일).
 */
export const COMBO = {
  DIVISION: 'Division_SCP',
  VALID: 'YesOrNo', // 그리드 셀 STOCK_EXCEPTION 콤보와 동일 SQL_ID 재사용(Y/N 고정값, §2.6 위반 아님) — 조회조건 Valid Yn 은 별도 확인 필요(design 02 §2-5)로 UI 골격만 노출, 이 상수는 그리드 셀 콤보 전용
} as const;

// AS-IS validations(00_checklist.md §3a) MSG ID → TO-BE 실측 매핑(Hook #114, SCM_ADM_MSG_M 역조회).
//   AS-IS 번호 그대로 쓰지 않는다 — 문구 대조로 확정.
export const MSG = {
  REQUIRED_FIELDS: 'MSG00013', // "Please enter the required fields." — AS-IS MSG00001(8필드 공백)의 TO-BE 등가(AS-IS MSG00001 은 TO-BE 에서 "저장하시겠습니까?" 로 의미가 다름 — 역조회로 확정)
  DATE_RANGE_INVALID: 'MSG00219', // "Invalid period (start > end)." — AS-IS 번호 그대로 일치 확인
  SAFETY_STOCK_EXISTS: 'MSG00260', // "Duplicate combination ..." — AS-IS 저장 가드(안전재고 존재 시 차단)의 근접 TO-BE 매핑, 검사 컬럼 확인 필요(design 01 §5-2)
  ITEM_NOT_FOUND: 'MSG00458', // "MODEL:{0} Invalid model!" — AS-IS 번호 그대로 일치 확인
  SAVE_SUCCESS: 'MSG00002', // "Saved successfully." — useProcMutation 기본 onSuccess 가 사용(화면 별도 배선 불필요, 문서화 목적)
  NO_CHANGE: 'MSG_NO_CHANGE',
} as const;
