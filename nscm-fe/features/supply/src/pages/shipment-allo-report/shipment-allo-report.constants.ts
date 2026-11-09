export const MENU_ID = 'SCP0055' as const;
export type MENU_ID = typeof MENU_ID;

// Main/Gap 탭이 동일 sheetNm 을 공유(design 03 §0 — sheetNm 1종). SHEETS 유니온은 convert-core §2.4 규약.
export const enum SHEETS {
  MAIN = 'main',
  NOTE = 'note',
}

export const enum TAB {
  MAIN = 'MAIN',
  GAP = 'GAP',
}

// OnShown 강제 고정값 4종(design 01 §2 #1-4) — 사용자가 바꿀 수 없음(disabled).
export const FIXED_SEARCH = {
  DIVISION_ID: '40',
  OPERATION_GROUP: 'A', // Cell
  BUCKET_TYPE: 'MONTHLY',
  CELL_TYPE_GR: 'C', // Cyl
} as const;

export const COMBO = {
  DIVISION: 'MyDivisionInEE_SCP',
  CELL_TYPE_GR: 'CellTypeGr_SCP',
  OPERATION_GROUP_LOOKUP: 'LookupCommon',
  FROM_SITE: 'AllPlantSiteDescription_SCP',
  OPERATION_GROUP: 'OperationGroup_SCP',
  OPERATION_GROUP_EE: 'OperationGroupEE_SCP',
  // Team(clbTeam) — AS-IS `Data.UserTeamByDivision` = CallBizCommonData("TeambyDivision", div, group, user)
  //   의 TO-BE 이관. SCM 공통 도메인 함수 FN_SCM0001_TEAM_BY_DIVISION(@divisionId) 기반. div40 실측 시
  //   19팀 반환하며 그리드 실제 팀(13) 전부 포함(superset) 확인(2026-11-02). 이름 유사 `SCMTeamByDivision_SCP`
  //   는 FINAL_ITEM.ATTRIBUTE6 경로라 그리드와 다른 5팀을 줘 오답 — 재사용 금지(convert-core §2.6).
  TEAM: 'SCM0001_TeamByDivision',
  DATE_WEEKLY: 'DATE_WEEKLY',
  // cboBucketType — AS-IS `DM.DM0003_GET_BUCKET_TYPE_CODE`(파라미터 없음) 대응. TO-BE 기존 등록 SQL_ID
  // `BucketType`(LOOKUP_TYPE='BUCKET_TYPE_CODE', CODE/NAME 3건 DAILY/WEEKLY/MONTHLY)을 재사용 —
  // FIXED_SEARCH.BUCKET_TYPE='MONTHLY' 코드값이 그대로 존재함을 ora.py 실측으로 확인(신규 등록 불필요).
  BUCKET_TYPE: 'BucketType',
} as const;

export const LABEL = {
  DIVISION: 'LBL00001',
  OPERATION_GROUP: 'LBL00027',
  // SCP0055.md #5(명칭/팝업)·#6(조회조건 삭제): AS-IS Model + Nick Name 2개 조회조건을 TO-BE 는
  //   단일 'Model/Nickname'(LBL00618, ora.py 실측 KO/EN/CN="Model/Nickname")으로 통합. 하나의 팝업이
  //   itemId·nickName 을 함께 반환(P_ITEM_ID/P_NICKNAME 둘 다 유지). MODEL/NICK_NAME 은 미사용.
  MODEL_NICKNAME: 'LBL00618',
  MODEL: 'LBL00669',
  NICK_NAME: 'LBL00767',
  TEAM: 'LBL00044',
  FROM_SITE: 'LBL00022',
  CELL_TYPE_GR: 'LBL00042',
  FCST_PEGGING: 'LBL01078',
  BUCKET: 'LBL00710',
  PLAN_DATE: 'LBL00039',
  GAP_DATE: 'LBL00065',
  PERIOD: 'LBL00013',
} as const;

export const MSG = {
  // 조회 사전검증 3종 — AS-IS 코드(MSG00344/345/348)는 TO-BE 미등록이라, 문구 역조회로 등록된 TO-BE
  //   등가 코드에 재매핑(convert-core §4.1, AS-IS 번호 그대로 쓰지 말 것). AS-IS 문구와 완전일치·KO/EN/CN
  //   완비(ora.py 실측 2026-11-02) — 재매핑 전엔 미등록이라 "_영문" fallback 만 떴다.
  PERIOD_RANGE: 'MSG01340', // Period From > To (AS-IS MSG00344 "Please check the Period.")
  PLAN_GAP_ORDER: 'MSG01341', // PlanDate < GapDate (AS-IS MSG00345 "plan date is earlier than gap date")
  PLAN_GAP_EQUAL: 'MSG01344', // PlanDate = GapDate (AS-IS MSG00348 "Gap date and Plan date must not be equal.")
  // 저장 성공 건수 — MSG00672 "{0}개의 데이터가 저장되었습니다."(AS-IS MSG00004 "{0} data saved." 등가).
  //   주의: TO-BE MSG00004 는 "수정한 내용이 없습니다."(No changes to save)로 의미가 반전돼 있어 성공 토스트에
  //   MSG00004 를 쓰면 저장돼도 "수정한 내용이 없습니다"로 뜬다(07_validation D2). 성공은 반드시 MSG00672 사용.
  SAVE_COUNT: 'MSG00672', // {0}개의 데이터가 저장되었습니다.
  // Division 권한 0건 — AS-IS SetDivisionAuthCheck(cs:144-145, BaseForm.cs:5995)가 MSG00097 "권한을 가진
  //   Division이 없습니다."로 안내. TO-BE MSG00097 은 "Please select Division."으로 의미가 달라 재사용 금지,
  //   등가 코드 MSG00667("No authority assigned." — ora.py 실측 등록)로 역매핑(convert-core §4.1).
  NO_DIVISION_AUTH: 'MSG00667',
} as const;

// SUBTOTAL/GAP/비고 — admin 메타(SCM_MST_SHEET_COLUMNS) 밖 코드리터럴 칼럼(design 03 §1.2).
export const DERIVED_COLUMN = {
  SUBTOTAL: 'SUBTOTAL',
  GAP: 'GAP',
  NOTE: 'NOTE',
} as const;
