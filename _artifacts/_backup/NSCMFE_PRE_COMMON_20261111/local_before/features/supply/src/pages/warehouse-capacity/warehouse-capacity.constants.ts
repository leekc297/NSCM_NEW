export const MENU_ID = 'SCP0133' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Master.UIL SCP0133_WarehouseCapacity (spdMain 2시트: Warehouse Capacity / Warehouse Item Mapping):
//   설계 근거: .atlas/gscm-design/SCP0133/design/00_checklist.md ~ 03_grid-columns.md
//   격리 세션 — GSCM 원본 `.cs`/`.Designer.cs` 미확보 + AS-IS MSSQL 접속 실패(design 00~03 3중 ERROR).
//   GET  main(WhCapa)      : PKG_SCP0133.P_SCP0133_GET_WAREHOUSE_CAPACITY (배포됨 VALID, ora.py 실측)
//   GET  itemMapping       : PKG_SCP0133.P_SCP0133_GET_WAREHOUSE_ITEM_MAPPING (배포됨 — gap-resolve
//     iter-2 에서 ItemMapping 전용 GET SP 실재 확인, 9 IN 파라미터 + O_RC1. design 03 §6-9 "전용
//     GET SP 없음" 가정은 배포로 무효. A2 해소: useTabProcQuery 조회 배선)
//   SAVE main(WhCapa)      : PKG_SCP0133.P_SCP0133_SAVE_WAREHOUSE_CAPACITY
//   SAVE itemMapping       : PKG_SCP0133.P_SCP0133_SAVE_WAREHOUSE_ITEM_MAPPING (16 IN + pre-key 4,
//     배포됨. A3 해소: handleSave activeSheet===1 배선)
//   조회조건: Division(콤보 SQL_ID 확인필요) -> PlanGroup/Site/Stage/Warehouse cascade(전부 확인필요,
//     design 02 §7) + Valid(확정 YesOrNo) + Period(From/To) + Item ID(팝업 MaterialByDivisionModal, 확정)
//   편집: EditButton "수정 모드" 토글 어포던스는 TO-BE 미이식(전 화면 공통 결정,
//     `.atlas/memory/editbutton-toggle-not-ported.md`) — 조회 직후에도 화이트리스트 외 컬럼은
//     바로 편집 가능(`utils/warehouseCapacityEditLock.ts`).
export enum SHEETS {
  MAIN = 'main', // spdMain 시트1 "Warehouse Capacity" (SCM_MST_SHEET_COLUMNS SHEET_NAME, 15컬럼)
  // spdMain 시트2 "Warehouse Item Mapping" (16컬럼). 전용 GET/SAVE SP 가 PKG_SCP0133 에 배포돼
  //   있음을 gap-resolve iter-2 에서 실측 확인(P_SCP0133_GET/SAVE_WAREHOUSE_ITEM_MAPPING) →
  //   procedures.d.ts 계약 + call-proc 라우팅(BTN_MPG SHT_NM='itemMapping', 05_register.sql) 배선.
  ITEM_MAPPING = 'itemMapping',
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  ITEM_MAPPING: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 상수 그대로(design 03 §0).
//   컬럼 메타 DB 등록 확인: PROGRAM_ID='SCP0133' 31행(15+16) 실측 완료(design 03 §1 대사 일치).
export const ADMIN_SHEET_NAME = {
  MAIN: 'Warehouse Capacity',
  ITEM_MAPPING: 'Warehouse Item Mapping',
} as const;

// 조회조건 콤보 ID — design 02 §2/§5 실측. Division/PlanGroup/Site/Stage/Warehouse 5개 전부
//   "강한 후보" 또는 "확인 필요" 상태다(GSCM 원본·AS-IS DB 이중 차단, design 02 §7 15건).
//   여기 상수로 배선하되, 실제 조회 결과가 AS-IS 와 다를 수 있음을 화면 주석에도 남긴다.
export const COMBO = {
  // 확인 필요(design 02 §2.2) — Division/Division_SCP/MyDivision 3후보 중 미확정.
  //   EE 제외(ATTRIBUTE3<>'EE') 여부가 후보마다 다르므로 임의 채택 금지 — 권한필터 있는
  //   Division_SCP 를 기본값으로 쓰지 않는다(convert-core §2.6 경고 그대로).
  //   확정 전까지는 EE 제외 없는 'Division_SCP'(권한필터만 적용)로 보수적으로 배선한다 —
  //   더 넓은 후보(Division, 권한필터도 없음)보다는 안전하나, 이 값 자체가 확인 필요다.
  DIVISION: 'Division_SCP',
  // 강한 후보(design 02 §2.3) — SQL_ID 존재 확인(ora.py). Division 컬럼 반환 → FE 클라 필터.
  PLAN_GROUP: 'PlanGroup_SCP_ALL',
  // A1 해소(gap-resolve iter-2): 기존 'SiteMasterAll_SCP' 는 `A.SITE_TYPE = @siteType`(등호, IS NULL
  //   완화 없음)인데 이 화면은 @siteType 를 공급하지 않아 항상 0행이었다(ora.py SQL 본문 실측).
  //   전용 'Site' 콤보로 교체 — DIVISION_ID/CODE/NAME 반환(SALES+PLANT, 창고 CAPA 조인), @token 없이
  //   전량 반환하므로 FE 가 matchSiteByDivision(EE 분기)로 클라 필터한다(PlanGroup 과 동형 +
  //   memory scp-site-combo-ee-branch-not-global-base-filter).
  SITE: 'Site',
  // Warehouse(Name) 조회조건 — AS-IS 는 자유텍스트가 아니라 다중선택 체크리스트 콤보다
  //   (RefreshWarehouse, .cs:384-407). 원천은 화면 저장테이블 자기참조: GET_SEARCH_INFO #5 와
  //   동일한 'Warehose' 콤보(SELECT DISTINCT DIVISION_ID, WH_NM CODE/NAME, OPMZ_PLAN_GR_ID ...
  //   FROM SCP_OPMZ_WAREHOUSE_CAPACITY, ora.py 실측 — grid 셀 콤보 CELL_COMBO.WAREHOUSE 와 같은 ID).
  //   @token 없이 전량 반환 → FE 가 division(+plan group)으로 클라 필터(AS-IS sFilter 재현).
  WAREHOUSE: 'Warehose',
} as const;

// Stage 콤보는 SCM_ADM_CMBO_SQL_M 이 아니라 lookup master 후보(design 02 §2.4, 확인 필요) —
//   OPMZ_STAGE_CD 가 강한 후보이나 SEGMENT1=division 외 계층 의미 미확정.
export const STAGE_LOOKUP_TYPE = 'OPMZ_STAGE_CD';

// Warehouse 콤보는 SCM_ADM_CMBO_SQL_M/LOOKUP_MASTER_DETAIL 어디에도 전용 SQL_ID 가 없다
//   (design 02 §2.6 — 확인 필요, 전용 마스터 없음 실측 확인). 이번 회차는 조회조건 Warehouse
//   다중선택을 위한 서버 콤보 원천이 없어 빈 옵션으로 남기고(§5 확인 필요 항목), 추측 등록하지 않는다.

// Valid — 확정(design 02 §2.1).
export const VALID_COMBO_ID = 'YesOrNo';

// 셀 콤보 SQL_ID(그리드 컬럼 CELL_COMBO_DATA_TYPE, design 03 §1) — PlanGroup 은 등록 확인(ora.py),
//   Site/Warehose(오탈자 그대로)/StorLoc 은 SCM_ADM_CMBO_SQL_M 0건(design 03 §6-1, 미등록).
//   등록 전까지 해당 셀 콤보는 빈 드롭다운이 정상이다 — 05_register.sql 이 신규 등록을 시도한다.
export const CELL_COMBO = {
  PLAN_GROUP: 'PlanGroup',
  SITE: 'Site',
  WAREHOUSE: 'Warehose', // 오탈자 그대로 등록된 DB 값(design 03 §1.2) — 신규 화면이라도 임의 교정 금지
  STOR_LOC: 'StorLoc',
} as const;

// 다국어 LABEL — SCM_ADM_MSG_M 실측(ora.py). AS-IS 조회조건 라벨(GSCM 원본 Designer 재확보,
//   SCP0133_WarehouseCapacity.Designer.cs)과 사용자 요청(2026-10-22)을 반영해 정식 코드로 매핑.
export const LBL = {
  // Division 라벨은 Form 에서 리터럴 'Div'(+required '*')로 직접 표기한다 — DB에 정확한 'Div' 라벨
  //   코드가 없어서다(WarehouseCapacityForm.tsx 주석 참조). 그래서 여기 LBL.DIVISION 은 두지 않는다.
  PLAN_GROUP: 'LBL00002', // Plan Group
  SITE: 'LBL00016', // SCM Site (AS-IS lblSite "SCM Site" 정합 — 기존 LBL00015 'Site' 교체)
  STAGE: 'LBL00061', // Stage
  // 사용자 요청: Warehouse(AS-IS lblWarehouse "Name") → 표시 "WH Name". 기존 Form 하드코딩
  //   LBL00319('Storage')에서 LBL00064('WH Name')로 교체.
  WAREHOUSE: 'LBL00064', // WH Name
  // 사용자 요청: Valid → "Active". 기존 LBL00639('Valid')에서 LBL00007('Active')로 교체.
  VALID: 'LBL00007', // Active
  PERIOD: 'LBL00013', // Period (AS-IS "Period*", * 는 required 마커)
  // 사용자 요청: Model(AS-IS lblItemId "Model") → "Model/Nickname". 기존 LBL01142('Item')에서
  //   LBL00618('Model/Nickname')로 교체. 조회조건만 변경 — 그리드 ITEM_ID 헤더는 "Model*" 유지.
  ITEM_ID: 'LBL00618', // Model/Nickname
} as const;

// AS-IS MSG ID 는 TO-BE 그대로 재사용하지 않는다(Hook #114). design 02 §4 는 AS-IS 번호(MSG00001/
//   MSG00046/MSG00219)를 그대로 인용하지만, ora.py 로 TO-BE `SCM_ADM_MSG_M` 문구를 역조회한 결과
//   TO-BE MSG00001 = "Would you like to save it?"(저장 확인)로 AS-IS 의미(필수조건 공백)와 다르다 —
//   AS-IS 번호를 그대로 옮기면 엉뚱한 문구가 뜬다(2026-09-10 SCP0020 사고 재발 방지). 문구 기준으로
//   재매핑했다.
export const MSG = {
  NO_CHANGE: 'MSG00004', // No changes to save. (TO-BE 문구 확인, 자매 SCP0023 재사용)
  // 필수조건 공백(AS-IS MSG00001 의도) — TO-BE 문구 일치 확인(design 02 §4 FindButton 가드).
  REQUIRED_FIELD: 'MSG00013', // Please enter the required fields.
  // 편집중 재조회 차단(AS-IS MSG00046 의도) — TO-BE 문구 일치 확인(design 02 §4 FindButton 가드).
  UNSAVED_RESEARCH: 'MSG00703', // There are unsaved changes. Do you want to search again?
  // From>To 차단(AS-IS MSG00219 의도) — gap-resolve iter-2(A7): MSG00219 는 TO-BE SCM_ADM_MSG_M
  //   에 미등록(ora.py 0 rows)이라 fallback 영문만 떴다. Hook #114(기존 문구 재사용)로 동일 의미의
  //   실재 TO-BE 메시지 MSG01135='The start date can not be later than the end date.' 로 재매핑.
  INVALID_PERIOD: 'MSG01135', // The start date can not be later than the end date.
  // 저장행 날짜형식 오류(AS-IS MSG00046 "유효한 날짜 형식" 의도 — TO-BE 미등록이라 동일 의미의 실재
  //   메시지로 재매핑, Hook #114). 07_validation-audit S3(셀 FROM/TO YYYYMMDD 형식 검증).
  INVALID_DATE_FORMAT: 'MSG00611', // Invalid date format. (YYYYMMDD)
  // 숫자 하한/음수 클램프(AS-IS MSG00085) — TO-BE 문구 완전 일치 확인(design 03 §3 #27).
  NUMBER_NON_NEGATIVE: 'MSG00085', // Only values greater than or equal to {0} are allowed.
  // 편집중 시트 전환 차단(AS-IS MSG00129 의도, validation C2) — AS-IS 번호를 그대로 쓰지 않는다
  //   (Hook #114). ora.py 실측상 TO-BE MSG00129="Sheet-specific edit mode notice."(의미 상이)라
  //   재사용 금지이고, AS-IS 문구("You are modifying {0} and can not change the sheet.")와 동일한
  //   TO-BE 실재 메시지는 MSG01149(EN/KO/CN 등록 확인)다. Workbench(동일 AS-IS 패턴)와 같은 코드.
  SHEET_CHANGE_BLOCKED: 'MSG01149', // You are modifying {0} and can not change the sheet.
} as const;
