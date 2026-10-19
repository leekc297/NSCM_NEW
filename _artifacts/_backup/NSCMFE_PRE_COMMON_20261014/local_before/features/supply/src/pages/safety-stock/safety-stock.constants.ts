export const MENU_ID = 'SCP0128' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Master.UIL SCP0128_SafetyStock (단일 FpSpread spdMain, 단일 SheetView):
//   설계 근거: .atlas/gscm-design/SCP0128/design/00_checklist.md ~ 03_grid-columns.md,
//   convert-flow/goal.md v2(AS-IS .cs 원문 확보로 다수 확인필요 실측 정정)
//   - GET SP  : SCP0128_GET_SAFETY_STOCK (16컬럼) — PKG_SCP0128 미배포(convert-sp 후속)
//   - SAVE SP : SCP0128_SAVE_SAFETY_STOCK (PRE_* 8종 복합키 UPDATE 패턴) — 미배포
//   - 조회조건 8개 전건 데이터소스 확정(goal.md v2 ④-1). Division/Period/ItemID/Plan Group/Valid
//     5개는 UI+데이터 배선 완료, Site/Type/Stage 3개는 UI 골격만 노출(데이터는 PKG_SCP0128 배포
//     후 배선) — __asis-mapping__.md 참조.
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
 * DIVISION: SP직접 SQL_ID, AS-IS `BLUtils.GetDivision(false,"")` ↔ TO-BE 1:1 확정(§2-1, EE 포함
 *   유지 — WithoutEE 아님).
 * PLAN_GROUP: `PlanGroup` — GAP-01 해소(react-gap-audit fail, 본 회차 재확인 완료). AS-IS 원문상
 *   이 화면의 Plan Group 공급원은 화면 전용 SP `SCP.SCP0128_GET_SEARCH_INFO`(Table[0])이나 그 SP는
 *   `PKG_SCP0128` 미배포로 아직 호출할 수 없다. 대신 `SCM_ADM_CMBO_SQL_M`에 신규 등록된 `PlanGroup`
 *   SQL_ID(SELECT OPMZ_PLAN_GR_ID AS CODE, OPMZ_PLAN_GR_NAME AS NAME, DIVISION_ID FROM
 *   SCP_OPMZ_PLAN_GR_M WHERE VALID_YN='Y', 본 회차 `ora.py query` 실측 확인)로 교체했다 — 반환
 *   컬럼이 AS-IS Table[0](OPMZ_PLAN_GR_ID/NAME + DIVISION_ID cascade 필터)과 동일 구조이며
 *   이전 `PlanGroup_SCP_ALL`(범용 Division별 PlanGroup 콤보, convert-core §2.6 위반 — 이름 유사
 *   재사용)보다 의미가 더 가깝다. `PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO` 배포 후 GET_SEARCH_INFO
 *   Table[0] 실호출로 최종 교체 필요(SP 후속, TODO 유지).
 * VALID: `YesOrNo`(고정 Y/N, §2-6 확정 — iter-2 goal.md v2 ④-2 재검증 결과 정당한 재사용,
 *   AS-IS `cboValid.DataBind(Data.Type.YesOrNo, true)` 와 1:1 일치, §2.6 위반 아님).
 * STAGE/SITE/TYPE: 데이터소스는 `SCP0128_GET_SEARCH_INFO`(Table[2]/[1]/[3])로 확정됐으나(goal.md
 *   v2 ④-1) PKG_SCP0128 미배포로 실배선 불가 — SafetyStockForm 에 UI 골격만 노출, comboId 배선은
 *   SP 배포 후(TODO).
 */
export const COMBO = {
  DIVISION: 'Division_SCP',
  PLAN_GROUP: 'PlanGroup',
  VALID: 'YesOrNo',
} as const;

// 화면 라벨 LBL 코드(SCM_ADM_MSG_M MSG_TP_CD='LBL') — DB 실측 검증분.
export const LBL = {
  SEARCH: 'LBL00112',
  DIVISION: 'LBL00001',
  SITE: 'LBL00015',
  TYPE: 'LBL00052',
  STAGE: 'LBL00061',
  PLAN_GROUP: 'LBL00002',
  PERIOD: 'LBL00013',
  VALID: 'LBL00639',
  ITEM: 'LBL01142',
} as const;

// AS-IS validations(00_checklist.md §4d 하단 표, 12건 전량 SaveData 소속) MSG ID 매핑 — AS-IS
//   번호 그대로 이관(design 문서가 실측한 msgId, SCP0127 과 달리 이 화면은 AS-IS 번호 자체가
//   Roslyn validations 배열에서 confirmed 라 역매핑 대상 아님).
// AS-IS `.cs:704-711` DateTime.ParseExact(v_from_yyyymmdd/v_to_yyyymmdd,"yyyyMMdd",null) catch
//   블록에서 발생(MSG00219 날짜 대소비교와 별개 — 형식 자체 파싱 실패 가드). GAP-05 재확인 완료
//   (본 회차 AS-IS 원문 직접 read), safetyStockSaveValidation.ts 에 배선.
export const MSG = {
  REQUIRED_FIELDS: 'MSG00001', // 9개 필수값(value_type/division/plan_gr/site/item/stage/from~to/qty/valid_yn) 공백
  DUPLICATE_EXISTS: 'MSG00260', // 기존 동일건 존재 시(삭제 아니면) 저장 차단
  INVALID_DATE_FORMAT: 'MSG00046', // From/To 날짜 형식 파싱 실패(.cs:704-711 catch) — MSG00219 대소비교와 별개
  DATE_RANGE_INVALID: 'MSG00219', // From > To 날짜 역전 차단
  QTY_NEGATIVE: 'MSG00085', // 적용수량 음수 차단
  ITEM_NOT_FOUND: 'MSG00458', // 대상 Item 존재하지 않음
  NO_CHANGE: 'MSG_NO_CHANGE',
} as const;
