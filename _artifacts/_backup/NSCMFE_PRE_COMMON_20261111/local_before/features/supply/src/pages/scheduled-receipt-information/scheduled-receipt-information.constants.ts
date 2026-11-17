export const MENU_ID = 'SCP0130' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Master.UIL SCP0130_ScheduledRecieptInformation — 2 sheetNm 정적 그리드(pivot 없음):
//   design/00_checklist.md ~ 03_grid-columns.md, convert-flow/goal.md·plan.md
//   - GET SP(2건)  : virtualBom 시트 = SCP.SCP0130_GET_VIRTUAL_BOM / scheduledReceipt 시트 =
//     SCP.SCP0130_GET_SCHEDULED_RECIEPT_INFORMATION — AS-IS FindData_Main()(.cs:556-666)이
//     활성 시트에 따라 분기하는 서로 다른 SP다(gap-resolve/iter-1, AS-IS 원문으로 확정 — 이전
//     회차가 두 시트 모두 GET_VIRTUAL_BOM으로 잘못 기재). 동명 SEARCH_INFO 는 시트전환 부가정보용
//     (그리드 데이터 아님, 이 화면 미적용)
//   - SAVE SP(2건) : SCP.SCP0130_SVAE_VIRTUAL_BOM(원문 오탈자 그대로 유지) / SCP.SCP0130_SAVE_
//     SCHEDULED_RECIEPT_INFORMATION — 저장 시 순차 호출(SVAE_VIRTUAL_BOM → SAVE_SCHEDULED_RECIEPT_
//     INFORMATION → GET_VIRTUAL_BOM 재조회, design/03_grid-columns.md §4)
//   - PKG_SCP0130 는 TO-BE 미배포(all_objects 0건, goal.md ② — convert-sp 백로그)
export enum SHEETS {
  VIRTUAL_BOM = 'virtualBom',
  SCHEDULED_RECEIPT = 'scheduledReceipt',
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = {
  VIRTUAL_BOM: 'o_rc1',
  SCHEDULED_RECEIPT: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

/**
 * 컬럼 메타 fetch(/admin/menu/SCP0130/column)의 sheetNm 은 SCM_MST_SHEET_COLUMNS.SHEET_NAME 과
 * 정확히 일치해야 한다(BE 가 문자열 그대로 매칭). DB 실측(design/03_grid-columns.md §1) 값을
 * 그대로 쓴다 — 코드 키(SHEETS)와 분리(formation.constants.ts 선례와 동일 패턴).
 */
export const COLUMN_SHEET_NAME: Record<SHEETS, string> = {
  [SHEETS.VIRTUAL_BOM]: 'Virtual Bom',
  [SHEETS.SCHEDULED_RECEIPT]: 'Scheduled Reciept Information',
};

/**
 * 조회조건 콤보 SQL_ID.
 *
 * DIVISION: `Division_SCP` 채택(2026-10-21 AS-IS 재대조로 `MyDivision`에서 교정). AS-IS
 *   `BLUtils.GetDivision(false,"")`(BLUtils.cs:133-146, company='' → EE 필터 없는 기본 호출)은
 *   `Data_SCP.Common(Type.Division)` → SP 분기 `@Code='Division'` → **함수 `FN_GET_DIVISION`**
 *   (asis.py 원문: 설명 "권한에 해당하는 사업부 조회(**EE 포함**)", WHERE 권한사업부 + VALID_YN='Y',
 *   ATTRIBUTE3 필터 없음). TO-BE `Division_SCP`(ora.py 실측)가 이 함수와 동형 — 동일 컬럼셋·동일
 *   NAME 포맷(DIVISION_ID||' '||DIVISION_NAME)·동일 권한필터·**EE 미제외**. 이전 `MyDivision`은
 *   `ATTRIBUTE3<>'EE'`로 EE 6개(EE/EE_UC/EE_HM/EE_ST/EE_HD/EE_HG)를 숨겨 AS-IS 와 달랐다(변수명
 *   dtMyDivision 에 오인). EE 집계 사업부 선택 시 Site 콤보의 구성사업부 확장은 Form 에서 재현
 *   (GetDivisionChecked .cs:257-291 / RefreshSiteByDivision .cs:354-362).
 * PLAN_GROUP / PLAN_GROUP_VBOM: AS-IS 는 활성 시트별로 Plan Group 조회콤보 원천이 다르다
 *   (SCP0130_GET_SEARCH_INFO, asis.py proc 원문 확인 — SpdMain_ActiveSheetChanged .cs:1479/1500):
 *     · Virtual Bom 시트       = 결과셋1(C# Tables[0]) 전체 Plan Group → `PlanGroup_SCP_ALL`
 *     · Scheduled Receipt 시트 = 결과셋9(C# Tables[8]) 가상BOM 등록분만 → `PlanGroupVirtualBom`
 *       (ora.py 실측: 가상BOM 등록 5건 vs 전체 45건 — 실제로 좁다). Form 이 isVirtualBom 으로 분기.
 * SITE / CHILD_MATERIAL(SCP0130-03): 등록 콤보 `PlantSiteSir`/`ItemIdChild` 를 조회콤보로 재사용.
 *   AS-IS MSSQL 재접속 성공으로 §2.6 모집단 대조 완료 — GET_SEARCH_INFO 결과셋8(Tables[7],
 *   PLANT_SITE_BY_DIVISION)·결과셋6(Tables[5], Child ID)의 SQL 이 두 Oracle 콤보 SQL 과 동일
 *   (Oracle `(+)`=SQL Server LEFT JOIN). Form 에서 AS-IS RefreshSiteByDivision/RefreshDivisionByItem
 *   처럼 Division 필터 + CODE 중복제거(buildDivisionOptions). Division 이 EE 를 포함하므로(Division_SCP)
 *   Site 는 EE 집계 사업부를 구성 사업부로 확장한다(siteDivisionFilter, AS-IS .cs:354-362).
 */
export const COMBO = {
  DIVISION: 'Division_SCP',
  PLAN_GROUP: 'PlanGroup_SCP_ALL',
  PLAN_GROUP_VBOM: 'PlanGroupVirtualBom',
  SITE: 'PlantSiteSir',
  CHILD_MATERIAL: 'ItemIdChild',
} as const;

// AS-IS validations(00_checklist.md §3a, design 03 §3.1) MSG ID → TO-BE 실측 매핑(Hook #114).
//   규약(2026-10-21): AS-IS 와 같은 MSG 코드가 TO-BE 에 없으면 새로 등록하지 않고, 문구가 똑같은
//   기존 TO-BE 코드를 찾아 매핑한다. MSG00050("유효한 숫자 형식이 아닙니다. {0}")은 TO-BE 에
//   MSG00050 으로는 없으나 문구 완전 동일한 MSG01082(KO/EN/CN, ora.py 실측)가 있어 그걸 쓴다.
//   MSG00046 은 AS-IS 코드가 날짜형식검증에 호출(.cs:835/873)하나 실제 등록문구가 "삭제할 데이터가
//   없습니다"(AS-IS 버그 — 주석과 불일치)이고 TO-BE 는 TO_YYYYMMDD 가 FPDate picker 라 형식오류 자체가
//   없어 재현 불필요 → 매핑 제거(dead 상수 정리, SCP0130-06c).
export const MSG = {
  // AS-IS MSG00001("모든 항목은 필수 입력입니다."/"All entries are mandatory.") — TO-BE MSG00001 은
  //   "저장하시겠습니까?"로 의미가 다르나, 문구 완전 동일한 기존 코드 MSG01039(KO/EN/CN, ora.py 실측)가
  //   있어 그걸 쓴다(규약: 같은 코드 없으면 같은 문구 기존 코드 매핑). 이전 MSG00013("필수 입력란을
  //   입력해 주세요.")은 문구가 달라 교체.
  REQUIRED_FIELDS: 'MSG01039',
  // AS-IS MSG00085(수량 0 미만 금지) — TO-BE 등록됐으나 본문 TODO(design 03 §3.1 #4).
  QTY_NEGATIVE: 'MSG00085',
  // AS-IS 날짜형식 유효성(.cs:831-837/869-875 ParseExact). AS-IS 가 호출한 MSG00046 은 실문구가
  //   "삭제할 데이터 없음"(AS-IS 버그)이라, 의도 문구("유효한 날짜 형식이 아닙니다. {0}")와 동일한
  //   기존 코드 MSG01081(KO/EN/CN, ora.py 실측)로 매핑. {0}=필드명('Valid To').
  INVALID_DATE: 'MSG01081',
  // AS-IS MSG00050(숫자 형식 아님) ↔ 문구 동일 기존 코드 MSG01082("유효한 숫자 형식이 아닙니다. {0}").
  QTY_NOT_NUMBER: 'MSG01082',
  // 소수 10자리 초과(AS-IS literal 메시지, msgId 없음) — TO-BE 근접 등록 코드 재사용
  //   (MSG00165 "자리수를 초과했습니다", ora.py 실측).
  QTY_DECIMAL_OVERFLOW: 'MSG00165',
  // AS-IS MSG00260(Division/PlanGroup/Site/ItemChild/ValidTo 조합 중복) — TO-BE 등록·본문 존재.
  DUPLICATE_EXISTS: 'MSG00260',
  NO_CHANGE: 'MSG00004',
  // AS-IS MSG00129(.cs:1515 spdSub_ActiveSheetChanging, "{0}를 수정 중이어서 시트를 변경 할 수
  //   없습니다.") — TO-BE MSG00129 는 문구가 다르나("시트 별 편집 모드 안내."), 문구 완전 동일한
  //   기존 코드 MSG01149(KO·EN "You are modifying {0} and can not change the sheet."·CN, ora.py
  //   실측)가 있어 그걸 쓴다(규약: 같은 코드 없으면 같은 문구 기존 코드 매핑).
  SHEET_EDIT_LOCK: 'MSG01149',
} as const;

/** 수량 저장 검증 — 소수 10자리 초과 금지(design 03 §3.1 #5/#16 literal 메시지). */
export const QTY_DECIMAL_MAX_DIGITS = 10;

// 조회조건 다국어 라벨 — AS-IS 실화면/Designer 라벨 텍스트와 1:1 일치시킨다(2026-10-21, SCP0130-15).
//   AS-IS Designer/런타임: Division 필드='Div*'(lblCombo1) · Site 필드='Plant Site'(lblSite) ·
//   Item 필드='Parent Model'(lblItemId) · Plan Group/Valid/From Date/Child Material 동일. 기존 LBL
//   코드 중 문구가 같은 것을 매핑(새 등록 없음, 규약). 그리드 컬럼 메타(COLUMN_LABEL_NAME)도 이미
//   'Div*'/'Plant Site*'/'Parent Item*'라 조회영역만 어긋나 있었다.
//   - DIVISION: LBL00641('Division')→LBL00001('Div', KO='Div'·EN/CN='Div.') — AS-IS 'Div' 복원
//     (design 02 §4.5 의 LBL00641 지정은 AS-IS 표시와 불일치 — AS-IS 우선).
//   - SITE: LBL00015('Site')→LBL00005('Plant Site', 3언어 완비. LBL00509 는 KO 누락이라 제외).
//   - ITEM_ID: LBL01142('Item')→LBL01100('Parent Model', 3언어). 조회 라벨은 'Parent Model',
//     그리드 컬럼은 'Parent Item'(메타)으로 AS-IS 가 서로 다름 — 각자 원문 유지.
export const LABEL = {
  DIVISION: 'LBL00001',
  PLAN_GROUP: 'LBL00002',
  SITE: 'LBL00005',
  CHILD_MATERIAL: 'LBL01062',
  VALID: 'LBL00639',
  FROM_DATE: 'LBL00062',
  ITEM_ID: 'LBL01100',
  // Child Material 필드 라벨은 활성 시트로 스왑(SCP0130-08, AS-IS .cs:1477/1493): Virtual Bom =
  //   'Child Material'(LBL01062) / Scheduled Receipt = 'Material'(LBL00021, ora.py 실측).
  MATERIAL: 'LBL00021',
} as const;
